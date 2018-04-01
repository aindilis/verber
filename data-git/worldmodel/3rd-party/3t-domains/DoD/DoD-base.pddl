
 (in-package :ap)
(define (domain dod-base)
  (:comment "DoD-base Ontology")
  (:extends base)
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     boat truck car tank artillery anti-aircraft bicycle ship - surface
     area-of-interest - geographical-area
     us-military-organization opposing-force-organization - military-organization
     personnel-class - physical-entity
     combatant - personnel-class
     enemy friendly - combatant
     terrorist - enemy
     surface-mine-counter-measures-uuv - under-water
     plant - building
     power-plant chemical-plant - plant
     vertical-takeoff-uav aerial-munition blackjack - aerial
     cluster-bomb - bomb
     mine - explosive
     land-mine water-mine - mine
     infra-red optical-imaging thermal sonar magnetic
     acoustic multi-sensor - sensor
     forward-staging-base mine-field - military-land-area
     capability observation-range vehicle-class military-objective - abstract-entity
     air-to-air-missile air-to-surface-missile surface-to-ai-r-missile infra-red-guided-missile - missile
     launch-state - state
     unmanned-aerial-vehicle unmanned-surface-vehicle unmanned-ground-vehicle unmanned-underwater-vehicle - unmanned-vehicle
     smart-munition blackjack - unmanned-aerial-vehicle
     harbor shoreline river dock beach - water-area
     base-location - physical-location
   )  
  (:constants
    ground-observing low-altitude-observing high-altitude-observing  - capability
    close-up medium-distance long-distance  - observation-range
    not-launched on-the-ground in-the-air  - launch-state

   )
  (:predicates
    (on-ship ?pe - physical-entity ?s - ship)
    (has-sensor ?pe - physical-entity ?s - sensor)
    (has-weapon ?pe - physical-entity ?w - weapon)
    (has-observation-range ?a - agent ?or - observation-range)
    (is-attached-to ?pe - physical-entity ?pe1 - physical-entity)
    (has-vehicle-class ?v - vehicle ?vc - vehicle-class)
    (has-military-objective ?mo - military-organization ?mo1 - military-objective)
    (is-military-objective-for ?mo - military-objective ?mo1 - military-organization)
    (has-armament ?v - vehicle ?a - armament)
    (has-current-target ?maa - marine-attack-aircraft ?ofo - opposing-force-organization)
    (has-location-objective ?mo - military-organization ?ga - geographical-area)

  )
  (:functions
    (is-located ?pe - physical-entity) - location
    (has-launch-state ?uav - unmanned-aerial-vehicle) - launch-state

  )
  (:axiom
   :vars (?s - ship
          ?p - physical-entity
          ?l - location)
   :context (and 
             (on-ship ?p ?s)
             (is-located ?s ?l))
   :implies  (is-located ?p ?l)
   )
  (:axiom
   :vars (?c - container
          ?p - physical-entity
          ?l - location)
   :context (and 
             (contains ?c ?p)
             (is-located ?c ?l))
   :implies  (is-located ?p ?l)
   )
  (:axiom
   :vars (?a - agent
          ?p - physical-entity
          ?l - location)
   :context (and 
             (possesses ?a ?p)
             (is-located ?a ?l))
   :implies  (is-located ?p ?l)
   )
  (:axiom
   :vars (?a - physical-entity
          ?b - physical-entity
          ?l - location)
   :context (and 
             (has-component ?a ?b)
             (is-located ?a ?l))
   :implies  (is-located ?b ?l)
   )
  (:axiom
   :vars (?a - physical-entity
          ?b - physical-entity
          ?l - location)
   :context (and 
             (is-attached-to ?a ?b)
             (is-located ?b ?l))
   :implies  (is-located ?a ?l)
   )
  (:axiom
   :vars (?mo - military-organization
          ?mo1 - military-objective)
   :context (has-military-objective ?mo ?mo1)
   :implies (is-military-objective-for ?mo1 ?mo)
   )
 )