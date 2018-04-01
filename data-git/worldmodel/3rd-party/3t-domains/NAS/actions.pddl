(in-package :ap)

(defun petes-debug (plan-root node-number)
  (test-alternative (nth (1- node-number)
			 (plot-subactions plan-root))))

(defparameter *uav-locs* 
    '((seal-harbor-dock (hill224 20.0)
		   (desert4 15.0)
		   (tank1 15.0)
		   (zambezi-river 10.0)
		   (city1 12.0)
		   (unknown-tgt-loc 15.0))
      ))


(define (durative-action take-off)
    :parameters (?o - unmanned-aerial-vehicle
		    ?s - launch-state)
    :condition (and (at start (= ?s in-the-air))
		    (at start (flight-state ?o on-ground)))
    :effect (at end (flight-state ?o ?s))
    :duration 1.0
    :comment "?o takes off")

(define (durative-action land)
    :parameters (?o - unmanned-aerial-vehicle
		    ?s - launch-state)
    :condition (and (at start (= ?s on-ground))
		    (at start (flight-state ?o in-the-air)))
    :effect (at end (flight-state ?o ?s))
    :duration 1.0
    :comment "?o travels from ?start-loc to ?end-loc")

(defun time-to-travel (start end &optional (in-locs *uav-locs*))
    (loop for loc-spec in in-locs
	as start-loc = (first loc-spec)
	as locs = (rest loc-spec)
	as new-start = (assoc start locs)
	if (eq start-loc start)
	return
	  (loop for (loc time) in locs
	      if (eq loc end)
	      return time
	      finally (return
			(progn
			  (format t "~%(1)Unable to find a time from ~a to ~a." start end)
			  1.0)))
	else if (and new-start (eq end start-loc))
	return (second new-start)
	finally 
	  (return
	    (let ()
	      (format t "~%(2)Unable to find a time from ~a to ~a." start end)
	      2.0))))

;;; (time-to-travel 'seal-harbor 'city1)
;;; (time-to-travel 'city1 'seal-harbor)


(defun time-to-travel-uav (action)
  (let* ((start (gsv action '?start-loc))
	 (end (gsv action '?end-loc))
	 (locs *uav-locs*))
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> From ~a to ~a.~%~%" start end)
    (time-to-travel (name start) (name end) locs)))

(define (durative-action uav-travel-to-tgt)
    :parameters (?o - unmanned-aerial-vehicle
		 ?obj - physical-entity)
    :vars (?start-loc - (located ?o))
    :condition (at start (flight-state ?o in-the-air))
    :effect (and (at end (tgt-located ?o ?obj))
		 (at end (located ?o unknown-location)))
    :probability 0.75
    :duration 15.0
    :comment "?o travels from ?start-loc to ?tgt")

(define (durative-action uav-travel-to-loc)
    :parameters (?o - unmanned-aerial-vehicle
		 ?end-loc - location)
    :vars (?start-loc - (located ?o))
    :condition (at start (flight-state ?o in-the-air))
    :effect (at end (located ?o ?end-loc))
    :probability 0.75
    :duration time-to-travel-uav
    :comment "?o travels from ?start-loc to ?end-loc")

(define (durative-action uav-launch-and-fly-to)
    :parameters (?o - unmanned-aerial-vehicle
		 ?end-loc - location)
    :vars (?start-loc - (or dock harbor))
    :condition (at start (located ?o ?start-loc))
    :expansion (sequential 
		(flight-state ?o in-the-air)
		(located ?o ?end-loc))
    :effect (at end (located ?o ?end-loc))
    :comment "?o travels from ?start-loc to ?end-loc")

;;; smart munitions can't use this since they can't be on the ground
;;; (they are either launched or not launched)
(define (durative-action uav-launch-and-fly-to-tgt)
    :parameters (?o - unmanned-aerial-vehicle
		  ?tgt - physical-entity)
    :vars (?start-loc - (or dock harbor))
    :condition (and (at start (located ?o ?start-loc))
    	       	    (at start (flight-state ?o on-ground)))
    :expansion (sequential 
		(flight-state ?o in-the-air)
		(tgt-located ?o ?tgt))
    :effect (at end (tgt-located ?o ?tgt))
    :comment "?o travels from ?start-loc to ?tgt")

(define (durative-action uav-fly-to-and-land)
    :parameters (?o - unmanned-aerial-vehicle
		 ?end-loc - dock)
    :condition (at start (not (instance ?o smart-munition)))
    :expansion (sequential 
		(located ?o ?end-loc)
		(flight-state ?o on-ground))
    :effect (at end (located ?o ?end-loc))
    :comment "?o travels from ?start-loc to ?end-loc")

(define (durative-action neutralize)
     :parameters (?o - unmanned-vehicle
		 ?t - physical-entity)
     :vars (?w - weapon)
     :duration 5.0 
     :condition (at start (has-weapon ?o ?w))
     :effect (at end (neutralized ?o ?t))
     :comment "?o neutralizes ?t.")

(define (durative-action inspect)
     :parameters (?o - unmanned-vehicle
		 ?t - vehicle)
     :vars (?s - sensor)
     :duration 5.0
     :condition (and (at start (has-sensor ?o ?s))
		     (at start (has-observation-range ?o close-up)))
     :effect (at end (inspected ?o ?t))
     :comment "?o inspects ?t.")	

(define (durative-action monitor)
    :parameters (?o - unmanned-vehicle
		    ?l - location)
    :vars (?s - sensor)
    :duration 2.0 
    :condition (and (at start (has-sensor ?o ?s))
		    (at start (has-observation-range ?o long-distance)))
    :effect (at end (monitoring ?o ?l))
    :comment "?o inspects ?t.")

(define (durative-action track)
    :parameters (?o - unmanned-vehicle
		    ?t - physical-entity)
    :vars (?s - sensor)
    :duration 2.0 
    :condition (and (at start (has-sensor ?o ?s))
		    (at start (has-observation-range ?o medium-distance)))
    :effect (at end (tracking ?o ?t))
    :comment "?o tracks ?t.")

(define (durative-action search)
    :parameters (?o - unmanned-vehicle
		    ?t - physical-entity)
    :vars (?s - sensor)
    :duration 2.0 
    :condition (and (at start (has-sensor ?o ?s))
		    (at start (has-vehicle-class ?s UISS)))
    :effect (at end (searching ?o ?t))
    :comment "?o searches ?t.")

(defun time-for-delay (action)
  (print (list "at delay " (name (template action))))
  (cond ((samep (name (template action)) 'delay10)
	 10.0)
	((samep (name (template action)) 'delay24hrs)
	 1440.0)
	((samep (name (template action)) 'delay1hr)
	 60.0)
	(t 15.0)))

 ;;; A delay action
(define (durative-action Delay10)
    :parameters (?o - unmanned-vehicle)
    :duration time-for-delay
    :effect (at end (Delay10_a ?o done)))

(define (durative-action surveil)
    :parameters (?o - unmanned-vehicle ?t - (and physical-entity (not sensor)(not weapon)))
    :vars (?base-loc - base-location)
    :condition (at start (located ?o ?base-loc))
    :expansion (sequential
		(tgt-located ?o ?t)
		(tracking ?o ?t)
		(Delay10_a ?o done)
		(located ?o ?base-loc))
    :effect (at end (surveilled ?o ?t))
    :comment "sureveillance task"
    )

;;; Starting from a random place
(define (durative-action surveil2)
    :parameters (?o - unmanned-vehicle ?t - (and physical-entity (not sensor)(not weapon)))
    :vars (?base-loc - seal-harbor)
    :expansion (sequential
		(tgt-located ?o ?t)
		(tracking ?o ?t)
		(Delay10_a ?o done)
		(located ?o ?base-loc))
    :effect (at end (surveilled ?o ?t))
    :comment "sureveillance task"
    )

(define (durative-action prosecute)
    :parameters (?o - unmanned-vehicle ?t - (and physical-entity enemy))
    :vars (?start-loc - (located ?o))
    :expansion (sequential
		(tgt-located ?o ?t)
		(neutralized ?o ?t)
		(located ?o ?start-loc))
    :effect (at end (prosecuted ?o ?t))
    :comment "prosecute task"
    )

(define (durative-action monitor-loc)
    :parameters (?o - unmanned-vehicle ?l - location)
    :vars (?base-loc - base-location)
    :condition (at start (located ?o ?base-loc))
    :expansion (sequential
		(located ?o ?l)
		(monitoring ?o ?l)
		(Delay10_a ?o done)
		(located ?o ?base-loc))
    :effect (at end (monitor-loc ?o ?l))
    :comment "monitor task"
    )

;;; Starting from a random place
(define (durative-action monitor-loc2)
    :parameters (?o - unmanned-vehicle ?l - location)
    :vars (?base-loc - seal-harbor-dock)
    :expansion (sequential
		(located ?o ?l)
		(monitoring ?o ?l)
		(Delay10_a ?o done)
		(located ?o ?base-loc))
    :effect (at end (monitor-loc ?o ?l))
    :comment "monitor task"
    )

(define (durative-action inspect-target)
    :parameters (?o - unmanned-vehicle ?t - (and physical-entity (not sensor)))
    :vars (?base-loc - base-location)
    :condition (at start (located ?o ?base-loc))
    :expansion (sequential
		(tgt-located ?o ?t)
		(inspected ?o ?t)
		(located ?o ?base-loc))
    :effect (at end (inspect-target ?o ?t))
    :comment "prosecute task"
    )

(define (durative-action inspect-target2)
    :parameters (?o - unmanned-vehicle ?t - (and physical-entity (not sensor)))
    :vars (?base-loc - seal-harbor)
    :expansion (sequential
		(tgt-located ?o ?t)
		(inspected ?o ?t)
		(located ?o ?base-loc))
    :effect (at end (inspect-target ?o ?t))
    :comment "prosecute task"
    )

