(in-package :ap)

;;; 03/03/2015
;;; Making some complex actions primitives and moving the detail to the procedures

(defun petes-debug (plan-root node-number)
  (test-alternative (nth (1- node-number)
			 (plot-subactions plan-root))))

(defparameter *uav-locs* 
    '((wilmington-harbor-dock1  (hill224 20.0)
		   (desert4 10.0)
		   (tank1 23.0)
		   (zambezi-river 10.0)
		   (city1 12.0)
		   (aoi_1 20.0)
		   (aoi_2 10.0)
		   (aoi_3 5.0)
		   (aoi_4 15.0)
		   (aoi_4 17.0)
                   (us_74 20.0)
		   (us_76 17.0)
		   (us_701 15.0)
		   (us_17 10.0)
                   (unknown-location 15.0))
             (LCS1  (hill224 20.0)
		   (desert4 10.0)
		   (tank1 23.0)
		   (zambezi-river 10.0)
		   (city1 12.0)
		   (aoi_1 20.0)
		   (aoi_2 10.0)
		   (aoi_3 5.0)
		   (aoi_4 15.0)
		   (aoi_4 17.0)
                   (us_74 20.0)
		   (us_76 17.0)
		   (us_701 15.0)
		   (us_17 10.0)
                   (unknown-location 15.0))	
            (jackson-base  (hill224 25.0)
		   (desert4 15.0)
		   (tank1 28.0)
		   (zambezi-river 15.0)
		   (city1 17.0)
		   (aoi_1 25.0)
		   (aoi_2 15.0)
		   (aoi_3 10.0)
		   (aoi_4 20.0)
		   (aoi_4 22.0)
                   (us_74 25.0)
		   (us_76 22.0)
		   (us_701 20.0)
		   (us_17 15.0)
                   (unknown-location 15.0))	   
      ))

(defparameter *usv-locs* 
    '((wilmington-harbor (hill224 50.0)
		   (desert4 65.0)
		   (city1 36.0))
      (unknown-location (wilmington-harbor 15.0))		   
      ))

(defparameter *uuv-locs* 
    '((wilmington-harbor (zambezi-river 25.0))
      (wilmington-harbor (shoreline1 13.0))
      (unknown-location (wilmington-harbor 15.0))
      ))

;;;Need to do a reverse lookup
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
			  5.0)))
	else if (and new-start (eq end start-loc))
	return (second new-start)
	finally 
	  (return
	    (let ()
	      (format t "~%(2)Unable to find a time from ~a to ~a." start end)
	      5.0))))

;;; (time-to-travel 'seal-harbor 'city1)
;;; (time-to-travel 'city1 'seal-harbor)

(define (durative-action take-off)
    :parameters (?o - unmanned-aerial-vehicle
		    ?s - launch-state)
    :condition (and (at start (not (instance ?o smart-munition)))
                    (at start (= ?s in-the-air))
		    (at start (has-launch-state ?o on-the-ground)))
    :effect (at end (has-launch-state ?o ?s))
    :duration 1.0
    :comment "?o takes off")

(define (durative-action launch)
    :parameters (?o - unmanned-aerial-vehicle
		    ?s - launch-state)
    :condition (and (at start (not (instance ?o smart-munition)))
                    (at start (= ?s in-the-air))
		    (at start (has-launch-state ?o not-launched)))
    :effect (at end (has-launch-state ?o ?s))
    :duration 1.0
    :comment "?o takes off")

(define (durative-action land)
    :parameters (?o - unmanned-aerial-vehicle
		    ?s - launch-state)
    :condition (and (at start (= ?s on-the-ground))
		    (at start (has-launch-state ?o in-the-air)))
    :effect (at end (has-launch-state ?o ?s))
    :duration 1.0
    :comment "?o lands")

(define (durative-action land-blackjack)
    :parameters (?o - unmanned-aerial-vehicle
		    ?s - launch-state)
    :condition (and (at start (= ?s not-launched))
		    (at start (has-launch-state ?o in-the-air)))
    :effect (at end (has-launch-state ?o ?s))
    :duration 1.0
    :comment "blackjack type aircraft lands")

;;; special test for pax 5/5/15
(define (durative-action take-off&land)
    :parameters (?o - unmanned-aerial-vehicle)
    :condition (and (at start (not (instance ?o smart-munition)))
    	            (at start (has-launch-state ?o on-the-ground)))
    :effect (at end (took-off&landed ?o))
    :duration 15.0
    :comment "?o takes off and lands")

(defun get-agent-type (agent)
  (Let ((subclasses (rdfs:subclassof (type agent))))
    (cond ((member 'UNMANNED-AERIAL-VEHICLE subclasses :test #'samep)
           'uav)
          ((member 'UNMANNED-underwater-VEHICLE subclasses :test #'samep)
           'uuv)
          (t 'usv))))

;;; These are defined in the loader, but for jenkins tests we need it here.
(defun all-sits (sit)
  (if (null (immediately-after sit))
      (list sit)
    (append (list sit)
	    (let ((nsits (immediately-after sit)))
	      (loop for nsit in (if (consp nsits) nsits (list nsits))
		appending (all-sits nsit))))))

(defun all-sit-props (sit &optional rel)
  (let* ((sits (all-sits sit))
	 (props (loop for sit in sits
		   appending (map-a-hash (propositions (eval sit))))))
    ;;(print (list "length of props = " (length props)))
    (if rel
	 (loop for prop in props
	    if (eq rel (name (first prop)))
	     collect prop)
       props)))

(defun time-to-travel-uv (action)
  (let* ((agent (gsv action '?o))
         (loc-props (all-sit-props (input-situation action) 'is-located))
         (agent-loc (loop for prop in loc-props if (samep agent (second prop)) return (third prop)))
	 (obj (gsv action '?obj))
         (obj-loc (loop for prop in loc-props if (samep obj (second prop)) return (third prop)))
	 (end (let ((end (gsv action '?end-loc)))
                  (cond (end end)
                        (obj-loc obj-loc)
                        (t unknown-location))))
	 (locs (case (get-agent-type agent)
                 (uav *uav-locs*)
                 (usv *usv-locs*)
                 (otherwise *uuv-locs*))))
    ;;(break)
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> From ~a to ~a.~%~%" agent-loc (if obj-loc obj-loc end))
    (time-to-travel (name agent-loc) (if obj-loc
    		    	  	     	 (name obj-loc)
					 (name end)))))

#|(defun time-to-travel-usv (action)
  (let* ((start (gsv action '?start-loc))
	 (end (gsv action '?end-loc))
	 (locs *usv-locs*)
         (obj (gsv action '?obj)))
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> From ~a to ~a.~%~%" start end)
    (time-to-travel (name start) (name end) locs)))

(defun time-to-travel-uuv (action)
  (let* ((start (gsv action '?start-loc))
	 (end (gsv action '?end-loc))
	 (locs *uuv-locs*)
         (obj (gsv action '?obj)))
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> From ~a to ~a.~%~%" start end)
    (time-to-travel (name start) (name end) locs)))|#

;;;Just for jdams
(define (durative-action jdam-travel-to-tgt)
    :parameters (?o - unmanned-aerial-vehicle
		 ?obj - physical-entity)
    :vars (?start-loc - (is-located ?o))
    :condition (at start (has-launch-state ?o in-the-air))
    :effect (and (at end (tgt-located ?o ?obj))
		 (at end (is-located ?o unknown-location)))
    :probability 0.75
    :duration  time-to-travel-uv
    :comment "?o travels from ?start-loc to ?tgt")

(define (durative-action uav-travel-to-loc)
    :parameters (?o - unmanned-aerial-vehicle
		 ?end-loc - location)
    :vars (?start-loc - (is-located ?o))
    :condition (at start (has-launch-state ?o in-the-air))
    :effect (at end (is-located ?o ?end-loc))
    :probability 0.75
    :duration time-to-travel-uv
    :comment "?o travels from ?start-loc to ?end-loc")

#|(define (durative-action uav-launch-and-fly-to)
    :parameters (?o - unmanned-aerial-vehicle
		 ?end-loc - location)
    :vars (?start-loc - (or dock harbor))
    :condition (at start (is-located ?o ?start-loc))
    :expansion (sequential 
		(has-launch-state ?o in-the-air)
		(is-located ?o ?end-loc))
    :effect (at end (is-located ?o ?end-loc))
    :comment "?o travels from ?start-loc to ?end-loc")|#

(define (durative-action uav-launch-and-fly-to)
    :parameters (?o - unmanned-aerial-vehicle
		 ?end-loc - location)
    :vars (?start-loc - 
    	  	      ;;(or dock harbor)
		      base-location
	  ?launch-state - (or on-the-ground not-launched))
    :condition (and (at start (has-launch-state ?o ?launch-state))
                    (at start (is-located ?o ?start-loc)))
    :duration time-to-travel-uv
    :effect (at end (is-located ?o ?end-loc))
    :comment "?o takes off and travels from ?start-loc to ?end-loc")

;;; smart munitions can't use this since they can't be on the ground
;;; (they are either launched or not launched)
#|(define (durative-action uav-launch-and-fly-to-tgt)
    :parameters (?o - unmanned-aerial-vehicle
		  ?tgt - physical-entity)
    :vars (?start-loc - (or dock harbor))
    :condition (and (at start (is-located ?o ?start-loc))
    	       	    (at start (has-launch-state ?o on-the-ground)))
    :expansion (sequential 
		(has-launch-state ?o in-the-air)
		(tgt-located ?o ?tgt))
    :effect (at end (tgt-located ?o ?tgt))
    :comment "?o travels from ?start-loc to ?tgt")|#

#|(define (durative-action uav-launch-and-fly-to-tgt)
    :parameters (?o - unmanned-aerial-vehicle
		  ?obj - physical-entity)
    :vars (?start-loc - 
    	  	      	;;(or dock harbor)
			base-location
	    ?launch-state - (or on-the-ground not-launched))
    :condition (and (at start (is-located ?o ?start-loc))
    	       	    (at start (has-launch-state ?o ?launch-state)))
    :duration time-to-travel-uv
    :probability 0.75
    :effect (and (at end (tgt-located ?o ?obj))
    	         (at end (is-located ?o unknown-location)))
    :comment "?o takes off and travels from ?start-loc to ?obj")|#

(define (durative-action uav-launch-and-fly-to-tgt)
    :parameters (?o - unmanned-aerial-vehicle
		  ?obj - physical-entity)
    :vars (?start-loc - 
    	  	      	;;(or dock harbor)
			base-location
	    ?launch-state - (or on-the-ground not-launched)
	    ?tgt-loc - location)
    :condition (and (at start (is-located ?o ?start-loc))
    	       	    (at start (is-located ?obj ?tgt-loc))
		    (at start (has-launch-state ?o ?launch-state)))		    
    :duration time-to-travel-uv
    :effect (and (at end (tgt-located ?o ?obj))
    	         (at end (is-located ?o ?tgt-loc)))
    :comment "?o takes off and travels from ?start-loc to the loc of ?obj")

#|(define (durative-action uav-fly-to-and-land)
    :parameters (?o - unmanned-aerial-vehicle
		 ?end-loc - dock)
    :condition (at start (not (instance ?o smart-munition)))
    :expansion (sequential 
		(is-located ?o ?end-loc)
		(has-launch-state ?o on-the-ground))
    :effect (at end (is-located ?o ?end-loc))
    :comment "?o travels from ?start-loc to ?end-loc")|#

(define (durative-action uav-fly-to-and-land)
    :parameters (?o - unmanned-aerial-vehicle
		 ?end-loc - base-location)
    :condition (at start (not (instance ?o smart-munition)))
    :duration time-to-travel-uv
    :effect (and (at end (has-launch-state ?o on-the-ground))
                 (at end (is-located ?o ?end-loc)))	
    :comment "?o travels from ?start-loc to ?end-loc")

(define (durative-action usv-travel-to)
    :parameters (?o - unmanned-surface-vehicle
		 ?end-loc - water-area)
    :vars (?start-loc - (is-located ?o))
    :effect (at end (is-located ?o ?end-loc))
    :duration time-to-travel-uv
    :comment "?o travels from ?start-loc to ?end-loc")

(define (durative-action uav-travel-to-tgt)
    :parameters (?o - unmanned-aerial-vehicle
		 ?obj - physical-entity)
    :vars (?start-loc - (is-located ?o))
    :effect (and (at end (tgt-located ?o ?obj))
		 (at end (is-located ?o unknown-location)))
    :probability 0.75
    :duration  time-to-travel-uv
    :comment "?o travels from ?start-loc to ?tgt")

(define (durative-action usv-travel-to-tgt)
    :parameters (?o - unmanned-surface-vehicle
		 ?obj - physical-entity)
    :effect(and (at end (tgt-located ?o ?obj))
		 (at end (is-located ?o unknown-location)))
    :duration 15.0
    :comment "?o travels from ?start-loc to ?end-loc")

(define (durative-action uuv-travel-to)
    :parameters (?o - unmanned-underwater-vehicle
		 ?end-loc - water-area)
    :vars (?start-loc - (is-located ?o))
    :effect (at end (is-located ?o ?end-loc))
    :duration time-to-travel-uv
    :comment "?o travels from ?start-loc to ?end-loc")

(define (durative-action uuv-travel-to-tgt)
    :parameters (?o - unmanned-underwater-vehicle
		 ?obj - physical-entity)
    :effect (and (at end (tgt-located ?o ?obj))
		 (at end (is-located ?o unknown-location)))
    :duration 15.0
    :comment "?o travels from ?start-loc to ?end-loc")

(define (durative-action neutralize)
     :parameters (?o - unmanned-vehicle
		 ?t - (or military-organization vehicle)
                      ;;physical-entity
		      )
     :vars (?w - weapon)
     :duration 5.0 
     :condition (at start (has-weapon ?o ?w))
     :effect (at end (neutralized ?o ?t))
     :comment "?o neutralizes ?t.")

(define (durative-action neutralize-sm)
     :parameters (?o - smart-munition
		 ?t - physical-entity)
     :vars (?w - war-head)
     :duration 5.0 
     :condition (and (at start (has-war-head ?o ?w))
     		     (at start (has-launch-state ?o in-the-air))
		     (at start (has-aerial-munition-state ?o intact)))
     :effect (and (at end (neutralized ?o ?t))
     	     	  (at end (has-aerial-munition-state ?o destroyed)))
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

;;; No limit to observation range
(define (durative-action monitor)
    :parameters (?o - unmanned-vehicle
		    ?l - location)
    :vars (?s - sensor)
    :duration 10.0 
    :condition (at start (has-sensor ?o ?s))
    :effect (at end (monitored ?o ?l))
    :comment "?o inspects ?t.")

(define (durative-action track)
    :parameters (?o - unmanned-vehicle
		    ?t - (or military-organization vehicle)
                          ;;physical-entity
                          )
    :vars (?s - sensor)
    :duration 10.0 
    :condition (and (at start (has-sensor ?o ?s))
		    (at start (has-observation-range ?o medium-distance)))
    :effect (at end (tracked ?o ?t))
    :comment "?o tracks ?t.")

(define (durative-action search)
    :parameters (?o - unmanned-vehicle
		    ?t - physical-entity)
    :vars (?s - sensor)
    :duration 2.0 
    :condition (and (at start (has-sensor ?o ?s))
		    (at start (has-vehicle-class ?s UISS)))
    :effect (at end (searched ?o ?t))
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

#|(define (durative-action surveil)
    :parameters (?o - unmanned-vehicle ?t - (and physical-entity (not sensor)(not weapon)))
    :vars (?base-loc - base-location)
    :condition (at start (is-located ?o ?base-loc))
    :expansion (sequential
		(tgt-located ?o ?t)
		(tracking ?o ?t)
		(Delay10_a ?o done)
		(is-located ?o ?base-loc))
    :effect (at end (surveilled ?o ?t))
    :comment "sureveillance task"
    )|#

(define (durative-action surveil)
    :parameters (?o - unmanned-surface-vehicle ?t - (and physical-entity (not sensor)(not weapon)))    
    :vars (?base-loc - base-location)
    :condition (at start (is-located ?o ?base-loc))
    :expansion (sequential
		(tgt-located ?o ?t)
		(tracked ?o ?t)
		(is-located ?o ?base-loc))
    :effect (at end (surveilled ?o ?t))
    :comment "sureveillance task"
    )

;;; Starting from a random place
#|(define (durative-action surveil2)
    :parameters (?o - unmanned-vehicle ?t - (and physical-entity (not sensor)(not weapon)))
    :vars (?base-loc - seal-harbor)
    :expansion (sequential
		(tgt-located ?o ?t)
		(tracking ?o ?t)
		(Delay10_a ?o done)
		(is-located ?o ?base-loc))
    :effect (at end (surveilled ?o ?t))
    :comment "sureveillance task"
    )

|#

(define (durative-action surveil2)
    :parameters (?o - unmanned-surface-vehicle ?t - (and physical-entity (not sensor)(not weapon)))    
    :vars (?base-loc - wilmington-harbor)
    :expansion (sequential
		(tgt-located ?o ?t)
		(tracked ?o ?t)
		(is-located ?o ?base-loc))
    :effect (at end (surveilled ?o ?t))
    :comment "surveillance task"
    )

;;; Mine surveillance
#|(define (durative-action surveil3)
    :parameters (?o - unmanned-surface-vehicle ?t - water-area)
    :vars (?base-loc - seal-harbor)
    :expansion (sequential
		(tgt-located ?o ?t)
		(searching ?o ?t)
		(Delay10_a ?o done)
		(is-located ?o ?base-loc))
    :effect (at end (surveilled ?o ?t))
    :comment "sureveillance task"
    )|#

(define (durative-action surveil3)
    :parameters (?o - unmanned-surface-vehicle ?t - water-area)
    :vars (?base-loc - wilmington-harbor)
    :expansion (sequential
		(tgt-located ?o ?t)
		(searched ?o ?t)
		(is-located ?o ?base-loc))
    :effect (at end (surveilled ?o ?t))
    :comment "sureveillance task"
    )

(define (durative-action prosecute)
    ;; :parameters (?o - unmanned-vehicle ?t - (and physical-entity enemy))
    :parameters (?o - unmanned-vehicle ?t - physical-entity)
    :vars (?start-loc - (is-located ?o))
    :expansion (sequential
		(tgt-located ?o ?t)
		(neutralized ?o ?t)
		(is-located ?o ?start-loc))
    :effect (at end (prosecuted ?o ?t))
    :comment "prosecute task"
    )

#|(define (durative-action monitor-loc)
    :parameters (?o - unmanned-vehicle ?l - location)
    :vars (?base-loc - base-location)
    :condition (at start (is-located ?o ?base-loc))
    :expansion (sequential
		(is-located ?o ?l)
		(monitoring ?o ?l)
		(Delay10_a ?o done)
		(is-located ?o ?base-loc))
    :effect (at end (monitor-loc ?o ?l))
    :comment "monitor task"
    )|#

(define (durative-action monitor-loc)
    ;; :parameters (?o - unmanned-vehicle ?l - location)
    :parameters (?o - unmanned-aerial-vehicle ?l - location)    
    :vars (?base-loc - base-location)
    :condition (at start (is-located ?o ?base-loc))
    :expansion (sequential
		(is-located ?o ?l)
		(monitored ?o ?l)
		(is-located ?o ?base-loc))
    :effect (at end (monitor-loc ?o ?l))
    :comment "monitor task"
    )

;;; Starting from a random place
#|(define (durative-action monitor-loc2)
    :parameters (?o - unmanned-vehicle ?l - location)
    :vars (?base-loc - seal-harbor-dock)
    :expansion (sequential
		(is-located ?o ?l)
		(monitoring ?o ?l)
		(Delay10_a ?o done)
		(is-located ?o ?base-loc))
    :effect (at end (monitor-loc ?o ?l))
    :comment "monitor task"
    )|#

(define (durative-action monitor-loc2)
    ;;:parameters (?o - unmanned-vehicle ?l - location)
    :parameters (?o - unmanned-aerial-vehicle ?l - location)    
    :vars (?base-loc - wilmington-harbor-dock1)
    :expansion (sequential
		(is-located ?o ?l)
		(monitored ?o ?l)
		(is-located ?o ?base-loc))
    :effect (at end (monitor-loc ?o ?l))
    :comment "monitor task"
    )

#|(define (durative-action inspect-target)
    :parameters (?o - unmanned-vehicle ?t - (and physical-entity (not sensor)))
    :vars (?base-loc - base-location)
    :condition (at start (is-located ?o ?base-loc))
    :expansion (sequential
		(tgt-located ?o ?t)
		(inspected ?o ?t)
		(is-located ?o ?base-loc))
    :effect (at end (inspect-target ?o ?t))
    :comment "prosecute task"
    )|#

(define (durative-action inspect-target)
    :parameters (?o - unmanned-underwater-vehicle ?t - (and physical-entity (not sensor)))
    :vars (?base-loc - wilmington-harbor)
    :expansion (sequential
		(tgt-located ?o ?t)
		(inspected ?o ?t)
		(is-located ?o ?base-loc))
    :effect (at end (inspect-target ?o ?t))
    :comment "inspect task"
    )

#|
Here are all the actions in this file:
(UUV-TRAVEL-TO <template UUV-TRAVEL-TO>) 
(SURVEIL <template SURVEIL>) 
(PROSECUTE <template PROSECUTE>) 
(INSPECT <template INSPECT>) 
(TAKE-OFF&LAND <template TAKE-OFF&LAND>) 
(MONITOR-LOC <template MONITOR-LOC>) 
(NEUTRALIZE <template NEUTRALIZE>) 
(TAKE-OFF <template TAKE-OFF>) 
(SURVEIL2 <template SURVEIL2>) 
(LAND <template LAND>) 
(DO-TASKS3 <template DO-TASKS3>) 
(DO-TASKS2 <template DO-TASKS2>) 
(UAV-TRAVEL-TO-LOC <template UAV-TRAVEL-TO-LOC>) 
(UAV-FLY-TO-AND-LAND <template UAV-FLY-TO-AND-LAND>) 
(UAV-TRAVEL-TO-TGT <template UAV-TRAVEL-TO-TGT>) 
(DELAY10 <template DELAY10>) 
(LAUNCH <template LAUNCH>) 
(JDAM-TRAVEL-TO-TGT <template JDAM-TRAVEL-TO-TGT>) 
(USV-TRAVEL-TO-TGT <template USV-TRAVEL-TO-TGT>) 
(UUV-TRAVEL-TO-TGT <template UUV-TRAVEL-TO-TGT>) 
(INSPECT-TARGET <template INSPECT-TARGET>) 
(SURVEIL3 <template SURVEIL3>) 
(UAV-LAUNCH-AND-FLY-TO <template UAV-LAUNCH-AND-FLY-TO>) 
(NEUTRALIZE-SM <template NEUTRALIZE-SM>) 
(USV-TRAVEL-TO <template USV-TRAVEL-TO>) 
(UAV-LAUNCH-AND-FLY-TO-TGT <template UAV-LAUNCH-AND-FLY-TO-TGT>) 
(MONITOR-LOC2 <template MONITOR-LOC2>) 
(TRACK <template TRACK>) 
(LAND-BLACKJACK <template LAND-BLACKJACK>) 
(MONITOR <template MONITOR>) 
(DO-TASKS1 <template DO-TASKS1>) 
(SEARCH <template SEARCH>) 
(DO-TASKS4 <template DO-TASKS4>) 
(DO-SURVEIL-TASK <template DO-SURVEIL-TASK>)
|#