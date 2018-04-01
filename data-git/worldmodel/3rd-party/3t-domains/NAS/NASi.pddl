
 (in-package :ap)
(define (domain nasi)
  (:comment "NASi Ontology")
  (:extends base DOD-base)
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     plant - building
     power-plant chemical-plant - plant
     vertical-takeoff-uav - aerial
     uav-take-off-command uav-travel-to-command uav-land-command uav-engage-command - command
     uav-launch-state-enumeration - enumeration
     war-head - weapon
     unitary-war-head hard-target-penetrator-war-head - war-head
     uav-launch-state - enumerated-telemetry
     synthetic-aperture-sonar - sonar
     aerial-munition-state - state
     x_argument y_argument - numeric-command-argument
   )
  (:predicates
    (tgt-located ?a - agent ?pe - physical-entity)
    (neutralized ?a - agent ?pe - physical-entity)
    (inspected ?a - agent ?pe - physical-entity)
    (surveilled ?a - agent ?pe - physical-entity)
    (prosecuted ?a - agent ?pe - physical-entity)
    (monitoring ?a - agent ?pe - physical-entity)
    (tracking ?a - agent ?pe - physical-entity)
    (searching ?a - agent ?pe - physical-entity)
    (inspect-target ?a - agent ?pe - physical-entity)
    (monitor-loc ?a - agent ?l - location)

  )
 )