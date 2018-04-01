;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)

#|
How to test alternatives
AP(7): (run-ap install-light)


*problem*=INSTALL-LIGHT
  init:
    (CONTAINS ORU-BAG_1 LUMINAIRE_1)
    (POSSESSES BOB ORU-BAG_1)
    (HAS-ISS-LOCATION BOB S1B05F04MP)
  deadline=100.0

establish-goal INSTALLED-STATE(LUMINAIRE_1)=YES

Thus ends the plan-generation phase of INSTALL-LIGHT ...

choose-plan <goal INSTALL-LIGHT> --> NO-PLAN empty conflict-set [no choices]
:NO-PLAN
AP(8): (test-alternative INSTALL-LIGHT)


Which action?
  1. INSTALL-ITEM-FROM-CONTAINER
  2. INSTALL-ITEM
Type n or n1,n2,... or <cr> to dismiss: 1


explain-failed-candidate <template INSTALL-ITEM-FROM-CONTAINER>:
  param-tests failed on ((INSTANCE LUMINAIRE_1 '(OR CETA-LIGHT POWER-CABLE SPACE-POSITIONING-DEVICE CONTROL-PANEL-ASSEMBLY)))
T
AP(9):



;;;Tether sit for debugging as of 5/14/13

85-ft_tether_4 85-ft_tether_7 85-ft_tether_3 85-ft_tether_2 85-ft_tether_6 85-ft_tether_5  - 85-ft_safety_tether_assembly
tether_2 tether_4 tether_3 tether_1  - safety_tether_-307
oru_tether_assy_1 oru_tether_assy_2 oru_tether_assy_3  - oru_tether_assy
stp_2 stp_1  - safety-tether-pack

(is-available 85-ft_tether_2 yes)
(installed-state 85-ft_tether_2 yes)
(has-iss-location 85-ft_tether_2 alck-stb-nad)

(is-available 85-ft_tether_3 yes)
(installed-state 85-ft_tether_3 yes)
(has-iss-location 85-ft_tether_3 alck-stb-nad)

(possesses bob stp_1)
(contains stp_1 85-ft_tether_4)
(possesses sally stp_2)
(contains stp_2 85-ft_tether_5)


;;; debugging  the PRIDE demo

retrieve-item2: not sure about changing the possesses and possessed_by.
The following debugging all follows from this def:

(define (durative-action Retrieve-item2)
    :parameters (?ev - crew
		     ?item - luminaire__ceta_light
		     )
    :vars (?container - (bag-size-for ?item)
		      ?loc - (has-iss-location ?item))
    :condition (at start (has-iss-location ?ev airlock))
    :expansion (sequential
		(possessed_by ?container ?ev) ;;; for the PRIDE demo
		;;(possesses ?ev ?container)
		(has-iss-location ?ev ?loc)
		(item-extracted ?ev ?item)
		(has-iss-location ?ev airlock)
		(has-iss-location ?item INTRA-VEHICLE)
		)
    :effect (at end (retrieve-and-stow ?ev ?item))
    :comment "?ev picks up ?container, travels to ?item's loc, unmounts and stores ?item in ?container and returns.")

;;; This is what comes from the GUI when we select retrieve-item2
;;; This one from acl 9
(NEW-PREDICATE '(JOBS-DONE ?AGENT7 - CREW) NASA-DOMAIN)
(DEFINE (DURATIVE-ACTION DO-JOBS) :PARAMETERS (?AGENT7 - CREW) :VARS
        (?AGENT8 - CREW ?ROBOT - ISS-ROBOT ?BAG - MEDIUM-ORU-BAG) :CONDITION
        (AND (AT START (NOT (= ?AGENT7 ?AGENT8))) (AT START (NOT (= (HAS-OPERATOR ?ROBOT) ?AGENT7)))
             (AT START (NOT (= (HAS-OPERATOR ?ROBOT) ?AGENT8))) (OVER ALL (BAG-SIZE-FOR LUMINAIRE_3 ?BAG)))
        :EXPANSION
        (SEQUENTIAL (HAS-ISS-LOCATION ?AGENT7 AIRLOCK) (HAS-ISS-LOCATION ?BAG AIRLOCK) (PREPARED-FOR ?AGENT7 EVA)
         (RETRIEVE-AND-STOW ?AGENT7 LUMINAIRE_3) (HAS-ISS-LOCATION ?AGENT7 AIRLOCK)
         (HAS-ISS-LOCATION ?AGENT7 INTRA-VEHICLE) (HATCH-STATE AIRLOCK-HATCH LOCKED)
         (PREPARED-FOR ?AGENT7 REPRESSURIZATION))
        :EFFECT (AT END (JOBS-DONE ?AGENT7)))
(DEFINE (PROBLEM DONE-JOBS) (:DOMAIN NASA-DOMAIN) (:SITUATION PHALCON-EVA) (:INIT (POSSESSES SALLY MICRO_SCOOP_4))
        (:DEADLINE 200.0) (:GOAL (JOBS-DONE SALLY)))

acl 8
(NEW-PREDICATE '(JOBS-DONE ?AGENT1 - CREW) NASA-DOMAIN T)
(DEFINE (DURATIVE-ACTION DO-JOBS) :PARAMETERS (?AGENT1 - CREW) :VARS
           (?AGENT2 - CREW ?ROBOT - ISS-ROBOT ?BAG - MEDIUM-ORU-BAG) :CONDITION
           (AND (AT START (NOT (= ?AGENT1 ?AGENT2))) (AT START (NOT (= (HAS-OPERATOR ?ROBOT) ?AGENT1)))
                (AT START (NOT (= (HAS-OPERATOR ?ROBOT) ?AGENT2)))
                (OVER ALL (BAG-SIZE-FOR LUMINAIRE_3 ?BAG)))
           :EXPANSION
           (SEQUENTIAL 
	    (HAS-ISS-LOCATION ?AGENT1 AIRLOCK) 
	    (HAS-ISS-LOCATION ?BAG AIRLOCK)
            (PREPARED-FOR ?AGENT1 EVA) 
	    (RETRIEVE-AND-STOW ?AGENT1 LUMINAIRE_3) 
	    (HAS-ISS-LOCATION ?AGENT1 AIRLOCK)
            (HAS-ISS-LOCATION ?AGENT1 INTRA-VEHICLE) 
	    (HATCH-STATE AIRLOCK-HATCH LOCKED)
            (PREPARED-FOR ?AGENT1 REPRESSURIZATION))
           :EFFECT (AT END (JOBS-DONE ?AGENT1)))

(DEFINE (PROBLEM DONE-JOBS) (:DOMAIN NASA-DOMAIN) (:SITUATION PHALCON-EVA) (:DEADLINE 390.0) (:GOAL (JOBS-DONE SALLY)))

This is a bad pick-up because the item is not equipment

(define (durative-action pick-up)
    :parameters (?item0 - station-object ?crew0 - crew)
    :vars (?isslocation0 - iss-location)
    :duration 5.0
    :condition (and
       (at start (has-iss-location ?crew0 ?isslocation0))
       (at start (has-iss-location ?item0 ?isslocation0))
    )
    :effect (and
       (at end (possessed_by ?item0 ?crew0))
    )
    :comment "Crew picks up item and tethers to suit"
    )


When pick-up is defined as (note the possessed_by -- the original pick-up uses possesses):

(define (durative-action pick-up)
    :parameters (?crew0 - crew ?equipment0 - equipment)
    :vars (?isslocation0 - iss-location)
    :duration 5.0
    :condition (and
       (at start (has-iss-location ?equipment0 ?isslocation0))
       (at start (has-iss-location ?crew0 ?isslocation0))
    )
    :effect (and
       (at end (possessed_by ?equipment0 ?crew0))
    )
    :comment "Crew picks up item and tethers to suit"
    )

The above gets a plan:

DO-JOBS462: JOBS-DONE(SALLY)
  sequential
    EGRESS-INSIDE-AGENT557: HAS-ISS-LOCATION(SALLY)=AP::AIRLOCK
    STOW-EXTERNAL562: HAS-ISS-LOCATION(ORU-BAG_1)=AP::AIRLOCK
      simultaneous
        HAND-OVER565: HANDED-OVER(BOB,ORU-BAG_1)
        STOW566: STOWED(SALLY,ORU-BAG_1)
    PREPARE-FOR-EVA567: PREPARED-FOR(SALLY,EVA)
    RETRIEVE-ITEM2577: RETRIEVE-AND-STOW(SALLY,LUMINAIRE_3)
      sequential
        PICK-UP611: POSSESSED_BY(ORU-BAG_1)=AP::SALLY
        TRANSLATE-BY-HANDRAIL701: HAS-ISS-LOCATION(SALLY)=AP::S1B07F03MP
        EXTRACT-ITEM-TO-BAG761: ITEM-EXTRACTED(SALLY,LUMINAIRE_3)
        TRANSLATE-BY-HANDRAIL844: HAS-ISS-LOCATION(SALLY)=AP::AIRLOCK
        STOW-INTERNAL860: HAS-ISS-LOCATION(LUMINAIRE_3)=AP::INTRA-VEHICLE
          simultaneous
            HAND-OVER863: HANDED-OVER(SALLY,LUMINAIRE_3)
            STOW864: STOWED(BOB,LUMINAIRE_3)
    TRANSLATE-BY-HANDRAIL844 **reused**
    INGRESS-OUTSIDE-AGENT865: HAS-ISS-LOCATION(SALLY)=AP::INTRA-VEHICLE
    CLOSE-HATCH871: HATCH-STATE(AIRLOCK-HATCH)=AP::LOCKED
PREPARE-FOR-REPRESS875: PREPARED-FOR(SALLY,REPRESSURIZATION)

The other (default) actions are:

(define (durative-action Translate-by-handrail)
    :parameters (?ev - crew
		 ?end-loc - iss-location)
    :vars (?start-loc - iss-location)
    :condition (and (at start (not (= ?start-loc intra-vehicle)))
		    (at start (not (= ?end-loc intra-vehicle)))
		    (at start (has-iss-location ?ev ?start-loc))
		    (at start (not (too-far ?start-loc ?end-loc))))
    :effect (at end (has-iss-location ?ev ?end-loc))
    :duration time-from-path
    :execute (print (list "TRANSLATING BY HANDRAIL!!!" ?ev ?start-loc ?end-loc))
    :comment "?ev travels by handrail from ?start-loc to ?end-loc")


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
		 )
	     
    :comment "crew removes ?item at ?l and stows in bag."
    )

When I use this translate from PRIDE it fails because tethered-for-egress doesn't get established
and that's right because that goal is only for assisted egress.

(define (durative-action translate-by-handrail)
    :parameters (?crew0 - crew ?isslocation0 - iss-location)
    :vars (?safetytether0 - safety-tether ?isslocation1 - iss-location)
    :duration 15.0
    :condition (and
       (at start (has-iss-location ?crew0 ?isslocation1))
       (at start (tethered-for-egress ?crew0 ?safetytether0))
    )
    :effect (and
       (at end (has-iss-location ?crew0 ?isslocation0))
    )
    :comment "Crew translates from one truss location to another"
    )

Also this one fails because the airlock is not a truss location:

(define (durative-action translate-by-handrail)
    :parameters (?crew0 - crew ?trusslocation0 - truss-location)
    :vars (?trusslocation1 - truss-location ?safetytether0 - safety-tether)
    :duration 15.0
    :condition (and
       (at start (has-iss-location ?crew0 ?trusslocation1))
       (at start (tethered_to ?safetytether0 ?crew0))
    )
    :effect (and
       (at end (has-iss-location ?crew0 ?trusslocation0))
    )
    :comment "Crew translates from one truss location to another"
    )

We should use:
(define (durative-action translate-by-handrail)
    :parameters (?crew0 - crew ?isslocation0 - iss-location)
    :vars (?safetytether0 - safety-tether ?isslocation1 - iss-location)
    :duration 15.0
    :condition (and
       (at start (has-iss-location ?crew0 ?isslocation1))
       (at start (tethered_to ?safetytether0 ?crew0))
    )
    :effect (and
       (at end (has-iss-location ?crew0 ?isslocation0))
    )
    :comment "Crew translates from one truss location to another"
    )

Then we get a plan.

Finally, this from the translator:

(define (durative-action extract-item-to-bag)
    :parameters (?crew0 - crew ?item0 - station-object ?orubag0 - oru-bag)
    :vars (?pgt-with-turn-setting0 - pgt-with-turn-setting ?isslocation0 - iss-location)
    :duration 15.0
    :condition (and
       (at start (possesses ?crew0 ?pgt-with-turn-setting0))
       (at start (possesses ?crew0 ?orubag0))
       (at start (has-iss-location ?item0 ?isslocation0))
       (at start (has-iss-location ?crew0 ?isslocation0))
    )
    :effect (and
       (at end (item-extracted ?crew0 ?item0))
    )
    :comment "Crew uses pgt to extract item and stows it in the bag."
    )

Properly fails the plan and this from the translator:

(define (durative-action extract-item-to-bag)
    :parameters (?crew0 - crew ?item0 - station-object ?orubag0 - oru-bag)
    :vars (?pgt-with-turn-setting0 - pgt-with-turn-setting ?isslocation0 - iss-location)
    :duration 15.0
    :condition (and
       (at start (possesses ?crew0 ?pgt-with-turn-setting0))
       (at start (possesses ?crew0 ?orubag0))
       (at start (has-iss-location ?item0 ?isslocation0))
       (at start (has-iss-location ?crew0 ?isslocation0))
    )
    :effect (and
       (at end (item-extracted ?crew0 ?item0))(at end (contains ?orubag0 ?item0))
    )
    :comment "Crew uses pgt to extract item and stows it in the bag."
    )

Gets a successful plan.


So I believe the following gets a successful demo:

1) Use the retrieve2 with the possessed_by (or use the original and change the pickup)
2) Use the PRIDE defs as decribed above

|#


#| ;;; delay
(define (problem delay-test)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (Delay10_a done)))

(define (problem delay-bob)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (Delay-action_a bob)))
(define (problem bob-2-mid)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock))
  (:goal (has-iss-location bob P1B10F01MM))
  )

(define (problem bob-from-mid)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob P1B10F01MM))
  (:goal (has-iss-location bob P3B20F01NP))
  )

;;|#

;;;egress-inside-agent
(define (problem bob-out)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (has-iss-location bob airlock)))

;;; assisted-egress
(define (problem assist-sally)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (has-ISS-location bob airlock)
	 (cover-state thermal-cover-airlock open))
  (:deadline 100.0)
  (:goal (has-ISS-location sally AIRLOCK)))

;; egress & assisted egress
(define (problem two-out)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (sequential 
	  (has-ISS-location bob AIRLOCK)
	  (has-ISS-location sally AIRLOCK))))

;;;Prepare-for-eva
(define (problem bob-ready)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-ISS-location bob airlock)
	 (tethered_to 85-FT_TETHER_2 bob))
  (:goal (prepared-for bob eva)))

(define (problem two-ready)
   (:domain nasa-domain)
   (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-ISS-location bob airlock)
	 (has-ISS-location sally airlock)
	 (tethered_to 85-FT_TETHER_2 bob)
	 (tethered_to 85-FT_TETHER_3 sally))
  (:goal (parallel
	  (prepared-for bob eva)
	  (prepared-for sally eva))))

(define (problem all-out)
   (:domain nasa-domain)
   (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (crew-moved-to airlock)))

;;; Assisted-ingress
(define (problem assist-one-in)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (has-ISS-location bob airlock)
	 (has-ISS-location sally airlock)
	 (tethered_to 85-FT_TETHER_3 sally)
	 )
  (:deadline 100.0)
  (:goal (has-ISS-location sally INTRA-VEHICLE)))

;;; Ingress-outside-agent
(define (problem bob-inside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (has-ISS-location bob airlock)
	 (tethered_to 85-FT_TETHER_2 bob)
	 (cover-state thermal-cover-airlock open))
  (:deadline 100.0)
  (:goal (has-ISS-location bob intra-vehicle)))

(define (problem two-in)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-ISS-location bob airlock)
	 (has-ISS-location sally airlock)
	 (tethered_to 85-FT_TETHER_2 bob)
	 (tethered_to 85-FT_TETHER_3 sally))
  (:goal (sequential 
	  (has-ISS-location sally intra-vehicle)
	  (has-ISS-location bob intra-vehicle))))

;;; closing up
(define (problem two-repress)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (cover-state thermal-cover-airlock closed))
  (:deadline 100.0)
  (:goal (sequential (hatch-state airlock-hatch locked)
		     (parallel
		      (prepared-for bob repressurization)
		      (prepared-for sally repressurization)))))

(define (problem all-in)
   (:domain nasa-domain)
   (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-ISS-location bob airlock)
	 (has-ISS-location sally airlock)
	 (tethered_to 85-FT_TETHER_2 bob)
	 (tethered_to 85-FT_TETHER_3 sally))
  (:goal (crew-moved-to intra-vehicle)))

;;;Translate-by-handrail
(define (problem bob-elc-2-truss)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob ELC0107-FWD-STB-NAD))
  (:goal (has-iss-location bob s1b05f04mp))
  )

(define (problem bob-2-light-loc)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (has-iss-location LUMINAIRE_1 s1b05f04mp))
  (:goal (has-iss-location bob s1b05f04mp))
  )

(define (problem bob-elc-2-truss)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob ELC0107-FWD-STB-NAD))
  (:goal (has-iss-location bob s1b05f04mp))
  )

;;;tether swap
;;; From phalcon-eva
;;; (is-available 85-ft_tether_2 yes)
;;; (installed-state 85-ft_tether_2 yes)
(define (problem bob-swap)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (tethered_to 85-ft_tether_3 bob)
	 (not (possesses bob stp_1))
	 (has-iss-location 85-ft_tether_2 P1B10F01MM)
	 (has-iss-location bob P1B10F01MM))
  (:goal (tethered_to 85-ft_tether_2 bob))
  )

;;;tether-swap-back
(define (problem bob-swap-back)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob P1B10F01MM)
	 (not (possesses bob stp_1))
	 (tethered_to 85-ft_tether_3 bob)
	 (tethered_to 85-ft_tether_2 bob)
	 (has-iss-location 85-ft_tether_2 P1B10F01MM))
  (:goal (not (tethered_to 85-ft_tether_2 bob)))
  )

(define (problem bob-round-trip)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (not (possesses bob stp_1))
	 (tethered_to 85-ft_tether_3 bob)
	 (has-iss-location 85-ft_tether_2 P1B10F01MM))
  (:goal (sequential
	  (has-iss-location bob P1B10F01MM)
	  (TETHER-SWAPPED BOB 85-FT_TETHER_3)
	  (has-iss-location bob P3B20F01NP)
	  (has-iss-location bob P1B10F01MM)
	  (TETHER-SWAPPED BOB 85-FT_TETHER_2)
	  (has-iss-location bob airlock)))

  )

;;; Now let AP determine the swap...but first swap reused improperly.
(define (problem bob-round-trip2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (not (possesses bob stp_1)) 
	 (tethered_to 85-ft_tether_3 bob)
	 (is-available 85-ft_tether_3 no)
	 (has-iss-location 85-ft_tether_2 P1B10F01MM))
  (:goal (sequential
	  (has-iss-location bob P3B20F01NP)
	  (has-iss-location bob airlock)))

  )

;;;trying to debug the above problem.
;;;this correctly uses tether-swap
(define (problem bob-round-trip3)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (not (possesses bob stp_1))
	 (tethered_to 85-ft_tether_3 bob)
	 (has-iss-location 85-ft_tether_2 P1B10F01MM))
  (:goal (has-iss-location bob P3B20F01NP))

  )

;;;This incorrectlt uses tether-swap&pickup
(define (problem bob-round-trip4)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob P3B20F01NP)
	 (not (possesses bob stp_1))
	 (tethered_to 85-ft_tether_3 bob)
	 (tethered_to 85-ft_tether_2 bob)
	 (has-iss-location 85-ft_tether_2 P1B10F01MM))
  (:goal (has-iss-location bob airlock))
  )

;;; install-tether&swap
;;; From phalcon-eva: (contains stp_2 85-ft_tether_5)
(define (problem bob-swap2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (tethered_to 85-ft_tether_3 bob)
	 (possesses bob stp_2) 
	 (has-iss-location bob P1B10F01MM))
  (:goal (tethered_to 85-ft_tether_5 bob))
  )

(define (problem bob-to-p3)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (tethered_to 85-ft_tether_3 bob)
	 (possesses bob stp_1)
	 (has-iss-location bob airlock))
  (:goal (has-iss-location bob P3B20F01NP)) 
  )

;;;Go and return
;;;uses tether-swap&pickup
(define (problem bob-round-trip5)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (tethered_to 85-ft_tether_3 bob))
  (:goal (sequential
	  (has-iss-location bob P3B20F01NP)
	  (has-iss-location bob airlock)))

  )

(define (problem crew-round-trip)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (sequential
	  (has-iss-location sally airlock)
	  (has-iss-location bob airlock)
	  (has-iss-location bob P3B20F01NP)
	  (has-iss-location sally s1b05f04mp)
	  (has-iss-location bob airlock)
	  (has-iss-location sally airlock)
	  (has-iss-location sally intra-vehicle)
	  (has-iss-location bob intra-vehicle)))
  )

;;;retrieve-item
(define (problem bob-unbolt-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob s1b05f04mp)
	 (has-iss-location LUMINAIRE_1 s1b05f04mp)
	 (possesses bob oru-bag_1)
	 (possesses bob pgt_2))
  (:goal (item-retrieved bob LUMINAIRE_1))
  )

(define (problem bob-get-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (possesses bob oru-bag_1)
	 (possesses bob pgt_2))
  (:goal (item-retrieved bob LUMINAIRE_3))
  )

(define (problem bob-get-light2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (possesses bob oru-bag_1)
	 (possesses bob pgt_2)
	 (tethered_to 85-ft_tether_3 bob)
	 (possesses bob stp_1))
  (:goal (item-retrieved bob LUMINAIRE_2))
  )

(define (problem bob-get-light3)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (possesses bob oru-bag_1)
	 (possesses bob pgt_2))
  (:goal (retrieve-and-stow bob LUMINAIRE_3))
  )

 ;;;stow-external
(define (problem bag-outside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (cover-state thermal-cover-airlock open))
  (:goal (has-iss-location oru-bag_1 AIRLOCK)))

;;;stow-internal
(define (problem bag-inside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (possessed_by oru-bag_1 bob)
	 (cover-state thermal-cover-airlock open))
  (:goal (has-iss-location oru-bag_1 intra-vehicle)))

;;;Egress-agents
(define (problem all-outside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (crew-and-tools airlock)))

;;;Ingress-agents
(define (problem all-inside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (has-iss-location sally airlock)
	 (tethered_to 85-ft_tether_2 sally)
	 (tethered_to 85-ft_tether_3 bob)
	 (possesses bob oru-bag_1)
	 (cover-state thermal-cover-airlock open))
  (:goal (crew-and-tools intra-vehicle)))

;;;jobs-done sally 
(define (problem do-jobs)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (jobs-done sally)))

;;;Put-down
(define (problem bob-put-bag)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (possesses bob oru-bag_1)
	 (has-iss-location bob airlock))
  (:goal (not (possesses bob oru-bag_1)))
  )

;;install-item
(define (problem install-m) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock))
  (:goal (installed-state  mut-ee_1 yes))
  )

;;; install-item-from-container
(define (problem install-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob s1b07f03mp)
	 (possesses bob oru-bag_1)
	 (contains oru-bag_1 LUMINAIRE_3))
  (:goal (installed-state LUMINAIRE_3 yes))
  )

(define (problem install-pc)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob s0b00f03mp)
	 (possesses bob fish-stringer_1)
	 (contains fish-stringer_1 mlm_pwr_cable_ch_1_4_1))
  (:goal (installed-state mlm_pwr_cable_ch_1_4_1 yes))
  )

(define (problem install-j)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (possesses bob fish-stringer_1))
  (:goal (item-installed bob mlm_pwr_cable_ch_1_4_1))
  )

;;; Install-fqd-in-place _25in_jumper_1_2017 at p1b16f06mp
(define (problem install-f)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob p1b16f06mp)
	 (possesses bob fish-stringer_1)
	 )
  (:goal (installed-state _25-in_jumper_1_2017 yes))
  )

(define (problem go-install-f)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (has-iss-location fish-stringer_1 airlock))
  (:goal (item-installed-in-place bob _25-in_jumper_1_2017))
  )

;;; extract-item-to-suit
(define (problem sally-extract-mut)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location sally airlock)
	 (has-iss-location mut-ee_2 airlock)
	 (not (possesses sally mut-ee_2))
	 (installed-state mut-ee_2 yes))
  (:goal (possessed_by mut-ee_2 sally))
  )

;;; extract apfr
(define (problem bob-extract-apfr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (contained_by apfr_2 oiwif_14)
	 (has-iss-location oiwif_14 p1b16f06mp)
	 (has-iss-location bob p1b16f06mp))
  (:goal (possesses bob apfr_2))
  )

;;; extract-ddcu
(define (problem bob-extract-ddcu2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location ddcu-e_3 s0b01f01ms)
	 (has-iss-location bob s0b01f01ms)
	 (possesses bob pgt_2)
	 (possesses bob MICRO_SCOOP_2)
	 (possesses bob 7_16-in_box_end_ratchet_wrench_2))
  (:goal (possesses bob ddcu-e_3))
  )

;;; extract-ddcu-by-two
(define (problem bob-extract-ddcu)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location ddcu-e_3 s0b01f01ms)
	 (has-iss-location bob s0b01f01ms)
	 (has-iss-location sally s0b01f01ms)
	 (possesses bob MICRO_SCOOP_2))
  (:goal (possesses bob ddcu-e_3))
  )

;;; position item
(define (problem position-ddcu)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (has-iss-location stanchion-mount-cover1 airlock)
	 (possesses bob stanchion-mount-cover1))
  (:goal (item-positioned stanchion-mount-cover1 s0b01f01ms)
	 )
  )

;;;install scoop
(define (problem install-sc) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (possesses bob micro_scoop_1))
  (:goal (contains ddcu-e_15 micro_scoop_1)
	)
  )

 ;;;Install-scoop-from-container
(define (problem install-sc-from-bag) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (possesses bob crew-lock-bag1))
  (:goal (contains ddcu-e_15 micro_scoop_1))
  )

;;;ddcu-r&r-prep
(define (problem ddcu-prep) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (possesses bob crew-lock-bag1)
	 (has-iss-location stanchion-mount-cover1 airlock) )
  (:goal (site-prepped-for-r&r bob ddcu_s01a)) ;;oru location
  )

;;;take-ddcu-off-cover
(define (problem take-off-cover) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (possesses bob stanchion-mount-cover1)
	 (contains ddcu-e_15 micro_scoop_1)
	 (has-iss-location sally airlock))
  (:goal (cover-removed ddcu-e_15 stanchion-mount-cover1)
	 ;;(possesses sally ddcu-e_15)
	 )
  )

;;;put-cover-on-ddcu
(define (problem put-on-cover) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (has-iss-location ddcu-e_15 airlock)
	 (possesses bob ddcu-e_15)
	 (not (CONTAINS STANCHION-MOUNT-COVER1 DDCU-E_15))
	 (contains ddcu-e_15 micro_scoop_1)
	 (has-iss-location sally airlock)
	 (possesses sally stanchion-mount-cover1))
  (:goal (is-attached-to stanchion-mount-cover1 ddcu-e_15)
	 ;;(cover-attached ddcu-e_15 stanchion-mount-cover1)old action
         ;;(contains stanchion-mount-cover1 ddcu-e_15)
	 )
  )

;;; temp install ddcu
(define (problem insert-ddcu) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob S0B01F01MS)
	 (has-iss-location ddcu-e_15 S0B01F01MS)
	 (not (CONTAINS STANCHION-MOUNT-COVER1 DDCU-E_15))
	 (possesses bob ddcu-e_15)
	 (contains ddcu-e_15 micro_scoop_1)
	 )
  (:goal (inserted ddcu-e_15 S0B01F01MS)
	 )
  )

 ;;;ddcu-change-out
(define (problem change-out-d) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob S0B01F01MS)
	 (has-iss-location sally S0B01F01MS)
	 (has-iss-location ddcu-e_3 S0B01F01MS)
	 (possesses sally stanchion-mount-cover1)
	 (not (contains crew-lock-bag1 micro_scoop_1))
	 ;;(possesses bob micro_scoop_1) he already has scoop2
	 (contains ddcu-e_15 micro_scoop_1))
  (:goal (replaced-item-at bob ddcu_s01a))
  )

;;;ddcu-r&r
#|(define (problem r&r-d) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (has-iss-location sally airlock)
	 (has-iss-location ddcu-e_3 S0B01F01MS) ;;added this since the attached-to axiom was commented out
	 (possesses sally crew-lock-bag1)
	 (possesses sally stanchion-mount-cover1)
	 ;;(has-iss-location stanchion-mount-cover1 airlock)
	 )
  (:goal (remove&replace_a bob ddcu_s01a))
  )|#

(define (problem r&r-d) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (has-iss-location sally airlock)
	 (has-iss-location ddcu-e_3 S0B01F01MS) ;;added this since the attached-to axiom was commented out
	 (possesses sally crew-lock-bag1)
	 (has-iss-location stanchion-mount-cover1 airlock)
	 ;;(possesses sally stanchion-mount-cover1)
	 )
  (:goal (remove&replace_a bob ddcu_s01a))
  )

;;;new translate by handrail
(define (problem bob-2-truss)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (tethered-for-egress bob 85-ft_tether_3))
  (:goal (has-iss-location bob s1b05f04mp))
  )

;;;new pickup
(define (problem bob-pickup)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob S1B07F03MP)
	 (has-iss-location ORU-bag_1 S1B07F03MP))
  (:goal (possesses bob ORU-bag_1)) 
  )

;;;new extract to bag
 (define (problem bob-extract-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob s1b05f04mp)
	 (has-iss-location LUMINAIRE_1 s1b05f04mp)
	 (possesses bob pgt_2)
	 (possesses bob ORU-bag_1))
  (:goal (item-extracted bob LUMINAIRE_1))
  )

(define (problem new-get-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (has-iss-location bob airlock)
	 (tethered-for-egress bob 85-ft_tether_3)
	 (has-iss-location oru-bag_1 airlock)
	 (possesses bob pgt_2))
  (:goal (item-retrieved bob LUMINAIRE_3))
  )

#|
(define (problem bob-gca)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (is-attached-to bob space-station-remote-manipulator[ssrms])
	 (has-iss-location space-station-remote-manipulator[ssrms] s1b05f04mp)
	 (can-reach space-station-remote-manipulator[ssrms] p1b16f06mp))
  (:goal (has-iss-location bob p1b16f06mp))
  )
|#
