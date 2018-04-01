;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
;;(PUSH :V *PDBG*)
;;;============
;;; Instruments
;;;============

#|
debug stuff
;;; to debug (trace apply-param-tests template+bindings check-condition add-var)
;;; print-relation-history print-relation-props is helpful too

(setf thing (second (plot-subactions DDCU-CHANGE-OUT12100)))
(test-alternative thing)

(defun petes-debug (plan-root node-number)
  (test-alternative (nth (1- node-number)
			 (plot-subactions plan-root))))

(setf sit (output-situation DDCU-R&R-PREP362))
(print-relation-props possesses sit)
(print-relation-history possesses sit)

(let ((foo (MAKE-STRING-OUTPUT-STREAM)))
  (let ((*standard-output* foo))
    (explain-failed-goal (first-failed-subgoal DO-JOBS2049))
    (GET-OUTPUT-STREAM-STRING FOO)))
;;|#

;;;
;;; Optical Imaging
;;;
;;; Assume they have a lens protector that needs to be open for a period of time

(define (durative-action open-or-close-shutter)
    :parameters (?oi - optical-imaging
		     ?s - state)
    :duration 1.0 
    :effect (at end (shutter-state ?oi ?s))
    :comment "opens shutter.")
	
(define (durative-action power-or-unpower-device)
    :parameters (?c - (and physical-entity (not power-generator solar-array))
		    ?s - power-state)
    :duration 1.0 
    :effect (at end (has-power-state ?c ?s))
    :comment "powers equipment on off or standby.")
	
;;(new-predicate '(state-of-sensors ?sc - space-craft ?s - state) *domain*)

(define (durative-action power-or-unpower-sensors)
    :parameters (?sc - unmanned-space-craft
		     ?st - power-state)
    :duration 1.0 
    :expansion (sequential
		(forall (?s - (has-sensor ?sc))
			(has-power-state ?s ?st)))
    :effect (at end (state-of-sensors ?sc ?st))
    :comment "sets power state of space craft sensors.")

;;(new-predicate '(state-of-components ?sc - unmanned-space-craft ?s - state) *domain*)

(define (durative-action power-or-unpower-components)
    :parameters (?sc - unmanned-space-craft
		     ?st - power-state)
    :duration 1.0 
    :expansion (sequential
		(forall (?s - (has-component ?sc))
			(has-power-state ?s ?st)))
    :effect (at end (state-of-components ?sc ?st))
    :comment "sets power state of space craft components.")

(defparameter *celestial-bodies* '(Earth Mars Jupiter Saturn Luna Europa Ganymede))
(defun generate-angles ()
  (loop for body1 in *celestial-bodies*
      as i from 0
      append
      (loop for body2 in *celestial-bodies*
	  as angle = (+ 20 (random 200))
	  if (eq body1 body2)
	  collect `(,body1 ,body2 0)
	  else collect `(,body1 ,body2 ,angle))))

(defparameter *attitudes* (generate-angles))
(defparameter *action* nil)
(defun time-from-attitudes (action)
  (setf *action* action)
  (let* ((from-tgt (name (gsv action '?from-tgt)))
	 (to-tgt (name (gsv action '?tgt)))
	 (angle (loop for (body1 body2 angle) in *attitudes*
		    if (and (eq from-tgt body1)
			    (eq to-tgt body2))
		    return angle
			   finally (return 333))))
    (format t "~%~%---------------------------------")
    (format t "~%~% start, end, angle = ~a, ~a, ~a." from-tgt to-tgt angle)
    (format t "~%~% Value for ~a is ~a." (name action) (max 4.0 (/ angle 5.0)))
    (format t "~%~%---------------------------------")
    (max 4.0 (/ (abs angle) 5.0)))) ;; slew rate is 5 degrees per unit time

;;;(new-predicate '(current-target ?s - unmanned-space-craft ?tgt - celestial-body) *domain*)
;;;(owl:Restriction 'current-target 'owl:cardinality 1)
;;;(new-predicate '(pointed-at ?s - unmanned-space-craft ?tgt - celestial-body) *domain*)
;;;(owl:Restriction 'current-target 'owl:cardinality 1)

#| AML
activity slew {
  // input parameters
  string target_name;
  target_id_t target_id;

  // derived parameters
  target_id_t from_target_id;

  priority = [1, 999];

  timeline_dependencies =
    from_target_id <- attitude;

  dependencies =
    duration <- max(1, compute_slew_time(from_target_id, target_id));

  reservations =
    attitude change_to -1 at_start,
    attitude change_to target_id at_end,
    slew_state change_to "slewing" at_start,
    slew_state change_to "idle" at_end;

  no_permissions = ("move", "add", "delete");
  }

;;; We need to think of attitude as a target/planet/ thing.
;;; slew means to turn the spacecraft from one target to another
;;;

  (define (durative-action slew)
    :parameters (?s - unmanned-space-craft
                 ?target_name - celestial-body
                 )
		 :vars (?from_target_id - (attitude ?s)
		        ?target_id - (angle_to ?target_name))
    :condition (and (at start (attitude ?s -1))
	            (at start (slew_state ?s slewing)))
    :duration  time-from-targets
    :effect (and (at end (attitude ?s ?tgt))
                 (at end (slew_state ?s idle))
		 )
    :comment "reorient the spacecraft from -1 to attitude of the tgt.") 
		 |#



(define (durative-action point-at-tgt)
    :parameters (?s - unmanned-space-craft
		    ?tgt - celestial-body)
    :vars (?from-tgt - (current-target ?s)
	   )
    :duration  time-from-attitudes
    :effect (and (at end (pointed-at ?s ?tgt))
		 (at end (current-target ?s ?tgt))
		 )
    :comment "reorient the spacecraft from curent attitude to attitude of the image.")

(new-predicate '(image-stored ?s - unmanned-space-craft ?tgt - celestial-body) *domain*)

(define (durative-action store-images)
    :parameters (?s - unmanned-space-craft
		    ?tgt - celestial-body)
    :vars (?oi - optical-imaging)
    :condition (and (at start (has-sensor ?s ?oi))
		    (at start (has-power-state ?oi power_on))
		    (at start  (shutter-state ?oi open)))
    :duration  8.333333	;;; 500 secs 
    :effect (at end (image-stored ?s ?tgt))
    :comment "take picture.")

(new-predicate '(pointed&imaged ?s - unmanned-space-craft ?tgt - celestial-body) *domain*)

#|
(define (durative-action point&image)
    :parameters (?s - unmanned-space-craft
		    ?tgt - celestial-body)
    :vars (?from-tgt - (current-target ?s)
		     ?oi - optical-imaging)
    :condition (at start (has-sensor ?s ?oi))
    :expansion (sequential
		(current-target ?s ?tgt)
		(has-power-state ?oi power_on)
		(shutter-state ?oi open)
		(image-stored ?s ?tgt)
		(shutter-state ?oi closed))
    :effect (at end (pointed&imaged ?s ?tgt))
    :comment "reorient the spacecraft and take picture.")
|#

;;; This one works when ?s is a designator...
(define (durative-action point&image)
    :parameters (?s - unmanned-space-craft
		    ?tgt - celestial-body)
    :vars (?from-tgt - celestial-body
		     ?oi - optical-imaging)
    :condition (and (at start (has-sensor ?s ?oi))
		    (at start (current-target ?s ?from-tgt)))
    :expansion (sequential
		(current-target ?s ?tgt)
		(has-power-state ?oi power_on)
		(shutter-state ?oi open)
		(image-stored ?s ?tgt)
		(shutter-state ?oi closed)
		(has-power-state ?oi power_off))
    :effect (at end (pointed&imaged ?s ?tgt))
    :comment "reorient the spacecraft and take picture.")

#|(define (durative-action orbit-to)
    :parameters (?s - satellite
		    ?tgt-loc - location)
    :vars (?start-loc - (located ?s))
    :condition (at start (located ?s ?start-loc))
    :effect (at end (located ?s ?tgt-loc))
    :duration time-from-locs
    :comment "get satellite over a location.")

(define (durative-action go_and_shoot)
    :parameters (?sat - satellite
		      ?name - image_name)
    :vars (?loc - location)
    :condition (and (at start (loc_for ?name ?loc))
		    (at start (not (located afsat1 ?loc))))
    :expansion (sequential
		(camera-state ?sat off)
		;;(not (on imager))
		(located ?sat ?loc)
		(pointed&imaged ?sat ?name)
		#|(parallel
		 (camera-state ?sat on)
		 ;;(on imager)
		 (pointed_at ?sat ?name))|#
		(shutter-state ?sat opened)
		;;(opened shutter)
		(image_stored ?sat ?name)
		(shutter-state ?sat closed)
		;;(not (opened shutter))
		)
    :effect (at end (image_taken ?sat ?name))
    :comment "travel to loc and shoot image.")

(define (durative-action just_shoot)
    :parameters (?s - satellite
		    ?name - image_name)
    :vars (?loc - (located afsat1))
    :condition (at start (loc_for ?name ?loc))
    :expansion (sequential
		(pointed&imaged ?s ?name)
		#|(parallel
		 (camera-state ?s on)
		 ;;(on imager)
		 (pointed_at ?s ?name))|#
		(shutter-state ?s opened)
		;;(opened shutter)
		(image_stored ?s ?name)
		(shutter-state ?s closed)
		;;(not (opened shutter))
		)
    :effect (at end (image_taken ?s ?name))
    :comment "travel to loc and shoot image.")

(define (durative-action shoot_lots)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - image_name)
    :expansion (sequential
		(image_taken ?s ?img1)
		(image_taken ?s ?img2)
		(image_taken ?s ?img3))
    :effect (at end (images_taken ?s ?img1 ?img2 ?img3))
    :comment "travel to loc and shoot image.")

(define (durative-action open-comms)
    :parameters (?o - satellite)
    :vars (?c - (has-comms ?o))
    :duration 1.0 
    :effect (at end (comms-state ?o opened))
    :comment "open a comms channel.")

(define (durative-action close-comms)
    :parameters (?o - satellite)
    :vars (?c - (has-comms ?o))
    :duration 1.0 
    :effect (at end (comms-state ?o closed))
    :comment "close a comms channel.")

(define (durative-action send-image)
    :parameters (?s - satellite
		    ?name - image_name)
    :vars (?c - (has-comms ?s)
	      ?cam - (has-camera ?s))
    :duration 1.0 
    :condition (and (over all (comms-state ?s opened))
		    (at start (camera-state ?s off)))

    :effect (at end (image_sent ?s ?name))
    :comment "download picture.")

(define (durative-action downlinked-at-location)
    :parameters (?dloc - down-link-loc)
    :effect (at end (downlink-location ?dloc))
    :comment "used just to get the dloc passed to the maketasks functions.")

(define (durative-action download-image)
    :parameters (?s - satellite 
		    ?img - image_name)
    :vars (?dloc - down-link-loc
		 ?cam - (has-camera ?s)
		 ?c - (has-comms ?s))
    :expansion (sequential
		(camera-state ?s off)
		;;(not (on imager))
		(located ?s ?dloc)
		(comms-state ?s opened)
		;;(opened comms)
		(image_sent ?s ?img)
		;;;(not (opened comms))
		(comms-state ?s closed))
    :effect (at end (image_downloaded ?s ?img))
    :comment "travel to downlink loc and send image.")

(define (durative-action download-images)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - image_name)
    :vars (?dloc - down-link-loc
		 ?cam - (has-camera ?s)
		 ?c - (has-comms ?s))
    :expansion (sequential
		(camera-state ?s off)
                ;;(not (on imager))
		(located ?s ?dloc)
		(comms-state ?s opened)
		;;(opened comms)
		(image_sent ?s ?img1)
		(image_sent ?s ?img2)
		(image_sent ?s ?img3)
		;(not (opened comms))
		(comms-state ?s closed))
    :effect (at end (images_downloaded ?s ?img1 ?img2 ?img3))
    :comment "travel to downlink loc and downlink images.")

(define (durative-action shoot_lots&store)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - image_name)
    :expansion (sequential
		(image_taken ?s ?img1)
		(image_taken ?s ?img2)
		(image_taken ?s ?img3)
		(images_downloaded ?s ?img1 ?img2 ?img3)
		)
    :effect (at end (images_taken&stored ?s ?img1 ?img2 ?img3))
    :comment "travel to each loc shoot image then go downlink them.")

|#
