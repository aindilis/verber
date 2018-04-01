

(define
 (problem fffopcp)
 (:domain fffopcp)
 (:objects v2v3 v2v2 v2v1 v1v3 v1v2 v1v1 - self neg knows atLocation - pred townhome - location andrewDougherty - agent)
 (:init
  (p1 neg v1v1 v1v2)
  (p2 atLocation v1v3 andrewDougherty townhome)
  (p2 knows v1v2 andrewDougherty v1v3))
 (:goal
  (and
   (p2 knows v2v1 andrewDougherty v1v3)
   (exists
    (?l - location)
    (p2 atLocation v1v3 andrewDougherty ?l))))
 (:metric minimize
  (total-time)))