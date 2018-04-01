(define
 (problem problem_bacon_wrapped_hotdogs)
 (:domain gourmet)
 (:objects t1 t0 - tool ing7 ing6 ing5 ing4 ing3 ing2 ing1 ing0 - ingredient)
 (:init
  (initialized ing0)
  (initialized ing1)
  (initialized ing2))
 (:goal
  (and
   (combined_into_2 ing3 ing0 ing1)
   (cooked_into ing4 t1 ing5)
   (done_into ing3 t0 ing4)
   (cooked_into ing6 t1 ing7)
   (checked ing7)
   (combined_into_2 ing6 ing2 ing5))))