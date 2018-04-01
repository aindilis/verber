(in-package :ap)

(define (domain nasa2i)
  (:comment "nasa2i Ontology")
  (:extends base ISS-base)
  (:requirements :domain-axioms :multi-agent :durative-actions)
  (:types
     luminaire__ceta_light camera__light_&_ptu_assembly_[clpa] - light
     linear_drive_unit_[ldu] - motor
     coolant-pump - pump
     pump&-control-valve-package internal-coolant-pump - coolant-pump
     itcs-configuration - configuration
     eva-task-set eva-task - crew-activity-type
     cover vent_tool_extension_assembly vent_tool_extension_connector_plug_assy power_data_grapple_fixture power_data_grapple_fixture_[pdgf] power_data_grapple_fixture_[pdgf]_51618-0000-1 plasma_contactor_unit plasma_contactor_unit_r078480-11 fish-stringer multi-use-tether-end-effector modified_active_coupler_[ceta_cart] mobile-transporter-stop gap-spanner fluid-jumper worksite-inter-face tool-stanchion adapter plug scoop handle power-cable power-grip-tool space-positioning-device wrench - equipment
     stanchion-mount-cover thermal-cover - cover
     s0_mt_stop s0_mt_stop_1f76452-1 p1_mt_stop mt_stop - mobile-transporter-stop
     ground_installed_gap_spanners orbit_installed_gap_spanner_[21-30-in] orbit_installed_gap_spanner_[18-21-in] orbit_installed_gap_spanner_[30-45-in] orbit_installed_gap_spanner_[45-72-in] - gap-spanner
     _25_in_p1_s1_fluid_jumper_assy_to_p3_s3 - fluid-jumper
     oiwif_socket_assy_[installable_wif] - worksite-inter-face
     portable_foot_restraint_workstation_stanchion_[pfrws] pfr_workstation_stanchion_assy - tool-stanchion
     worksite-inter-face-adapter ssu_shunt_plug_adapter - adapter
     high_strength_passive_wif_adapter passive_wif_adapter_assy passive_wif_adapter_assy_[wif_socket_adapter] - worksite-inter-face-adapter
     ssu_shunt_plug - plug
     micro_scoop__ohts_[square_scoop] mcf_scoop__ohts_[round_scoop] - scoop
     common_d-handle__ohts - handle
     usos_mlm_power_cables_channel_1_4 usos_mlm_power_cables_channel_2_3 - power-cable
     pgt-with-torque-break-setting pgt-with-turn-setting - power-grip-tool
     wrench__7_16-inch_ratcheting_box_end - wrench
     control-panel-assembly crew_&_equipment_translation_aid_[ceta] crew_&_equipment_translation_aid[ceta] luminaire__ceta_light mount
     cargo-transport-container trailing-umbilical-system-assembly utility-transfer-assembly oru_temporary_stow_device grapple-systems
     tether swing_arm_assembly sequential-shunt-unit brake-handle-assembly oru_tool_platform_[otp]
     articulating-portable-foot-restraint floating_potential_measurement_unit floating_potential_measurement_unit_[fpmu] cover hatch
     coolant-pump coolant-loop tcs-object battery_charge_discharge_unit_[bcdu] direct_current_switching_unit_assy
     dc-to-dc-converter-unit main-bus-switching-unit bcdu&dcsu&mbsu remote-power-controller-module trundle-bearing-assembly
     drive-lock-assembly remote-power-controller remote-bus-isolator solar-array-wing beta-gimbal-assembly
     solar-array-rotating-joint multiplexer-de-multiplexer antenna-assembly gyro receiver-processor
     iss-robot robot-arm joint latching-end-effector camera
     air-revitalization-object - station-object
     ddcu-mount mdm-mount rpcm-mount - mount
     cargo_transport_container_2 cargo_transport_container_3 cargo_transport_container_5 - cargo-transport-container
     reel_assembly_-_trailing_umbilical_system mt_tus_interface_umbilical_assy mt_tus_interface_umbilical_assy_1f42993-503 - trailing-umbilical-system-assembly
     utility_transfer_assembly_oru_assy utility_transfer_assembly_[uta] - utility-transfer-assembly
     fixed_grapple_bar adjustable_grapple_assembly - grapple-systems
     safety-tether long_duration_tie_down_tethers oru_tether_assy adjustable_equipment_tether - tether
     safety_tether_-307 85-ft_safety_tether_assembly - safety-tether
     sequential_shunt_unit sequential_shunt_unit_re1806-02 sequential_shunt_unit_re1806-03 - sequential-shunt-unit
     brake_handle_assembly brake_handle_assembly_seg33107081-301 brake_handle_assembly_seg33107081-305 - brake-handle-assembly
     articulating_portable_foot_restraint interoperable_apfr - articulating-portable-foot-restraint
     stanchion-mount-cover thermal-cover - cover
     pump&-control-valve-package internal-coolant-pump - coolant-pump
     external-coolant-loop internal-coolant-loop - coolant-loop
     medium-temperature-loop low-temperature-loop - internal-coolant-loop
     internal-thermal-control-system gas-tanks&-assemblies heat-exchanger cold-plate pump&-flow-control-sub-assembly pump-module-assembly radiator-assembly radiator flex-hose-rotary-coupler thermal-radiator-rotary-joint - tcs-object
     ammonia_tank_assembly high_pressure_gas_tank high_pressure_gas_tank_[hpgt] high_pressure_n2_tank high_pressure_o2_tank
     nitrogen_tank_assembly - gas-tanks&-assemblies
     heat_exchanger__high_load__0-25_kw_[14-k-w] heat_exchanger__low_load high_load_heat_exchanger - heat-exchanger
     coldplate_assembly__ddcu coldplate_assembly__mbsu coldplate_assy__ddcu - cold-plate
     pump_&_flow_control_subassembly pump_&_flow_control_subassembly_[eeatcs] pump_&_flow_control_subassembly_[pfcs] pump_&_flow_control_subassembly_[pfcs]_re3310-03 pump_&_flow_control_subassembly_[pfcs]_re3310-04
     pump_&_flow_control_subassembly_[pfcs]_re2814-06 pump_&_flow_control_subassembly_[pfcs]_re2814-08 - pump&-flow-control-sub-assembly
     pump_module_assembly pump_module_assembly_1f96100-1 - pump-module-assembly
     heat_rejection_subsystem_radiator - radiator
     flex_hose_rotary_coupler_[fhrc] flex_hose_rotary_coupler_[fhrc]_5839202-501 - flex-hose-rotary-coupler
     thermal_radiator_rotary_joint_[trrj]_complete_assy - thermal-radiator-rotary-joint
     dc_dc_converter_unit_external_[ddcu-e] dc_dc_converter_unit_internal - dc-to-dc-converter-unit
     main_bus_switching_unit_[mbsu] - main-bus-switching-unit
     battery_charge_discharge_unit_[bcdu] main-bus-switching-unit direct_current_switching_unit_assy - bcdu&dcsu&mbsu
     main_bus_switching_unit_[mbsu] - main-bus-switching-unit
     cdn_remote_power_control_module_[crpcm] rpc_module_type_ii rpc_module_type_iii rpc_module_type_iii_r077418-51 rpc_module_type_iv rpc_module_type_iv_r072702-81 rpc_module_type_v rpc_module_type_vi rpc_module_type_vi_r077420-31 - remote-power-controller-module
     trundle_bearing_assembly trundle_bearing_assembly_5846485-501 - trundle-bearing-assembly
     drive_lock_assembly_[dla]_-_sarj drive_lock_assembly_[dla]_-_sarj_684-014007-0003 - drive-lock-assembly
     wing__solar_array__photovoltaic - solar-array-wing
     solar_array_wing__beta_gimbal solar_array_wing__beta_gimbal_r075800-41 solar_array_wing__beta_gimbal_r075800-61 solar_array_wing__beta_gimbal_r075800-81 - beta-gimbal-assembly
     essmdm_external_-910 mdm-10e_external mdm-10e_external mdm-10_external_-925 mdm-4e_external_-909 mdm-4e_external_-910 mdm-4e_external_-927 mdm-4e_external_-928 mdm-4e_external_-929 mdm_assembly__lower_[pvcu] mdm_assembly__upper_[pvcu] pvcu-1a_mdm_[upper]_w__bracket pvcu-1b_mdm_[upper]_w__bracket pvcu-2a_mdm_[upper]_w__bracket pvcu-3b_mdm_[lower]_w__bracket radiator_oru__nadir_[mdm] radiator_oru__zenith_[mdm] radiator_oru__[mdm] command&-control-mdm internal-mdm gnc_mdm node1_mdm node3hcz_mdm - multiplexer-de-multiplexer
     gps_antenna_assembly gps_antenna_assembly_seg20100155-315 gps_antenna_assy - antenna-assembly
     rate-gyro control-moment-gyro - gyro
     rate_gyro_assembly - rate-gyro
     control_moment_gyro control_moment_gyro_[cmg] control_moment_gyro_[cmg]_7080105-9 - control-moment-gyro
     gps-receiver-processor - receiver-processor
     spdm_arm arm_oru_[spdm] - robot-arm
     joint_[yaw]_[ssrms] joint_[roll_pitch]_[ssrms] - joint
     latching_end_effector_[lee]_poa latching_end_effector_[lee]_[spdm] latching_end_effector_[lee] - latching-end-effector
     camera__light_&_ptu_assembly_[clpa] luminaire__video_camera luminaire__video_camera_a05a0298-1 video_camera_unit_k?-154 color_television_camera_[ctvc]
     color_television_camera_[ctvc]_10033497-1 ext_tv_camera_group_[etvcg] - camera
     carbon-dioxide-removal-system cdrs-heater cdrs-water-pump smoke-detector cdrs-gas-valve - air-revitalization-object
     iss-control-bus - control-bus
     cargo-transport-container reel_assembly_-_trailing_umbilical_system sequential-shunt-unit utility-transfer-assembly gas-tanks&-assemblies heat-exchanger pump-module-assembly radiator flex-hose-rotary-coupler pump&-flow-control-sub-assembly thermal-radiator-rotary-joint battery_charge_discharge_unit_[bcdu] direct_current_switching_unit_assy
     dc-to-dc-converter-unit main-bus-switching-unit remote-power-controller-module solar-array-wing multiplexer-de-multiplexer antenna-assembly 
     gyro gps-receiver-processor joint camera camera__light_&_ptu_assembly_[clpa] - orbital-replacement-unit
     cargo_transport_container_2 cargo_transport_container_3 cargo_transport_container_5 - cargo-transport-container
     sequential_shunt_unit sequential_shunt_unit_re1806-02 sequential_shunt_unit_re1806-03 - sequential-shunt-unit
     utility_transfer_assembly_oru_assy utility_transfer_assembly_[uta] - utility-transfer-assembly
     ammonia_tank_assembly high_pressure_gas_tank high_pressure_gas_tank_[hpgt] high_pressure_n2_tank high_pressure_o2_tank
     nitrogen_tank_assembly - gas-tanks&-assemblies
     heat_exchanger__high_load__0-25_kw_[14-k-w] heat_exchanger__low_load high_load_heat_exchanger - heat-exchanger
     pump_module_assembly pump_module_assembly_1f96100-1 - pump-module-assembly
     heat_rejection_subsystem_radiator - radiator
     flex_hose_rotary_coupler_[fhrc] flex_hose_rotary_coupler_[fhrc]_5839202-501 - flex-hose-rotary-coupler
     pump_&_flow_control_subassembly pump_&_flow_control_subassembly_[eeatcs] pump_&_flow_control_subassembly_[pfcs] pump_&_flow_control_subassembly_[pfcs]_re3310-03 pump_&_flow_control_subassembly_[pfcs]_re3310-04
     pump_&_flow_control_subassembly_[pfcs]_re2814-06 pump_&_flow_control_subassembly_[pfcs]_re2814-08 - pump&-flow-control-sub-assembly
     thermal_radiator_rotary_joint_[trrj]_complete_assy - thermal-radiator-rotary-joint
     dc_dc_converter_unit_external_[ddcu-e] dc_dc_converter_unit_internal - dc-to-dc-converter-unit
     main_bus_switching_unit_[mbsu] - main-bus-switching-unit
     cdn_remote_power_control_module_[crpcm] rpc_module_type_ii rpc_module_type_iii rpc_module_type_iii_r077418-51 rpc_module_type_iv rpc_module_type_iv_r072702-81 rpc_module_type_v rpc_module_type_vi rpc_module_type_vi_r077420-31 - remote-power-controller-module
     wing__solar_array__photovoltaic - solar-array-wing
     essmdm_external_-910 mdm-10e_external mdm-10e_external mdm-10_external_-925 mdm-4e_external_-909 mdm-4e_external_-910 mdm-4e_external_-927 mdm-4e_external_-928 mdm-4e_external_-929 mdm_assembly__lower_[pvcu] mdm_assembly__upper_[pvcu] pvcu-1a_mdm_[upper]_w__bracket pvcu-1b_mdm_[upper]_w__bracket pvcu-2a_mdm_[upper]_w__bracket pvcu-3b_mdm_[lower]_w__bracket radiator_oru__nadir_[mdm] radiator_oru__zenith_[mdm] radiator_oru__[mdm] command&-control-mdm internal-mdm gnc_mdm node1_mdm node3hcz_mdm - multiplexer-de-multiplexer
     gps_antenna_assembly gps_antenna_assembly_seg20100155-315 gps_antenna_assy - antenna-assembly
     rate-gyro control-moment-gyro - gyro
     rate_gyro_assembly - rate-gyro
     control_moment_gyro control_moment_gyro_[cmg] control_moment_gyro_[cmg]_7080105-9 - control-moment-gyro
     joint_[yaw]_[ssrms] joint_[roll_pitch]_[ssrms] - joint
     camera__light_&_ptu_assembly_[clpa] luminaire__video_camera luminaire__video_camera_a05a0298-1 video_camera_unit_k?-154 color_television_camera_[ctvc]
     color_television_camera_[ctvc]_10033497-1 ext_tv_camera_group_[etvcg] - camera
     external-stowage-platform ex-press-logistics-carrier - stowage-structures
     iss-robot - robot
     mobile_base_system_[mbs] - vehicle
     oru-bag equipment-bag tool-box safety-tether-pack - container
     large-oru-bag medium-oru-bag small-oru-bag - oru-bag
     vent_tool_extension_bag_assy fluid_qd_toolbag ohts_tool_bag 96_bolt_tool_bag node_tool_bag
     crew-lock-bag - equipment-bag
     tool_box-a_l eva_tool_storage_device_[etsd]_[stbd] eva_tool_storage_device_[etsd]_[port] - tool-box
     tcs-role dcsu-role ddcu-role rpcm-role saw-role mbsu-role bcdu-role sarj-role mdm_oru-role cmg-role rga-role gps-role clpa-role - oru-role
     multiplexer-de-multiplexer - iss-computer
     essmdm_external_-910 mdm-10e_external mdm-10e_external mdm-10_external_-925 mdm-4e_external_-909 mdm-4e_external_-910 mdm-4e_external_-927 mdm-4e_external_-928 mdm-4e_external_-929 mdm_assembly__lower_[pvcu] mdm_assembly__upper_[pvcu] pvcu-1a_mdm_[upper]_w__bracket pvcu-1b_mdm_[upper]_w__bracket pvcu-2a_mdm_[upper]_w__bracket pvcu-3b_mdm_[lower]_w__bracket radiator_oru__nadir_[mdm] radiator_oru__zenith_[mdm] radiator_oru__[mdm] command&-control-mdm internal-mdm gnc_mdm node1_mdm node3hcz_mdm - multiplexer-de-multiplexer
     prox_gps_antenna wal_ait-to-air_antenna sgant_[ku_band_antenna] s-band_antenna_&_support_assembly_[sasa] ap-2ap-bka_antenna antenna_assy__uhf ewis_antenna_1f15530-511 ewis_antenna_1f15530-513 ewis_antenna_1f15530-515 ewis_antenna_1f15530-517 ewis_antenna_1f15530-503 ewis_antenna_1f15530-505 ewis_antenna_1f15530-507 ewis_antenna_1f15530-509 ewis_antenna_1f15530-501 ewis_antenna_1f15530-1 ewis_antenna_1f15530-521 ewis_antenna external_wireless_communications_antenna external_wireless_communications_antenna_684-015274-0001 - antenna
     mdm-role - role
     ddcu-state rpcm-state rpc-state mdm-state cdrs-water-pump-state cdrs-state cdrs-heater-state cdrs_day-night-state - state
     iss-power-channel - power-channel
     eva-task-object - abstract-entity
     nh3_vent_tool 1_5_inch_qd_release_tool_and_fid_gauge power-grip-tool - tool
     pgt-with-torque-break-setting pgt-with-turn-setting - power-grip-tool
     crew_&_equipment_translation_aid_[ceta] crew_&_equipment_translation_aid[ceta] mobile_base_system_[mbs] - transport
     alpha_magnetic_spectrometer extravehicular_external_charged_particle_directional_spectrometer - sensor
     coolant - liquid
   )
  (:functions
	(cover-state ?c - cover) - state
	(hatch-state ?h - hatch) - state
	(tethered_to ?t - tether) - agent
	(installed-state ?so - station-object) - boolean-value
	(has-operator ?ir - iss-robot) - agent
	)
(:predicates
    (bag-size-for ?so - station-object ?ob - oru-bag)
    ;;(tethered_to ?t - tether ?a - agent)
    ;;(installed-state ?so - station-object ?bv - boolean-value)
    ;;(cover-state ?c - cover ?s - state)
    ;;(hatch-state ?h - hatch ?s - state)
    (tethered-for-egress ?c - crew ?st - safety-tether)
    (untethered-for-ingress ?c - crew ?st - safety-tether)
    (tether-swapped ?c - crew ?st - safety-tether)
    (scoop-installed ?s - scoop ?so - station-object)
    (has-itcs-configuration ?itcs - internal-thermal-control-system ?ic - itcs-configuration)
    (radiates-through ?ecl - external-coolant-loop ?ra - radiator-assembly)
    (has-coolant ?ecl - external-coolant-loop ?c - coolant)
    (has-fluid-connection-to ?to - tcs-object ?to1 - tcs-object)
    (has-cold-side ?he - heat-exchanger ?cl - coolant-loop)
    (has-hot-side ?he - heat-exchanger ?cl - coolant-loop)
    (has-pump ?cl - coolant-loop ?p - pump)
    (has-ddcu ?ipc - iss-power-channel ?dtdcu - dc-to-dc-converter-unit)
    (ddcu-in-power-channel ?dtdcu - dc-to-dc-converter-unit ?ipc - iss-power-channel)
    (has-rpcm ?ipc - iss-power-channel ?rpcm - remote-power-controller-module)
    (rpcm-in-power-channel ?rpcm - remote-power-controller-module ?ipc - iss-power-channel)
    (has-rpc ?ipc - iss-power-channel ?rpc - remote-power-controller)
    (rpc-in-power-channel ?rpc - remote-power-controller ?ipc - iss-power-channel)
    (has-rpc-state ?rpc - remote-power-controller ?rs - rpc-state)
    ;;(has-position ?rpc - remote-power-controller ?rpe - rpc-position-enumeration)
    (has-eps-connection ?rbi - remote-bus-isolator ?rbi1 - remote-bus-isolator)
    (has-ddcu-connection ?rbi - remote-bus-isolator ?dtdcu - dc-to-dc-converter-unit)
    (has-mbsu-connection ?rbi - remote-bus-isolator ?mbsu - main-bus-switching-unit)
    (has-dcsu-connection ?rbi - remote-bus-isolator ?d - direct_current_switching_unit_assy)
    (has-rbi ?b - bcdu&dcsu&mbsu ?rbi - remote-bus-isolator)
    (is-rbi-for ?rbi - remote-bus-isolator ?b - bcdu&dcsu&mbsu)
    (has-mdm-role ?mdm - multiplexer-de-multiplexer ?mr - mdm-role)
    (has-mdm ?icb - iss-control-bus ?mdm - multiplexer-de-multiplexer)
    (is-mdm-for ?mdm - multiplexer-de-multiplexer ?icb - iss-control-bus)
    ;;(has-operator ?ir - iss-robot ?a - agent)
    (is-operator-for ?a - agent ?ir - iss-robot)
    (can-reach ?t - transport ?il - iss-location)
    (beginning-role ?eto - eva-task-object ?or - oru-role)
    (end-role ?eto - eva-task-object ?or - oru-role)
    (from-location ?eto - eva-task-object ?il - iss-location)
    (to-location ?eto - eva-task-object ?il - iss-location)
    (affected-object ?eto - eva-task-object ?pe - physical-entity)
    (has-task-object ?et - eva-task ?eto - eva-task-object)
    (has-eva-task ?ets - eva-task-set ?et - eva-task)

  )
  (:axiom
   :vars (?t - tether
          ?a - agent)
   :context (and 
             (tethered_to ?t ?a)
             (not (= ?a nobody)))
   :implies  (is-available ?t no)
   )
  (:axiom
   :vars (?t - tether
          ?a - agent)
   :context (and 
             (tethered_to ?t ?a)
             (= ?a nobody))
   :implies  (is-available ?t yes)
   )
  (:axiom
   :vars (?a - agent
          ?l - iss-location)
   :context (and 
             (has-iss-location ?a ?l)
             (= ?l intra-vehicle))
   :implies  (has-schematic-location ?a quest)
   )
  (:axiom
   :vars (?t - eva-task-object
          ?p - physical-entity
          ?l - iss-location)
   :context (and 
             (affected-object ?t ?p)
             (has-iss-location ?p ?l))
   :implies  (from-location ?t ?l)
   )
  (:axiom
   :vars (?t - eva-task-object
          ?p - physical-entity
          ?r - oru-role)
   :context (and 
             (affected-object ?t ?p)
             (has-oru-role ?p ?r))
   :implies  (beginning-role ?t ?r)
   )
  #|(:axiom
   :vars (?t - eva-task-object
          ?p - physical-entity)
   :context (and 
             (affected-object ?t ?p)
	     (has-settings ?t ?r))
   :implies  (beginning-settings ?t ?r)
   )|#
  (:axiom
   :vars (?ipc - iss-power-channel
          ?dtdcu - dc-to-dc-converter-unit)
   :context (has-ddcu ?ipc ?dtdcu)
   :implies (ddcu-in-power-channel ?dtdcu ?ipc)
   )
  (:axiom
   :vars (?ipc - iss-power-channel
          ?rpcm - remote-power-controller-module)
   :context (has-rpcm ?ipc ?rpcm)
   :implies (rpcm-in-power-channel ?rpcm ?ipc)
   )
  (:axiom
   :vars (?ipc - iss-power-channel
          ?rpc - remote-power-controller)
   :context (has-rpc ?ipc ?rpc)
   :implies (rpc-in-power-channel ?rpc ?ipc)
   )
  (:axiom
   :vars (?B - BCDU&DCSU&MBSU
          ?rbi - remote-bus-isolator)
   :context (has-rbi ?B ?rbi)
   :implies (is-rbi-for ?rbi ?B)
   )
  (:axiom
   :vars (?icb - iss-control-bus
          ?mdm - multiplexer-de-multiplexer)
   :context (has-mdm ?icb ?mdm)
   :implies (is-mdm-for ?mdm ?icb)
   )
  (:axiom
   :vars (?ir - iss-robot
          ?a - agent)
   :context (has-operator ?ir ?a)
   :implies (is-operator-for ?a ?ir)
   )
 )
