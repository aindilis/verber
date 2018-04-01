
 (in-package :ap)
(define (domain base)
  (:comment "top-level ontology")
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     entity - object
     spatio-temporal-entity input-output-entity abstract-entity - entity
     physical-entity - spatio-temporal-entity
     substance environment location consumable pump
     computer power-channel power-source control-bus robot
     weapon sensor actuator equipment transport
     light antenna vehicle motor celestial-body
     network social-entity - physical-entity
     solid liquid gas - substance
     weather - environment
     physical-location orientation schematic-location geographical-area - location
     coordinates - physical-location
     water-area land-area - geographical-area
     urban-area rural-area coastal-area continent geo-political-area - land-area
     city - urban-area
     civil-state province nation - geo-political-area
     european-nation - nation
     fuel - consumable
     container tool transmitter receiver - equipment
     aerial surface subsurface space-craft - vehicle
     under-ground under-water - subsurface
     orbital deep-space - space-craft
     agent non-agentive-entity - social-entity
     unmanned-vehicle - agent
     language - non-agentive-entity
     english-language - language
     parts-of-speech - english-language
     verbs - parts-of-speech
     action-verbs - verbs
     command command-argument enumeration telemetry - input-output-entity
     enumerated-command-argument numeric-command-argument - command-argument
     enumerated-telemetry string-telemetry numeric-telemetry - telemetry
     boolean-value size rate state role geometry configuration activity-type capability - abstract-entity
     mode - state
   )  
  (:constants
    off on unlocked locked closed open done  - state
    unknown-location  - location
    nobody  - agent
    fast average_rate slow  - rate
    cubic hexagonal  - geometry
    nothing  - physical-entity
    yes yes X untripped unsynched unknown tripped transitioning static standby standby single_bed operational open open on okay offline off not_armed no-change no no night min-ops mdm2 mdm1 leak-rcvy-fdir-state-inhibited leak-rcvy-fdir-state-enabled invalid in-sync inprogress init inhibited inhibit incrementing inactive in_progress fire fail-rcvy-fdir-state-inhibited fail-rcvy-fdir-state-enabled fail enabled enable2 enable1 enable dual_bed deactivate-input-undervolt-trip-recovery deactivate-input-undervolt-trip deactivate-input-undervolt-command-rejection deactivate-commanded-bit deactivate day complete closed closed close blank-on-off-status blank-command-status blank armed arm activate ?  - enumeration
    spain france germany england  - european-nation
    large medium small large medium small  - size
    japan russia USA  - nation
    no yes  - boolean-value

   )
  (:predicates
    (has-network-membership ?pe - physical-entity ?n - network)
    (has-mode ?pe - physical-entity ?m - mode)
    (tool-for ?pe - physical-entity ?e - equipment)
    ;;(is-available ?pe - physical-entity ?bv - boolean-value)
    (has-power-channel ?pe - physical-entity ?pc - power-channel)
    (has-control-bus ?pe - physical-entity ?cb - control-bus)
    (is-control-bus-for ?cb - control-bus ?pe - physical-entity)
    (is-power-channel-for ?pc - power-channel ?pe - physical-entity)
    (has-schematic-location ?pe - physical-entity ?sl - schematic-location)
    (has-physical-location ?pe - physical-entity ?pl - physical-location)
    (has-component ?pe - physical-entity ?pe1 - physical-entity)
    (is-controlled-by ?pe - physical-entity ?c - computer)
    (controller-for ?c - computer ?pe - physical-entity)
    (possesses ?a - agent ?e - entity)
    ;;(possessed_by ?e - entity ?a - agent)
    (contains ?pe - physical-entity ?e - entity)
    ;;(contained_by ?e - entity ?pe - physical-entity)
    (location-for ?pe - physical-entity ?pl - physical-location)
    (has-command ?pe - physical-entity ?c - command)
    (has-telemetry ?pe - physical-entity ?t - telemetry)
    (has-command-argument ?c - command ?ca - command-argument)
    (has-enumeration ?eca - (or enumerated-command-argument enumerated-telemetry ) ?e - enumeration)

  )
(:functions
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
 )
;;;(owl:Restriction 'contained_by 'owl:cardinality 1)
;;;(owl:Restriction 'possessed_by 'owl:cardinality 1)
;;;(owl:Restriction 'is-available 'owl:cardinality 1)