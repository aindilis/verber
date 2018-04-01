

(define
 (problem fffopcsw)
 (:domain fffopcsw)
 (:objects neg knows atLocation - pred townhome - location v2v3 v2v2 v2v1 v1v3 v1v2 v1v1 null - id a9 a8 a7 a6 a5 a4 a3 a2 a1 a0 - arg andrewDougherty - agent)
 (:init
  (argIsa v1v1 a0 neg)
  (argIsa v1v1 a1 v1v2)
  (argIsa v1v2 a0 knows)
  (argIsa v1v2 a1 andrewDougherty)
  (argIsa v1v2 a2 v1v3)
  (argIsa v1v3 a0 atLocation)
  (argIsa v1v3 a1 andrewDougherty)
  (argIsa v1v3 a2 townhome))
 (:goal
  (and
   (argIsa v2v1 a2 v1v3)
   (argIsa v2v1 a1 andrewDougherty)
   (argIsa v2v1 a0 knows)
   (exists
    (?l - location)
    (and
     (argIsa v1v3 a0 atLocation)
     (argIsa v1v3 a1 andrewDougherty)
     (argIsa v1v3 a2 ?l)))))
 (:metric minimize
  (total-time)))