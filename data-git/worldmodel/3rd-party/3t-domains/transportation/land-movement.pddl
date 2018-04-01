(in-package :ap)

;; robot level (vice mission level)

(define (domain land-movement)
    (:comment "Point-to-Point ground movement by robots")
  (:extends ground)
  (:requirements :durative-actions)
  (:types Robot - (and Agent TransportationDevice)
          )
  (:predicates 
   (neighbor - fact ?p1 ?p2 - Point)
   (move ?r - Robot ?p - Point)
   )
  (:axiom
   :vars (?r - Road)
   ;;:context (not (roadLength ?r :ignore))
   :implies (roadLength ?r 2)
   :comment "default value")
  (:axiom 
   :vars (?l1 ?pt ?l2 - Point
	      ?r - Road
	      ?d - Direction)
   :context (and (neighbor ?l1 ?pt)
		 (neighbor ?pt ?l2)
		 (direction ?r ?l1 ?l2 ?d)
		 (not (= ?l1 ?pt))
		 (not (= ?pt ?l2))
		 (not (= ?l1 ?l2)))
   :implies (direction ?r ?l1 ?pt ?d))
  (:axiom
   :vars (?p1 ?p2 ?p3 - Point
	      ?r - Road)
   :context (and (connects ?r ?p1 ?p3)
		 (neighbor ?p1 ?p2)
		 (neighbor ?p2 ?p3))
   :implies (and (connects ?r ?p1 ?p2)
		 (connects ?r ?p2 ?p1)
		 (connects ?r ?p2 ?p3)
		 (connects ?r ?p3 ?p2)))
  (:axiom 
   :vars (?p ?n1 ?n2 - Point
	     ?r - Road)
   :context (and (neighbor ?p ?n1)
		 (neighbor ?p ?n2)
		 (onRoad ?n1 ?r)
		 (onRoad ?n2 ?r)
		 (not (= ?n1 ?n2))
		 (not (= ?p ?n1))
		 (not (= ?p ?n2)))
   :implies (onRoad ?p ?r))
  )

(inverseOf 'neighbor 'neighbor)

;;;-- HTN operators [with :expansion] --

(define (durative-action approach-given-direction)
    :parameters (?robot - Robot
		 ?to - (or Point location)
	         ?heading - Direction)
    :vars (?from - (located ?robot)
	   ?route - (all-robot-routes ?from ?to ?heading))
    :expansion (series
		(forall (?point - ?route)
			(move ?robot ?point)))
    :effect (approach ?robot ?to ?heading)
    :comment "top level only")

(define (durative-action traverse-path)
    :parameters (?robot - Robot
		 ?to - (or Point location))
    :vars (?from - (located ?robot)
	   ?route - (all-robot-routes ?from ?to)) ; fails if ?from next to ?to
    :expansion (series
		(forall (?point - ?route)
			(move ?robot ?point)))
    :effect (and (move ?robot ?to)
		 (located ?robot ?to))
    :comment "Point-to-Point path planning more detailed than get-directions")

(define (durative-action turn-move)
    :parameters (?robot - Robot
		 ?to - Point)
    :vars (?from - (located ?robot)
	   ?direction - (get-direction ?from ?to))
    :condition (and (at start (not (heading ?robot ?direction)))
		    (over all (not (occupied ?to)))) ; don't turn toward blocked point
    :expansion (series
		(heading ?robot ?direction)
		(move ?robot ?to))
    :effect (and (move ?robot ?to)
		 (located ?robot ?to))
    :comment "Point-to-Point move after changing direction")

;;-- leaf-level actions --

(define (durative-action move)
    :parameters (?robot - Robot
		 ?to - Point)
    :vars (?from - (located ?robot)
	   ?toneighbor - (find ?to (neighbors ?from)) ; ?to must be neighboring point
	   ?direction - (get-direction ?from ?to))    ; nil if ?from = ?to
    :condition (and (at start (located ?robot ?from))
		    (at start (heading ?robot ?direction)) ; no turning required
		    (over all (not (occupied ?to))))
    :effect (and (at start (not (occupied ?from)))
		 (over all (occupied ?to)) ; prevent another from starting simultaneously
		 (at end (move ?robot ?to))
		 (at end (located ?robot ?to))
		 )
    :duration 0.006			; 20 seconds
    :cost 1.0
    :execute (exec-sim-command *current-action*)
    :comment "Point-to-Point move. drive in ground.pddl goes via intersections.")

#|
;;; specialized move for the graph model
;;; no dependence on direction
;;; not handled: you can't move out on the arc you came in on (I think this
;;; could roughly be handled by taking an out direction <= n degrees from
;;; the current heading, letting heading come from the direction
;;; ?from->?to, which has to be calculated)
(define (durative-action graph-move)
    :parameters (?robot - Robot
		 ?to - Point)
    :vars (?from - (located ?robot)
	   ?toneighbor - (find ?to (neighbors ?from))) ; ?to must be neighboring point
    :condition (and (at start (located ?robot ?from))
		    (over all (not (occupied ?to))))
    :effect (and (at start (not (occupied ?from)))
		 (over all (occupied ?to)) ; prevent another from starting simultaneously
		 (at end (move ?robot ?to))
		 (at end (located ?robot ?to))
		 )
    :duration 0.006			; 20 seconds
    :execute (exec-sim-command *current-action*)
    :comment "Point-to-Point move. drive in ground.pddl goes via intersections.")
|#

;; Note: following actions only apply to TrackedVehicles. 
;;       See ground.pddl for more general turn operator.

(define (durative-action pivot)
    :parameters (?td - TrackedVehicle
		 ?direction - Direction)
    :vars (?current - (heading ?td))
    :precondition (opposite ?direction ?current)
    :effect (heading ?td ?direction)
    :duration 0.003
    :cost 2.0				; relatively expensive
    :execute (exec-sim-command *current-action*)
    :comment "turn 180 in place")

(define (durative-action skid)
    :parameters (?td - TrackedVehicle
		 ?direction - Direction)
    :vars (?current - (heading ?td))
    :precondition (and (not (= ?direction ?current))
		       (not (opposite ?direction ?current)))
    :effect (heading ?td ?direction)
    :duration 0.002
    :cost 1.5				; more expensive than move
    :execute (exec-sim-command *current-action*)
    :comment "skid steer to take a corner")

;;; allow user to control

(defun tell-user (&rest args)
  "test :execute directive"
  ;; return non-NIL => action succeeds, NIL => action keeps executing
  (ask-user-p "action=~s args=~s" *current-action* args))
