(in-package :ap)

(define (domain ATTetCK)
    (:extends malware windows)
  (:predicates
   (compromised ?a - Agent ?h - Host)
   (compromisedBy ?h - Host ?a - Agent)
   (attack ?a - Agent ?o - object)
   ))

(inverseOf compromised compromisedBy)

(define (action Compromise_host)
    :parameters (?a - Agent
                 ?h - Host)
    :effect (and (compromised ?a ?h)
		 (hasAccessTo ?a ?h))
    :probability 0.9)
