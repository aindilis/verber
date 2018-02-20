(define

 (problem PSEX)
 ;; (time-units minutes)

 (:domain PSEX)

 (:objects
  ;; 51343
  entry-51343 entry-235523 entry-532523 entry-41341 - unilang-entry
  )

 (:init

  ;; (costs entry-41341 200)
  (= (cost entry-41341) 200)

  )

 (:constraints

  ;; (depends entry-41341 entry-51343)
  (sometime-before (completed entry-41341) (completed entry-51343))

  ;; ;; (provides entry-532523 entry-235523)
  ;; (always (implies (completed entry-532523) (completed entry-235523)))

  ;; (eases entry-41341 entry-532523)
  (preference eases-entry-41341-entry-532523
   (sometime-before (completed entry-41341) (completed entry-532523)))

  )

 (:goal
  (and

   ;; (goal entry-51343)
   (completed entry-51343)

   )
  )
 )

