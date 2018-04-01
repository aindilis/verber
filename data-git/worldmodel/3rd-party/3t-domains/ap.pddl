(in-package :ap)

#|
domain with types and predicates for use during adversarial planning
|#

(define (domain ap)
    (:documentation "Adversarial Planning")
  (:extends foaf)
  (:prefix "ap")
  (:uri "http://www.fsf.org/ontologies/2012/ap#")
  (:requirements :multi-agent)
  (:types Planner - Agent)
  (:predicates
   (agentOf ?a - Agent ?p - Planner)
   (hasAgent ?p - Planner ?a - Agent)
   (hasAdversary ?p1 ?p2 - Planner)
   (hasIntent ?a - Agent ?t - Thing))
  )

(inverseOf 'hasAgent 'agentOf)
(inverseOf 'hasAdversary 'hasAdversary)

   