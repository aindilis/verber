
 (in-package :ap)
(define (domain spacecraft-base)
  (:comment "SpaceCraft-base Ontology")
  (:extends base)
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     high-gain low-gain - antenna
     hill city desert - land-area
     recorder thrusters reaction-wheels tanks motors
     inertial-measurement-unit - physical-entity
     transponder - transmitter
     planet star asteroid moon - celestial-body
     transponder - receiver
     magnetometer infra-red ultra-violet optical-imaging thermal radar radio fields&-particles - sensor
     orbit-type observation-range - abstract-entity
     low-earth-orbit medium-earth-orbit geosynchronous - orbit-type
     tracking&-data-relay-satellite noaa-weather-satellite - orbital
     battery power-generator solar-array - power-source
     radioisotope-thermoelectric-generators - power-generator
     launch-state power-state charge-state thruster-state - state
     unmanned-space-craft - unmanned-vehicle
     harbor shoreline river dock - water-area
   )  
  (:constants
    power_standby power_off power_on  - power-state
    thrusters-off firing  - thruster-state
    ground-network space-network deep-space-network  - network
    discharged charged  - charge-state
    leo-equatorial leo-inclined leo-polar  - low-earth-orbit
    saturn jupiter mars earth  - planet
    ground-observing low-altitude-observing high-altitude-observing  - capability
    geo-equatorial  - geosynchronous
    close-up medium-distance long-distance  - observation-range
    meo-equatorial meo-inclined  - medium-earth-orbit
    ganymede europa luna  - moon
    on-ground launched  - launch-state

   )
  (:predicates
    (has-charge-state ?b - battery ?cs - charge-state)
    (has-thruster-state ?t - thrusters ?ts - thruster-state)
    (has-orbit-type ?o - orbital ?ot - orbit-type)
    ;;(has-power-state ?pe - physical-entity ?ps - power-state)
    (has-sensor ?pe - physical-entity ?s - sensor)
    (has-power-source ?pe - physical-entity ?ps - power-source)
    (has-observation-range ?a - agent ?or - observation-range)
    (is-attached-to ?pe - physical-entity ?pe1 - physical-entity)
    ;;(flight-state ?sc - space-craft ?ls - launch-state)
    ;;(located ?pe - physical-entity ?l - location)
    ;;(current-target ?sc - space-craft ?pe - physical-entity)
    ;;(pointed-at ?sc - space-craft ?pe - physical-entity)

  )
(:functions
	(flight-state ?sc - space-craft) - launch-state
	(located ?pe - physical-entity) - location
	(has-power-state ?pe - physical-entity) - power-state
    	(current-target ?sc - space-craft) - physical-entity
    	(pointed-at ?sc - space-craft) - physical-entity

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
             (is-attached-to ?a ?b)
             (located ?b ?l))
   :implies  (located ?a ?l)
   )
 )
;;;(owl:Restriction 'flight-state 'owl:cardinality 1)
;;;(owl:Restriction 'located 'owl:cardinality 1)
;;;(owl:Restriction 'has-power-state 'owl:cardinality 1)
;;;(owl:Restriction 'current-target 'owl:cardinality 1)
;;;(owl:Restriction 'pointed-at 'owl:cardinality 1)