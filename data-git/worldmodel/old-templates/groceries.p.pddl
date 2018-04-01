;; (include BUSROUTE)

(define (problem GROCERIES)
  (:domain GROCERIES)
  (:objects	
   ; groceries - object
   AndrewDougherty - person
   )

  (:init
   ; (at groceries store)
   (at user Wilkins-and-Worth)
   (has-store Forbes-And-Murray)
   )

  (:goal 
   (and
    ; (at groceries home)
    (at user Wilkins-and-Worth)
    (has-groceries user)
    )
   )
  )

