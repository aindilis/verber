(define
 (problem NEW-1)

 (:domain NEW)

 (:objects g1 g2 g3 - goal Andrew-Dougherty - person)

 (:init
  (= (savings Andrew-Dougherty) 100)
  )

 (:goal
  (done g1)
  )

(:constraints (and

	(preference p0 (hold-after 0.001 (> (savings Andrew-Dougherty) 1)))
	(preference p1 (hold-after 0.001 (> (savings Andrew-Dougherty) 1000)))

	       ))

(:metric minimize (+ 
		   (* 1 (is-violated p0))
		   (* 3 (is-violated p1))
		   (* 5 (total-time))
		   )
 )

)