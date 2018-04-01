
 (in-package :ap)
(define (domain spacecrafti)
  (:comment "SpaceCrafti Ontology")
  (:extends base spacecraft-base)
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
   )
  (:predicates
    (inspect-target ?a - agent ?pe - physical-entity)
    (inspected ?a - agent ?pe - physical-entity)
    (monitor-loc ?a - agent ?l - location)
    (monitoring ?a - agent ?pe - physical-entity)
    ;;(shutter-state ?oi - optical-imaging ?s - state)
    (surveilled ?a - agent ?pe - physical-entity)
    (tgt-located ?a - agent ?pe - physical-entity)
    (tracking ?a - agent ?pe - physical-entity)

  )
(:functions
(shutter-state ?oi - optical-imaging) - state
)
 )
;;(owl:Restriction 'shutter-state 'owl:cardinality 1)