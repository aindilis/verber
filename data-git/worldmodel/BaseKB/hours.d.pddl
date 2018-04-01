(define (problem hours-of-operation)

  (:domain hours-of-operation)

  (:objects

   UC-swimming-pool - facility

   )

  (:init

   ;; University Center & Athletics

   ;; Information Desk x8-2107
   ;; 7 days a week: 8:am-midnight
   ;; UC Athletic Facilities x8-1236
   ;; Monday - Friday: 6am-midnight
   ;; Saturday & Sunday: 10am-midnight
   ;; UC Pool x8-1236
   ;; Mon-Thu: 7am-8am, 11:30am-1:15pm, 6:45pm-9:30pm
   ;; Friday: 7am-8am, 11:30am-1:15pm, 6:45pm-8pm
   ;; Saturday & Sunday: 1pm-5pm


   (at  (open UC-swimming-pool))
   (at 8 (not (open UC-swimming-pool)))


   (at 24 (isolated flagstaff-hill))
   (at 32 (not (isolated flagstaff-hill)))
   (isolated cathedral-of-learning)
   (isolated brians-apartment)

   )

  (:goal 
   (and

    (shaved andy-dougherty)

    )
   )

  (:metric minimize (+
		     (+ 
		      (total-time) 
		      (actions))
		     (total-walking-distance)))

  )
