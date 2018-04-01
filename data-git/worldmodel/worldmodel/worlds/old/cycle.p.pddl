(define (problem cycle)

 (:domain cycle)

 (:objects
  chores plan-cycle - task
  )

 (:init
  (= (estimated-duration plan-cycle) 1)
  (= (estimated-duration chores) 1)

  (pending plan-cycle)
  (pending chores)
  )

 (:goal 
  (and
   (finished plan-cycle)
   (finished chores)
   )
  )
 )
