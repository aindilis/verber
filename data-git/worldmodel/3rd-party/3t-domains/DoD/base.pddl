
 (in-package :ap)
(define (domain base)
  (:comment "top-level ontology")
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     entity - object
     spatio-temporal-entity input-output-entity abstract-entity - entity
     physical-entity - spatio-temporal-entity
     platform substance environment organization location mechanism amplifier consumable pump computer heater cooler valve engine power-channel power-source communications-channel control-bus robot weapon sensor actuator explosive armament equipment transport light antenna vehicle motor celestial-body network social-entity furniture - physical-entity
     solid liquid gas - substance
     weather - environment
     military-organization - organization
     physical-location orientation direction schematic-location geographical-area - location
     structure coordinates enclosure - physical-location
     bridge industrial-complex - structure
     building room corridor - enclosure
     nautical-zenith-nadir-direction nautical-port-starboard-direction nautical-forward-aft-direction - direction
     water-area land-area path sector - geographical-area
     military-water-area - water-area
     oil-field gas-field urban-area rural-area coastal-area continent military-land-area hill desert geo-political-area - land-area
     city - urban-area
     civil-state province nation - geo-political-area
     european-nation - nation
     roadway - path
     highway - roadway
     fuel food - consumable
     two-way-valve three-way-valve - valve
     rocket missile bomb - armament
     container tool communication-equipment - equipment
     transmitter receiver transceiver - communication-equipment
     navigation-transceiver - transceiver
     aerial surface subsurface space-craft - vehicle
     under-ground under-water - subsurface
     orbital deep-space - space-craft
     agent non-agentive-entity - social-entity
     unmanned-vehicle human-agent - agent
     language - non-agentive-entity
     english-language - language
     parts-of-speech - english-language
     verbs - parts-of-speech
     action-verbs - verbs
     command command-argument enumeration telemetry - input-output-entity
     enumerated-command-argument numeric-command-argument - command-argument
     enumerated-telemetry string-telemetry numeric-telemetry - telemetry
     boolean-value size color age gender
     happiness rate state role action
     geometry configuration activity-type capability unit-type
     units - abstract-entity
     mode - state
   )  
  (:constants
    off on unlocked locked closed open_state done  - state
    unknown-location  - location
    nobody  - agent
    elderly middle-age young-adult childhood  - age
    fast average_rate slow  - rate
    gray brown black white green blue red yellow violet indigo orange  - color
    cubic hexagonal  - geometry
    nothing  - physical-entity
    aft forward  - nautical-forward-aft-direction
    liters-per-sec moles-per-sec inches centimeters kelvin faherenheit centigrade  - units
    starboard port  - nautical-port-starboard-direction
    neuter hermaphrodite male female  - gender
    spain france germany england  - european-nation
    large medium small large medium small  - size
    liquid-flow-rate gas-flow-rate mass weight dimension pressure temperature  - unit-type
    japan russia USA  - nation
    nadir zeni-tc-th  - nautical-zenith-nadir-direction
    mellow sad happy  - happiness
    no yes  - boolean-value

   )
  (:predicates
    (has-unit-type ?t - telemetry ?ut - unit-type)
    (has-units ?t - telemetry ?u - units)
    (has-valve-state ?v - valve ?s - state)
    (has-network-membership ?pe - physical-entity ?n - network)
    (has-mode ?pe - physical-entity ?m - mode)
    (tool-for ?pe - physical-entity ?e - equipment)
    (is-ar-ready ?pe - physical-entity ?bv - boolean-value)
    (has-power-channel ?pe - physical-entity ?pc - power-channel)
    (has-control-bus ?pe - physical-entity ?cb - control-bus)
    (is-control-bus-for ?cb - control-bus ?pe - physical-entity)
    (is-power-channel-for ?pc - power-channel ?pe - physical-entity)
    (has-schematic-location ?pe - physical-entity ?sl - schematic-location)
    (has-physical-location ?pe - physical-entity ?pl - physical-location)
    (has-component ?pe - physical-entity ?pe1 - physical-entity)
    (is-component-of ?pe - physical-entity ?pe1 - physical-entity)
    (is-controlled-by ?pe - physical-entity ?c - computer)
    (controller-for ?c - computer ?pe - physical-entity)
    (possesses ?a - agent ?e - entity)
    (contains ?pe - physical-entity ?e - entity)
    (location-for ?pe - physical-entity ?pl - physical-location)
    (has-command ?pe - physical-entity ?c - command)
    (has-telemetry ?pe - physical-entity ?t - telemetry)
    (is-telemetry-for ?t - telemetry ?pe - physical-entity)
    (has-command-argument ?c - command ?ca - command-argument)
    (has-enumeration ?eca - (or enumerated-command-argument enumerated-telemetry ) ?e - enumeration)
    (has-happiness ?ha - human-agent ?h - happiness)
    (has-gender ?ha - human-agent ?g - gender)
    (has-size ?pe - physical-entity ?s - size)
    (no-op ?a - agent ?s - state)

  )
  (:functions
    (has-color ?pe - physical-entity) - color
    (contained_by ?e - entity) - physical-entity
    (possessed_by ?e - entity) - agent
    (is-available ?pe - physical-entity) - boolean-value

  )
  (:axiom
   :vars (?a - agent
          ?c - physical-entity
          ?p - physical-entity)
   :context (and 
             (contains ?c ?p)
             (possesses ?a ?c))
   :implies  (possesses ?a ?p)
   )
  (:axiom
   :vars (?c - computer
          ?pe - physical-entity)
   :context (controller-for ?c ?pe)
   :implies (is-controlled-by ?pe ?c)
   )
  (:axiom
   :vars (?pe - physical-entity
          ?pc - power-channel)
   :context (has-power-channel ?pe ?pc)
   :implies (is-power-channel-for ?pc ?pe)
   )
  (:axiom
   :vars (?pe - physical-entity
          ?cb - control-bus)
   :context (has-control-bus ?pe ?cb)
   :implies (is-control-bus-for ?cb ?pe)
   )
  (:axiom
   :vars (?a - agent
          ?e - entity)
   :context (possesses ?a ?e)
   :implies (possessed_by ?e ?a)
   )
  (:axiom
   :vars (?pe - physical-entity
          ?e - entity)
   :context (contains ?pe ?e)
   :implies (contained_by ?e ?pe)
   )
  (:axiom
   :vars (?pe - physical-entity
          ?pe1 - physical-entity)
   :context (has-component ?pe ?pe1)
   :implies (is-component-of ?pe1 ?pe)
   )
  (:axiom
   :vars (?pe - physical-entity
          ?t - telemetry)
   :context (has-telemetry ?pe ?t)
   :implies (is-telemetry-for ?t ?pe)
   )
 )