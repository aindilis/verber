(in-package :ap)

(define (domain iss-base)
  (:comment "ISS-base Ontology")
  (:extends base)
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     station-object stowage-structures orbital-replacement-unit - physical-entity
     oru-role - role
     iss-action-verbs - action-verbs
     space-station - orbital
     sarj-mode us_gnc-mode device-mode - mode
     iss-schematic-location - schematic-location
     crew-activity-type mcc-activity-type - activity-type
     crew flight-controller - agent
     cato phalcon adco odin thor - flight-controller
     iss-computer iss-computer - computer
     oru-location iss-location - physical-location
     truss-location module-location external-stowage-platform-location ex-press-logistics-carrier-location airway - iss-location
   )  
  (:constants
    esp0306-aft-stb-nad esp0206-aft-prt-zen esp0206-fwd-prt-nad esp0204-aft-stb-zen esp0301-aft-nad-prt esp0101-aft-prt-zen esp0202-fwd-mid-zen esp0207-aft-prt-nad  - external-stowage-platform-location
    repressurization EVA  - crew-activity-type
    active non-active stand-by  - device-mode
    auto-track blind directed-position  - sarj-mode
    z1tr-aec z1tr-stb Z1B00F03ZS Z1B00F03NS Z1B00F03NP Z1B00F03ZP P6B48F04MN P6B48F01MN P3B20F01NP P1B10F01MM P1B06F04MS S1B05F04MP P1B06F01MP P1B06F00MM S1B05F01MS S6B43F04NP S6B43F04NS S6B43F01NS S6B43F01NP P6B44F01NS P6B44F01NP P1B16F06MP S4B23F04ZM S4B23F01ZM S5B26F04MM S5B29F01MM S6B47F04MN S6B47F01MN S6B53F04PB S6B53F01PB S4B23F04MN S4B23F01MN P4B24F04MN P1B12F01MP S1B07F03MP S0B04F01MS S1B11F01MS P1B12F01MP P1B08F01MS S1B07F01MP P4B24F01MN P1B16F01NS S1B15F01ZP S0B00F06ZP S0B00F06ZS S0B01F01NS S0B01F01ZS S1B13F01ZP S0B00F03MP S0B00F06MP S0B02F02MS S0B02F02MP S0B00F06MS S0B02F01MP S0B01F01MS S0B01F01MP P3B20F02MP S3B19F02MS  - truss-location
    elc0204-aft-prt-nad elc0307-aft-prt-nad elc0109-aft-stb-zen elc0109-fwd-prt-zen elc0406-mid-stb-nad elc0301-aft-stb-nad elc0105-fwd-prt-zen elc0102-fwd-prt-zen elc0201-aft-prt-nad elc0205-aft-stb-nad elc0106-fwd-stb-zen elc0206-aft-stb-zen elc0107-fwd-stb-nad elc0405-mid-prt-nad  - ex-press-logistics-carrier-location
    CMG cmg_ta drift gnc-standby udg wait  - us_gnc-mode
    airlock intra-vehicle  - iss-location
    nod1mid-prt alck-stb-fwd alck-stb-nad ulab-aec-stb nod2aec-zen nod2aec-nad nod2fec-nad nod2fec-zen ulab-aec-prt  - module-location
    spare-oru used  - oru-role
    wire-tie wire wipe wiggle wait verify use unlock unbolt turn tighten translate transfer torgque tether-to tether temp_stow take swap strap straighten stow soft-dock slide setup set select secure seat rotate roll retrieve retract retorque restrain report replace repeat remove relocate release refer reinstall record reconfigure receive reattach pry push pull provide press present prepare prep position place photo perform peal-back orient 
    ;;open 
    obtain notify navigate move monitor mnvr mate manipulate maneuver maintain loosen lock locate lift label jiggle instruct install inspect insert input ingress increase hold handover handout guide go-to go give GCA fold fairlead extend establish ensure engage egress drive don doff dock disconnect detach describe demate cycle couple counteract continue connect configure 
;;close 
click clean check cinch bundle break-torque break bolt avoid attempt attach assist assess align access  - iss-action-verbs

   )
  (:predicates
    (body-size ?c - crew ?s - size)
    (o2-use-rate ?c - crew ?r - rate)
    (too-far ?il - iss-location ?il1 - iss-location)
    (has-oru-role ?oru - orbital-replacement-unit ?or - oru-role)
    (fills-oru-role ?or - oru-role ?oru - orbital-replacement-unit)
    (is-attached-to ?pe - physical-entity ?pe1 - physical-entity)
    ;;(has-iss-location ?pe - physical-entity ?il - iss-location)
    (has-oru-location ?so - station-object ?ol - oru-location)
    (item-extracted ?c - crew ?so - station-object)
    (item-positioned ?so - station-object ?l - location)
    (egressed-by-two ?c - crew ?so - station-object)
    (ingressed-by-two ?c - crew ?so - station-object)
    (item-retrieved ?c - crew ?so - station-object)
    (item-installed ?c - crew ?pe - physical-entity)
    (item-installed-in-place ?c - crew ?pe - physical-entity)
    (prepared-for ?c - crew ?cat - crew-activity-type)
    (stowed ?c - crew ?so - station-object)
    (handed-over ?c - crew ?so - station-object)
    (present-item_a ?c - crew ?so - station-object)
    (remove-cover_a ?c - crew ?so - station-object)
    (attach-cover_a ?c - crew ?so - station-object)
    (inserted ?so - station-object ?il - iss-location)
    (install-item_a ?c - crew ?so - station-object)

  )
  (:functions 
    (has-iss-location ?pe - physical-entity) - iss-location)
(:axiom
   :vars (?c - container
          ?p - physical-entity
          ?l - iss-location)
   :context (and 
             (contains ?c ?p)
             (has-iss-location ?c ?l))
   :implies  (has-iss-location ?p ?l)
   )
 #|(:axiom
   :vars (?c - container
          ?p - physical-entity
          ?l - iss-location)
   :context (and 
             (contained_by ?p ?c)
             (has-iss-location ?c ?l))
   :implies  (has-iss-location ?p ?l)
   )|#
 (:axiom
   :vars (?a - agent
          ?p - physical-entity
          ?l - iss-location)
   :context (and 
             (possesses ?a ?p)
             (has-iss-location ?a ?l))
   :implies  (has-iss-location ?p ?l)
   )
  (:axiom
   :vars (?a - physical-entity
          ?b - physical-entity
          ?l - iss-location)
   :context (and 
             (is-attached-to ?a ?b)
             (has-iss-location ?b ?l))
   :implies  (has-iss-location ?a ?l)
   )
  (:axiom
   :vars (?a - physical-entity
          ?b - physical-entity
          ?l - oru-location)
   :context (and 
             (is-attached-to ?a ?b)
             (has-oru-location ?b ?l))
   :implies  (has-oru-location ?a ?l)
   )
  (:axiom
   :vars (?a - physical-entity
          ?b - physical-entity
          ?l - oru-location)
   :context (and 
             (has-component ?a ?b)
             (has-oru-location ?a ?l))
   :implies  (has-oru-location ?b ?l)
   )
  (:axiom
   :vars (?a - physical-entity
          ?b - physical-entity
          ?l - iss-location)
   :context (and 
             (has-component ?a ?b)
             (has-iss-location ?a ?l))
   :implies  (has-iss-location ?b ?l)
   )
  (:axiom
   :vars (?a - station-object
          ?o - oru-location
          ?l - iss-location)
   :context (and 
             (has-oru-location ?a ?o)
             (has-iss-location ?o ?l))
   :implies  (has-iss-location ?a ?l)
   )
  (:axiom
   :vars (?a - iss-location
          ?b - iss-location)
   :context (and 
             (too-far ?a ?b))
   :implies  (too-far ?b ?a)
   )
  (:axiom
   :vars (?oru - orbital-replacement-unit
          ?or - oru-role)
   :context (has-oru-role ?oru ?or)
   :implies (fills-oru-role ?or ?oru)
   )
 )
;;;(owl:Restriction 'has-iss-location 'owl:cardinality 1)