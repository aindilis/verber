;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => '0000-00-00_01:00:00',
;;           'StartDate' => '20120819T205052Z'
;;         };

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