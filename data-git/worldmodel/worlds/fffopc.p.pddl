

(define
 (problem fffopc1)
 (:domain fffopc)
 (:objects v2v3 v2v2 v2v1 v1v3 v1v2 v1v1 - self townhome - location andrewDougherty - agent)
 (:init
  (atLocation v1v3 andrewDougherty townhome)
  (knows v1v2 andrewDougherty v1v3)
  (neg v1v1 v1v2))
 (:goal
  (and
   (exists
    (?v1v1 ?v1v2 - self ?l - location)
    (and
     (knows ?v1v1 andrewDougherty ?v1v2)
     (atLocation ?v1v2 andrewDougherty ?l)))))
 (:metric minimize
  (total-time)))