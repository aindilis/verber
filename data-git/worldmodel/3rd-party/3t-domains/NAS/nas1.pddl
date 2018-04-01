
 (in-package :ap)
(define (situation nas1) 
  (:domain nas-domain)
  (:objects
    firescout_1 - (and unmanned-aerial-vehicle vertical-takeoff-uav)
    PREDATOR1 - (and aerial unmanned-aerial-vehicle)
    global_hawk1 - (and aerial unmanned-aerial-vehicle)
    seal-harbor-dock - (and base-location dock)
    seal-harbor - (and base-location harbor)
    PREDATOR2 - (and aerial unmanned-aerial-vehicle)
    global_hawk2 - (and aerial unmanned-aerial-vehicle)
    blaha-gas-field-epsilon  - gas-field
    lfe_1 lfw_2 lfw_1  - forward-staging-base
    WAL  - terrorist
    jdam5_land_command jdam4_land_command jdam3_land_command jdam2_land_command jdam1_land_command vt-global_hawk1_land_command predator2_land_command predator1_land_command global_hawk2_land_command global_hawk1_land_command  - uav-land-command
    LCS  - base-location
    blaha-bridge-pi  - bridge
    global-hawk predator fire_scout  - vehicle-class
    city1 gula-phi gulu-theta gulu-zeta gulu-rho  - city
    firescout_1_launch_state predator2_launch_state predator1_launch_state global_hawk2_launch_state global_hawk1_launch_state  - uav-launch-state
    lfc_artillery_2 lfc_artillery_1 lfc_aa_2 lfc_aa_1 liberation-force-central liberation-force-east liberation-force-west  - enemy
    jdam5_engage_command jdam4_engage_command jdam3_engage_command jdam2_engage_command jdam1_engage_command vt-global_hawk1_engage_command predator2_engage_command predator1_engage_command global_hawk2_engage_command global_hawk1_engage_command  - uav-engage-command
    optical-imaging11 optical-imaging10 optical-imaging9 optical-imaging8 optical-imaging7 optical-imaging6 optical-imaging5 optical-imaging4 optical-imaging3 optical-imaging2 optical-imaging1  - optical-imaging
    jdam5_take-off_command jdam4_take-off_command jdam3_take-off_command jdam2_take-off_command jdam1_take-off_command vt-global_hawk1_take-off_command predator2_take-off_command predator1_take-off_command global_hawk2_take-off_command global_hawk1_take-off_command  - uav-take-off-command
    gulu blaha  - civil-state
    zambezi-river  - river
    sas_2 sas_1  - synthetic-aperture-sonar
    LCS1  - ship
    blaha-oilf-field-nu  - oil-field
    us3_2s us3_1s sonar3 sonar2 sonar1  - sonar
    jdam5_travel-to_command jdam4_travel-to_command jdam3_travel-to_command vt-global_hawk1_travel-to_command jdam2_travel-to_command jdam1_travel-to_command predator2_travel-to_command predator1_travel-to_command global_hawk2_travel-to_command global_hawk1_travel-to_command  - uav-travel-to-command
    shoreline1  - shoreline
    desert4  - desert
    blaha-chemical-plant-omega  - chemical-plant
    weapon3 weapon2 weapon1  - weapon
    blaha-complex-rex  - industrial-complex
    pana  - nation
    hill224  - hill
    infra-red4 infra-red3 infra-red2 infra-red1  - infra-red
    blaha-power-plant-alpha  - power-plant
    landed launched  - uav-launch-state-enumeration
    blaha-harbor-gamma blaha-harbor-delta gamma delta  - harbor

   )
   (:init
    (has-observation-range firescout_1 close-up)
    (has-sensor firescout_1 optical-imaging2)
    (flight-state firescout_1 on-ground)
    (has-telemetry firescout_1 firescout_1_launch_state)
    (has-command firescout_1 vt-global_hawk1_travel-to_command)
    (has-command firescout_1 vt-global_hawk1_land_command)
    (has-command firescout_1 vt-global_hawk1_take-off_command)
    (on-ship firescout_1 lcs1)
    (has-vehicle-class firescout_1 fire_scout)
    (has-observation-range global_hawk2 medium-distance)
    (has-sensor global_hawk2 infra-red2)
    (flight-state global_hawk2 on-ground)
    (has-telemetry global_hawk2 global_hawk2_launch_state)
    (has-command global_hawk2 global_hawk2_travel-to_command)
    (has-command global_hawk2 global_hawk2_land_command)
    (has-command global_hawk2 global_hawk2_take-off_command)
    (located global_hawk2 seal-harbor-dock)
    (has-observation-range PREDATOR2 medium-distance)
    (has-sensor PREDATOR2 optical-imaging4)
    (has-sensor PREDATOR2 infra-red3)
    (has-weapon PREDATOR2 weapon1)
    (flight-state PREDATOR2 on-ground)
    (has-telemetry PREDATOR2 predator2_launch_state)
    (has-command PREDATOR2 predator2_travel-to_command)
    (has-command PREDATOR2 predator2_engage_command)
    (has-command PREDATOR2 predator2_land_command)
    (has-command PREDATOR2 predator2_take-off_command)
    (located PREDATOR2 seal-harbor-dock)
    (has-observation-range global_hawk1 long-distance)
    (has-sensor global_hawk1 optical-imaging1)
    (has-sensor global_hawk1 infra-red1)
    (flight-state global_hawk1 on-ground)
    (has-telemetry global_hawk1 global_hawk1_launch_state)
    (has-command global_hawk1 global_hawk1_travel-to_command)
    (has-command global_hawk1 global_hawk1_land_command)
    (has-command global_hawk1 global_hawk1_take-off_command)
    (located global_hawk1 seal-harbor-dock)
    (has-observation-range PREDATOR1 medium-distance)
    (has-weapon PREDATOR1 weapon3)
    (has-sensor PREDATOR1 optical-imaging3)
    (flight-state PREDATOR1 on-ground)
    (has-telemetry PREDATOR1 predator1_launch_state)
    (has-command PREDATOR1 predator1_travel-to_command)
    (has-command PREDATOR1 predator1_engage_command)
    (has-command PREDATOR1 predator1_land_command)
    (has-command PREDATOR1 predator1_take-off_command)
    (located PREDATOR1 seal-harbor-dock)
    (located LCS1 seal-harbor)
   )
)