(in-package :ap)

;;; functions for transportation domains called during planning.
;;; These are referenced in actions in transportation.pddl

;;;  Note the use of API functions: samep instead of eql, instance
;;;    instead of typep, and get-value which starts at *current-situation*

;;;======== :duration functions ======
;;; time is in hours, distance in KM

(defun transport-duration (action)
  "this gives the estimated-duration"
  (let ((?start (gsv action '?start))
	(?dest (gsv action '?dest))
	(?td (gsv action '?td)))
    (cond ((and ?td ?start ?dest)
	   (+ 2.0 (move-duration ?td ?start ?dest)))
	  (t
	   (format t "~%transport-duration: ~a vars must be ?td ?start ?dest" action)
	   100.0))))

(defun move-duration (?td ?start ?dest)
  "distance divided by speed"
  (let ((distance (get-distance ?start ?dest))
	(speed (get-value 'maxSpeed ?td))) ; NIL if assumed-resource
    (if (and distance speed)
	(/ distance speed)
      100.0)))

;;;--- extension domain functions ---
;;; Not enough of these yet to bother with thier own files

(defun fly-duration (action)
  "dummy for now"
  (let ((?start (gsv action '?start))
	(?dest (gsv action '?dest)))
    (cond ((eql (get-value 'geographicSubregionOf ?start)
		(get-value 'geographicSubregionOf ?dest))
	   4.0)
	  (t
	   10.0))))

(defun water-distance (from to)
  "temp hack for water-route"
  (declare (ignore from to))
  1.0)

(defun water-route (from to)
  "returns list of locations on route. does NOT include from"
  (rest (cl-user::a-star from #'connected-neighbors #'water-distance
			 (lambda (place)(eql place to)))))

(defun refuel-duration (action)
  "only used by refuel action"
  (let ((?td (gsv action '?td)))
    (cond ((instance ?td 'WaterVehicle)
	   10.0)
	  ((instance ?td 'LandVehicle)
	   0.2)
	  (t
	   2.0))))

;;;=== distance ===

(defmethod agent-distance ((action action))
  "account for possible designations of agent"
  (with-slots (purpose) action
    (let ((destination (gsv action '?dest)))
      (get-distance (second purpose) destination))))

#|
(defun calculate-distance (from to)
  "returns shortest distance if you can get FROM-> TO via roads"
  (let* ((path (cl-user::a-star from #'connected-neighbors #'road-length
			       (lambda (place)(eql place to))))
	 (distance (path-length path)))
    (cache-distance from to distance)
    (values distance path)))

(defun path-length (path)
  "path is a sequence of locations"
  (if path
      (loop for from in path
	  for to in (cdr path)
	  sum (road-length from to))
    most-positive-fixnum))

|#

;;;-- save distance calculation for speed later ---

(defun cache-distance (from to n)
  ;;-distance relation is reflexive, so reverse will be asserted automatically
  (assert-proposition `(distance ,from ,to ,n) *current-situation*))

(defmethod agent-distance ((op operator))
  "for multi-step actions like hop"
  (plot-distance (plot op)))

(defmethod plot-distance ((plot cons) &optional prior-loc)
  "recursive, note return"
  (let ((relation (first plot))
	(distance 0))
    (cond ((find relation *legal-actionRelations*)
	   ;;--treats them all as if they are series
	   (dolist (prop (rest plot))
	     (multiple-value-bind (inner-distance loc)
		 (plot-distance prop prior-loc)
	       (incf distance inner-distance)
	       (setq prior-loc loc))))
	  ((samep relation 'located)
	   (incf distance (get-distance (or prior-loc (second plot))(third plot)))
	   (setq prior-loc (third plot))))
    (values distance
	    prior-loc)))

(defmethod get-distance ((from object)(to object))
  "might return NIL"
  (let* ((start (get-location from))
	 (dest (get-location to))
	 (distance (if (eql start dest)
		       0
		     (get-value 'distance start dest)))
	 (connection (get-value 'connectedBy start dest)))
    (cond (distance)
	  (connection
	   (if (instance connection 'Road)
	       (get-value 'roadLength connection)
	     most-positive-fixnum))
	  ((find dest (connected-neighbors start))
	   1.0)				; kludge
	  (t
	   (format t "~%get-distance ~a ~a: no connection between" from to)
	   most-positive-fixnum))))

#|
    (or distance			; cached value
	(etypecase start
	  (resource			; transportationDevice
	   (get-distance (get-value 'located start) dest))
	  (object
	   (setq connection (get-value 'connectedBy start dest))
	   (cond ((instance connection 'Road)
		  (get-value 'roadLength connection))
		 ((samep (get-value 'located dest) start)
		  5)			; city to local airport
		 (t
		  (calculate-distance start dest))))))))
|#

(defmethod get-distance ((from designator) dest)
  (let ((start (get-value 'located from)))
    (if start
	(get-distance start dest)
      (loop for resource in (owl:oneOf from)
	  as loc = (get-location resource)
	  if loc
	  minimize 
	    (get-distance loc dest)))))

(defmethod get-location ((o object))
  (if (instance o 'Location)
      o
    (get-value 'located o)))

;;;=== preconditions  ====

;;; use might-be instead of instance for designators 

(defun appropriate-conveyance-p (td cargo)
  "either arg might be an object or a designator"
  (cond ((might-be td 'TankerShip)
	 (might-be cargo 'Liquid))
	((might-be td 'PassengerVehicle)
	 (or (might-be cargo 'ArbitraryGroupOfPeople)
	     (might-be cargo 'Person)))
	((might-be td 'CargoVehicle)
	 (might-be cargo 'Cargo))))
