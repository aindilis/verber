

(define
 (problem fffopcs)
 (:domain fffopcs)
 (:objects neg knows atLocation - pred townhome - location v2v3 v2v2 v2v1 v1v3 v1v2 v1v1 null - id andrewDougherty - agent)
 (:init
  (triple v1v1 neg v1v2 null)
  (triple v1v2 knows andrewDougherty v1v3)
  (triple v1v3 atLocation andrewDougherty townhome))
 (:goal
  (and
   (triple v2v1 knows andrewDougherty v1v3)
   (exists
    (?l - location)
    (triple v1v3 atLocation andrewDougherty ?l))))
 (:metric minimize
  (total-time)))