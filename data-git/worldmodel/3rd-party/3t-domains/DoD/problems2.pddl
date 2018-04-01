(in-package :ap)

(define (problem uav-takeoff)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (has-launch-state global-hawk2 in-the-air)))

(define (problem uav-land)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (has-launch-state global-hawk2 on-the-ground)))

(define (problem uav-launch)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (has-launch-state blackjack1 in-the-air)))

(define (problem blackjack-land)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (has-launch-state blackjack1 not-launched)))

(define (problem uav-to&l)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (took-off&landed global-hawk1)))

(define (problem uav-travel0)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (is-located global-hawk1 cedar-island-south-beach)))

;;; Why don't this work no more, Dr C?
(define (problem uav-travel)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:init (is-located global-hawk1 wilmington-harbor-dock1))
  (:goal (sequential
           (is-located global-hawk1 cedar-island-south-beach)
           ;;(is-located global-hawk1 elizabethtown)
	   )))

(define (problem usv-travel)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (is-located spartan-scout1 carolina-beach-harbor)))

(define (problem usv-travel-no)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (is-located spartan-scout1 bladenboro)))

(define (problem uuv-travel-no)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (is-located Knifefish1 shalotte)))

(define (problem uuv-travel)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (is-located Knifefish1 cedar-island-south-beach)))

(define (problem uav-neutralize)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (neutralized reaper4 tank1)))

(define (problem jdam-neutralize)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (neutralized ijdam3 tank1)))

(define (problem uav-inspect-no)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (inspected Reaper4 tank1)))

(define (problem usv-inspect)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (inspected spartan-scout1 tank1)))

(define (problem uuv-inspect)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (inspected knifefish2 tank1)))

(define (problem uav-monitor)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (monitored global-hawk1 caroline-oil-field2)))

(define (problem usv-track)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (tracked spartan-scout1 tank1)))

(define (problem usv-surveil)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (surveilled spartan-scout1 red-brigade1)))

(define (problem usv-surveil2)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (surveilled talisman2 cedar-island-north-shoreline)))

(define (problem usv-surveil3)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (surveilled talisman2 core-sound-shoreline)))

(define (durative-action do-surveil-task)
    :parameters (?lcs - ship)
    :vars (?uv - unmanned-vehicle)
    :expansion (sequential
		(surveilled ?uv tank1))
    :effect (at end (did-surveil ?lcs))
    :comment "monitor task"
    )

(define (problem var-surveil3)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (did-surveil lcs1)))

(define (problem inspect-tgt)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (inspect-target knifefish2 USS-Eisenhower)))

(define (problem usv-inspect)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (inspected spartan-scout1 tank1)))

(define (problem uav-monitor)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (monitor-loc global-hawk1 desert4)))

(define (problem uav-monitor2)
    (:domain dod-domain)
  (:situation dod1)
 (:init (IS-LOCATED predator1 jackson-base)(HAS-LAUNCH-STATE predator1 in-the-air))	      
  (:deadline 400.0)
  (:goal (monitor-loc predator1 desert4)))

;;; Big actions for testing 

(define (durative-action do-tasks1)
    :parameters (?lcs - ship)
    :vars (?uav - unmanned-aerial-vehicle
	   ?usv - unmanned-surface-vehicle
	   ?uuv - unmanned-underwater-vehicle)
    :expansion (parallel
		(monitor-loc ?uav desert4)
		(surveilled ?usv red-brigade1)
		(inspect-target ?uuv uss-eisenhower))
    :effect (at end (tasks-done1 ?lcs))
    :comment "monitor task"
    )

(define (durative-action do-tasks2)
    :parameters (?lcs - ship)
    :expansion (parallel
		(monitor-loc global-hawk1 desert4)
		(surveilled spartan-scout1 red-brigade1)
		(inspect-target knifefish2 uss-eisenhower))
    :effect (at end (tasks-done2 ?lcs))
    :comment "monitor task"
    )

#|
(define (durative-action do-tasks3)
    :parameters (?lcs - ship)
    :expansion (parallel
		(sequential
		 (monitor-loc global_hawk1 desert4)
		 (prosecuted uav4 tank1))
		(surveilled spartan_scout1 red-brigade1)
		(inspect-target uuv2 uss-eisenhower)
		)
    :effect (at end (tasks-done3 ?lcs))
    :comment "monitor task"
    )|#

(define (durative-action do-tasks3)
    :parameters (?lcs - ship)
    :expansion (parallel
		 (prosecuted reaper4 tank1)
		 (inspect-target knifefish2 uss-eisenhower)
		)
    :effect (at end (tasks-done3 ?lcs))
    :comment "monitor task"
    )

(define (durative-action do-tasks4)
    :parameters (?lcs - ship)
    :expansion (sequential
		 (surveilled talisman2 cedar-island-south-beach)
		 ;;(surveilled talisman2 writesville-beach-shoreline)
		)
    :effect (at end (tasks-done4 ?lcs))
    :comment "monitor task"
    )

(define (problem do-tasks1)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (tasks-done1 lcs1)))

(define (problem do-tasks2)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (tasks-done2 lcs1)))

(define (problem do-tasks3)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (tasks-done3 lcs1)))

(define (problem do-tasks4)
    (:domain dod-domain)
  (:situation dod1)
  (:deadline 400.0)
  (:goal (tasks-done4 lcs1)))


#|(NEW-PREDICATE '(DOD-JOBS-DONE ?LCS - agent) dod-DOMAIN)

(DEFINE (DURATIVE-ACTION DO-DOD-JOBS) :PARAMETERS (?LCS - SHIP) :vars (?o - unmanned-vehicle) :EXPANSION
           (PARALLEL (MONITOR-LOC ?O DESERT4)) :EFFECT (AT END (DOD-JOBS-DONE ?LCS)))

(DEFINE (PROBLEM DONE-DOD-JOBS) (:DOMAIN DOD-DOMAIN) (:SITUATION DOD1) (:INIT) (:DEADLINE 390.0)
           (:GOAL (DOD-JOBS-DONE LCS1)))|#
