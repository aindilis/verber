;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)

;;;
;;; The process of building these actions that use the ontology is as follows:
;;;
;;; We transform the action from nasa2.pddl
;;;  1- predicates: either change them to the new predicates, or make new predicates in the ontology
;;;  2- parameters and variables: either change the names to match the ontology or make new ones in the ontology
;;;  3- find a problem from problems2.pddl and transform it as in 1 and 3 above, storing in owlpddlprobs.pddl.
;;;  Making new predicates and objects means:
;;;  1 - see if anything like them is in excatt, by using excatt-utilities. If so, generate them
;;;      using events->owl and put them in the appropriate defs file
;;;      otherwise manually build the objects and their classes in the defs file
;;;  2 - run do-all from generatePhase2owl.lisp
;;;  3 - run generate-all-to from owl-to-pddl.lisp
;;;  4 - use APQuickmake.lisp to load the new pddls and use run-all to test.
#|
debug stuff
;;; to debug (trace apply-param-tests template+bindings check-condition add-var)
;;; print-relation-history print-relation-props is helpful too

(setf thing (second (plot-subactions DDCU-CHANGE-OUT12100)))
(test-alternative thing)

(defun petes-debug (plan-root node-number)
  (test-alternative (nth (1- node-number)
			 (plot-subactions plan-root))))

(petes-debug DO-JOBS1286 3)

(setf sit (output-situation DDCU-R&R-PREP362))
(print-relation-props possesses sit)
(print-relation-history possesses sit)

;;; Not sure why the delay is here
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
    :duration time-for-delay
    :effect (at end (Delay10_a done)))

(define (durative-action Delay-action)
    :parameters (?inside-agent - crew)
    :expansion (sequential
		(has-iss-location ?inside-agent AIRLOCK)
		(Delay10_a done)
		(has-iss-location ?inside-agent INTRA-VEHICLE))
    :effect (at end (Delay-action_a ?inside-agent))
    :comment "experimenting with an action that just lets time pass."
    )
;;|#

;;;****************************************
;;; egressing agents
;;;****************************************
;;;
;;; Gets an inside agent outside
;;;

;;;
;;; 5/25/15 SHouldn'rt use = with agents or designators (until Chris fixes it).
(define (durative-action Egress-inside-agent)
    :parameters (?ev - crew 
		     ?st - safety-tether)
    :duration 4.0 
    :condition (and (at start (= (has-iss-location ?st) alck-stb-nad)) ;;; over all doesn't work
		    (at start (installed-state ?st yes)) ;; as opposed to one in an STP
		    (at start (is-available ?st yes))
		    (at start (= (has-iss-location ?ev) INTRA-VEHICLE))
		    )
    :effect (and ;;(at start (located ?ev nowhere)) 
		 (at end (has-iss-location ?ev AIRLOCK)) ;; the purpose of this action
		 (at end (tethered_to ?st ?ev)) ;; axioms will establish not(available)
		 (at end (cover-state thermal-cover-airlock open)))
		 
    :probability 0.5 ;;  don't use if assisted-egress is possible
    :comment "crew opens the cover, moves outside and tethers to a safety-tether at the AIRLOCK")

(define (durative-action Egress-inside-agent)
    :parameters (?ev - crew 
		     ?st - safety-tether)
    :duration 4.0 
    :condition (and (at start (= (has-iss-location ?st) alck-stb-nad)) ;;; over all doesn't work
		    (at start (installed-state ?st yes)) ;; as opposed to one in an STP
		    (at start (is-available ?st yes))
		    ;;(at start (= (has-iss-location ?ev) INTRA-VEHICLE))
		    ;;  This is better: CE 5/25/2015
		    (at start (has-iss-location ?ev INTRA-VEHICLE))
		    ;; the = syntax should mainly be used for testing :vars
		    )
    :effect (and ;;(at start (located ?ev nowhere)) 
		 (at end (has-iss-location ?ev AIRLOCK)) ;; the purpose of this action
		 (at end (tethered_to ?st ?ev)) ;; axioms will establish not(available)
		 (at end (cover-state thermal-cover-airlock open)))
		 
    :probability 0.5 ;;  don't use if assisted-egress is possible
     :comment "crew opens the cover, moves outside and tethers to a safety-tether at the AIRLOCK")

;;;
;;; Uses an outside agent to help an inside agent outside
;;;

(define (durative-action Egress-by-two)
    :parameters (?ev2 - crew
		      ?st - safety-tether) 
    :duration 2.0
    :effect (at end (egressed-by-two ?ev2 ?st))
    :comment "?ev2 hands out a waist tether, waits till its connected to ?st, 
              egresses and closes the AIRLOCK door"
    )

(define (durative-action Safety-tether-for-egress)
    :parameters (?ev1 - crew
		      ?st - safety-tether) ;; where is the waist tether? CE -- in the procedure-RPB
    :duration 2.0
    :effect (at end (tethered-for-egress ?ev1 ?st))
    :comment "?ev1 connects inside waist tether to outside ?st."
    )

(define (durative-action Assisted-egress)
    :parameters (?ev2 - crew ?st - safety-tether)
    :vars (?ev1 - crew)
    :condition (and (at start (= (has-ISS-location ?ev1) AIRLOCK))
		    (at start (= (has-ISS-location ?ev2) INTRA-VEHICLE))
		    (at start (= (has-ISS-location ?st) alck-stb-nad))
		    (at start (installed-state ?st yes)) ;; as opposed to being in an STP
		    (at start (is-available ?st yes))
		    (at start (cover-state thermal-cover-airlock open))
		    (at start (not (= ?ev1 ?ev2)))
		    )
    :expansion (SIMULTANEOUS
		(egressed-by-two ?ev2 ?st)
		(tethered-for-egress ?ev1 ?st))
    :effect (and (at end (tethered_to ?st ?ev2))
		 (at end (has-iss-location ?ev2 AIRLOCK)) ;; the purpose of this action
		 (at end (cover-state thermal-cover-airlock closed))
		 ) 
    :comment "joint task where outside agent helps inside agent outside")

(define (durative-action Prepare-for-eva)
    :parameters (?ev - crew ?a - crew-activity-type)
    :vars (?st - safety-tether)
    :duration 3.0
    :condition (and (at start (= ?a EVA))
		    (at start (= (tethered_to ?st) ?ev))
		    (at start (= (has-iss-location ?ev) AIRLOCK)))
    :effect (at end (prepared-for ?ev ?a))
    :comment "crew tethered outside moves around and checks all connections.")

(define (durative-action Crew-out)
    :vars (?inside-agent ?outside-agent - crew
			 ?robot - iss-robot)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (has-operator ?robot ?outside-agent))) 
		    (at start (not (has-operator ?robot ?inside-agent)))
		    (at start (= (has-iss-location ?inside-agent) INTRA-VEHICLE))
		    (at start (= (has-iss-location ?outside-agent) INTRA-VEHICLE))
		    ;;(at start (has-iss-location ?inside-agent INTRA-VEHICLE))
		    ;;(at start (has-iss-location ?outside-agent INTRA-VEHICLE))
		    )
    :expansion (sequential
		(has-iss-location ?outside-agent AIRLOCK)
		(has-iss-location ?inside-agent AIRLOCK)
		(parallel
		 (prepared-for ?inside-agent EVA)
		 (prepared-for ?outside-agent EVA))
		)
    :effect (at end (crew-moved-to AIRLOCK))
    :comment "First crew gets out, then second crew gets out, then they both prep for eva")

;;;***********************************************
;;; Ingressing agents
;;;***********************************************

;; When you ingress, one ev goes inside and untethers from the st, handing the st out.
;; After the outside ev hands the inside ev all the tools and bags, then the outside ev
;; detaches his st, goes in , and closes the door.

(define (durative-action Ingress-by-two)
    :parameters (?ev2 - crew
		      ?st - safety-tether)
    :duration 2.0
    :effect (and (at end (ingressed-by-two ?ev2 ?st))
		 )
    :comment "?ev2 opens the door, goes inside, disconnects from and hands out her ?st."
    )

(define (durative-action Untether-for-ingress)
    :parameters (?ev1 - crew
		      ?st - safety-tether)
    :duration 2.0
    :effect (at end (untethered-for-ingress ?ev1 ?st))
    :comment "?ev1 receives disconnected ?st and reels it in."
    )

(define (durative-action Assisted-ingress)
    :parameters (?ev2 - crew)
    :vars (?ev1 - crew ;;ev1 helps ev2 in
		?st - safety-tether)
    :condition (and 
		;; (at start (= (tethered_to ?st) ?ev2)) this fails two-in
		(at start (tethered_to ?st ?ev2)) 
		(at start (= (has-ISS-location ?st) alck-stb-nad))
		(at start (= (has-ISS-location ?ev2) AIRLOCK))
		(at start (= (has-ISS-location ?ev1) AIRLOCK))
		(at start (not (= ?ev1 ?ev2))))
    :expansion (SIMULTANEOUS
		(ingressed-by-two ?ev2 ?st)
		(untethered-for-ingress ?ev1 ?st))
    :effect (and (at end (tethered_to ?st nobody)) ;;axioms assert (is-available ?t yes)
		 (at end (has-ISS-location ?ev2 INTRA-VEHICLE))  ;; the purpose of this action
		 (at end (cover-state thermal-cover-airlock open))
		 ) 
    :comment "joint task where ?ev2 goes inside and hands out her freed ?st to ?ev1.")

(define (durative-action Ingress-outside-agent)
    :parameters (?ev - crew)
    :vars (?st - safety-tether)
    :duration 4.0 
    :condition (and (at start (cover-state thermal-cover-airlock open))
		    (at start (= (has-ISS-location ?ev) AIRLOCK))
		    (at start (= (has-ISS-location ?st) alck-stb-nad))
		    (at start (= (tethered_to ?st) ?ev))
		    )
		    
    :effect (and (at end (has-ISS-location ?ev INTRA-VEHICLE))
		 (at end (tethered_to ?st nobody)) ;;axioms assert (is-available ?t yes)
		 (at end (cover-state thermal-cover-airlock closed))
		 )
    :probability 0.5
    :comment "outside ?ev hooks a waist tether to the A/L d-ring, unhooks and stows his ?st, moves inside and closes the door"
    )

(define (durative-action Close-hatch) 
    :vars (?ev  - crew
	        ?robot - iss-robot)
    :duration 2.0
    :condition (and (at start (cover-state thermal-cover-airlock closed))
		    (at start (= (has-ISS-location ?ev) INTRA-VEHICLE))
		    (at start (not (has-operator ?robot ?ev))))
    :effect (at end (hatch-state airlock-hatch locked))
    :comment "?ev closes and locks the inner door to prepare for repressurization.")

(define (durative-action Prepare-for-repress)
    :parameters (?ev - crew ?a - crew-activity-type)
    :duration 3.0
    :condition (and (at start (= ?a repressurization))
		    (at start (= (has-ISS-location ?ev) INTRA-VEHICLE))
		    (at start (hatch-state airlock-hatch locked))
		    )
    :effect (at end (prepared-for ?ev ?a))
    :comment "?ev stows SCU and turns suit water off.")

(define (durative-action Crew-in)
    :vars (?inside-agent ?outside-agent - crew
			 ?robot - iss-robot)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (= (has-operator ?robot) ?outside-agent))) 
		    (at start (not (= (has-operator ?robot) ?inside-agent)))
		    (at start (= (has-iss-location ?inside-agent) AIRLOCK))
		    (at start (= (has-iss-location ?outside-agent) AIRLOCK)))
    :expansion (sequential
		(has-iss-location ?inside-agent INTRA-VEHICLE)
		(has-iss-location ?outside-agent INTRA-VEHICLE)
		(hatch-state airlock-hatch locked)
		(parallel
		 (prepared-for ?inside-agent repressurization)
		 (prepared-for ?outside-agent repressurization)))
    :effect (at end (crew-moved-to intra-vehicle))
    :comment "First crew gets in, then second crew gets in and closes the hatch, then they both prep for repress")

;;;
;;; Traveling
;;;

(Defparameter *area-truss-loc-order* 
    '("S5" "S4" "S3" "S2" "S1" "S0" "Z1" "P1" "P3" "P4" "p5" "P6"))

(defparameter *area-es-loc-order* 
    '("ELC01" "ELC03" "P1" "S0" "AIRLOCK""ESP02" "ESP01" "S1" "ELC02" "ESP03" "ELC04"))

(defparameter *area-mod-loc-order* 
    '("ULAB" "NOD2")) 

(defun get-iss-area-loc (iss-loc)
  (let* ((loc-str (string (name iss-loc)))
	 (truss-subseq (subseq loc-str 0 2)) ;; length 2
	 (mod-subseq (subseq loc-str 0 4)) ;; length 4
	 (ext-stow-subseq (subseq loc-str 0 5)) ;; length 5
	 (out-str ""))
    (cond ((member truss-subseq *area-truss-loc-order* :test #'equal)
	   truss-subseq)
	  ((equal loc-str "AIRLOCK")
	   loc-str)
	  ((member mod-subseq *area-mod-loc-order* :test #'equal)
	   mod-subseq)
	  ((member ext-stow-subseq *area-es-loc-order* :test #'equal)
	   ext-stow-subseq)
	  (t out-str))))

 ;;; (get-iss-area-loc S0B01F01MP)
 ;;; (get-iss-area-loc ELC0107-FWD-STB-NAD)

;;; Just checking
(defun time-from-path (action)
  (let* ((start-loc (gsv action '?start-loc))
	 (end-loc (gsv action '?end-loc))
	 (sloc-str (get-iss-area-loc start-loc))
	 (eloc-str (get-iss-area-loc end-loc))
	 (snum (position sloc-str *area-es-loc-order* :test #'equal))
	 (enum (position eloc-str *area-es-loc-order* :test #'equal))
	 (dist (if (and snum enum)
		   (abs (- enum snum))
		 1))
	 )
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> For Action ~a" (name action))
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> Computing time from ~a to ~a" start-loc end-loc)
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> Computing time from ~a to ~a" sloc-str eloc-str)
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> Dist = ~a~%~%" dist)
    (* 5.0 dist)))

(define (durative-action Translate-by-handrail)
    :parameters (?ev - crew
		 ?end-loc - iss-location)
    :vars (?start-loc - iss-location)
    :condition (and (at start (not (= ?start-loc intra-vehicle)))
		    (at start (not (= ?end-loc intra-vehicle)))
		    ;;(at start (= (has-iss-location ?ev) ?start-loc)) 4/22/13 This kills delay-bob and crew-round-trip 
		    (at start (has-iss-location ?ev ?start-loc))
		    (at start (not (too-far ?start-loc ?end-loc))))
    :effect (at end (has-iss-location ?ev ?end-loc))
    :duration time-from-path
    :execute (print (list "TRANSLATING BY HANDRAIL!!!" ?ev ?start-loc ?end-loc))
    :comment "?ev travels by handrail from ?start-loc to ?end-loc")

;; If the distance is too far, we must execute  tether swap.

;; A simple swap if the 2nd tether is already installed at the location.
;; The end of the first tether is connected to the 2nd tether.
#|(define (durative-action tether-swap)
    :parameters (?ev - crew
		     ?st1 ?st2 - safety-tether)
    :vars (?l - (has-iss-location ?ev))
    :condition (and (at start (not (= ?st1 ?st2)))
		    (at start (tethered_to ?st1 ?ev))
		    (at start (= (has-iss-location ?st2) ?l))
		    (at start (not (tethered_to ?st2 ?ev)))
		    (at start (is-available ?st2 yes))
		    (at start (installed-state ?st2 yes))
		    )
    :effect (and (at end (tethered_to ?st2 ?ev))
		 (at end (tether-swapped ?ev ?st1))) ;; needed for decomps
    :duration 2
    :comment "?ev swaps one tether for another in place.")|#

;;;5/27/13 This gets a better solution to bob-round-trip2
;;; Soon as I put the availabel and installed state stuff in it gets an invalid plan
(define (durative-action tether-swap)
    :parameters (?ev - crew
		     ?st1 ?st2 - safety-tether)
    :vars (?l - (has-iss-location ?ev))
    :condition (and (at start (not (= ?st1 ?st2)))
		    (at start (tethered_to ?st1 ?ev))
		    (at start (not (tethered_to ?st2 ?ev)))
		    (at start (= (has-iss-location ?st2) ?l))
		    (at start (not (tethered_to ?st2 ?ev)))
		    ;;(at start (is-available ?st2 yes))
		    ;;(at start (installed-state ?st2 yes))
		    )
    :effect (and (at end (tethered_to ?st2 ?ev))
		 ;;(at start (is-available ?st2 no))
		 ;;(at start (is-available ?st1 yes))
		 (at end (tether-swapped ?ev ?st1))) ;; needed for decomps
    :duration 2
    :comment "?ev swaps one tether for another in place.")

 ;;; Now going back the other way, we swap a tether with the one we left there.
(define (durative-action tether-swap-back)
    :parameters (?ev - crew
		     ?st2 ?st1 - safety-tether)
    :vars (?l - (has-iss-location ?ev))
    :condition (and (at start (not (= ?st1 ?st2)))
		    (at start (tethered_to ?st1 ?ev))
		    (at start (tethered_to ?st2 ?ev))
		    (at start (= (has-iss-location ?st2) ?l))
		    (at start (installed-state ?st2 yes))
		    )
    :effect (and (at end (not (tethered_to ?st2 ?ev)))
		 (at end (is-available ?st2 yes))
		 (at end (tether-swapped ?ev ?st2))) ;; needed for decomps
    :duration 2
    :comment "?ev swaps second tether for the first one in place.")

(define (durative-action install-tether&swap)
    :parameters (?ev - crew
		     ?st1 ?st2 - safety-tether)
    :vars (?l - (has-iss-location ?ev)
	      ?stp - (possesses ?ev))
    :condition (and (at start (= (contained_by ?st2) ?stp))
		    (at start (not (= ?st1 ?st2)))
		    (at start (tethered_to ?st1 ?ev))
		    )
    :effect (and (at end (not (contained_by ?st2 ?stp)))
		 (at end (tethered_to ?st2 ?ev))
		 (at end (has-iss-location ?st2 ?l))
		 (at end (tether-swapped ?ev ?st1)))
    :duration 5
    :comment "?ev installs a second tether and then swaps his current tether for the new one.")

;;; Now going back the other way, we swap tethers and pick up the one we brought
(define (durative-action tether-swap&pick-up)
    :parameters (?ev - crew
		     ?st2 ?st1 - safety-tether)
    :vars (?l - (has-iss-location ?ev)
	      ?stp - (possesses ?ev))
    :condition (and (at start (not (= ?st1 ?st2)))
		    (at start (tethered_to ?st2 ?ev)) ;; when the functional form of this is used, BOB-TO-P3 uses it incorrectly.
		    (at start (tethered_to ?st1 ?ev)) ;; when the functional form of this is used, BOB-TO-P3 uses it incorrectly.
		    (at start (not (contained_by ?st2 ?stp))) ;; ought to have (contains ?stp nothing)
		    )
    :effect (and (at end (not (tethered_to ?st2 ?ev)))
		 (at end (contains ?stp ?st2)) 
		 (at end (tether-swapped ?ev ?st2)))
    :duration 5
    :comment "?ev swaps his current tether for the old one then picks up the old one.")

(define (durative-action Translate-by-hr&swap)
    :parameters (?ev - crew
		 ?end-loc - location)
    :vars (?start-loc - (has-iss-location ?ev)
	   ?mloc - (intermediate-loc-for ?start-loc ?end-loc)
	   ?st - safety-tether)
    :condition (and 
		(at start (not (= ?start-loc intra-vehicle)))
		(at start (not (= ?end-loc intra-vehicle)))
		(at start (too-far ?start-loc ?end-loc))
		(at start (not (= ?start-loc ?end-loc)))
		(at start (= (tethered_to ?st) ?ev))
		)
    :expansion (sequential
		(has-iss-location ?ev ?mloc)
		(tether-swapped ?ev ?st)
		(has-iss-location ?ev ?end-loc)
		)
    :effect (at end (has-iss-location ?ev ?end-loc))
    :duration time-from-path
    :comment "?ev travels by handrail to ?end-loc via ?mloc")

(define (durative-action Extract-item-to-bag) ;; call it this to match the one from PRIDE
    :parameters (?ev - crew
		     ?item - (or luminaire__ceta_light
				 control-panel-assembly)
		     ?container - oru-bag)
    :vars (?pgt - pgt-with-turn-setting
		?l - (has-iss-location ?item)
		)
    :duration 12.0
    :condition (and (at start (= (has-iss-location ?ev) ?l))
		    (at start (possesses ?ev ?container))
		    (at start (= (possessed_by ?pgt) ?ev))
		    (at start (bag-size-for ?item ?container)))
    :effect (and (at end (item-extracted ?ev ?item))
		 (at end (contains ?container ?item))
		 ;;(at end (possesses ?ev ?item)) ;; added by CE 7/7/2015
		 )
	     
    :comment "crew removes ?item at ?l and stows in bag."
    )

(define (durative-action Retrieve-item)
    :parameters (?ev - crew
		     ?item - (or luminaire__ceta_light
			     control-panel-assembly
			     power-cable
			     space-positioning-device))
    :vars (?container - (or oru-bag fish-stringer)
	   ?loc - (has-iss-location ?item))
    :expansion (sequential
		;;(possessed_by ?container ?ev)
		(possesses ?ev ?container)
		(has-iss-location ?ev ?loc)
		(item-extracted ?ev ?item)
		)
    :effect (at end (item-retrieved ?ev ?item))
    :comment "?ev picks up ?container, travels to ?item's loc, unmounts and stores ?item in ?container and returns.")

;;; Used for the pride demo
(define (durative-action Retrieve-item2)
    :parameters (?ev - crew
		     ?item - luminaire__ceta_light
		     )
    :vars (?container - (bag-size-for ?item)
		      ?loc - (has-iss-location ?item))
    :condition (at start (has-iss-location ?ev airlock))
    :expansion (sequential
		;;(possessed_by ?container ?ev) ;;; for the PRIDE demo
		(possesses ?ev ?container)
		(has-iss-location ?ev ?loc)
		(item-extracted ?ev ?item)
		(has-iss-location ?ev airlock)
		(has-iss-location ?item INTRA-VEHICLE)
		)
    :effect (at end (retrieve-and-stow ?ev ?item))
    :comment "?ev picks up ?container, travels to ?item's loc, unmounts and stores ?item in ?container and returns.")

;;;****************************************
;;; handing stuff out and in 
;;;****************************************

(define (durative-action Stow)
    :parameters (?ev - crew
	         ?item - (or equipment station-object))
    :duration 2.0
    :effect (at end (stowed ?ev ?item))
    :comment "?ev receives ?item and stows")

(define (durative-action Hand-over)
    :parameters (?ev - crew
	         ?item - (or equipment station-object))
    :duration 2.0
    :effect (at end (handed-over ?ev ?item))
    :comment "?ev untethers and hands over ?item ")

(define (durative-action Stow-external)
    :parameters (?item - equipment)
    :vars (?inside-ev ?outside-ev - crew
	   ?robot - iss-robot)
    :condition (and 
		(at start (= (has-iss-location ?item) INTRA-VEHICLE))
		(at start (cover-state thermal-cover-airlock open))
		(at start (= (has-iss-location ?outside-ev) AIRLOCK))
		(at start (= (has-iss-location ?inside-ev) INTRA-VEHICLE))
		(at start (not (= (has-operator ?robot) ?inside-ev)))
		(at start (not (= ?inside-ev ?outside-ev))))
    :expansion (simultaneous
		(handed-over ?inside-ev ?item)
		(stowed ?outside-ev ?item))
    :effect (at end (has-iss-location ?item AIRLOCK))
    :comment "?inside-ev hands ?item to ?outside-ev")

;;;(explain-failed-goal (goal bag-outside))

;;; Oldest one before 25 May 15
;;; Chris thought this was the original 7/7/2015
(define (durative-action Stow-internal)
    :parameters (?outside-ev - crew 
			    ?item - (or equipment station-object))
    :vars  (?inside-ev  - crew ;; helper
		       ?robot - iss-robot)
    :condition (and (at start (= (has-iss-location ?outside-ev) AIRLOCK))
		    (at start (= (has-iss-location ?inside-ev) INTRA-VEHICLE))
		    (at start (= (possessed_by ?item) ?outside-ev))
		    (at start (cover-state thermal-cover-airlock open))
		    (at start (not (= (has-operator ?robot) ?inside-ev)))
		    (at start (not (= ?inside-ev ?outside-ev))))
    :expansion (simultaneous
		(handed-over ?outside-ev ?item)
		(stowed ?inside-ev ?item))
    :effect (and (at end (has-iss-location ?item INTRA-VEHICLE))
		 (at end (not (possessed_by ?item ?outside-ev)))
		 )
    :comment "?outside-ev hands ?item to ?inside-ev")

#|;;; Now the one from 5/25/15
(define (durative-action Stow-internal)
    :parameters (?outside-ev - crew 
			    ?item - (or equipment station-object))
    :vars  (?inside-ev  - crew ;; helper
		       ?robot - iss-robot)
    :condition (and (at start (has-iss-location ?outside-ev AIRLOCK))
		    (at start (has-iss-location ?inside-ev INTRA-VEHICLE))
		    (at start (= (possessed_by ?item) ?outside-ev))
		    (at start (cover-state thermal-cover-airlock open))
		    (at start (not (= (has-operator ?robot) ?inside-ev)))
		    (at start (not (= ?inside-ev ?outside-ev))))
    :expansion (simultaneous
		(handed-over ?outside-ev ?item)
		(stowed ?inside-ev ?item))
    :effect (and (at end (has-iss-location ?item INTRA-VEHICLE))
		 (at end (not (possessed_by ?item ?outside-ev)))
		 )
    :comment "?outside-ev hands ?item to ?inside-ev")
;;|#

;;; CE 7/7/2015  = condition overused, causes everyting to become a constraint
;;    rule: only use it when a :var is referenced and that ?var is a resource

(define (durative-action Stow-internal)
    :parameters (?outside-ev - crew 
			    ?item - (or equipment station-object))
    :vars  (?inside-ev  - crew ;; helper
		       ?robot - iss-robot)
    :condition (and (at start (has-iss-location ?outside-ev AIRLOCK))
		    (at start (= (has-iss-location ?inside-ev) INTRA-VEHICLE))
		    (at start (possessed_by ?item ?outside-ev))
		    (at start (cover-state thermal-cover-airlock open))
		    (at start (not (= (has-operator ?robot) ?inside-ev)))
		    (at start (not (= ?inside-ev ?outside-ev))))
    :expansion (simultaneous
		(handed-over ?outside-ev ?item)
		(stowed ?inside-ev ?item))
    :effect (and (at end (has-iss-location ?item INTRA-VEHICLE))
		 (at end (not (possessed_by ?item ?outside-ev)))
		 )
    :comment "?outside-ev hands ?item to ?inside-ev")

(define (durative-action Egress-agents)
    :vars (?inside-agent ?outside-agent - crew
			 ?ceta-light - luminaire__ceta_light
			 ?bag - medium-oru-bag
			 ?robot - iss-robot)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (= (has-operator ?robot) ?outside-agent)))
		    (at start (not (= (has-operator ?robot) ?inside-agent)))
		    (over all (bag-size-for ?ceta-light ?bag))
		    (at start (= (has-iss-location ?inside-agent) INTRA-VEHICLE))
		    (at start (= (has-iss-location ?outside-agent) INTRA-VEHICLE)))
    :expansion (sequential
		(has-iss-location ?outside-agent AIRLOCK)
		(has-iss-location ?bag AIRLOCK)
		(has-iss-location ?inside-agent AIRLOCK)
		(parallel
		 (prepared-for ?inside-agent EVA)
		 (prepared-for ?outside-agent EVA))
		)
    :effect (at end (crew-and-tools AIRLOCK))
    :comment "First crew gets out, then second crew hands tools out then gets out, then they both prep for eva")

(new-predicate '(JOBS-DONE ?AGENT1 - crew) *domain*)

(define (durative-action Ingress-agents)
    :vars (?inside-agent ?outside-agent - crew
			 ?robot - iss-robot
			 ?bag - oru-bag)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (= (has-operator ?robot) ?outside-agent)))
		    (at start (not (= (has-operator ?robot) ?inside-agent)))
		    (at start (= (has-iss-location ?inside-agent) AIRLOCK))
		    (at start (= (has-iss-location ?outside-agent) AIRLOCK))
		    (at start (= (possessed_by ?bag) ?outside-agent)))
    :expansion (sequential
		(has-iss-location ?inside-agent INTRA-VEHICLE)
		(has-iss-location ?bag INTRA-VEHICLE)
		(has-iss-location ?outside-agent INTRA-VEHICLE)
		(hatch-state airlock-hatch locked)
		(parallel
		 (prepared-for ?inside-agent repressurization)
		 (prepared-for ?outside-agent repressurization)))
    :effect (at end (crew-and-tools intra-vehicle))
    :comment "First crew gets in, then second crew hands bag in then gets in and closes the hatch, then they both prep for repress")

(define (durative-action Pick-up)
    :parameters (?ev - crew
		     ?item - equipment)
    :vars (?l - (has-iss-location ?item))
    :condition (and (at start (forall (?h - (or oru-bag worksite-inter-face worksite-inter-face-adapter))
				      (not (contained_by ?item ?h))))
		    ;; (at start (installed-state ?item no)) easier to just set those few that are installed
		    (at start (not (installed-state ?item yes)))
		    (at start (has-iss-location ?ev ?l))
		    )
    :duration 2.0
    :effect (at end (possesses ?ev ?item))
    :comment "Untether from a handrail and tether or otherwise secure an item to ?ev's suit")

 ;;;A full action as would be generated by the GUI
(DEFINE (DURATIVE-ACTION DO-JOBS) 
    :PARAMETERS (?AGENT1 - CREW) 
    :VARS
    (?AGENT2 - CREW 
	     ?robot - iss-robot 
	     ?STP - SAFETY-TETHER-PACK 
	     ?BAG - MEDIUM-ORU-BAG)
	:CONDITION
	(AND (AT START (NOT (= ?AGENT1 ?AGENT2)))
	     (AT START (NOT (= (has-operator ?robot) ?AGENT1)))
	     (AT START (NOT (= (has-operator ?robot) ?AGENT2))) 
	     (POSSESSES ?AGENT1 ?STP)
	     (OVER ALL (BAG-SIZE-FOR LUMINAIRE_3 ?BAG)))
	:EXPANSION
	(SEQUENTIAL (has-iss-location ?AGENT1 AIRLOCK) 
		    (has-iss-location ?BAG AIRLOCK)
		    (PREPAREd-FOR ?AGENT1 EVA) 
		    (POSSESSES ?AGENT1 ?BAG)
		    (item-retrieved ?AGENT1 LUMINAIRE_3)
		    (has-iss-location ?AGENT1 AIRLOCK)
		    (has-iss-location ?BAG INTRA-VEHICLE) 
		    (has-iss-location ?AGENT1 INTRA-VEHICLE) 
		    (hatch-state airlock-hatch locked)
		    (PREPAREd-FOR ?AGENT1 repressurization))
	:EFFECT (AT END (JOBS-DONE ?AGENT1)))

;;;**************************************************************
;;; Place/install
;;;**************************************************************
;;;
;;; place (tether to a handrail at a loc)
;;;

;;; A conundrum here. An axiom says that an item is located wherever its possessor is located. 
;;; So the put-down action is not to locate the item but to dispossess the possessor of the item.  
;;; We have to distinguish between real possession, e.g.,having the item tethered to a waist tether or BRT on the suit, 
;;; and indirect possession, where you possess a container that contains the object.

(define (durative-action Put-down)
    :parameters (?ev - crew 
		     ?item - equipment
		       )
    :condition (and (at start (forall (?h - oru-bag)
				      (not (contained_by ?item ?h))))
		    (at start (forall (?f - fish-stringer)
				      (not (contained_by ?item ?f))))
		    (at start (possesses ?ev ?item))
		    )
    :duration 2.0
    :effect (at end (not (possesses ?ev ?item)))
    :comment "detach from suit and tether to a location (i.e., a handrail)"
    )

;;;
;;; Install
;;;

;; The analog to extract is install.
;; You can install most things like lights and cables by taking them out of/off their container
;; and bolting them at their location.
;; Some things - like fqd-jumpers, are stored at a location and just
;; need to be unfolded or otherwise prepared and then connected up.
;;

;;; Sometimes you don't put-down (tether), you attach
(define (durative-action install-item)
    :parameters (?ev - crew 
		     ?item - multi-use-tether-end-effector
		       )
    :condition (at start (possesses ?ev ?item))
    :duration 2.0
    :effect (and
	     (at end (installed-state ?item yes))
	     (at end (not (possesses ?ev ?item)))
	     (at end (item-installed ?ev ?item)))
    :comment "detach from suit and attach to HR."
    )

(define (durative-action Install-item-from-container)
    :parameters (?ev - crew 
		     ?item - (or luminaire__ceta_light
				  power-cable 
				  space-positioning-device
				  control-panel-assembly)
	       )
    :vars (?l - (location-for ?item)
	      ?container - (or oru-bag fish-stringer))
    :duration 12.0
    :condition (and (at start (= (has-iss-location ?ev) ?l))
		    (at start (= (possessed_by ?container) ?ev))
		    (at start (= (contained_by ?item) ?container))
		    )
    :effect (and 
	     (at end (installed-state ?item yes))
	     (at end (not (contains ?container ?item)))
	     (at end (item-installed ?ev ?item))
	     )
	     
    :comment "crew takes ?item off or out of container and bolts it to a location."
    )

(define (durative-action go-install-item)
    :parameters (?ev - crew
		     ?item - (or luminaire__ceta_light
				 control-panel-assembly
				 power-cable))
    :vars (?container - (contained_by ?item)
		      ?loc - (location-for ?item))
    :expansion (sequential
		(possesses ?ev ?container)
		(has-iss-location ?ev ?loc)
		(installed-state ?item yes)
		)
    :effect (at end (item-installed ?ev ?item))
    :comment "?ev picks up ?container that holds ?item, travels to the item's loc and installs it.")

(define (durative-action Install-fqd-in-place)
    :parameters (?ev - crew 
		     ?item - fluid-jumper 
		      ?holder - (or fish-stringer oru-bag)
		      ?spd1 ?spd2 - space-positioning-device)
    :duration 12.0
    :condition (and (at start (= (has-iss-location ?ev)(location-for ?item)))
		    (at start (possesses ?ev ?holder))
		    (at start (not (= ?spd1 ?spd2)))
		    (at start (= (contained_by ?spd1) ?holder))
		    (at start (= (contained_by ?spd2) ?holder))
		    )
    :effect (and 
	     (at end (installed-state ?item yes))
	     (at end (not (contains ?holder ?spd1)))
	     (at end (not (contains ?holder ?spd1)))
	     (at end (item-installed-in-place ?ev ?item))
	     )
	     
    :comment "crew unpacks ?item and connects it up at a location."
    )

(define (durative-action install-in-place)
    :parameters (?ev - crew
		     ?item - fluid-jumper)
    :vars (?loc - (location-for ?item)
		?spd1 ?spd2 - space-positioning-device
		?container - (contained_by ?spd1))
    :condition (and (at start (not (= ?spd1 ?spd2)))
		    (at start (= (contained_by ?spd2) ?container)))
    :expansion (sequential
		(possesses ?ev ?container)
		(has-iss-location ?ev ?loc)
		(installed-state ?item yes)
		)
    :effect (at end (item-installed-in-place ?ev ?item))
    :comment "?ev picks up ?container that holds ?item, travels to the item's loc and installs it.")

;;;
;;; Extract
;;;
;;; Like a mut-ee. It's not tethered, its installed.
(define (durative-action Extract-item-to-suit)
    :parameters (?ev - crew 
		     ?item - (or multi-use-tether-end-effector nh3_vent_tool)
		     )
    :vars (?l - (has-iss-location ?item))
    :duration 5.0
    :condition (and (at start (has-iss-location ?ev ?l))
		    (at start (installed-state ?item yes))
		    )
    :effect (and (at end (installed-state ?item no))
		 (at end (possessed_by ?item ?ev)))
    :comment "crew removes ?item and stows on suit tether."
    )

;;; apfrs can be tethered to a handrail
;; But when they are installed in holders like wifs or wifas, you pick them up by extracting them.
(define (durative-action Extract-apfr)
    :parameters (?ev - crew
		     ?apfr - articulating-portable-foot-restraint
		     )
    :vars (?holder - (contained_by ?apfr)
		   ?l - (has-iss-location ?holder))
    :condition (at start (has-iss-location ?ev ?l))
    :duration 1.0
    :effect (and (at end (possesses ?ev ?apfr))
		 (at end (not (contained_by ?apfr ?holder)))
		 )
    :comment "Pull ?apfr from ?holder and secure to ?ev's suit")

;;;***************************************************************
;;; DDCU stuff
;;;***************************************************************

;;; Two versions: one that needs two evs to break the torque
;;; Since either ev can have the torque-break pgt,
;;; I just insist that both pgts be at the site.
(define (durative-action Extract-ddcu-by-two)
    :parameters (?ev1 - crew 
		     ?item - dc_dc_converter_unit_external_[ddcu-e])
    :vars (?ev2 - crew ;;;helper
	      ?pgt1 - pgt-with-turn-setting
	      ?pgt2 - pgt-with-torque-break-setting
	      ?scoop - micro_scoop__ohts_[square_scoop]
	      ?l - (has-iss-location ?item))
    :duration 15.0
    :condition (and (at start (not (= ?ev1 ?ev2)))
		    (at start (has-iss-location ?ev1 ?l))
		    (at start (has-iss-location ?ev2 ?l))
		    (at start (= (has-iss-location ?pgt1) ?l))
		    (at start (= (has-iss-location ?pgt2) ?l))
		    (at start (possesses ?ev1 ?scoop)))
    :effect (and (at end (possesses ?ev1 ?item))
		 (at end (contains ?item ?scoop)))
    :probability 0.75
    :comment "?ev1 & ?ev2 extract ?item by using two pgts"
    )

;;; And one that needs just one ev and a ratchet wrench
;;; possesed_by dint work, e.g., (at start (= (possessed_by ?pgt) ?ev))
(define (durative-action Extract-ddcu)
    :parameters (?ev - crew 
		     ?item - dc-to-dc-converter-unit)
    :vars (?l - (has-iss-location ?item)
	      ?pgt - pgt-with-turn-setting
	      ?torque-breaker - wrench__7_16-inch_ratcheting_box_end
	      ?scoop - micro_scoop__ohts_[square_scoop])
    :duration 20.0
    :condition (and (at start (has-iss-location ?ev ?l))
		    (at start (possesses ?ev ?pgt))
		    (at start (possesses ?ev ?torque-breaker))
		    (at start (possesses ?ev ?scoop))
		    )
    :effect (and (at end (possesses ?ev ?item))
		 (at end (contains ?item ?scoop)))
    :probability 0.95	     
    :comment "?ev removes ?item at ?l using pgt and torque breaker."
    )

;;; An ev can carry a ddcu on a body restraint tether (BRT).
;;; This positions anything that can be tethered, including bags
;;; A spare-ddcu is carried on a stanchion mount cover, so if you position
;;; the cover and it contains the ddcu, then you should position
;;; the ddcu.

(define (durative-action item-positioned)
    :parameters (?item - (or luminaire__ceta_light
				 control-panel-assembly
				 stanchion-mount-cover 
				 equipment
				 (not space-positioning-device))
		     ?loc - location)
    :vars (?ev - (possessed_by ?item)) ;; need to establish this first
    :condition (at start (not (= (has-iss-location ?item) INTRA-VEHICLE)))
    :expansion (sequential
		(has-iss-location ?ev ?loc)
		(not (possesses ?ev ?item))
		)
    :effect (at end (item-positioned ?item ?loc))
    :comment "?ev picks up ?item, goes to the loc and tethers it there.")

;;; One way is if an ev at the ddcu site has a scoop
;;; 10/17/13 A problem here if the scoop is in a bag.
;;; If ev possesses the bag then she possesses the scoop.
;;; Unless you take the scoop out of the bag, the (not (possesses ?ev ?scoop))
;;; will conflict. Consider a second action where the scoop is in a bag...
(define (durative-action Install-scoop)
    :parameters (?scoop - micro_scoop__ohts_[square_scoop]
		     ?ddcu - dc-to-dc-converter-unit)
    :vars (?ev - (possessed_by ?scoop))
    :condition (at start (= (has-iss-location ?ev)(has-iss-location ?ddcu)))
    :effect (and (at end (scoop-installed ?scoop ?ddcu))
		 (at end (contains ?ddcu ?scoop))
		 ;;(at end (not (possesses ?ev ?scoop)))
		 (at end (is-available ?scoop no))
		 )
    :comment "someone bolts scoop onto the ddcu")

;;; Another way is if an ev at the ddcu site has a container that has the scoop
(define (durative-action Install-scoop-from-container)
    :parameters (?scoop -  micro_scoop__ohts_[square_scoop]
		     ?ddcu - dc-to-dc-converter-unit)
    :vars (?ev - crew
	       ?h - (contained_by ?scoop))
    :condition (and (at start (= (possessed_by ?h) ?ev))
		    (at start (= (has-iss-location ?ev)(has-iss-location ?ddcu)))
		    )
    :effect (and (at end (scoop-installed ?scoop ?ddcu))
		 (at end (is-available ?scoop no))
		 (at end (contains ?ddcu ?scoop))
		 (at end (not (contains ?h ?scoop))))
    :comment "someone takes a scoop out of the container and bolts it onto the ddcu")

(new-predicate '(site-prepped-for-r&r ?ev - crew ?item - oru-location) *domain*)

;;(PUSH :V *PDBG*)

;;; 9/24/13 Want to push on oru location and iss loctaions.
;;; When we do a task for DDCU_S01A, that's the ddcu with the S01A role.
;;; And there's an iss location for that role.
(define (durative-action ddcu-r&r-prep)
    :parameters (?ev - crew 
		     ?item - oru-location) ;; like DDCU_S01A
    :vars (?ddcu-spare - dc-to-dc-converter-unit
		       ?loc - (has-iss-location ?item)
		       ?scoop -  micro_scoop__ohts_[square_scoop]
		       ?bag - (contained_by ?scoop)
		       ?cover - stanchion-mount-cover
		       )
    :condition (and (at start (is-available ?ddcu-spare yes))
		    (at start (= (contained_by ?ddcu-spare) ?cover)))
    :expansion
    (sequential
     (possesses ?ev ?bag)
     (possesses ?ev ?cover)
     (item-positioned ?cover ?loc)
     (scoop-installed ?scoop ?ddcu-spare)
     (possesses ?ev ?cover) 
     )
    :effect (at end (site-prepped-for-r&r ?ev ?item))
    :comment "?ev picks up scoop and spare ddcu, goes to ddcu loc puts down the spare and installs the scoop on it")

;;;
;;; Stanchion mount covers.  Modeled as a container.
;;; One is on the spare ddcu in the IS. 
;;;

;;;(new-predicate '(present-item_a ?ev - crew ?item - dc-to-dc-converter-unit) *domain* t)
(define (durative-action Present-item)
    :parameters (?ev - crew
		     ?item - dc-to-dc-converter-unit
		     )
    :duration 2.0
    :effect (at end (present-item_a ?ev ?item))
    :comment "?ev holds item out for someone to take or install something on")

;;;(new-predicate '(remove-cover_a ?ev - crew ?item - dc-to-dc-converter-unit) *domain* t)
(define (durative-action Remove-cover)
    :parameters (?ev - crew
		     ?item - dc-to-dc-converter-unit
		     )
    :vars (?cover - (contained_by ?item))
    :duration 2.0
    :effect (at end (remove-cover_a ?ev ?item))
    :comment "?ev takes ?item off ?cover.")

;;;(new-predicate '(attach-cover_a ?ev - crew ?item - dc-to-dc-converter-unit) *domain* t)
(define (durative-action attach-cover)
    :parameters (?ev - crew
		     ?item - dc-to-dc-converter-unit
		     )
    :vars (?cover - stanchion-mount-cover)
    :condition (at start (possesses ?ev ?cover))
    :duration 2.0
    :effect (at end (attach-cover_a ?ev ?item))
    :comment "?ev puts ?item on ?cover.")

(new-predicate '(cover-removed ?pe - physical-entity ?cover - cover) *domain*)

(define (durative-action take-ddcu-off-cover)
    :parameters (?ddcu - dc-to-dc-converter-unit
		     ?cover - stanchion-mount-cover)
    :vars (?receiver - crew
		     ?presenter - (possessed_by ?cover)
		      ?scoop - micro_scoop__ohts_[square_scoop]
		  )
    :condition (and (at start (not (= ?receiver ?presenter)))
		    (at start (= (contained_by ?ddcu) ?cover)) ;; presenter grips
		    (at start (= (contained_by ?scoop) ?ddcu)) ;; receiver grips
		    (at start (= (has-iss-location ?receiver)(has-iss-location ?presenter)))
		    )
    :expansion (simultaneous
		(present-item_a ?presenter ?ddcu)
		(remove-cover_a ?receiver ?ddcu)
		)
    :effect (and (at end (cover-removed ?ddcu ?cover))
		 (at end (not (contains ?cover ?ddcu)))
		 (at end (not (possesses ?presenter ?ddcu))) ;;;shouldn't need since the cover doesn't contain it
		 (at end (possesses ?receiver ?ddcu))
		 )
    :comment "?presenter presents ?ddcu to ?receiver who removes it from ?cover.")

(define (durative-action put-cover-on-ddcu)
    :parameters (?ddcu - dc-to-dc-converter-unit
			   ?cover - stanchion-mount-cover)
    :vars (?receiver - (possessed_by ?cover)
	   ?presenter  - (possessed_by ?ddcu)
	   ?scoop - micro_scoop__ohts_[square_scoop]
		  )
    :condition (and (at start (not (= ?receiver ?presenter)))
		    (at start (= (has-iss-location ?receiver)
				 (has-iss-location ?presenter)))
		    (at start (= (contained_by ?scoop) ?ddcu))
		    )
    :expansion (simultaneous
		(present-item_a ?presenter ?ddcu)
		(attach-cover_a ?receiver ?ddcu)
		)
    :effect (and (at end (is-attached-to ?cover ?ddcu))
		 ;;(at end (cover-attached ?ddcu ?cover))
		 (at end (contains ?cover ?ddcu))
		 (at end (not (possesses ?presenter ?ddcu))))
    :comment "?presenter presents ?ddcu to ?receiver who screws on ?cover.")

;;;(new-predicate '(inserted ?item - dc-to-dc-converter-unit ?l - location) *domain* t)

#|(define (durative-action Temp-install-ddcu)
    :parameters (?item - dc-to-dc-converter-unit
		       ?l - location)
    :vars (?ev - crew
	       ?scoop - micro_scoop__ohts_[square_scoop])
    :value ?ev				; added by CE 3/28/2014
    :duration 15.0			; it will have no effect without link
    :condition (and			; (link <subgoal> :input ?ev1) in DDCU-R&R
		(at start (has-iss-location ?ev ?l))
		(at start (possesses ?ev ?item))
		(at start (= (contained_by ?scoop) ?item))
		    )
    :effect (and 
	     (at end (inserted-item ?ev ?item))
	     (at end (inserted ?item ?l))
	     (at end (not (contains ?item ?scoop)))
	     (at end (possesses ?ev ?scoop))
	     (at end (not (possesses ?ev ?item)))
	     )
	     
    :comment "?ev inserts ?item at ?l and takes off the ?scoop."
    )|#

(define (durative-action Temp-install-ddcu)
    :parameters (?ev - crew 
		     ?item - dc-to-dc-converter-unit)
    :vars (?l - location
	       ?scoop - micro_scoop__ohts_[square_scoop])
    :duration 15.0			
    :condition (and			
		(at start (has-iss-location ?ev ?l))
		(at start (possesses ?ev ?item))
		(at start (= (contained_by ?scoop) ?item))
		    )
    :effect (and 
	     (at end (inserted-item ?ev ?item))
	     (at end (inserted ?item ?l))
	     (at end (not (contains ?item ?scoop)))
	     (at end (possesses ?ev ?scoop))
	     (at end (not (possesses ?ev ?item)))
	     )
	     
    :comment "?ev inserts ?item at ?l and takes off the ?scoop."
    )

 ;;;(new-predicate '(install-item_a ?ev - crew ?item - dc-to-dc-converter-unit) *domain* t)
(define (durative-action Secure-ddcu)
    :parameters (?ev - crew 
		     ?item - dc-to-dc-converter-unit)
    :vars (?l - (has-iss-location ?item)
	       ?pgt - pgt-with-turn-setting)
    :duration 15.0
    :condition (and (at start (has-iss-location ?ev ?l))
		    (at start (= (possessed_by ?pgt) ?ev))
		    (at start (inserted ?item ?l)))
    :effect (and (at end (install-item_a ?ev ?item))
		 (at end (installed-state ?item yes)))
    :comment "?ev bolts ?item at ?l using ?pgt."
    )

(new-predicate '(replaced-item-at ?ev1 - crew ?oru-loc - oru-location) *domain*)

 ;;; With both evs at the site and the spare prepped, ev1 extracts the old-ddcu (supposedly tethering it to her brt).
;;; Then ev2 gives ev1 the spare using the cover and ev1 temp-installs the 
;;; spare, removing the scoop.  Then ev1 installs the scoop on the old ddcu and hands it over to
;;; the ev2 who puts the cover on it while ev1 holds it and then ev1 releases it.
(define (durative-action ddcu-change-out)
    :parameters (?ev1 - crew
		     ?oru-loc - oru-location
		     )
    :vars (?spare ?item - dc-to-dc-converter-unit
		   ?scoop - micro_scoop__ohts_[square_scoop]
		   ?cover - stanchion-mount-cover
		   ?ev2 - crew
		   ?loc - (has-iss-location ?oru-loc)
		   ;;?ev2 - (possessed_by ?cover) ;;; when I used this  r&r-d2 worked!
		   )
    :condition (and (at start (not (= ?spare ?item)))
		    (at start (has-iss-location ?item ?loc))
		    (at start (has-iss-location ?spare ?loc))
		    (at start (not (= ?ev1 ?ev2)))
;;; these should all be set up by the ddcu-prep
		    (at start (has-iss-location ?ev2 ?loc))
		    (at start (has-iss-location ?ev1 ?loc))
		    (at start (possesses ?ev2 ?cover))
		    (at start (= (contained_by ?scoop) ?spare))
		    (at start (= (contained_by ?spare) ?cover))
		    )
    :expansion (sequential
		(possesses ?ev1 ?item)	;;; ev1 extracts the old ddcu
		(cover-removed ?spare ?cover) ;;; ev2 presents spare and ev1 removes it from the cover
		(inserted-item ?ev1 ?spare)
		;;(inserted ?spare ?loc) ;;; ev1 inserts and takes scoop off spare
		;; if you tell TEMP-INSTALL-DDCU you want ?ev1 to do it, this works
		;;(link (inserted ?spare ?loc) :input ?ev1)
		(is-attached-to ?cover ?item) ;;;ev1 presents ev2 puts cover on
		(installed-state ?spare yes) ;; ev1 bolts it down
		)
    :effect (at end (replaced-item-at ?ev1 ?oru-loc))
    :comment "evs extract the ddcu, install the spare and bolt it down"
    )

#| I set the vars for the crew

(define (durative-action ddcu-change-out)
    :parameters (?ev1 - crew
		     ?oru-loc - oru-location
		     )
    :vars (?spare - ddcu-e_15
		  ?item - ddcu-e_3
		   ?scoop - micro_scoop__ohts_[square_scoop]
		   ?cover - stanchion-mount-cover
		   ?ev2 - sally
		   ?loc - (has-iss-location ?oru-loc)
		   ;;?ev2 - (possessed_by ?cover) ;;; when I used this  r&r-d2 worked!
		   )
    :condition (and (at start (not (= ?spare ?item)))
		    (at start (has-iss-location ?item ?loc))
		    (at start (has-iss-location ?spare ?loc))
		    (at start (not (= ?ev1 ?ev2)))
;;; these should all be set up by the ddcu-prep
		    (at start (has-iss-location ?ev2 ?loc))
		    (at start (has-iss-location ?ev1 ?loc))
		    (at start (possesses ?ev2 ?cover))
		    (at start (= (contained_by ?scoop) ?spare))
		    (at start (= (contained_by ?spare) ?cover))
		    )
    :expansion (sequential
		(possesses ?ev1 ?item)	;;; ev1 extracts the old ddcu
		(cover-removed ?spare ?cover) ;;; ev2 presents spare and ev1 removes it from the cover
		(inserted ?spare ?loc) ;;; ev1 inserts and takes scoop off spare
		(is-attached-to ?cover ?item) ;;;ev1 presents ev2 puts cover on
		(installed-state ?spare yes) ;; ev1 bolts it down
		)
    :effect (at end (replaced-item-at ?ev1 ?oru-loc))
    :comment "evs extract the ddcu, install the spare and bolt it down"
    )

and got the following problem
explain-failed-candidate <template DDCU-CHANGE-OUT>:
  var-tests failed on ((SAMEP (GET-VALUE CONTAINED_BY MICRO_SCOOP_2) DDCU-E_15)
                       (SAMEP (GET-VALUE CONTAINED_BY MICRO_SCOOP_3) DDCU-E_15)
                       (SAMEP (GET-VALUE CONTAINED_BY MICRO_SCOOP_1) DDCU-E_15)
                       (SAMEP (GET-VALUE CONTAINED_BY MICRO_SCOOP_4) DDCU-E_15))

But this state should have been set by the scoop install of the site prep

INSTALL-SCOOP453_OUT
AP(36): (print-relation-history contained_by sit)

R&R-D_IS:
   (CONTAINED_BY MICRO_SCOOP_1 CREW-LOCK-BAG1)
   (CONTAINED_BY 85-FT_TETHER_5 STP_2)
   (CONTAINED_BY SPD_2 FISH-STRINGER_1)
   (CONTAINED_BY DDCU-E_15 STANCHION-MOUNT-COVER1)
   (CONTAINED_BY SPD_1 FISH-STRINGER_1)
   (CONTAINED_BY 85-FT_TETHER_4 STP_1)
   (CONTAINED_BY MLM_PWR_CABLE_CH_1_4_1 FISH-STRINGER_1)
INSTALL-SCOOP453_OUT: (CONTAINED_BY MICRO_SCOOP_1 DDCU-E_15)

;;|#

(new-predicate '(remove&replace_a ?ev2 - crew ?oru-loc - oru-location) *domain*)

(define (durative-action ddcu-r&r)
    :parameters (?ev2 - crew
		      ?oru-loc - oru-location)
    :vars (?ev1 - crew
		?l - (has-iss-location ?oru-loc))
    :condition (at start (not (= ?ev1 ?ev2)))
    :expansion (sequential 
		(site-prepped-for-r&r ?ev1 ?oru-loc)
		(has-iss-location ?ev2 ?l)
		(replaced-item-at ?ev2 ?oru-loc)
		)
    :effect (at end (remove&replace_a ?ev2 ?oru-loc))
    )


#|(:axiom
   :vars (?a - agent
          ?e - entity)
   :context (not (possesses ?a ?e))
   :implies (not (possessed_by ?e ?a))
   :documentation "when one is negated, the other must be as well")
(:axiom
   :vars (?o1 ?o2 - physical-entity)
   :context (not (contains ?o1 ?o2))
   :implies (not (contained_by ?o2 ?o1))
   :documentation "when one is negated, the other must be as well")|#
