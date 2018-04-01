

(define
 (problem nested)
 (:domain nested)
 (:objects rent - billtype andrewdougherty - agent)
 (:init
  (paybill andrewdougherty rent))
 (:goal
  (and
   (stillalive andrewdougherty)))
 (:metric minimize
  (total-time)))