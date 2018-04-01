

(define
 (problem flptest)
 (:domain flptest)
 (:objects task2 task1 - task)
 (:init
  (completed task2))
 (:goal
  (and
   (<
    (time) 1)
   (completed task1)))
 (:metric minimize
  (total-time)))