(in-package :ap)

(define (problem uav-travel0)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (located global_hawk1 zambezi-river)))

(define (problem uav-travel)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:init (located global_hawk1 seal-harbor-dock))
  (:goal (sequential
           (located global_hawk1 zambezi-river)
           (located global_hawk1 seal-harbor-dock))))

(define (problem uav-neutralize)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (neutralized predator2 wal)))

(define (problem uav-inspect-no)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (inspected predator2 lcs1)))

(define (problem uav-inspect-yes)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (inspected firescout_1 lcs1)))

(define (problem uav-monitor)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (monitoring global_hawk1 hill224)))

(define (problem uav-monitor)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (monitor-loc global_hawk1 desert4)))

(define (problem uav-monitor2)
    (:domain nas-domain)
  (:situation nas1)
 (:init (LOCATED global_hawk1 DESERT4)(FLIGHT-STATE global_hawk1 in-the-air))	      
  (:deadline 400.0)
  (:goal (monitor-loc global_hawk1 desert4)))

;;; Big actions for testing 

(define (durative-action do-tasks1)
    :parameters (?lcs - ship)
    :vars (?uav1 - unmanned-aerial-vehicle
	   ?uav2 - unmanned-aerial-vehicle
	   ?uav3 - unmanned-aerial-vehicle)
    :condition (and (at start (not (= ?uav1 ?uav2)))
    	       	    (at start (not (= ?uav2 ?uav3)))
		    (at start (not (= ?uav1 ?uav3))))
    :expansion (parallel
		(monitor-loc ?uav1 desert4)
		(surveilled ?uav2 city1)
		(inspect-target ?uav3 lcs1))
    :effect (at end (tasks-done1 ?lcs))
    :comment "monitor task"
    )

(define (problem do-tasks1)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (tasks-done1 lcs1)))

#|
(define (durative-action do-tasks2)
    :parameters (?lcs - ship)
    :expansion (parallel
		(monitor-loc uav1 desert4)
		(surveilled usv1 red-brigade1)
		(inspect-target uuv2 uss-eisenhower))
    :effect (at end (tasks-done2 ?lcs))
    :comment "monitor task"
    )

(define (durative-action do-tasks3)
    :parameters (?lcs - ship)
    :expansion (parallel
		(sequential
		 (monitor-loc uav1 desert4)
		 (prosecuted uav4 tank1))
		(surveilled usv1 red-brigade1)
		(inspect-target uuv2 uss-eisenhower)
		)
    :effect (at end (tasks-done3 ?lcs))
    :comment "monitor task"
    )

(define (durative-action do-tasks3)
    :parameters (?lcs - ship)
    :expansion (parallel
		 (prosecuted uav4 tank1)
		 (inspect-target uuv2 uss-eisenhower)
		)
    :effect (at end (tasks-done3 ?lcs))
    :comment "monitor task"
    )

(define (problem do-tasks1)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (tasks-done1 lcs1)))

(define (problem do-tasks2)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (tasks-done2 lcs1)))

(define (problem do-tasks3)
    (:domain nas-domain)
  (:situation nas1)
  (:deadline 400.0)
  (:goal (tasks-done3 lcs1)))

|#
#|(NEW-PREDICATE '(NAS-JOBS-DONE ?LCS - agent) nas-domain)

(DEFINE (DURATIVE-ACTION DO-NAS-JOBS) :PARAMETERS (?LCS - SHIP) :vars (?o - unmanned-vehicle) :EXPANSION
           (PARALLEL (MONITOR-LOC ?O DESERT4)) :EFFECT (AT END (NAS-JOBS-DONE ?LCS)))

(DEFINE (PROBLEM DONE-NAS-JOBS) (:DOMAIN NAS-DOMAIN) (:SITUATION NAS1) (:INIT) (:DEADLINE 390.0)
           (:GOAL (NAS-JOBS-DONE LCS1)))|#
