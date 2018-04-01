(define (problem silly1)

 (:domain silly)

 (:objects testPurchase - product andrewDougherty - person)

 (:init
  (= (total-actions) 0)
  )

 (:goal
  (and
   (own andrewDougherty testPurchase)
   )
  )

 (:metric minimize (total-actions))

 )