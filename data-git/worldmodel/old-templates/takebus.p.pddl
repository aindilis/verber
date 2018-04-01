;; Planning out for todays tasks, so that I can figure out what I need
;; to do and when, given the constraints

(define (problem TAKEBUS)
  (:domain BUSROUTE)
  (:objects	
   AndrewDougherty - person
   Bus67A Bus67F - bus
   ForbesOPPCraigSt DallasANDPennham - stop
   )

  (:init
   ;; bus schedule information
   <TRANSIT-INFORMATION>

   ;; initial location
   (at AndrewDougherty ForbesOPPCraigSt)
   )

  (:goal 
   (and 	
    (at AndrewDougherty DallasANDPennham)
    )
   )

  )
