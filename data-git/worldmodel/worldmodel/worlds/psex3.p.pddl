

(define
 (problem PSEX3)
 (:domain PSEX3)
 (:objects andy - person)
 (:init
  (= (budget andy) 500))
 (:goal
  (and))
 (:metric minimize
  (total-time)))