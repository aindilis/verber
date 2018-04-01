
 (in-package :ap)
(define (domain dodi)
  (:comment "DoDi Ontology")
  (:extends base DOD-base)
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     uv_x-position uv_y-position uv_fuel-level uv_battery-charge - numeric-telemetry
     uv-travel-to-target-command uv-travel-to-waypoint-command uv-neutralize-command uv-monitor-command uav-take-off-command
     battery-on-command battery-off-command transmitter-on-command transmitter-off-command optical-imaging-on-command
     optical-imaging-off-command infra-red-on-command infra-red-off-command uav-land-command uav-image-command
     uav-designate-command usv-track-command uuv-inspect-command uuv-active-bit-initiate-command jdam-launch-command
     blackjack-launch-command uv-accept-target-command - command
     marine-attack-aircraft marine-electronic-warfare-aircraft - aerial
     verticalor-short-take-offand-land - marine-attack-aircraft
     av-8b-harrier - verticalor-short-take-offand-land
     ea-6b-prowler - marine-electronic-warfare-aircraft
     military-action - action
     cover-action attack-action defend-action seize-action defend-action
     fire-support-action reconnaissance-action - military-action
     lau-5003 - rocket
     uv-transmitter - transmitter
     mark80 - bomb
     military-organization-role - role
     synthetic-aperture-sonar - sonar
     uvs-atellite-connection-status-enumeration uv-battery-status-enumeration uvt-ransmit-status-enumeration uv-command-status-enumeration uv-accept-target-enumeration
     uv-target-enumeration uav-launch-state-enumeration optical-imaging-status-enumeration infra-red-status-enumeration uuv-status-enumeration
     uuv-active-bit-result-enumeration uuv-active-bit-state-enumeration - enumeration
     satellite-connection - communications-channel
     uv-satellite-connection - satellite-connection
     war-head - weapon
     unitary-war-head hard-target-penetrator-war-head - war-head
     us-army-organization us-marine-organization - us-military-organization
     corps division division-support-unit regiment brigade battalion company platoon squadron troop detachment firing-battery section team - us-army-organization
     div-arty discom - division-support-unit
     marine-aircraft-wing marine-aircraft-wing-hq marine-aircraft-group marine-attack-squadron marine-tactical-electronic-warfare-squadron
     marine-air-control-group marine-wing-support-group - us-marine-organization
     marine-aircraft-group-rotary-wing marine-aircraft-group-fixed-wing - marine-aircraft-group
     aim-9_side-winder - infra-red-guided-missile
     uv-last-command-status uvt-ransmit-status uv-battery-status uvs-atellite-connection-status uuv-status uuv-active-bit-result uuv-active-bit-status uav-launch-state optical-imaging-status infra-red-status - enumerated-telemetry
     aim-120_amraam - air-to-air-missile
     agm-65_maverick agm-84_harpoon agm-88_harm - air-to-surface-missile
     opfor-battalion opfor-brigade opfor-company opfor-platoon opfor-section - opposing-force-organization
     uv-battery - power-source
     aerial-munition-state - state
     x_argument y_argument - numeric-command-argument
     cbu-100 - cluster-bomb
     uv-target-argument - enumerated-command-argument
   )
  (:predicates
    (has-parent-organization ?mo - military-organization ?mo1 - military-organization)
    (has-subordinate-organization ?mo - military-organization ?mo1 - military-organization)
    (has-operational-control ?mo - military-organization ?mo1 - military-organization)
    (is-organizationally-attached-to ?mo - military-organization ?mo1 - military-organization)
    (has-mission-action ?mo - military-organization ?ma - military-action)
    (has-military-org-role ?mo - military-organization ?mor - military-organization-role)
    (has-aircraft ?mo - military-organization ?a - aerial)
    (has-war-head ?am - aerial-munition ?wh - war-head)
    (tgt-located ?a - agent ?pe - physical-entity)
    (neutralized ?a - agent ?pe - physical-entity)
    (inspected ?a - agent ?pe - physical-entity)
    (surveilled ?a - agent ?pe - physical-entity)
    (prosecuted ?a - agent ?pe - physical-entity)
    (monitoring ?a - agent ?pe - physical-entity)
    (monitored ?a - agent ?pe - physical-entity)
    (tracking ?a - agent ?pe - physical-entity)
    (tracked ?a - agent ?pe - physical-entity)
    (searching ?a - agent ?pe - physical-entity)
    (searched ?a - agent ?pe - physical-entity)
    (inspect-target ?a - agent ?pe - physical-entity)
    (monitor-loc ?a - agent ?l - location)

  )
  (:functions
    (has-aerial-munition-state ?am - aerial-munition) - aerial-munition-state

  )
  (:axiom
   :vars (?c - military-organization
          ?p - military-organization)
   :context (and 
             (has-subordinate-organization ?p ?c))
   :implies  (has-parent-organization ?c ?p)
   )
  (:axiom
   :vars (?c - military-organization
          ?a - aerial)
   :context (and 
             (has-aircraft ?c ?a))
   :implies  (has-parent-organization ?a ?c)
   )
  (:axiom
   :vars (?mo - military-organization
          ?mo1 - military-organization)
   :context (has-operational-control ?mo ?mo1)
   :implies (is-organizationally-attached-to ?mo1 ?mo)
   )
 )