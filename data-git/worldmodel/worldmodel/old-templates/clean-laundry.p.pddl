;; Planning out for todays tasks, so that I can figure out what I need
;; to do and when, given the constraints

(define (problem CLEAN-LAUNDRY)
  (:domain LAUNDRY)
  (:objects	
   laundry - object
   )

  (:init
   (dirty laundry)
   )

  (:goal 
   (and 	
    (cleaned laundry)
    )
   )
  )

