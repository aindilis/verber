(define
 (problem VELVEETA)
 ;; (time-units minutes)
 (:domain VELVEETA)
 (:objects
  velveeta - food
  water-cooler bowl-2-quart-microwavable - container
  )
 (:init

  (empty water-cooler)
  (= (capacity water-cooler) 5)
  (empty bowl-2-quart-microwavable)
  (= (capacity bowl-2-quart-microwavable) 0.5)

  (uncooked velveeta)
  (unheated velveeta)

  (= (heating-time velveeta) 11)
  (= (cooking-time velveeta) 11)
  )
 (:goal
  (and
   (cooked velveeta)
   )
  )
 )