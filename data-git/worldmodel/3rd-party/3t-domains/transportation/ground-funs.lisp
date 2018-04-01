(in-package :ap)

;;;====== using A* to calculate distances based on a road network ==========

(defvar *direction>to* nil
  "Optional desired direction when you arrive at ?to.
   Set in the function(s) that call a-star.")

(defvar *start* nil
  "starting point of route")

(defvar *destination* nil
  "If *direction>to* is set, and the TO point is eql to *destination*,
   then cost returned is very high if the direction is wrong")

(defun drive-duration (action)
  (let ((?td (gsv action '?td)))
    (/ (agent-distance action)
       (get-value 'maxSpeed ?td))))

;;;-- ground level: intersection-to-intersection
;;;   google-route only includes intersections to other roads
;;;  from the start to the end. If there are none, returns nil

(defun google-routes (from to &optional final-direction)
  "remove points that are on the same route as preceeding point"
  (let* ((*current-situation* (situation *problem*))
	 all-routes)
    (loop for route in (all-routes from to final-direction)
	as path = (intersections-only (cons from route))
	if (cddr path) ; allow route of one?
	do 
	  (pushnew (rest path) all-routes))
    all-routes))		; fastest first

(defun all-routes (from to &optional final-direction)
  "return routes having more than one step"
  (let* ((shortest (shortest-route from to final-direction))
	 (fastest (fastest-route from to final-direction)))
    ;;-must return list of lists since each bound to ?route
    (cond ((endp shortest)
	   nil)
	  ((equal shortest fastest)
	   (if (rest shortest)
	       (list shortest)))
	  ((rest shortest)
	   (list shortest fastest)))))

(defun shortest-route (from to &optional final-direction)
  "returns list of locations on shortest route. does NOT include from"
  (let ((*destination* to)
	(*direction>to* final-direction))
    (rest (cl-user::a-star from #'connected-neighbors #'road-length
			   (lambda (place)(eql place to))))))

(defun fastest-route (from to &optional final-direction)
  "returns list of locations on shortest route. does NOT include from"
  (let ((*destination* to)
	(*direction>to* final-direction))
    (rest (cl-user::a-star from #'connected-neighbors #'drive-time
			   (lambda (place)(eql place to))))))

(defun drive-time (from to)
  "divide by road-length by speedLimit"
  (let (road)
    (cond ((and (eql to *destination*)
		*direction>to*
		(not (samep (get-direction from to) *direction>to*)))
	   most-positive-fixnum)	; approaching from wrong direction
	  ((occupied-p to)
	   most-positive-fixnum)	; stay away, someone there
	  ((setq road (or (get-value 'connectedBy from to)
			  (connecting-road from to)))
	   (if (consp road)		; get-value returns list
	       (setq road (first road)))
	   (/ (get-distance from to)
	      (or (get-value 'speedLimit road)
		  25)))			; yet another kludge 5/4/2016
	  (t
	   most-positive-fixnum))))

(defun route-time (?start ?route)
  "compute total time to traverse from ?start to end of ?route"
  (if ?route
      (+ (drive-time ?start (first ?route))
	 (route-time (first ?route)(rest ?route)))
    0.0))	; lost

;;;-- a-star functions for ground level --

(defun occupied-p (Point)
  "return non-NIL if Point is occupied"
  ;;-this kludge is necessary because get-value does not test negations
  (declare (special occupied))
  (holds (list occupied Point) *current-situation*))

(defun intersections-only (waypoints)
  "remove waypoints between intersections on same road"
  (let ((prior (first waypoints))
	(mid (second waypoints))
	(next (third waypoints)))
    (cond ((not next)
	   waypoints)
	  ((eql (connecting-road prior mid) ; same road?
		(connecting-road mid next)) ; then remove MID
	   (intersections-only (cons prior (member next waypoints))))
	  (t
	   (cons prior (intersections-only (rest waypoints)))))))

;;;--- robot level: point-to-point movement ---

(defvar *point-visits* (make-hash-table)
  "give increasing cost to a point each time it is in a route.
   This will force all-robot-routes, via point-to-point-cost, to return all routes from->to")

(defun all-robot-routes (?from ?to &optional final-direction)
  "return list of all possible routes"
  (let (next-route
	added-cost
	all-routes)
    (clrhash *point-visits*)
    (setq next-route (intermediate-Points ?from ?to final-direction))
    (loop while next-route
	do 
	  (if (or (find next-route all-routes :test #'equal)
		  (find-if #'occupied-p (butlast next-route))) ; not a valid route
	      (return))			; no more possibilities
	  (push next-route all-routes)
	  ;;-make it increasingly costly to revisit a point
	  ;; starting at the end and working back 
	  (setq added-cost (* 2 (route-cost next-route)))
	  (dolist (Point (reverse (butlast next-route)))
	    (cond ((zerop added-cost)
		   (return))
		  ((gethash Point *point-visits*)
		   (incf (gethash Point *point-visits*) added-cost))
		  (t
		   (setf (gethash Point *point-visits*) added-cost)))
	    (decf added-cost 2))
	  ;;-try for a new [longer] route
	  (setq next-route (intermediate-Points ?from ?to final-direction)))
    (nreverse all-routes)))		; shortest first

(defun intermediate-Points (?from ?to &optional final-direction)
  "returns list of Points representing least costly points"
  (let* ((*destination* ?to)
	 (*direction>to* final-direction)
	 (path (rest (cl-user::a-star ?from #'neighbors #'point-to-point-cost
				      (lambda (place)(eql place ?to))))))
    (if (rest path)  ; don't return path of length 1
	path)))

(defun neighbors (Point)
  "robot-level sons function, also used for on-roads"
  (listify (get-value 'neighbor Point)))

(defun point-to-point-cost (from to)
  "robot-level cost function"
  (cond ((and *direction>to*		; want to approach in this direction
	      (eql to *destination*)
	      (not (samep (get-direction from to) *direction>to*)))
	 most-positive-fixnum)		; approaching from wrong direction
	((occupied-p to)		; don't go through it
	 most-positive-fixnum)
	((gethash to *point-visits*))	; disfavor revisits
	(t 
	 1)))

(defun route-cost (route)
  (loop for a in (butlast route)
      for b in (rest route)
      summing
	(point-to-point-cost a b)))

;;;--- roads ---

(defun road-length (from to)
  "return distance FROM TO based on roadLength"
  (let (road)
    (cond ((and (eql to *destination*)
		*direction>to*
		(not (samep (get-direction from to) *direction>to*)))
	   most-positive-fixnum)	; approaching from wrong direction
	  ((occupied-p to)	
	   most-positive-fixnum)	; stay away, someone there
	  ((setq road (intersection (get-value 'onRoad from)
				    (get-value 'onRoad to)))
	   (or (get-value 'roadLength road)
	       2)); 5/4/2016 temp kludge
	  ((setq road (get-value 'connectedBy from to))
	   (get-value 'roadLength (atomize road)))
	  (t
	   most-positive-fixnum))))

;;; if p is an end point of a road or an intersection, onRoad will be set
;;; otherwise, there are at most 2 neighbors
;;; go out from p to all neighbors and find the first point in each
;;; direction that has onRoad
;;; the intersection of the two onRoad sets = the road p is on

(defun on-roads (p &optional from)
  "return list of roads that p is on, not incl from"
  (let (neighbors l)
    (cond ((get-value 'onRoad p))	; More than one if intersection
          ((remove-duplicates
            (loop for p2 in (get-value 'connected p)
                  collect (get-value 'connectedBy p p2))))
	  ((and (instance p 'Point)
                (find-named-object 'neighbor 'relation))
	   (setq neighbors (remove from (neighbors p)))
	   (case (length neighbors)
	     (1
	      (on-roads (first neighbors) p))
	     (2
	      (intersection (on-roads (first neighbors) p)
			    (on-roads (second neighbors) p)))
	     (otherwise
	      (warn "on-roads fails; ~A has ~A neighbors" p l)))))))
	   
(defun connecting-road (start dest)
  "return the road that both are on, if any"
  (or (first (intersection (get-value 'onRoad start)(get-value 'onRoad dest)))
      (get-value 'connectedBy start dest)
      (if (or (samep (rdf:type start) 'Point)
	      (samep (rdf:type dest) 'Point)) 
	  (first (intersection (on-roads start) (on-roads dest))))))

(defun compute-neighbor-lists (road)
  "collects up neighbor lists for all points on the road"
  (loop for pt in (all-points-on-road road)
      collect 
	(cons pt
	      (loop for neighbor in (funcall (neighbor-function) pt)
		  if (on-road-p neighbor road)
		  collect neighbor))))

(defun all-points-on-road (road)
  (loop for pt in (all-instances 'Point)
      if (on-road-p pt road)
      collect pt))

(defun on-road-p (loc road)
  "return ROAD if LOC is on it, nil otherwise"
  (or (find road (get-value 'onRoad loc))
      (if (instance (rdf:type loc) 'Point)
	  (find road (on-roads loc)))))

(defun neighbor-function ()
  "function to use to find neighbors of a point or location"
  (cond ((find-named-object 'neighbor 'relation)
         #'neighbors)
        ((find-named-object 'connected 'relation)
         #'connected-neighbors)
        (t 
	 (warn "neighbor-function: no way to find neighbors")
	 #'identity)))

;;;----- direction from one point to another -----

(defmethod get-direction (p1 p2 &optional prior)
  (let ((road (first (intersection (on-roads p1)(on-roads p2))))
	pts)
    (cond ((eql p1 p2)
	   nil)
	  ((not road) ; not on same road, far as we can tell
	   nil)
	  ((get-value 'direction road p1 p2))
	  ((opposite-direction (get-value 'direction road p2 p1)))
          ((find-named-object 'neighbor 'relation) ; *domain* = robot
           (setq pts (sort-points-on-road road))
	   (if (> (position p1 pts) (position p2 pts))
	       (setq pts (reverse pts)))
	   (loop for pt1 in pts
	       for n1 from 0
	       thereis (loop for pt2 in pts
			   for n2 from 0
			   as dir = (get-value 'direction road pt1 pt2)
			   thereis (and dir
					(if (> n1 n2)
					    (opposite-direction dir)
					  dir)))))
          (t
	   (loop for pt in (remove prior (get-value 'connects road p1))
	       thereis 
		 (get-direction pt p2 p1))))))

(defun opposite-direction (dir)
  "keep it pretty"
  (get-value 'opposite dir))

(defmethod get-direction ((a Agent) p2 &optional prior)
  (let ((current-location (get-location a)))
    (if current-location
	(get-direction current-location p2 prior)
      (break "~a is not located anywhere" a))))

;;; no guarantee which end will be first and which will be last
(defun sort-points-on-road (road)
  "returns the points on the road sorted from end to end"
  (sort-points-on-road-1 (compute-neighbor-lists road) nil))

;;; strong assumption that a road is a sequence of points
;;; this will not work if roads can be more than one point wide
;;; starting with a list of (pt neighbor neighbor) (or (pt neighbor) for
;;; the ends) assemble the pts in order by using shared neighbors, ie, if A
;;; is a neighbor of P1 and P2 then it must be between them, if B is a
;;; neighbor of P1, then P1 is between A and B, etc 
;;; simple idea that got ugly
(defun sort-points-on-road-1 (neighbors-lists pt-sequence)
  "really sort them"
  (let (n pt)
    (cond ((endp neighbors-lists) pt-sequence)
          ((endp pt-sequence)
           (setq n (first neighbors-lists))
           ;; put the pt between its neighbors
           (sort-points-on-road-1 (cdr neighbors-lists)
                                  (cons (cadr n) (cons (car n) (cddr n)))))
          ((setq n (find (first pt-sequence) neighbors-lists :key #'first))
           (setq pt (if (find (second n) pt-sequence)
                        (unless (find (third n) pt-sequence)
                          (third n))
                      (second n)))
           (sort-points-on-road-1 (remove n neighbors-lists :test #'equal)
                                  (if pt
				      (cons pt pt-sequence)
                                    pt-sequence)))
          (t 
	   (sort-points-on-road-1 neighbors-lists (reverse pt-sequence))))))
