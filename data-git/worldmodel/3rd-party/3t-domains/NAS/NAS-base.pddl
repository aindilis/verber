
 (in-package :ap)
(define (domain nas-base)
  (:comment "NAS-base Ontology")
  (:extends base)
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     boat truck car tank artillery anti-aircraft bicycle ship - surface
     personnel-class - physical-entity
     combatant - personnel-class
     enemy friendly - combatant
     terrorist - enemy
     hill city desert - land-area
     mine - explosive
     land-mine water-mine - mine
     infra-red optical-imaging thermal sonar magnetic
     multi-sensor - sensor
     capability observation-range vehicle-class - abstract-entity
     launch-state - state
     unmanned-aerial-vehicle unmanned-surface-vehicle unmanned-ground-vehicle unmanned-underwater-vehicle - unmanned-vehicle
     harbor shoreline river dock - water-area
     base-location - physical-location
   )  
  (:constants
    ground-observing low-altitude-observing high-altitude-observing  - capability
    close-up medium-distance long-distance  - observation-range
    not-launched on-ground in-the-air  - launch-state

   )
  (:predicates
    (on-ship ?pe - physical-entity ?s - ship)
    (has-sensor ?pe - physical-entity ?s - sensor)
    (has-weapon ?pe - physical-entity ?w - weapon)
    (has-observation-range ?a - agent ?or - observation-range)
    (is-attached-to ?pe - physical-entity ?pe1 - physical-entity)
    (has-vehicle-class ?v - vehicle ?vc - vehicle-class)

  )
  (:functions
    (located ?pe - physical-entity) - location
    (flight-state ?uav - unmanned-aerial-vehicle) - launch-state

  )
  (:axiom
   :vars (?s - ship
          ?p - physical-entity
          ?l - location)
   :context (and 
             (on-ship ?p ?s)
             (located ?s ?l))
   :implies  (located ?p ?l)
   )
  (:axiom
   :vars (?c - container
          ?p - physical-entity
          ?l - location)
   :context (and 
             (contains ?c ?p)
             (located ?c ?l))
   :implies  (located ?p ?l)
   )
  (:axiom
   :vars (?a - agent
          ?p - physical-entity
          ?l - location)
   :context (and 
             (possesses ?a ?p)
             (located ?a ?l))
   :implies  (located ?p ?l)
   )
  (:axiom
   :vars (?a - physical-entity
          ?b - physical-entity
          ?l - location)
   :context (and 
             (has-component ?a ?b)
             (located ?a ?l))
   :implies  (located ?b ?l)
   )
  (:axiom
   :vars (?a - physical-entity
          ?b - physical-entity
          ?l - location)
   :context (and 
             (is-attached-to ?a ?b)
             (located ?b ?l))
   :implies  (located ?a ?l)
   )
 )