(in-package :ap)

(define (domain foaf)
    (:prefix "foaf")
  (:uri "http://xmlns.com/foaf/0.1/")
  (:extends owl)
  (:types Agent - Resource		; special for AP
	  Person Group Organization - Agent
	  OnlineAccount Document Project - Thing
	  )
  (:predicates
   (knows ?p1 ?p2 - Person)
   (account ?a - Agent ?oa - OnlineAccount)
   )
  )

