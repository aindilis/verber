;;; 6/17/15
;;; Load up AP for pride using the new ontology
;;; Copy and paste these actions into the ap package.
;;; Use the gui to plan for retrieve-amd-stow sally luminaire3.
;;; You should get a plan.
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

(define (durative-action extract-item-to-bag)
    :parameters (?crew0 - crew ?item0 - station-object ?orubag0 - oru-bag)
    :vars (?pgt-with-turn-setting0 - pgt-with-turn-setting ?isslocation0 - iss-location)
    :duration 15.0
    :condition (and
       (at start (possesses ?crew0 ?pgt-with-turn-setting0))
       (at start (possessed_by ?orubag0 ?crew0))
       (at start (has-iss-location ?item0 ?isslocation0))
       (at start (has-iss-location ?crew0 ?isslocation0))
    )
    :effect (and
       (at end (item-extracted ?crew0 ?item0))
       ;;(at end (contains ?orubag0 ?item0))
    )
    :comment "Crew uses pgt to extract item and stows it in the bag."
    )

#|
;;; From current PRIDE 6/22/15
(define (durative-action extract-item-to-bag)
    :parameters (?crew0 - crew ?item0 - station-object ?orubag0 - oru-bag)
    :vars (?pgt-with-turn-setting0 - pgt-with-turn-setting ?isslocation0 - iss-location ?agent0 - agent)
    :duration 15.0
    :condition (and
       (at start (possesses ?crew0 ?pgt-with-turn-setting0))
       (at start (has-iss-location ?item0 ?isslocation0))
       (at start (has-iss-location ?crew0 ?isslocation0))
       (at start (possessed_by ?orubag0 ?agent0))
    )
    :effect (and
       (at end (item-extracted ?crew0 ?item0))
       (at end (contains ?orubag0 ?item0))
    )
    :comment "Crew uses pgt to extract item and stows it in the bag."
    )
|#

(define (durative-action pick-up)
    :parameters (?item0 - station-object ?crew0 - crew ?equipment0 - equipment)
    :vars (?isslocation0 - iss-location)
    :duration 5.0
    :condition (and
       (at start (has-iss-location ?crew0 ?isslocation0))
       (at start (has-iss-location ?item0 ?isslocation0))
    )
    :effect (and
       (at end (possessed_by ?equipment0 ?crew0))
    )
    :comment "Crew picks up item and tethers to suit"
)

#|
(define (durative-action pick-up)
    :parameters (?item0 - station-object ?crew0 - crew ?equipment0 - equipment)
    :vars (?isslocation0 - iss-location)
    :duration 5.0
    :condition (and
       (at start (has-iss-location ?crew0 ?isslocation0))
       (at start (has-iss-location ?item0 ?isslocation0))
    )
    :effect (and
       (at end (possessed_by ?equipment0 ?crew0))
    )
    :comment "Crew picks up item and tethers to suit"
    )
|#

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

#|
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
|#

(NEW-PREDICATE '(JOBS-DONE ?AGENT1 - CREW) NASA-DOMAIN)

(DEFINE (DURATIVE-ACTION DO-JOBS) :PARAMETERS (?AGENT1 - CREW) :VARS
           (?AGENT2 - CREW ?ROBOT - ISS-ROBOT ?BAG - MEDIUM-ORU-BAG) :CONDITION
           (AND (AT START (NOT (= ?AGENT1 ?AGENT2)))
                (AT START (NOT (= (HAS-OPERATOR ?ROBOT) ?AGENT1)))
                (AT START (NOT (= (HAS-OPERATOR ?ROBOT) ?AGENT2)))
                (OVER ALL (BAG-SIZE-FOR LUMINAIRE_3 ?BAG)))
           :EXPANSION
           (SEQUENTIAL (HAS-ISS-LOCATION ?AGENT1 AIRLOCK) (HAS-ISS-LOCATION ?BAG AIRLOCK)
            (PREPARED-FOR ?AGENT1 EVA) (RETRIEVE-AND-STOW ?AGENT1 LUMINAIRE_3)
            (HAS-ISS-LOCATION ?AGENT1 AIRLOCK) (HAS-ISS-LOCATION ?AGENT1 INTRA-VEHICLE)
            (HATCH-STATE AIRLOCK-HATCH LOCKED) (PREPARED-FOR ?AGENT1 REPRESSURIZATION))
           :EFFECT (AT END (JOBS-DONE ?AGENT1)))

(DEFINE (PROBLEM DONE-JOBS) (:DOMAIN NASA-DOMAIN) (:SITUATION PHALCON-EVA)
           (:INIT (POSSESSES SALLY MICRO_SCOOP_4)) (:DEADLINE 390.0)
           (:GOAL (JOBS-DONE SALLY)))


#|
DO-JOBS19: (JOBS-DONE SALLY)
  SEQUENTIAL
    EGRESS-INSIDE-AGENT22: HAS-ISS-LOCATION(SALLY)=AIRLOCK
    STOW-EXTERNAL29: HAS-ISS-LOCATION(ORU-BAG_1)=AIRLOCK
      SIMULTANEOUS
        HAND-OVER30: (HANDED-OVER BOB ORU-BAG_1)
        STOW31: (STOWED SALLY ORU-BAG_1)
    PREPARE-FOR-EVA33: (PREPARED-FOR SALLY EVA)
    RETRIEVE-ITEM243: (RETRIEVE-AND-STOW SALLY LUMINAIRE_3)
      SEQUENTIAL
        PICK-UP44: POSSESSED_BY(ORU-BAG_1)=SALLY
        TRANSLATE-BY-HANDRAIL45: HAS-ISS-LOCATION(SALLY)=S1B07F03MP
        EXTRACT-ITEM-TO-BAG46: (ITEM-EXTRACTED SALLY LUMINAIRE_3)
        TRANSLATE-BY-HANDRAIL47: HAS-ISS-LOCATION(SALLY)=AIRLOCK
        STOW-INTERNAL53: HAS-ISS-LOCATION(LUMINAIRE_3)=INTRA-VEHICLE
          SIMULTANEOUS
            HAND-OVER54: (HANDED-OVER SALLY LUMINAIRE_3)
            STOW55: (STOWED BOB LUMINAIRE_3)
    TRANSLATE-BY-HANDRAIL47 HAS-ISS-LOCATION(SALLY)=AIRLOCK **reused**
    INGRESS-OUTSIDE-AGENT58: HAS-ISS-LOCATION(SALLY)=INTRA-VEHICLE
    CLOSE-HATCH65: HATCH-STATE(AIRLOCK-HATCH)=LOCKED
PREPARE-FOR-REPRESS68: (PREPARED-FOR SALLY REPRESSURIZATION)
|#