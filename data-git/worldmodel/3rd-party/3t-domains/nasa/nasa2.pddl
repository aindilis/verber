;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)

(defun petes-debug (plan-root node-number)
  (test-alternative (nth (1- node-number)
			 (plot-subactions plan-root))))

;;; to debug (trace apply-param-tests template+bindings)
;;; print-relation-history print-relation-props is helpful too

;;; changes:
;;;  CE 2/26/2012  moved contaied_by and corresponding axioms to physob.pddl
;;;                commented out (at end (not (possesses ?ev1 ?scoop)))
;;;                  from Extract-ddcu-by-two, Eatract-ddcu because
;;;                  they are logically inconsistent.
;;;                modified assertions of :multi-value to reflect the 
;;;                  ontologization of AP (sounds as ugly as it is)
;;;  CE 10/26/2012 changed types Tangible to Artifact, agent to Agent, and location to Location 
;;;                   to reflect inclusion of event.pddl
;;;                cleand up some axioms for speed
;;;  CE 2/27/2015 added event to :extends. No longer a default

(define (domain nasa-domain)
    (:requirements :multi-agent :durative-actions)
  (:extends physob Geography event)
  (:types body-size state station-object - object
	  station-resource - resource
	  crew flight-controller - Agent
	  cato phalcon adco odin thor - flight-controller
	  truss-segment station-bay bay-face path - object
	  ;;;- station-resource
	  instrument thermal-control-system ammonia-tank-assembly ammonia-tank  safety-tether equipment tool ceta-light  
	  control-panel-assembly ceta-cart special-purpose-dextrous-manipulator
	  ISS-EVA-handrail robotic-arm ammonia-tank-assembly ammonia-tank gas-qds gas-line sarj-cover 
	  activity sarj-surfaces section - station-object
	  internal-tcs external-tcs - thermal-control-system
	  photo-voltaic-tcs - external-tcs
	  power-grip-tool power-grip-tool-with-torque-break-setting square-scoop ratchet-wrench vent-tool - tool
	  safety-tether-pack fish-stringer oru-bag jumper qtr-inch-power-cable space-positioning-device 
	  workplace-interface wif-adapter articulating-portable-foot-restraint cpa-tether-point 
	  oru-bag qtr-inch-power-cable crew-lock-bag dc-to-dc-converter-unit cover multi-use-tether-end-effector 
	  vent-tool-adapter quick-disconnect radiator wipe-set camera grease-gun adjustable-tether 
	  stow-beam stow-beam-part - equipment
	  drager-tube - instrument
	  straight-nozzle-grease-gun j-hook-nozzle-grease-gun - grease-gun
	  fluid-quick-disconnect-jumper gas-quick-disconnect-jumper - jumper
	  pgt-with-torque-break-setting pgt-with-turn-setting - power-grip-tool 
	  stanchion-mount-cover - cover
	  medium-oru-bag vent-tool-equipment-bag - oru-bag
	  rate-gyro-assembly remote-power-controller rpc-string loop-pump water-loop comms-antenna 
	  external-video-switch-unit
	  solar-array-rotating-joint control-moment-gyro multiplexer-demultiplexer remote-bus-isolator - station-object
	  S0-mdm S1-MDM S3-MDM P1-MDM P3-MDM ext-mdm - multiplexer-demultiplexer
	  software-routine - station-object
	  rt-fdir - software-routine
	  sarj-mode rpc-string-mode ata-mode itcs-configuration contamination-status - state
	  shutdown autotrack blind directed-position - sarj-mode
	  cooling-loop heating-loop - water-loop 
	  no-contamination suspected confirmed - contamination-status) ;;; if none exists => none 
  (:constants				; just until Chris can fix the undefined constant problem
   stp2 - safety-tether-pack
   lab jem node1 node2 node3 - section	;  2/27/2012  what problem is that?
   lab-itcs - internal-tcs
   spdm-lee-cla - camera
   cla-cover - cover
   ;;the beam is in two parts
   s1-radiator-stow-beam - stow-beam
   s1-inboard-stow-beam s1-outboard-stow-beam - stow-beam-part
   s1-beam-bag - medium-oru-bag
   ;;Sarj-port - solar-array-rotating-joint  duplicated below CE 3/3/2012
   ssrms - robotic-arm
   spdm-lube - activity
   spdm - special-purpose-dextrous-manipulator
   vent fill - ata-mode
   inner-canted-surfaces datum-a-and-outer-canted-surfaces - sarj-surfaces
   s1-stow-beam-loc nowhere - Location ;; for during effect parsing
   vent-tool1 - vent-tool
   nh3 - gas-qds
   ata1 ata2 - ammonia-tank
   p6-radiator - radiator
   MUT-EE1 MUT-EE2 -  multi-use-tether-end-effector
   nobody - Agent
   p1-p5 - gas-line
   fqd-jumper1 - fluid-quick-disconnect-jumper 
   eas-jumpers nh3-jumper-p3-p4 p1-p5-jumpers - gas-quick-disconnect-jumper
   qd15 qd14 qdf185 - quick-disconnect
   power-cable1 - qtr-inch-power-cable	; just until Chris can fix the undefined constant problem
   ceta-light-bag1 - medium-oru-bag
   fish-stringer1 - fish-stringer
   sally joe bob - crew	;;; just until Chris can fix the undefined constant problem
   CETA-LIGHT1 CETA-LIGHT2 ceta-light3 - ceta-light ;;; just until Chris can fix the undefined constant problem
   THERMAL-COVER HATCH - Artifact
   small medium large - body-size
   open close done locked  - state
   AIRLOCK INTRA-VEHICLE UNKNOWN EXTRA-VEHICLE 
   ddcus01a-loc ssrms-loc1 ceta-cart-loc1 ceta-cart-loc2 
   P6-Z-FACE1 P3-Z-FACE1 p3-p4-juncture p5-p6-juncture p1-ata-panel - location
   ext-MDM1 ext-MDM2 - ext-mdm
   S0-MDM1 S0-MDM2 - S0-mdm
   S1-MDM1 S1-MDM2 - S1-mdm
   S3-MDM1 S3-MDM2 - S3-mdm	      
   P1-MDM1 P1-MDM2 - P1-mdm
   P3-MDM1 P3-MDM2 - P3-mdm	      
   S01A-C&C-MDM S01B-C&C-MDM STR-MDM - multiplexer-demultiplexer
   sarj-port sarj-starboard - solar-array-rotating-joint
   rga1 rga2 - rate-gyro-assembly
   lab-gnc-1-rt lab-gnc-2-rt - rt-fdir
   rpc1 rpc2 rpc3 rpc4 - remote-power-controller
   rpc4-5-6-7 rpc5-6-7-8 sarj-string1 sarj-string2 sarj-string3 sarj-string4 - rpc-string
   cmg1 cmg2 - control-moment-gyro
   ddcuS01B ddcuS01a - dc-to-dc-converter-unit
   shutdown autotrack blind directed-position - sarj-mode
   single-loop dual-loop - itcs-configuration
   monitor commanded checkout normal wait diagnostic off - state
   S01A-rt-fdir S01B-rt-fdir ddcus01a-rt-fdir ddcus01b-rt-fdir - rt-fdir
   LOOP-A LOOP-B - loop-pump
   MTL LTL - cooling-loop
   RBI4 RBI2 - remote-bus-isolator
   s-band-1 s-band-2 - comms-antenna)
  (:predicates 
   (contamination-state ?s - contamination-status)
   (nh3-decon_a)
   (decon-complete_a ?ev - crew)
   (reconfigure-itcs_a ?fc - thor ?itcs - internal-tcs)
   (configuration ?itcs - internal-tcs ?cf - itcs-configuration)
   (complete-spdm-lube_a ?ev - crew ?arm - robotic-arm)
   (spdm-snares-lubed ?ev - crew)(spdm-lube-cleanup_a ?ev - crew ?arm - robotic-arm)
   (item-installed-on ?ev - crew ?o1 ?o2 - object)
   (arm-guided-to ?ev - crew ?arm - robotic-arm)
   (worksite-for - fact ?o - activity ?l - location)(storage-site-for ?o - object ?l - location)
   (ready-for-spdm-lube ?ev - crew  ?t - (or robotic-arm ceta-cart))
   (fetched ?ev - crew ?item - station-object)
   (fetched-to ?ev - crew ?o - object ?l - location)(returned-to ?ev - crew ?o - object ?l - location)
   (configure_ata_a ?ev - crew ?s - state)
   (ata-configuration ?s - state)
   (full-lube-done ?ev - crew ?sarj - solar-array-rotating-joint)
   (cover-for-cover-set ?sarj -  solar-array-rotating-joint ?set - number ?c - sarj-cover)
   (lube-cover-set2_a ?ev - crew ?sarj - solar-array-rotating-joint ?n - number)
   (lube-cover-set_a ?ev - crew ?sarj - solar-array-rotating-joint ?n - number)
   (lube-covers-by-two2_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (lube-covers-by-two_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (lube-covers2_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (lube-covers_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (surfaces-lubed ?s - solar-array-rotating-joint ?s - sarj-surfaces)
   (surfaces-lubed2 ?s - solar-array-rotating-joint ?s - sarj-surfaces)
   (lube-surfaces2_a ?ev - crew ?sarj - solar-array-rotating-joint ?s - sarj-surfaces)
   (lube-surfaces_a ?ev - crew ?sarj - solar-array-rotating-joint ?s - sarj-surfaces)
   (covers-lubed ?s - solar-array-rotating-joint)
   (covers-lubed2 ?s - solar-array-rotating-joint)
   (inspected ?c - crew ?o - station-object)(lubed ?c - crew ?cov - sarj-cover ?surface - sarj-surfaces)
   (lubed2 ?c - crew ?cov - sarj-cover ?surface - sarj-surfaces)
   (covers-removed ?s - solar-array-rotating-joint)(covers-installed ?s - solar-array-rotating-joint)
   (install-cover-set_a ?ev - crew ?sarj - solar-array-rotating-joint ?cover-set-num - number)
   (install-covers-by-two_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (install-covers_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (remove-cover-set_a ?ev - crew ?sarj - solar-array-rotating-joint ?num - number)
   (remove-covers-by-two_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (remove-covers_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (removed ?c - crew ?o - station-object)
   (secured ?c - station-object ?t - adjustable-tether)(cover-for ?s - solar-array-rotating-joint ?c - sarj-cover )
   (lube-location - fact ?sarj - solar-array-rotating-joint ?loc - location)
   (sarj-lube-setup_a ?ev - crew ?sarj - solar-array-rotating-joint)
   (lube-setup-for ?ev - crew ?sarj - solar-array-rotating-joint)
   (grease-guns-ready-at ?s - solar-array-rotating-joint)
   (adjustable-tethers-ready-at ?psarj - solar-array-rotating-joint)
   (wipes-ready-at ?psarj - solar-array-rotating-joint)
   (retrieve-and-stow ?ev - crew ?item - station-object)
   (moved ?item - station-object ?start-loc ?end-loc - location)
   (p6-lines-vented ?c - crew ?r - radiator)(vented ?ev - crew  ?j - (or jumper gas-line))
   (close-ata-tank_a ?fc - thor ?ata - ammonia-tank)
   (open-ata-tank_a ?fc - thor ?ata - ammonia-tank)(nh3-reroute&rad-fill_a ?ev - crew)
   (check-for-leaks_a ?c - crew)
   (radiator-filled ?ev - crew ?r - radiator)(p6-radiator-filled ?evp3 - crew ?r - radiator)
   (rerouted ?evp3 - crew ?j - jumper)(final-qds-opened ?evp3 - crew ?q - gas-qds)
   (configured-for-fill ?0 - (or ammonia-tank photo-voltaic-tcs))
   (crew-setup-vt2_a ?c - crew ?vent-tool - vent-tool)
   (vent-tool-clean-up_a ?ev - crew ?vt - vent-tool)
   (vent-tool-setup_a ?ev - crew ?vt - vent-tool)(crew-setup-vt_a ?vent-tool - vent-tool)
   (assembled ?c - crew ?o - vent-tool)(mated ?vt - vent-tool ?vt-adapter - vent-tool-adapter)
   (disassembled ?c - crew ?o - vent-tool)
   (rotated_a ?fc - phalcon ?sarj  - solar-array-rotating-joint ?angle - int)
   (lock_sarj_a ?fc - phalcon ?sarj - solar-array-rotating-joint)
   (lock_sarj100_a ?fc - phalcon ?sarj - solar-array-rotating-joint)
   (recover-to-mode_a ?fc - phalcon ?sarj - solar-array-rotating-joint)
   (previous-sarj-mode ?sarj - solar-array-rotating-joint ?mode - sarj-mode)
   (angle ?sarj - solar-array-rotating-joint ?angle - int)
   (tether-swapped ?ev - crew ?st - safety-tether)
   (too-far - fact ?path - path)
   (intermediate-loc-for - fact ?path - path ?loc - location)
   ;;(contained_by ?o ?t - object)
   (can-reach ?arm - robotic-arm ?l - location)
   (ssrms-trans ?ev - crew ?l - location)
   (installed-on ?o1 ?o2 - object)
   (installed-item-in-place ?ev - crew ?item - station-object)
   (inserted-item ?ev - crew ?ddcu - dc-to-dc-converter-unit)
   (put-away ?ev - crew ?item - station-object)
   (extract_item_to_bag_a ?ev - crew ?item - station-object ?container - oru-bag) ;; used with PRIDE demo
   (translate_by_handrail_a ?l - location ?c - crew)
   (pick_up_a ?item - station-object ?c - crew)
   (extracted-item-to ?ev - crew ?item - station-object ?container - oru-bag)
   (stow-internal_a ?outside-ev - crew ?item - station-object)
   (stow-external_a ?outside-ev - crew ?item - station-object)
   (install-scoop_a ?ev - crew ?scoop - square-scoop ?ddcu - dc-to-dc-converter-unit)
   (Install-scoop-from-container_a ?ev - crew ?scoop - square-scoop ?ddcu - dc-to-dc-converter-unit)
   (position-item-test ?item - station-object ?loc - location) ;;; test
   (position-item_a ?ev - crew ?item - station-object ?loc - location)
   (did-ddcu ?ev1 ?ev2 - crew ?ddcu - dc-to-dc-converter-unit)
   (did-ddcu1 ?ev1 - crew ?ddcu - dc-to-dc-converter-unit)
   (did-ddcu2 ?ddcu - dc-to-dc-converter-unit)
   (remove&replace_a ?ev1 - crew ?ddcu - dc-to-dc-converter-unit)
   (replaced ?ev1 - crew ?ddcu - dc-to-dc-converter-unit)
   (ddcu-changed-out ?ddcu - dc-to-dc-converter-unit) ;;; test
   (ddcu-replaced ?ev1 ?ev2 - crew ?ddcu - dc-to-dc-converter-unit)
   (ddcu-replaced2 ?ddcu - dc-to-dc-converter-unit)
   (inserted ?item - dc-to-dc-converter-unit ?l - location)
   (ddcu-extracted ?d - dc-to-dc-converter-unit)(ddcu-extracted2 ?d - dc-to-dc-converter-unit) ;;;test
   (take-ddcu-off-cover_a ?c - crew ?d - dc-to-dc-converter-unit ?cover - stanchion-mount-cover)
   (put-cover-on-ddcu_a ?c - crew ?d - dc-to-dc-converter-unit ?cover - stanchion-mount-cover)
   (put-on-cover-test ?ddcu - dc-to-dc-converter-unit) ;;; test
   (take-off-cover-test ?ddcu - dc-to-dc-converter-unit) ;;; test
   (present-item_a ?ev - crew ?i - station-object)
   (Attach-to-cover_a ?ev - crew ?i - station-object ?c - cover)
   (remove-from-cover_a ?ev - crew ?i - station-object ?c - cover)
   (site-prepped-for-r&r ?ev - crew ?ddcu - dc-to-dc-converter-unit)
   (site-prep-tested ?ddcu - dc-to-dc-converter-unit)
   (retrieve-install-item_a ?ev - crew ?item - station-object)
   (crew-did-reroute ?outside-agent - crew)
   (crew-did-jobs ?outside-agent - crew)(crew-did-jobs2 ?outside-agent - crew)
   (retrieve-item_a ?ev - crew ?item - station-object)
   (transport-loaded ?transport - (or robotic-arm ceta-cart)) ;;;test
   (on ?ev - Agent ?transport - (or robotic-arm ceta-cart))
   (installed ?o - station-object)(installed-item ?ev - crew ?item - station-object)
   (install-item_a ?ev - crew ?item - (and station-object
					   (not articulating-portable-foot-restraint)))
   (crew-traveled-to ?l - location) ;;; test
   (crew-moved-to ?l - location)
   (prepare-for-eva_a ?c - crew)
   (assist-done ?l - location) ;;; test
   (safety-tether-for-egress_a ?ev1 - crew ?st - safety-tether)
   (egress-by-two_a ?ev2 - crew ?st - safety-tether)
   (Delay-action_a ?c - crew)
   (Delay10_a ?t - state)
   ;;;(waited ?t - (int 0 10000))
   ;;;(closed ?ev - crew ?o - station-object)
   (operator ?arm - robotic-arm ?iv - crew)
   (ingressed ?c - crew ?o - (or robotic-arm ceta-cart articulating-portable-foot-restraint))
   (egressed ?c - crew ?o - (or robotic-arm ceta-cart articulating-portable-foot-restraint))
   (ingress-arm_a ?c - crew ?r - robotic-arm ?a - articulating-portable-foot-restraint)
   (crew-outside ?inside-agent ?outside-agent - crew)
   (crew-inside ?inside-agent ?outside-agent - crew)
   (all-jobs ?s - state)(all-jobs2 ?s - state)(agent-egress&do-test ?s - state)
   (item-extracted ?item - (or station-object articulating-portable-foot-restraint))
   (item-picked ?item - (or station-object articulating-portable-foot-restraint))
   (location-for - fact ?i - station-object ?l - location)
   (needs-bag - fact ?o - station-object) ;; fact => it never changes
   (prepare-for-repress_a ?c - crew)
   (bag-size-for - fact ?item - station-object ?b - oru-bag)
   (stow_a ?ev - crew ?item - station-object)
   (hand-over_a ?inside-ev - crew ?item - station-object)
   (untether-for-ingress_a ?ev1 - crew ?st - safety-tether)
   (ingress-by-two_a ?ev2 - crew ?st - safety-tether)
   (available - predicate ?r - station-object)
   (open - predicate ?o - object)(locked - predicate ?o - object)
   (stowed ?ev1 ?ev2)(two-stowed-nh3 ?ev1 ?ev2 - crew)
   (close ?ev - crew ?o - object)
   (make-open ?ev - crew ?o - object)
   (tethered_to  ?st - safety-tether ?agent - Agent)
   (one-crew ?p - location) ;;; test
   (o2-use-rate - fact ?c - crew ?rate - float)
   (body-size - fact ?c - crew ?s - body-size)
   (two-out ?s - state)	;;;test
   (two-in ?s - state) ;;;test
   (crew-and-tools ?loc - location)(crew-and-tools2 ?loc - location)
   (jobs-done ?c1 ?c2 - crew)
   (tool-for - fact ?o - station-object ?t - station-object)
   (segment - fact ?loc - location ?seg - truss-segment)
   (bay - fact ?loc - location ?bay - station-bay)
   (face - fact ?loc - location ?face - bay-face)
   (start-loc - fact ?path - path ?loc - location)
   (end-loc - fact ?path - path ?loc - location)
   (Auto-route-video_a ?fc - cato ?evsu - external-video-switch-unit)
   (Auto-route-test_a ?fc - cato ?ddci - dc-to-dc-converter-unit) ;; just for testing
   (ddcu-r&r-done ?d - dc-to-dc-converter-unit);; for auto gen tasks
   (Activate-ceta-lights_a ?fc - phalcon)
   (S-band-swap_a ?fc - cato ?ddcu - dc-to-dc-converter-unit)
   (current-sband ?s - comms-antenna)(alternate-sband ?s - comms-antenna)
   (sband-for ?d - dc-to-dc-converter-unit ?a - comms-antenna)
   (full-shutdown ?phalcon - phalcon ?ddcu - dc-to-dc-converter-unit)
   (Delay24hrs_a ?s - state)(Delay1hr_a ?s - state)
   (Powerdown-ddcu_a ?phalcon - phalcon ?ddcu - dc-to-dc-converter-unit)
   (rbi-for - fact ?d - dc-to-dc-converter-unit ?r - remote-bus-isolator)
   (Deactivate-ddcu_a ?phalcon - phalcon ?ddcu - dc-to-dc-converter-unit)
   (turned-on ?o - station-object)(closed ?o - remote-bus-isolator)
   (Ddcu-shutdown_a ?phalcon - phalcon ?ddcu - dc-to-dc-converter-unit)
   (Shutdown-etcs-loop_a ?fc - thor ?ddcu - dc-to-dc-converter-unit)
   (etcs-pump-for ?ddcu - dc-to-dc-converter-unit ?loop-pump - loop-pump)
   (cooling-loop-for ?pump - loop-pump ?l - cooling-loop)
   (inhibited ?s - software-routine)
   (Inhibit-rt-fdir_a ?fc - phalcon ?ddcu - dc-to-dc-converter-unit)
   (rt-fdir-for ?m - (or multiplexer-demultiplexer dc-to-dc-converter-unit) ?s - rt-fdir)
   (rt-fdir-mdm ?ddcu - dc-to-dc-converter-unit ?m - multiplexer-demultiplexer)
   (Transition-mdm_a ?fc - odin ?m - multiplexer-demultiplexer)
   (Transition-S0-mdm_a ?fc - odin ?m - S0-mdm)
   (redundant-S0-mdm ?m - S0-mdm)
   (Deactivate-mdm_a ?fc - odin ?mdm - ext-mdm)
   (primary-ext-mdm ?m - ext-mdm)
   (redundant-ext-mdm ?m - ext-mdm)
   (primary-S0-mdm ?m - S0-mdm)
   (Transition-S1-mdm_a ?fc - odin ?m - S1-mdm)
   (redundant-S1-mdm ?m - S1-mdm)
   (primary-S1-mdm ?m - S1-mdm)
   (Transition-S3-mdm_a ?fc - odin ?m - S3-mdm)
   (redundant-S3-mdm ?m - S3-mdm)
   (primary-S3-mdm ?m - S3-mdm)
   (Transition-P1-mdm_a ?fc - odin ?m - P1-mdm)
   (redundant-P1-mdm ?m - P1-mdm)
   (primary-P1-mdm ?m - P1-mdm)
   (Transition-P3-mdm_a ?fc - odin ?m - P3-mdm)
   (redundant-P3-mdm ?m - P3-mdm)
   (primary-P3-mdm ?m - P3-mdm)
   (configure-sarj_a ?fc - phalcon ?sarj - solar-array-rotating-joint)
   (mode ?o -  (or solar-array-rotating-joint rpc-string multiplexer-demultiplexer) ?s - state)
   (alt-string-for ?sarj - solar-array-rotating-joint ?string - rpc-string)
   (string-for ?sarj - solar-array-rotating-joint ?string - rpc-string)
   (shutdown-cmg_a ?fc - adco ?ddcu - dc-to-dc-converter-unit)
   (parked ?cmg - control-moment-gyro)
   (cmg-for ?ddcu - dc-to-dc-converter-unit ?cmg  - control-moment-gyro)
   (associated-rpc ?rga - station-object ?rpc - remote-power-controller)
   (associated-rt ?rga - rate-gyro-assembly ?rt - rt-fdir)
   (power-source ?rpc - remote-power-controller ?ddcu - dc-to-dc-converter-unit)
   (operational ?e - station-object)
   ;;;(Deactivate-rga_a ?fc - adco ?rga - rate-gyro-assembly)
   (Deactivate-rga_a ?fc - adco ?d - dc-to-dc-converter-unit)
   (Prepare-for-ddcu-shutdown_a ?phalcon - phalcon ?ddcu - dc-to-dc-converter-unit)
   (gps-power-source ?ddcu - dc-to-dc-converter-unit)
   (gps-alternate-power-source ?alt-ddcu - dc-to-dc-converter-unit)
   (gps-rpc-string ?ddcu - dc-to-dc-converter-unit ?s - rpc-string)
   (Reconfig-gps-power_a ?fc - adco ?ddcu - dc-to-dc-converter-unit)
   )
  (:axiom
   :vars (?a - Agent
	     ?h - (or robotic-arm ceta-cart)
	     ?l - Location)
   :context (and (ingressed ?a ?h)
		 (located ?h ?l))
   :implies (located ?a ?l)
   :documentation "you are located wherever the thing you're ingressed to is located.")
#|  (:axiom
   :vars (?a - Agent
	     ?h - station-object
	     ?l - (located ?h)) ;; much faster than looking through all 129 Locations
   :context (and (ingressed ?a ?h)
		 ;;(located ?h ?l)
		 )
   :implies (located ?a ?l)
   :documentation "you are located wherever the thing you're ingressed to is located.")|#
  (:axiom
   :vars (?a - Agent ?t - safety-tether)
   :context (and (tethered_to ?t ?a)
		 (not (= ?a nobody)))
   :implies (not (available ?t))
   :documentation "an axiom to establish being tethered to someone")
  
  (:axiom
   :vars (?t - safety-tether)
   :context (tethered_to ?t nobody)
   :implies (available ?t)
   :documentation "an axiom to establish not being tethered to anyone")
;   (:axiom
;    :vars (?h ?o - object)
;    :context (and (contains ?h ?o)
; 		 (not (= ?o nothing)))
;    :implies (contained_by ?o ?h)
;    :documentation "inverse relation for convienence")  
;   (:axiom
;    :vars (?h ?o - object)
;    :context (not (contains ?h ?o))
;    :implies (not (contained_by ?o ?h))
;    :documentation "when one is negated, the other must be as well")
  (:axiom 
   :vars (?o1 - station-object
	      ?o2 - station-object ;;(or station-object articulating-portable-foot-restraint)
	      ?l - location
	      )
   :context (and (contains ?o1 ?o2)
		 (located ?o1 ?l)
		 )
   :implies (located ?o2 ?l)
   :documentation "a contained object is located where the container is")
;   (:axiom
;    :vars (?a - Agent
; 	  ?t1 ?t2 - object)
;    :context (and (possesses ?a ?t1)
; 		 (contained_by ?t2 ?t1)
; 		 (not (= ?t1 ?t2))
; 		 (not (= ?t2 nothing)))
;    :implies (possesses ?a ?t2)
;    :documentation "an Agent possess objects  contained_by its possessions")
  (:axiom
   :vars (?a - Agent
	     ?h - station-object ;;(or station-object articulating-portable-foot-restraint)
	     ?l - location)
   :context (and (possesses ?a ?h)
		 (located ?a ?l))
   :implies (located ?h ?l)
   :documentation "your possessions are located where you are.")
  )

(defparameter *mv-rels* '(bag-size-for tool-for too-far))
#| cardinality restriction obsolete. all predicates are :multi-value
   CE 7/2/2014
(dolist (rel *mv-rels*)
  (owl:Restriction rel 'owl:cardinality :multi-value))
|#

 ;;; Helper to generate paths and the start-loc end-loc predicates
(defun make-paths-from-locs (locs)
  (loop for i from 0 to (- (length locs) 2)
      with preds
      with forward-path
      with reverse-path
      as start-loc = (nth i locs)
	do
	(loop for j from 0 to (1- (length (nthcdr (1+ i) locs)))
	    as end-loc = (nth j (nthcdr (1+ i) locs))
	    do
	      (setf forward-path (read-from-string (format nil "~a-to-~a " start-loc end-loc))
		    reverse-path (read-from-string (format nil "~a-to-~a " end-loc start-loc)))
	      (push `(start-loc ,forward-path ,start-loc) preds)
	      (push `(end-loc ,forward-path ,end-loc) preds)
	      (push `(start-loc ,reverse-path ,end-loc) preds)
	      (push `(end-loc ,reverse-path ,start-loc) preds)
	      (format t "~a ~a " forward-path reverse-path))
      finally (return preds)))

;;; To generate all the props necessary for a new path
(defun make-path-props (start end &optional intermediate-loc)
  (let ((to-path (list (read-from-string (format nil "~a-to-~a" start end)) start end))
	(from-path (list (read-from-string (format nil "~a-to-~a" end start)) end start))
	(s-to-interm (list (read-from-string (format nil "~a-to-~a" start intermediate-loc))
			   start intermediate-loc))
	(interm-to-s  (list (read-from-string (format nil "~a-to-~a" intermediate-loc start))
			    intermediate-loc start))
	(interm-to-e (list (read-from-string (format nil "~a-to-~a" intermediate-loc end))
			   intermediate-loc end))
	(e-to-interm (list (read-from-string (format nil "~a-to-~a" end intermediate-loc))
			   end intermediate-loc)))
    (format t "~%;;; paths ~%")
    (loop for path in (list (first to-path)(first from-path)
			    (first s-to-interm) (first interm-to-s)
			    (first interm-to-e)(first e-to-interm))
	if path 
	do
	  (format t "~a " path))
    (format t "~%;;; props")
    (if intermediate-loc (format t "~%(too-far ~a)(too-far ~a)" (first to-path) (first from-path)))
    (if intermediate-loc (format t "~%(intermediate-loc-for ~a ~a)(intermediate-loc-for ~a ~a)" 
				 (first to-path) intermediate-loc (first from-path) intermediate-loc))
    (loop for (path start end) in `(,to-path ,from-path ,s-to-interm ,interm-to-s ,interm-to-e ,e-to-interm)
	do
	  (format t "~%(start-loc ~a ~a)(end-loc ~a ~a)" path start path end))))

;;; (make-path-props 'p1-ata-panel 'P6-Z-FACE1 P3-Z-FACE1)
;;; (make-path-props 'p1-ata-panel 'P5-p6-juncture P3-Z-FACE1)
;;; (make-path-props 'airlock 'p1-nadir-bay12)
;;; (make-path-props 'p3-p4-juncture 'p1-nadir-bay12)
;;; (make-path-props 'port-ceta-cart-loc 'p1-ata-panel)
;;; (make-path-props 'port-ceta-cart-loc 'p3-p4-juncture)
;;; (make-path-props 'port-ceta-cart-loc 'p6-z-face1)
;;; (make-path-props 's1-stow-beam-loc 'p3-p4-juncture)
;;; (make-path-props 's1-stow-beam-loc 'airlock)
;;; (make-path-props 's1-stow-beam-loc 'p1-ata-panel)
;;; (make-path-props 's1-stow-beam-loc 'p6-z-face1 'p3-p4-juncture)

;;;(defun time-for-delay (action)
;;;  (float (gsv action '?time)))

(defun time-for-delay (action)
  (print (list "at delay " (name (template action))))
  (cond ((samep (name (template action)) 'delay10)
	 10.0)
	((samep (name (template action)) 'delay24hrs)
	 1440.0)
	((samep (name (template action)) 'delay1hr)
	 60.0)
	(t 15.0)))

 ;;; A delay action

(define (durative-action Delay10)
    :duration time-for-delay
    :effect (at end (Delay10_a done)))

(define (durative-action Delay-action)
    :parameters (?inside-agent - crew)
    :expansion (sequential
		(located ?inside-agent AIRLOCK)
		(Delay10_a done)
		(located ?inside-agent INTRA-VEHICLE))
    :effect (at end (Delay-action_a ?inside-agent))
    :comment "experimenting with an action that just lets time pass."
    )

;;;****************************************
;;; egressing agents
;;;****************************************
;;;
;;; Gets an inside agent outside
;;;

(define (durative-action Egress-inside-agent)
    :parameters (?ev - crew 
		     ?st - safety-tether)
    :duration 4.0 
    :condition (and (at start (= (located ?st) AIRLOCK)) ;;; over all doesn't work
		    (at start (installed ?st)) ;; as opposed to one in an STP
		    (at start (available ?st))
		    (at start (located ?ev  INTRA-VEHICLE)))
    :effect (and (at start (located ?ev nowhere)) ;; testing during effect parsing
		 (at end (located ?ev AIRLOCK)) ;; the purpose of this action
		 (at end (tethered_to ?st ?ev)) ;; axioms will establish not(available)
		 (at end (open THERMAL-COVER)))
		 
    :probability 0.5 ;;  don't use if assisted-egress is possible
     :comment "crew opens the cover, moves outside and tethers to a safety-tether at the AIRLOCK")

(define (durative-action Egress-one-test)
    :vars (?ev - crew
	       ?st - safety-tether)
    :expansion 
    (sequential (tethered_to ?st ?ev))
    :effect (at end (one-crew airlock))
    )

;;;
;;; Uses an outside agent to help an inside agent outside
;;;

(define (durative-action Egress-by-two)
    :parameters (?ev2 - crew
		      ?st - safety-tether) 
    :duration 2.0
    :effect (and (at end (egress-by-two_a ?ev2 ?st))
		 )
    :comment "?ev2 hands out a waist tether, waits till its connected to ?st, 
              egresses and closes the AIRLOCK door"
    )

(define (durative-action Safety-tether-for-egress)
    :parameters (?ev1 - crew
		      ?st - safety-tether) ;; where is the waist tether? CE -- in the procedure-RPB
    :duration 2.0
    :effect (at end (safety-tether-for-egress_a ?ev1 ?st))
    :comment "?ev1 connects inside waist tether to outside ?st."
    )

(define (durative-action Assisted-egress)
    :parameters (?ev2 - crew ?st - safety-tether)
    :vars (?ev1 - crew)
    :condition (and (at start (= (located ?ev1) airlock))
		    (at start (= (located ?ev2) INTRA-VEHICLE))
		    (at start (= (located ?st) AIRLOCK))
		    (at start (installed ?st))
		    (at start (available ?st)) ;; as opposed to being in an STP
		    (at start (open THERMAL-COVER))
		    (at start (not (= ?ev1 ?ev2)))
		    )
    :expansion (SIMULTANEOUS
		(egress-by-two_a ?ev2 ?st)
		(safety-tether-for-egress_a ?ev1 ?st))
    :effect (and (at end (tethered_to ?st ?ev2))
		 (at end (located ?ev2 AIRLOCK)) ;; the purpose of this action
		 (at end (not (open THERMAL-COVER)))
		 ) 
    :comment "joint task where outside agent helps inside agent outside")

(define (durative-action Assist-out-test)
    :vars (?ev2 - crew)
    :expansion (sequential (located ?ev2 AIRLOCK))
    :effect (at end (assist-done AIRLOCK))
    )

(define (durative-action Two-out-test)
    :vars (?ev1 ?ev2 - crew)
    :condition (at start (not (= ?ev1 ?ev2)))
    :expansion 
    (sequential 
     (located ?ev1 AIRLOCK)
     (located ?ev2 AIRLOCK))
    :effect (at end (two-out done))
    )

(define (durative-action Prepare-for-eva)
    :parameters (?ev - crew)
    :vars (?st - safety-tether)
    :duration 3.0
    :condition (and (at start (= (tethered_to ?st) ?ev))
		    (at start (= (located ?ev) AIRLOCK)))
    :effect (at end (prepare-for-eva_a ?ev))
    :comment "crew tethered outside moves around and checks all connections.")

;;; Now we sequence them all to get two crew outside and prepped
;;; Plan for two-out-prep does not use assisted-egress for the 2nd ev.
(define (durative-action Crew-out)
    :vars (?inside-agent ?outside-agent - crew
			 ?arm - robotic-arm)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (operator ?arm ?outside-agent))) 
		    (at start (not (operator ?arm ?inside-agent)))
		    (at start (located ?inside-agent INTRA-VEHICLE))
		    (at start (located ?outside-agent INTRA-VEHICLE))
		    )
    :expansion (sequential
		(located ?outside-agent AIRLOCK)
		(located ?inside-agent AIRLOCK)
		(parallel
		 (prepare-for-eva_a ?inside-agent)
		 (prepare-for-eva_a ?outside-agent))
		)
    :effect (at end (crew-moved-to AIRLOCK))
    :comment "First crew gets out, then second crew gets out, then they both prep for eva")

;;;****************************************
;;; handing stuff out
;;;****************************************

(define (durative-action Stow)
    :parameters (?ev - crew
	         ?item - station-object)
    :duration 2.0
    :effect (at end (stow_a ?ev ?item))
    :comment "?ev receives ?item and stows")

(define (durative-action Hand-over)
    :parameters (?ev - crew
	         ?item - station-object)
    :duration 2.0
    :effect (at end (hand-over_a ?ev ?item))
    :comment "?ev untethers and hands over ?item ")

(define (durative-action Stow-external)
    :parameters (?item - station-object)
    :vars (?inside-ev ?outside-ev - crew
	   ?arm - robotic-arm)
    :condition (and 
		(at start (located ?item INTRA-VEHICLE))
		(at start (open THERMAL-COVER))
		(at start (located ?outside-ev AIRLOCK))
		(at start (= (located ?inside-ev) INTRA-VEHICLE))
		(at start (not (= (operator ?arm) ?inside-ev)))
		(at start (not (= ?inside-ev ?outside-ev))))
    :expansion (simultaneous
		(hand-over_a ?inside-ev ?item)
		(stow_a ?outside-ev ?item))
    :effect (at end (located ?item AIRLOCK))
    :comment "?inside-ev hands ?item to ?outside-ev")

;;; Now we expand crew out to get both crew and all the needed tools outside
;;; Plan has same problem here as in two-out-test (see problem all-outside),
;;; in that assisted-egress is not used for the 2nd ev.

;;; this appears to be one of the most explosive operators because there are
;;;   so many combinations of :vars. I have added a :condition that will cut that
;;;   in half. If you do NOT want ?bag ?bag2 to be distinct, take out the
;;;   condition I've marked with a comment  Chris  3/15/2012

(define (durative-action Egress-agents)
    :vars (?inside-agent ?outside-agent - crew
			 ?ceta-light - ceta-light
			 ?cpa - control-panel-assembly
			 ?power-jumper - qtr-inch-power-cable
			 ?bag ?bag2 - medium-oru-bag
			 ?clb - crew-lock-bag
			 ?fs - fish-stringer
			 ?spd1 ?spd2 - space-positioning-device
			 ?arm - robotic-arm)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (= (operator ?arm) ?outside-agent))) 
		    (at start (not (= (operator ?arm) ?inside-agent)))
		    (at start (not (= ?spd1 ?spd2)))
		    (at start (= (contained_by ?spd1) ?fs))
		    (at start (= (contained_by ?spd2) ?fs))
		    (at start (= (contained_by ?power-jumper) ?fs))
		    (at start (not (= ?bag ?bag2))) ; Chris added 3/15/2012, reduce explosion
		    (over all (bag-size-for ?ceta-light ?bag))
		    (over all (bag-size-for ?cpa ?bag2))
		    (at start (= (located ?inside-agent) INTRA-VEHICLE))
		    (at start (= (located ?outside-agent) INTRA-VEHICLE)))
    :expansion (sequential
		(located ?outside-agent AIRLOCK)
		(located ?fs AIRLOCK)
		(located ?bag AIRLOCK)
		(located ?bag2 AIRLOCK)
		(located ?clb AIRLOCK)
		(located ?inside-agent AIRLOCK)
		(parallel
		 (prepare-for-eva_a ?inside-agent)
		 (prepare-for-eva_a ?outside-agent))
		)
    :effect (at end (crew-and-tools AIRLOCK))
    :comment "First crew gets out, then second crew hands tools out then gets out, then they both prep for eva")

;;; Get a crew out to do some jobs -- specify the crew
(define (durative-action Agent-Egress-and-do)
    :parameters (?outside-agent - crew)
    :vars (?fc - phalcon 
		       ?power-jumper - qtr-inch-power-cable
		       ?fs - fish-stringer
		       ?arm - robotic-arm
		       ?bag  - medium-oru-bag
		       ?stp - safety-tether-pack) ;;;in case a tether swap is necessary
    :condition (and (at start (not (= (operator ?arm) ?outside-agent))) 
		    (over all (bag-size-for ceta-light3 ?bag))
		    )
    :expansion (sequential
		(lock_sarj_a ?fc sarj-port)
		(located ?outside-agent airlock)
		(located ?fs AIRLOCK)
		(located ?bag AIRLOCK)(located ?stp AIRLOCK)
		(prepare-for-eva_a ?outside-agent)
		(install-item_a ?outside-agent ?power-jumper)
		(located ?outside-agent airlock)
		(possesses ?outside-agent ?stp)
		(retrieve-item_a ?outside-agent ceta-light3)
		(located ?outside-agent airlock)
		(recover-to-mode_a ?fc sarj-port)
		)
    :effect (at end (crew-did-jobs ?outside-agent))
    :comment "First crew gets out, gets tools and goes and gets light.")

 ;;; Get anyone out to do some jobs.
(define (durative-action Egress-and-do-jobs)
    :vars (?outside-agent - crew
			  ?power-jumper - qtr-inch-power-cable
			  ?fs - fish-stringer
			  ?arm - robotic-arm
			  ?bag  - medium-oru-bag
			  ?stp - safety-tether-pack)
    :condition (and (at start (not (= (operator ?arm) ?outside-agent))) 
		    (over all (bag-size-for ceta-light3 ?bag))
		    )
    :expansion (sequential
		(located ?outside-agent airlock)
		(located ?fs AIRLOCK)
		(located ?bag AIRLOCK)
		(located ?stp AIRLOCK)
		(prepare-for-eva_a ?outside-agent)
		(install-item_a ?outside-agent ?power-jumper)
		(located ?outside-agent airlock)
		(possesses ?outside-agent ?stp)
		(retrieve-item_a ?outside-agent ceta-light3)
		(located ?outside-agent airlock)
		)
    :effect (at end (agent-egress&do-test done))
    :comment "First crew gets out, gets tools and does jobs.")

 ;;;***********************************************
;;; Ingressing agents
;;;***********************************************

;; When you ingress, one ev goes inside and untethers from the st, handing the st out.
;; After the outside ev hands the inside ev all the tools and bags, then the outside ev
;; detaches his st, goes in , and closes the door.

(define (durative-action Ingress-by-two)
    :parameters (?ev2 - crew
		      ?st - safety-tether)
    :duration 2.0
    :effect (and (at end (ingress-by-two_a ?ev2 ?st))
		 )
    :comment "?ev2 opens the door, goes inside, disconnects from and hands out her ?st."
    )

(define (durative-action Untether-for-ingress)
    :parameters (?ev1 - crew
		      ?st - safety-tether)
    :duration 2.0
    :effect (at end (untether-for-ingress_a ?ev1 ?st))
    :comment "?ev1 receives disconnected ?st and reels it in."
    )

(define (durative-action Assisted-ingress)
    :parameters (?ev2 - crew
		      ?st - safety-tether)
    :vars (?ev1 - crew ;;ev1 helps ev2 in
		)
    :condition (and 
		(at start (located ?st AIRLOCK))
		(at start (= (tethered_to ?st) ?ev2))
		(at start (= (located ?ev2) AIRLOCK))
		(at start (= (located ?ev1) airlock))
		(at start (not (= ?ev1 ?ev2))))
    :expansion (SIMULTANEOUS
		(ingress-by-two_a ?ev2 ?st)
		(untether-for-ingress_a ?ev1 ?st))
    :effect (and (at end (tethered_to ?st nobody)) ;;axioms assert available(?st)
		 (at end (located ?ev2 INTRA-VEHICLE))  ;; the purpose of this action
		 (at end (open THERMAL-COVER))
		 ) 
    :comment "joint task where ?ev2 goes inside and hands out her freed ?st to ?ev1.")

(define (durative-action Assist-in-test)
    :vars (?ev - crew)
    :expansion (sequential (located ?ev INTRA-VEHICLE))
    :effect (at end (assist-done INTRA-VEHICLE))
    )

;;; Here I want to say that this action is used only when
;;; there is no other agent outside to help you in.
;;; But (at start (forall (?evo - crew)(and (not (= ?evo ?ev))(located ?evo INTRA-VEHICLE)))) 
;;; doesn't work.
(define (durative-action Ingress-outside-agent)
    :parameters (?ev - crew)
    :vars (?st - safety-tether)
    :duration 4.0 
    :condition (and (at start (open THERMAL-COVER))
		    (at start (located ?ev AIRLOCK))
		    (at start (= (located ?st) AIRLOCK))
		    (at start (= (tethered_to ?st) ?ev))
		    )
		    
    :effect (and (at end (located ?ev INTRA-VEHICLE))
		 (at end (tethered_to ?st nobody)) ;;axioms assert available(?st)
		 (at end (not (open THERMAL-COVER)))
		 )
    :probability 0.5
    :comment "outside ?ev hooks a waist tether to the A/L d-ring, unhooks and stows his ?st, moves inside and closes the door"
    )

(define (durative-action Ingress-one-test)
    :vars (?ev - crew)
    :expansion 
    (sequential (located ?ev INTRA-VEHICLE))
    :effect (at end (one-crew INTRA-VEHICLE))
    )

(define (durative-action Two-in-test)
    :vars (?ev1 ?ev2 - crew)
    :condition (at start (not (= ?ev1 ?ev2)))
    :expansion
    (sequential 
     (located ?ev1 INTRA-VEHICLE)
     (located ?ev2 INTRA-VEHICLE))
    :effect (at end (two-in done))
    )

(define (durative-action Close-hatch)
    :vars (?ev  - crew
	       ?arm - robotic-arm)
    :duration 2.0
    :condition (and (at start (not (open THERMAL-COVER)))
		    (at start (located ?ev INTRA-VEHICLE))
		    ;; commenting out the constraint below solves TWO-IN&PREP 
		    (at start (not (operator ?arm ?ev)))
              		    )
    :effect (at end (locked HATCH))
    :comment "?ev closes and locks the inner door to prepare for repressurization.")

(define (durative-action Prepare-for-repress)
    :parameters (?ev - crew)
    :duration 3.0
    :condition (and (at start (= (located ?ev) INTRA-VEHICLE))
		    (at start (locked HATCH))
		    )
    :effect (at end (prepare-for-repress_a ?ev))
    :comment "?ev stows SCU and turns suit water off.")

;;; Now we sequence them all to get two crew inside.
;;; The plan here uses assisted-ingress as we'd hoped, but I think that's because
;;; it's alphabetically sooner than ingress-outside-agent. Ingress-agents
;;; below uses two ingress-outside-agents, which doesn't surprise me, since 
;;; there's nothing that restricts one over the other.
(define (durative-action Crew-in)
    :vars (?inside-agent ?outside-agent - crew
			 ?arm - robotic-arm)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (= (operator ?arm) ?outside-agent))) 
		    (at start (not (= (operator ?arm) ?inside-agent)))
		    (at start (= (located ?inside-agent) AIRLOCK))
		    (at start (= (located ?outside-agent) AIRLOCK)))
    :expansion (sequential
		(located ?inside-agent INTRA-VEHICLE)
		(located ?outside-agent INTRA-VEHICLE)
		(locked HATCH)
		(parallel
		 (prepare-for-repress_a ?inside-agent)
		 (prepare-for-repress_a ?outside-agent)))
    :effect (at end (crew-moved-to intra-vehicle))
    :comment "First crew gets in, then second crew gets in and closes the hatch, then they both prep for repress")

;;;*********************************
;;; Handing stuff in
;;;*********************************
(define (durative-action Stow-internal)
    :parameters (?outside-ev - crew 
			    ?item - station-object)
    :vars  (?inside-ev  - crew ;; helper
		       ?arm - robotic-arm) 
    :condition (and (at start (located ?outside-ev AIRLOCK))
		    (at start (located ?inside-ev INTRA-VEHICLE))
;;; This PC doesn't seem to be actually working, because
;;; in the PRIDE demo I violate it (see retrieve-item2)
;;; and it can only work if I change this pc to (at start (possesses ?outside-ev ?item))
		    (at start (possesses ?outside-ev ?item))
		    ;;;(at start (= (possessed_by ?item) ?outside-ev))
		    (at start (open THERMAL-COVER))
		    (at start (not (operator ?arm ?inside-ev)))
		    (at start (not (= ?inside-ev ?outside-ev))))
    :expansion (simultaneous
		(hand-over_a ?outside-ev ?item)
		(stow_a ?inside-ev ?item))
    :effect (and (at end (located ?item INTRA-VEHICLE))
		 (at end (not (possesses ?outside-ev ?item)))
		 )
    :comment "?outside-ev hands ?item to ?inside-ev")

;;; Now we extend crew-in to get a bag inside as well
;;; This gets a plan (see problem all-inside), but uses ingress-outside agent for both  
(define (durative-action Ingress-agents)
    :vars (?inside-agent ?outside-agent - crew
			 ?arm - robotic-arm
			 ?bag - oru-bag)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (= (operator ?arm) ?outside-agent))) 
		    (at start (not (= (operator ?arm) ?inside-agent)))
		    (at start (= (located ?inside-agent) AIRLOCK))
		    (at start (= (located ?outside-agent) AIRLOCK))
		    (at start (= (possessed_by ?bag) ?outside-agent)))
    :expansion (sequential
		(located ?inside-agent INTRA-VEHICLE)
		(located ?bag INTRA-VEHICLE)
		(located ?outside-agent INTRA-VEHICLE)
		(locked HATCH)
		(parallel
		 (prepare-for-repress_a ?inside-agent)
		 (prepare-for-repress_a ?outside-agent)))
    :effect (at end (crew-and-tools intra-vehicle))
    :comment "First crew gets in, then second crew hands bag in then gets in and closes the hatch, then they both prep for repress")

;;; Have a crew go out and do jobs and then go back in
(define (durative-action crew-egress-do-ingress)
    :parameters (?outside-agent - crew)
    :vars (?ceta-light - ceta-light
		       ?power-jumper - qtr-inch-power-cable
		       ?fs - fish-stringer
		       ?arm - robotic-arm
		       ?bag  - medium-oru-bag
		       ?stp - safety-tether-pack)
    :condition (and (at start (not (= (operator ?arm) ?outside-agent))) 
		    (over all (bag-size-for ?ceta-light ?bag))
		    )
    :expansion (sequential
		(located ?outside-agent airlock)
		(located ?fs AIRLOCK)(located ?stp AIRLOCK)
		(located ?bag AIRLOCK)
		(prepare-for-eva_a ?outside-agent)
		(install-item_a ?outside-agent ?power-jumper)
		(located ?outside-agent airlock)
		(retrieve-item_a ?outside-agent ?ceta-light)
		(located ?outside-agent airlock)
		(located ?bag INTRA-VEHICLE)
		(located ?outside-agent intra-vehicle)
		(locked HATCH)
		(prepare-for-repress_a ?outside-agent)
		)
    :effect (at end (crew-did-jobs2 ?outside-agent))
    :comment "crew gets out, gets tools does jobs and goes back inside.")

;;; Have any crew go out and do jobs and then go back in
;;; It's identical to the action above except that the agent is a var not a parameter.
(define (durative-action Egress-do-ingress)
    :vars (?outside-agent - crew
			  ?ceta-light - ceta-light
		       ?power-jumper - qtr-inch-power-cable
		       ?fs - fish-stringer
		       ?arm - robotic-arm
		       ?bag  - medium-oru-bag
		       ?stp - safety-tether-pack)
    :condition (and (at start (not (= (operator ?arm) ?outside-agent))) 
		    (over all (bag-size-for ?ceta-light ?bag))
		    )
    :expansion (sequential
		(located ?outside-agent airlock)
		(located ?fs AIRLOCK)
		(located ?stp AIRLOCK)
		(located ?bag AIRLOCK)
		(prepare-for-eva_a ?outside-agent)
		(install-item_a ?outside-agent ?power-jumper)
		(located ?outside-agent airlock)
		(retrieve-item_a ?outside-agent ?ceta-light)
		(located ?outside-agent airlock)
		(located ?bag INTRA-VEHICLE)
		(located ?outside-agent intra-vehicle)
		(locked HATCH)
		(prepare-for-repress_a ?outside-agent)
		)
    :effect (at end (all-jobs2 done))
    :comment "crew gets out, gets tools does jobs and goes back inside.")

;;;**************************************************************
;;; Pick up/extract
;;;**************************************************************

;;; Pick up anything that is not contained in/on anything, i.e., it's tethered to a location.
(define (durative-action Pick-up)
    :parameters (?ev - crew
		     ?item - station-object)
    :vars (?l - (located ?item))
    :condition (and (at start (forall (?h - (or oru-bag workplace-interface wif-adapter))
				      (not (contained_by ?item ?h))))
		    (at start (not (installed ?item)))
		    (at start (located ?ev ?l))
		    )
    :duration 2.0
    :effect (at end (possesses ?ev ?item))
    :comment "Untether from a handrail and tether or otherwise secure an item to ?ev's suit")

;;; Go get item and come back
(define (durative-action go-pick-up)
    :parameters (?ev - crew
		     ?item - equipment)
    :vars (?l1 - (located ?ev)
	      ?l2 - (located ?item))
    :expansion
    (sequential (located ?ev ?l2)
		(possesses ?ev ?item)
		(located ?ev ?l1))
    :effect (at end (fetched ?ev ?item)))

;; Now we do ingress-agents again but use a pick up action
;; to establish the possesses.
(define (durative-action Ingress-agents&tools2)
    :vars (?inside-agent ?outside-agent - crew
			 ?arm - robotic-arm
			 ?bag - oru-bag
			 ?clb - crew-lock-bag)
    :condition (and (at start (not (= ?inside-agent ?outside-agent)))
		    (at start (not (= (operator ?arm) ?outside-agent))) 
		    (at start (not (= (operator ?arm) ?inside-agent)))
		    (at start (= (located ?inside-agent) AIRLOCK))
		    (at start (= (located ?outside-agent) AIRLOCK))
		    )
    :expansion (sequential
		(possesses ?outside-agent ?bag)
		(possesses ?outside-agent ?clb)
		(located ?inside-agent intra-vehicle)
		(located ?bag INTRA-VEHICLE)
		(located ?clb INTRA-VEHICLE)
		(located ?outside-agent intra-vehicle)
		(locked hatch)
		(parallel
		 (prepare-for-repress_a ?inside-agent)
		 (prepare-for-repress_a ?outside-agent)))
    :effect (at end (crew-and-tools2 intra-vehicle))
    :comment "One crew picks up the bag, then other crew gets in, then second crew hands bag in then gets in and closes the hatch, then they both prep for repress")

;;; Some items get extracted from a location and are put in/on a container
(define (durative-action Extract-item-to-bag)
    :parameters (?ev - crew
		     ?item - (or ceta-light 
				 control-panel-assembly)
		     ?container - oru-bag)
    :vars (?pgt - pgt-with-turn-setting
		?l - (located ?item))
    :duration 12.0
    :condition (and (at start (located ?ev ?l))
		    (at start (possesses ?ev ?container))
		    (at start (= (possessed_by ?pgt) ?ev))
		    (at start (bag-size-for ?item ?container)))
    :effect (and (at end (extracted-item-to ?ev ?item ?container))
		 (at end (contains ?container ?item))
		 (at end (not (installed ?item))))
    :comment "crew removes ?item at ?l and stows in bag."
    )

(define (durative-action Extract-item-to-fs)
    :parameters (?ev - crew 
		     ?item - (or qtr-inch-power-cable
				 space-positioning-device)
		     ?container - fish-stringer)
    :vars (?l - (located ?item))
    :duration 12.0
    :condition (and (at start (located ?ev ?L))
		    (at start (possesses ?ev ?container))
		    )
    :effect (and (at end (extracted-item-to ?ev ?item ?container))
		 (at end (contains ?container ?item)))
    :comment "crew removes ?item and stows on fish-stringer."
    )

;;; Like a mut-ee. It's not tethered, its installed.
(define (durative-action Extract-item-to-suit)
    :parameters (?ev - crew 
		     ?item - (or multi-use-tether-end-effector vent-tool)
		     )
    :vars (?l - (located ?item))
    :duration 5.0
    :condition (and (at start (located ?ev ?l))
		    (at start (installed ?item))
		    )
    :effect (and (at end (not (installed ?item)))
		 (at end (possesses ?ev ?item)))
    :comment "crew removes ?item and stows on suit tether."
    )

 ;;; apfrs can be tethered to a handrail
;; But when they are installed in holders like wifs or wifas, you pick them up by extracting them.
(define (durative-action Extract-apfr)
    :parameters (?ev - crew
		     ?apfr - articulating-portable-foot-restraint
		     )
    :vars (?holder - (contained_by ?apfr)
		   ?l - (located ?holder))
    :condition (at start (located ?ev ?l))
    :duration 1.0
    :effect (and (at end (possesses ?ev ?apfr))
		 (at end (not (contains ?holder ?apfr)))
		 ;;; see install-apfr  11/28/2011  chris
		 (at end (not (installed-item ?ev ?apfr)))
		 )
    :comment "Pull ?apfr from ?holder and secure to ?ev's suit")

(define (durative-action Extract-apfr-test)
    :parameters (?apfr - articulating-portable-foot-restraint)
    :vars (?ev - crew)
    :expansion (sequential (possesses ?ev ?apfr))
    :effect (at end (item-extracted ?apfr)))

;;; Two versions: one that needs two evs to break the torque
;;; Since either ev can have the torque-break pgt,
;;; I just insist that both pgts be at the site.
(define (durative-action Extract-ddcu-by-two)
    :parameters (?ev1 - crew 
		     ?item - dc-to-dc-converter-unit)
    :vars (?ev2 - crew ;;;helper
	      ?pgt1 - pgt-with-turn-setting
	      ?pgt2 - pgt-with-torque-break-setting
	      ?scoop - square-scoop
	      ?l - (located ?item))
    :duration 15.0
    :condition (and (at start (not (= ?ev1 ?ev2)))
		    (at start (located ?ev1 ?l))
		    (at start (located ?ev2 ?l))
		    (at start (= (located ?pgt1) ?l))
		    (at start (= (located ?pgt2) ?l))
		    (at start (possesses ?ev1 ?scoop)))
    :effect (and (at end (possesses ?ev1 ?item))
		 ;;  the following introduces a logical inconsistency
		 ;; if you possess ?item 
		 ;;;   and ?itme contains ?scoop
		 ;; then 
		 ;;   you possess ?scoop
		 ;;  CE 2/26/2012 {see also comment on Extract-ddcu}
		 ;;(at end (not (possesses ?ev1 ?scoop)))
		 (at end (contains ?item ?scoop)))
    :probability 0.75
    :comment "?ev1 & ?ev2 extract ?item by using two pgts"
    )

(define (durative-action Extract-ddcu-test2)
    :parameters (?ddcu - dc-to-dc-converter-unit)
    :vars (?ev - crew)
    :expansion (sequential (possesses ?ev ?ddcu))
    :effect (at end (ddcu-extracted2 ?ddcu)))

;; And one that needs just one ev and a ratchet wrench
(define (durative-action Extract-ddcu)
    :parameters (?ev - crew 
		     ?item - dc-to-dc-converter-unit)
    :vars (?l - (located ?item)
	      ?pgt - pgt-with-turn-setting
	      ?torque-breaker - (or ratchet-wrench pgt-with-torque-break-setting)
	      ?scoop - square-scoop)
    :duration 20.0
    :condition (and (at start (located ?ev ?l))
		    (at start (= (possessed_by ?pgt) ?ev))
		    (at start (= (possessed_by ?torque-breaker) ?ev))
		    (at start (= (possessed_by ?scoop) ?ev))
		    )
    :effect (and (at end (possesses ?ev ?item))
		 ;;; ><  following effect introduces a contradiction! ><
		 ;;;  by the first axiom in the physob domain,  
		 ;;;  If ?ev possesses ?item 
		 ;;;   and ?item contains ?scoop, 
		 ;;;  then
		 ;;;    ?ev [still] possesses ?scoop
		 ;;; because possesses is transitive over contains.
		 ;;;  e.g., you possess a gun, the gun contains a bullet
		 ;;;        then you also possess the bullet
		 ;;(at end (not (possesses ?ev ?scoop)))
		 (at end (contains ?item ?scoop)))
    :probability 0.95	     
    :comment "?ev removes ?item at ?l using pgt and torque breaker."
    )

(define (durative-action Extract-ddcu-test)
    :parameters (?ddcu - dc-to-dc-converter-unit)
    :vars (?ev - crew)
     :expansion
    (sequential (possesses ?ev ?ddcu))
    :effect (at end (ddcu-extracted ?ddcu)))


;;;**************************************************************
;;; Place/install
;;;**************************************************************
;;;
;;; place (tether to a handrail at a loc)
;;;

;;; A conundrum here. An axiom says that an item is located wherever its possessor is located. 
;;; So the put-down action is not to locate the item but to dispossess the possessor of the item.  
;;; We have to distinguish between real possession, e.g.,having the item tethered to a waist tether or BRT on the suit, 
;;; and indirect possession, where you possess a container that contains the object.

(define (durative-action Put-down)
    :parameters (?ev - crew 
		     ?item - station-object
		       )
    :condition (and (at start (forall (?h - oru-bag)
				      (not (contained_by ?item ?h))))
		    (at start (forall (?f - fish-stringer)
				      (not (contained_by ?item ?f))))
		    (at start (possesses ?ev ?item))
		    )
    :duration 2.0
    :effect (at end (not (possesses ?ev ?item)))
    :comment "detach from suit and tether to a location (i.e., a handrail)"
    )

;;;
;;; Install
;;;

;; The analog to extract is install.
;; You can install most things like lights and cables by taking them out of/off their container
;; and bolting them at their location.
;; Some things - like fqd-jumpers, are stored at a location and just
;; need to be unfolded or otherwise prepared and then connected up.
;;

;;; Sometimes you don't put-down (tether), you attach
(define (durative-action install-item)
    :parameters (?ev - crew 
		     ?item - multi-use-tether-end-effector
		       )
    :condition (at start (possesses ?ev ?item))
    :duration 2.0
    :effect (and
	     (at end (installed-item ?ev ?item))
	     (at end (installed ?item))
	     (at end (not (possesses ?ev ?item))))
    :comment "detach from suit and attach to HR."
    )


(define (durative-action Install-item-from-container)
    :parameters (?ev - crew 
		     ?item - (or ceta-light 
				  qtr-inch-power-cable 
				  space-positioning-device
				  control-panel-assembly)
		     ?container - (or oru-bag fish-stringer)
	       )
    :vars (?l - (location-for ?item))
    :duration 12.0
    :condition (and (at start (located ?ev ?l))
		    (at start (= (possessed_by ?container) ?ev))
		    (at start (= (contained_by ?item) ?container))
		    )
    :effect (and 
	     (at end (installed-item ?ev ?item))
	     (at end (installed ?item))
	     (at end (not (contains ?container ?item)))
	     )
	     
    :comment "crew takes ?item off or out of container and bolts it to a location."
    )

(define (durative-action Install-fqd-in-place)
    :parameters (?ev - crew 
		     ?item - fluid-quick-disconnect-jumper 
		      ?holder - (or fish-stringer oru-bag)
		      ?spd1 ?spd2 - space-positioning-device)
    :duration 12.0
    :condition (and (at start (= (located ?ev)(location-for ?item)))
		    (at start (possesses ?ev ?holder))
		    (at start (not (= ?spd1 ?spd2)))
		    (at start (= (contained_by ?spd1) ?holder))
		    (at start (= (contained_by ?spd2) ?holder))
		    )
    :effect (and 
	     (at end (installed-item-in-place ?ev ?item))
	     (at end (installed ?item))
	     (at end (not (contains ?holder ?spd1)))
	     (at end (not (contains ?holder ?spd1)))
	     )
	     
    :comment "crew unpacks ?item and connects it up at a location."
    )

;;; wifas are installed on arms to accommodate an apfr
;;; We look for an agent that has the wifa.
(define (durative-action Install-wifa)
    :parameters (?ev - crew
		     ?wifa - wif-adapter  
		   )
    :vars (?holder - robotic-arm
		   ?l - (located ?holder))
    :condition (and (at start (located ?ev ?l))
		    (at start (= (possessed_by ?wifa) ?ev))
		    (at start (available ?holder)))
    :duration 1.0
    :effect (and (at end (installed-item ?ev ?wifa))
		 (at end (installed ?wifa))
		 (at end (contains ?holder ?wifa))
		 (at end (not (available ?holder)))
		 (at end (not (possesses ?ev ?wifa))))
    :comment "Untether ?wifa from ?ev's suit and put it into an arm")

;;; An apfr can be installed if there's an wifa or wif both avilable and installed
;; we need an agent to have the apfr.
(define (durative-action Install-apfr)
    :parameters (?ev - crew
		     ?apfr - articulating-portable-foot-restraint
		   )
    :vars (?wif - (or workplace-interface wif-adapter))
    :condition (and (at start (= (located ?ev)(located ?wif)))
		    (at start (= (possessed_by ?apfr) ?ev))
		    (at start (installed ?wif))
		    (at start (available ?wif)))
    :duration 1.0
    :effect (and (at end (installed-item ?ev ?apfr))
		 (at end (installed ?apfr))
		 (at end (contains ?wif ?apfr))
		 (at end (not (available ?wif)))
		 (at end (not (possesses ?ev ?apfr))))
    :comment "Untether ?apfr from ?ev's suit and put it into ?wif")

;;; item is usually a spare ddcu -- ev inserts it but doesn't bolt it then takes off the scoop
;;; (?l - (located ?ev) fails in the PCs when the ?ev is a designator
;; 01/15/10 - going to have to moedl this with two scoops to match reality.
(define (durative-action Temp-install-ddcu)
    :parameters (?ev - crew 
		     ?item - dc-to-dc-converter-unit)
    :vars (?l - location
	      ?scoop - square-scoop)
    :duration 15.0
    :condition (and 
		(at start (located ?ev ?l))
		(at start (possesses ?ev ?item))
		(at start (= (contained_by ?scoop) ?item))
		    )
    :effect (and 
	     (at end (inserted-item ?ev ?item))
	     (at end (inserted ?item ?l))
	     (at end (not (contains ?item ?scoop)))
	     (at end (possesses ?ev ?scoop))
	     (at end (not (possesses ?ev ?item)))
	     )
	     
    :comment "?ev inserts ?item at ?l and takes off the ?scoop."
    )

(define (durative-action Secure-ddcu)
    :parameters (?ev - crew 
		     ?item - dc-to-dc-converter-unit)
    :vars (?l - (located ?item)
	       ?pgt - pgt-with-turn-setting)
    :duration 15.0
    :condition (and ;;(at start (= (located ?ev) ?l))   changing these made a
		;;difference 12/28/09 
		    ;;(at start (= (possesses ?ev) ?pgt))
		    (at start (located ?ev ?l))
		    (at start (= (possessed_by ?pgt) ?ev))
		    (at start (inserted ?item ?l)))
    :effect (and (at end (installed-item ?ev ?item))
		 (at end (installed ?item)))
    :comment "?ev bolts ?item at ?l using ?pgt."
    )

;;; When one ev is holding the ddcu via the staunchion cover,
;;; the 2nd ev takes hold of it via the square scoop installed on ddcu connector H2.
;;; So we need a way to install the scoop on the ddcu.

;;; One way is if an ev at the ddcu site has a scoop
;;; I tried to restricy this action by saying the scoop can't be
;;; contained by anything, but the forall inexplicably fails
;;; probs CREW-R&R-D and R&R-D.

(define (durative-action Install-scoop)
    :parameters (?ev - crew
		     ?scoop - square-scoop
		     ?ddcu - dc-to-dc-converter-unit)
    :condition (and 
		;;(at start (forall (?h - (or oru-bag crew-lock-bag))
		;;		      (not (contained_by ?scoop ?h))))
		    (at start (= (possessed_by ?scoop) ?ev))
		    (at start (= (located ?ev)(located ?ddcu)))
		    )
    :effect (and (at end (install-scoop_a ?ev ?scoop ?ddcu))
		 (at end (contains ?ddcu ?scoop))
		 (at end (not (possesses ?ev ?scoop)))
		 (at end (not (available ?scoop)))
		 )
    :comment "someone bolts scoop onto the ddcu")

;;; Another way is if an ev at the ddcu site has a container that has the scoop
(define (durative-action Install-scoop-from-container)
    :parameters (?ev - crew
		     ?scoop - square-scoop
		     ?ddcu - dc-to-dc-converter-unit)
    :vars (?h - (contained_by ?scoop))
    :condition (and (at start (= (possessed_by ?h) ?ev))
		    (at start (= (located ?ev)(located ?ddcu)))
		    )
    :effect (and (at end (Install-scoop-from-container_a ?ev ?scoop ?ddcu))
		 (at end (not (available ?scoop)))
		 (at end (contains ?ddcu ?scoop))
		 (at end (not (contains ?h ?scoop))))
    :comment "someone takes a scoop out of the container and bolts it onto the ddcu")

;;;
;;; Once you have an apfr installed, you can Ingress an arm or a cart
;;;
;;; 01/15/10 Going to have to model this with safety tether swapping eventually.
(define (durative-action Ingress-transport)
    :parameters (?ev - crew
		     ?transport - (or robotic-arm ceta-cart)
		     ?apfr - articulating-portable-foot-restraint
		 )
    :duration 5.0
    :vars (?holder - (or workplace-interface wif-adapter))
    :condition (and (at start (= (contained_by ?holder) ?transport))
		    (at start (= (contained_by ?apfr) ?holder))
		    (at start (= (located ?ev)(located ?transport)))
		    (at start (available ?apfr))) 
    :effect (and (at end (on ?ev ?transport))
		 (at end (not (available ?apfr))))
    :comment "?ev gets on the ?apfr on the ?transport"
    )

(define (durative-action Ingress-crew-test)
    :parameters (?transport - (or robotic-arm ceta-cart))
    :vars (?ev - crew)
    :expansion (sequential (on ?ev ?transport))
    :effect (at end (transport-loaded ?transport))
    )
    
;;; So now, a crew can get on an arm or a cart by installing an apfr and getting on,
;;; or by installing a wif or wifa then apfr then getting on.
(define (durative-action Ingress-cart)
    :parameters (?ev - crew 
		     ?cart - ceta-cart)
    :vars (?apfr - articulating-portable-foot-restraint
		 ?l - (located ?cart))
    :condition (at start (= (possessed_by ?apfr) ?ev))
    :expansion (sequential 
		(located ?ev ?l)
		(installed ?apfr)
		(on ?ev ?cart))
    :effect (at end (ingressed ?ev ?cart))
    )

(define (durative-action Ingress-arm)
    :parameters (?ev - crew 
		     ?arm - robotic-arm)
    :vars (?apfr - articulating-portable-foot-restraint
		 ?l - (located ?arm)
		 ?wifa - wif-adapter)
    :condition (and (at start (not (= (operator ?arm) ?ev)))
		    (at start (= (possessed_by ?wifa) ?ev))
		    (at start (= (possessed_by ?apfr) ?ev))
		    )
    :expansion (sequential 
		(located ?ev ?l)
		(installed ?wifa)
		(installed ?apfr)
		(on ?ev ?arm))
    :effect (at end (ingressed ?ev ?arm))
    )

;;;
;;; Traveling
;;;

(defun time-from-path (action)
  (let ((path (gsv action '?path)))
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> Path is ~a.~%~%" (name path))
    (case (name path)
      ((P1-NADIR-BAY12-TO-PORT-CETA-CART-LOC PORT-CETA-CART-LOC-TO-P1-NADIR-BAY12)
       5.0)
      ((AIRLOCK-TO-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC-TO-AIRLOCK)
       10.0)
      ((AIRLOCK-TO-CETA-cart-LOC1 ceta-cart-loc1-AIRLOCK)
       8.0)
      ((AIRLOCK-TO-ssrms-loc1 ssrms-loc1-to-AIRLOCK)
       12.0)
      (otherwise 10.0))))

;;; Can't use ?start-loc - (located ?ev) because problem one-to-loc fails.

(define (durative-action Translate-by-handrail)
    :parameters (?ev - crew
		 ?end-loc - location)
    :vars (?path - path
		 ?start-loc - (start-loc ?path))
    :condition (and 
		(at start (end-loc ?path ?end-loc))
		(at start (not (too-far ?path)))
		(at start (not (= ?start-loc ?end-loc)))
		(at start (located ?ev ?start-loc))
;;		(at start (forall (?t - (or robotic-arm ceta-cart))
;;				  (not (on ?ev ?t))))
;;		(over all (start-loc ?path ?start-loc))
		;;; greater than 85'
		)
    :effect (at end (located ?ev ?end-loc))
    :duration time-from-path
    :execute (print (list "TRANSLATING BY HANDRAIL!!!" ?ev ?start-loc ?end-loc))
    :comment "?ev travels by handrail from ?start-loc to ?end-loc over ?path")

(define (durative-action Translate-by-handrail-test)
    :parameters (?end-loc - location)
    :vars (?ev - crew)
    :expansion (sequential (located ?ev ?end-loc))
    :effect (at end (crew-traveled-to ?end-loc))
    )

;; If the distance is too far, we must execute  tether swap.

;; A simple swap if the 2nd tether is already installed at the location.
;; The end of the first tether is connected to the 2nd tether.
;; Sometimes the second tether is already at the loc.
(define (durative-action tether-swap)
    :parameters (?ev - crew
		     ?st1 ?st2 - safety-tether)
    :vars (?l - (located ?ev)
	      ?stp - safety-tether-pack)
    :condition (and (at start (not (= ?st1 ?st2)))
		    (at start (tethered_to ?st1 ?ev))
		    (at start (located ?st2 ?l))
		    (at start (not (tethered_to ?st2 ?ev)))
		    (at start (not (contained_by ?st2 ?stp)))
		    ;;;(available ?st2)
		    )
    :effect (and (at end (tethered_to ?st2 ?ev))
		 (at end (tether-swapped ?ev ?st1))) ;; needed for decomps
    :duration 2
    :comment "?ev swaps one tether for another in place.")

;;; Now going back the other way, we swap a tether with the one we left there.
(define (durative-action tether-swap-back)
    :parameters (?ev - crew
		     ?st2 ?st1 - safety-tether)
    :vars (?l - (located ?ev))
    :condition (and (at start (not (= ?st1 ?st2)))
		    (at start (tethered_to ?st1 ?ev))
		    (at start (tethered_to ?st2 ?ev))
		    (at start (located ?st2 ?l)))
    :effect (and (at end (tethered_to ?st2 nobody))
		 (at end (tether-swapped ?ev ?st2))) ;; needed for decomps
    :duration 2
    :comment "?ev swaps second tether for the first one in place.")

;; Sometimes the ev carries the 2nd tether in a safety-tether-pack (STP)
(define (durative-action install-tether&swap)
    :parameters (?ev - crew
		     ?st1 ?st2 - safety-tether)
    :vars (?l - (located ?ev)
	      ?stp - safety-tether-pack)
    :condition (and (at start (not (= ?st1 ?st2)))
		    (at start (tethered_to ?st1 ?ev))
		    (at start (contains ?stp ?st2))
		    (at start (located ?stp ?l)) ;; trying to avoid possesses here
		    )
    :effect (and (at end (not (contains ?stp ?st2)))
		 (at end (tethered_to ?st2 ?ev))
		 (at end (located ?st2 ?l))
		 (at end (tether-swapped ?ev ?st1)))
    :duration 5
    :comment "?ev installs a second tether and then swaps his current tether for the new one.")

;;; Now going back the other way, we swap tethers and pick up the one we brought
(define (durative-action tether-swap&pick-up)
    :parameters (?ev - crew
		     ?st2 ?st1 - safety-tether)
    :vars (?l - (located ?ev)
	      ?STP - safety-tether-pack)
    :condition (and (at start (tethered_to ?st2 ?ev))
		    (at start (tethered_to ?st1 ?ev))
		    (at start (located ?stp ?l));; avoiding the possession here
		    (at start (not (contains ?stp ?st2))))
    :effect (and (at end (tethered_to ?st2 nobody))
		 (at end (contains ?STP ?st2)) 
		 (at end (tether-swapped ?ev ?st2)))
    :duration 5
    :comment "?ev swaps his current tether for the old one then picks up the old one.")

(define (durative-action Translate-by-hr&swap)
    :parameters (?ev - crew
		 ?end-loc - location)
    :vars (?path - path
		 ?start-loc - (start-loc ?path)
		 ?mloc - (intermediate-loc-for ?path)
		 ?st - safety-tether)
    :condition (and 
		(at start (too-far ?path))
		(at start (not (= ?start-loc ?end-loc)))
		(at start (located ?ev ?start-loc))
		(at start (tethered_to ?st ?ev))
;;		(at start (forall (?t - (or robotic-arm ceta-cart))
;;				  (not (on ?ev ?t))))
;;		(over all (start-loc ?path ?start-loc))
		(at start (end-loc ?path ?end-loc))
;;;		(at start (intermediate-loc-for ?path ?mloc))
		)
    :expansion (sequential
		(located ?ev ?mloc)
		(tether-swapped ?ev ?st)
		(located ?ev ?end-loc)
		)
    :effect (at end (located ?ev ?end-loc))
    :duration time-from-path
    :comment "?ev travels by handrail to ?end-loc over ?path via ?mloc")

;; so now a crew can travel to an item and retrieve it...
(define (durative-action Retrieve-item)
    :parameters (?ev - crew
		     ?item - (or ceta-light 
			     control-panel-assembly
			     qtr-inch-power-cable
				 space-positioning-device))
    :vars (?container - (or oru-bag fish-stringer)
		?loc - (located ?item))
    :expansion (sequential
		;;;(possessed_by ?container ?ev)
		(possesses ?ev ?container)
		(located ?ev ?loc)
		(extracted-item-to ?ev ?item ?container)
		)
    :effect (at end (retrieve-item_a ?ev ?item))
    :comment "?ev picks up ?container, travels to ?item's loc, unmounts and stores ?item in ?container and returns.")

;;; Used for the pride demo
(define (durative-action Retrieve-item2)
    :parameters (?ev - crew
		     ?item - ceta-light
		     )
    :vars (?container - (bag-size-for ?item)
		      ?loc - (located ?item))
    :condition (at start (located ?ev airlock))
    :expansion (sequential
		;;;(possessed_by ?container ?ev) ;;; for the PRIDE demo
		(possesses ?ev ?container)
		(located ?ev ?loc)
		(extracted-item-to ?ev ?item ?container)
		(located ?ev airlock)
		(located ?item INTRA-VEHICLE)
		)
    :effect (at end (retrieve-and-stow ?ev ?item))
    :comment "?ev picks up ?container, travels to ?item's loc, unmounts and stores ?item in ?container and returns.")

 ;;; ... with a tether swap if need be
#|
(define (durative-action Retrieve-item-with-swap)
    :parameters (?ev - crew
		     ?item - (or ceta-light 
			     control-panel-assembly
			     qtr-inch-power-cable
				 space-positioning-device))
    :vars (?container - (or oru-bag fish-stringer)
		      ?loc - (located ?item)
		      ?stp - safety-tether-pack)
    :expansion (sequential
		(possesses ?ev ?container)
		(possesses ?ev ?stp)
		(located ?ev ?loc)
		(extracted-item-to ?ev ?item ?container)
		;;(located ?ev airlock)
		)
    :effect (at end (retrieve-item_a ?ev ?item))
    :comment "?ev picks up ?container, travels to ?item's loc, unmounts and stores ?item in ?container and returns.")
|#

(defun time-for-transport (action)
  (let ((end (gsv action '?end-loc)))
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> End is ~a.~%~%" (name end))
    (case (name end)
      (CETA-CART-LOC1
       10.0)
      (otherwise 15.0))))

(define (durative-action Translate-by-transport)
    :parameters (?ev - crew
		 ?end-loc - location)
    :vars (?start-loc - location
		 ?transport - (or robotic-arm ceta-cart))
    :condition (and 
		(at start (located ?transport ?start-loc))
		(over all (on ?ev ?transport))
		(at start (can-reach ?transport ?end-loc))
		)
    :effect (at end (located ?ev ?end-loc))
    :duration time-for-transport
    :comment "?ev travels on ?transport from ?start-loc to ?end-loc")

(define (durative-action ssrms-trans-test)
    :parameters (?ev - crew
		     ?l - location)
    :vars (?arm - robotic-arm)
    :expansion (sequential
		(on ?ev ?arm)
		(located ?ev ?l))
    :effect (at end (ssrms-trans ?ev ?l)))
		

(define (durative-action ssrms-trans-test)
    :parameters (?ev - crew
		     ?l - location)
    :vars (?arm - robotic-arm)
    :expansion (sequential
		(ingressed ?ev ?arm)
		(located ?ev ?l))
    :effect (at end (ssrms-trans ?ev ?l)))

(define (durative-action go-install-item)
    :parameters (?ev - crew
		     ?item - (or ceta-light 
				 control-panel-assembly
				 qtr-inch-power-cable))
    :vars (?container - (contained_by ?item)
		      ?loc - (location-for ?item))
    :expansion (sequential
		(possesses ?ev ?container)
		(located ?ev ?loc)
		(installed ?item)
		)
    :effect (at end (install-item_a ?ev ?item))
    :comment "?ev picks up ?container that holds ?item, travels to the item's loc and installs it.")

(define (durative-action install-item-in-place)
    :parameters (?ev - crew
		     ?item - fluid-quick-disconnect-jumper)
    :vars (?loc - (location-for ?item)
		?spd1 ?spd2 - space-positioning-device
		?container - (contained_by ?spd1))
    :condition (and (at start (not (= ?spd1 ?spd2)))
		    (at start (= (contained_by ?spd2) ?container)))
    :expansion (sequential
		(possesses ?ev ?container)
		(located ?ev ?loc)
		(installed ?item)
		)
    :effect (at end (install-item_a ?ev ?item))
    :comment "?ev picks up ?container that holds ?item, travels to the item's loc and installs it.")

(define (durative-action retrieve-install-item)
    :parameters (?ev - crew
		     ?item - (or ceta-light 
				 control-panel-assembly
				 qtr-inch-power-cable
				 space-positioning-device))
    :expansion (sequential
		(retrieve-item_a ?ev ?item)
		(install-item_a ?ev ?item)
		)
    :effect (at end (retrieve-install-item_a ?ev ?item))
    :comment "?ev picks up ?container that holds ?item, travels to the item's loc and installs it.")

;;; -------------------------------------------------------------------
;;; Moving the arm (ground controlled approach)
;;; -------------------------------------------------------------------

(defun time-for-arm (action)
  (let ((start (name (gsv action '?start-loc)))
	(end (name (gsv action '?end-loc))))
    (format t "~%~%>>>>>>>>>>>>>>>>>>>> start, end = ~a,~a.~%~%" start end)
    (if (and (eq start 'ssrms-loc1)(eq end 'AIRLOCK))
	5.0
      7.0)))

(define (durative-action gca-arm)
    :parameters (?arm - robotic-arm
		     )
    :vars (?ev - crew
	       ?start-loc - (located ?arm) ;;; used by time-for-arm
	       ?end-loc - (located ?ev)
	       )
    :condition (and (at start (not (operator ?arm nobody))) 
		    (at start (can-reach ?arm ?end-loc)))
    :effect (at end (located ?arm ?end-loc))
    :duration time-for-arm
    :comment "?ev  guides arm (ground controlled approach = talking to iv over radio link) to end-loc")

;;; 12/17/10 The above says anyone can gca the arm to where they are.
;;; But we want to be able to guide the arm to a given ev.
(define (durative-action gca-arm-to-ev)
    :parameters (?ev - crew 
		     ?arm - robotic-arm)
    :vars (?start-loc - (located ?arm) ;;; used by time-for-arm
           ?end-loc - (located ?ev))
    :condition (and (at start (not (operator ?arm nobody))) ;;; someone can operatie the arm 
		    (at start (can-reach ?arm ?end-loc)))
    :effect (and (at end (arm-guided-to ?ev ?arm))
		 (at end (located ?arm ?end-loc)))
    :duration time-for-arm
    :comment "?ev  guides arm (ground controlled approach = talking to iv over radio link) to end-loc")

 ;;; Here's an alternative to going to the arm -- bring the arm to you.
(define (durative-action gca&Ingress-arm)
    :parameters (?ev - crew 
		     ?arm - robotic-arm)
    :vars (?apfr - articulating-portable-foot-restraint
		 ?l - (located ?ev)
		 ?wifa - wif-adapter)
    :condition (and (at start (= (possessed_by ?wifa) ?ev))
		    (at start (= (possessed_by ?apfr) ?ev))
		    )
    :expansion (sequential 
		(located ?arm ?l)
		(installed ?wifa)
		(installed ?apfr)
		(on ?ev ?arm))
    :effect (at end (ingressed ?ev ?arm))
    )

;;;***************************************************************
;;; DDCU stuff
;;;***************************************************************

;;; An ev can carry a ddcu on a body restraint tether (BRT).
;;; This positions anything that can be tethered, including bags
;;; A spare-ddcu is carried on a stanchion mount cover, so if you position
;;; the cover and it contains the ddcu, then you should position
;;; the ddcu.

(define (durative-action position-item)
    :parameters (?ev - crew
		     ?item - (or ceta-light 
				 control-panel-assembly
				 stanchion-mount-cover 
				 equipment
				 (not space-positioning-device))
		     ?loc - location)
    :condition (at start (not (= (located ?item) INTRA-VEHICLE)))
    :expansion (sequential
		(possesses ?ev ?item)
		(located ?ev ?loc)
		(not (possesses ?ev ?item))
		)
    :effect (at end (position-item_a ?ev ?item ?loc))
    :comment "?ev picks up ?item, goes to the loc and tethers it there.")

(define (durative-action position-item-test)
    :parameters (?item - (or ceta-light 
				 control-panel-assembly
				 stanchion-mount-cover 
				 equipment
				 (not space-positioning-device))
		       ?loc - location)
    :vars (?ev - crew)
    :expansion (sequential (position-item_a ?ev ?item ?loc))
    :effect (at end (position-item-test ?item ?loc))
    )

(define (durative-action ddcu-r&r-prep)
    :parameters (?ev - crew 
		     ?item - dc-to-dc-converter-unit)
    :vars (?ddcu-spare - dc-to-dc-converter-unit
		       ?loc - (location-for ?item)
		       ?scoop - square-scoop
		       ?bag - (contained_by ?scoop)
		       ?cover - stanchion-mount-cover
		       )
    :condition (and (at start (available ?ddcu-spare))
		    (at start (= (contained_by ?ddcu-spare) ?cover)))
    :expansion
    (sequential
     (possesses ?ev ?bag)
     (position-item_a ?ev ?cover ?loc)
     (install-scoop-from-container_a ?ev ?scoop ?ddcu-spare)
     (possesses ?ev ?cover) )
    :effect (at end (site-prepped-for-r&r ?ev ?item))
    :comment "?ev picks up scoop and spare ddcu, goes to ddcu loc puts down the spare and installs the scoop on it")

(define (durative-action r&r-prep-test)
    :parameters (?item - dc-to-dc-converter-unit)
    :vars (?ev - crew)
    :expansion
    (sequential
     (site-prepped-for-r&r ?ev ?item))
    :effect (at end (site-prep-tested ?item)))
;;;
;;; Stanchion mount covers.  Modeled as a container.
;;; One is on the spare ddcu in the IS. 
;;;

(define (durative-action Present-item)
    :parameters (?ev - crew
		     ?item - dc-to-dc-converter-unit
		     )
    :duration 2.0
    :effect (at end (present-item_a ?ev ?item))
    :comment "?ev holds item out for someone to take or install something on")

(define (durative-action Remove-from-cover)
    :parameters (?ev - crew
		     ?item - dc-to-dc-converter-unit
		     ?cover - cover)
    :duration 2.0
    :effect (at end (remove-from-cover_a ?ev ?item ?cover))
    :comment "?ev takes ?item off ?cover.")

(define (durative-action Attach-to-cover)
    :parameters (?ev - crew
		     ?item - dc-to-dc-converter-unit
		     ?cover - cover)
    :duration 2.0
    :effect (at end (Attach-to-cover_a ?ev ?item ?cover))
    :comment "?ev puts ?item on ?cover.")

(define (durative-action take-ddcu-off-cover)
    :parameters (?receiver - crew
			   ?ddcu - dc-to-dc-converter-unit
		     ?cover - stanchion-mount-cover)
    :vars (?presenter - (possessed_by ?cover)
		      ?l - location
		      ?scoop - square-scoop
		  )
    :condition (and (at start (= (contained_by ?ddcu) ?cover)) ;; presenter grips
		    (at start (= (contained_by ?scoop) ?ddcu)) ;; receiver grips
		    (at start (located ?receiver ?l))
		    (at start (located ?presenter ?l))
		    )
    :expansion (simultaneous
		(present-item_a ?presenter ?ddcu)
		(remove-from-cover_a ?receiver ?ddcu ?cover)
		)
    :effect (and (at end (take-ddcu-off-cover_a ?receiver ?ddcu ?cover))
		 (at end (not (contains ?cover ?ddcu)))
		 (at end (not (possesses ?presenter ?ddcu))) ;;;shouldn't need since the cover doesn't contain it
		 (at end (possesses ?receiver ?ddcu))
		 )
    :comment "?presenter presents ?ddcu to ?receiver who removes it from ?cover.")

(define (durative-action take-ddcu-off-test)
    :parameters (?receiver - crew 
		 ?ddcu - dc-to-dc-converter-unit)
    :expansion (sequential (possesses ?receiver ?ddcu))
    :effect (at end (take-off-cover-test ?ddcu)))
 
(define (durative-action put-cover-on-ddcu)
    :parameters (?receiver - crew
			   ?ddcu - dc-to-dc-converter-unit
			   ?cover - stanchion-mount-cover)
    :vars (?presenter  - (possessed_by ?ddcu)
		  ?l - (located ?receiver) ;;location
		  ?scoop - square-scoop
		  )
    :condition (and (at start (located ?presenter ?l))
		    (at start (= (contained_by ?scoop) ?ddcu))
		    (at start (possesses ?receiver ?cover))
		    )
    :expansion (simultaneous
		(Present-item_a ?presenter ?ddcu)
		(Attach-to-cover_a ?receiver ?ddcu ?cover)
		)
    :effect (and (at end (put-cover-on-ddcu_a ?receiver ?ddcu ?cover))
		 (at end (contains ?cover ?ddcu))
		 ;;;(at end (possesses ?receiver ?ddcu)) shouldn't be needed because she possesses the cover
		 (at end (not (possesses ?presenter ?ddcu))))
    :comment "?presenter presents ?ddcu to ?receiver who screws on ?cover.")

(define (durative-action put-cover-on-test)
    :parameters (?receiver - crew 
		 ?ddcu - dc-to-dc-converter-unit)
    :expansion (sequential (possesses ?receiver ?ddcu))
    :effect (at end (put-on-cover-test ?ddcu)))

;;; With both evs at the site and the spare prepped, ev1 extracts the old-ddcu (supposedly tethering it to her brt).
;;; Then ev2 gives ev1 the spare using the cover and ev1 temp-installs the 
;;; spare, removing the scoop.  Then ev1 installs the scoop on the old ddcu and hands it over to
;;; the ev2 who puts the cover on it while ev1 holds it and then ev1 releases it.
(define (durative-action ddcu-change-out)
    :parameters (?ev1 - crew
		     ?item - dc-to-dc-converter-unit
		     )
    :vars (?spare - dc-to-dc-converter-unit
		?scoop - square-scoop
		?cover - stanchion-mount-cover
		?ev2 - crew
		;;?ev2 - (possessed_by ?cover) ;;; when I used this  r&r-d2 worked!
		?l - (located ?item))
    :condition (and (at start (not (= ?spare ?item)))
		    (at start (not (= ?ev1 ?ev2)))
		    
;;; these should all be set up by the ddcu-prep
		    (at start (located ?ev2 ?l))
		    (at start (located ?ev1 ?l))
		    (at start (possesses ?ev2 ?cover))
		    (at start (= (contained_by ?scoop) ?spare))
		    (at start (= (contained_by ?spare) ?cover))
		    )
    :expansion (sequential
		(possesses ?ev1 ?item)	;;; ev1 extracts the old ddcu
		(take-ddcu-off-cover_a ?ev1 ?spare ?cover) ;;; ev2 presents spare and ev1 removes it from the cover
		(inserted-item ?ev1 ?spare) ;;; ev1 inserts and takes scoop off spare
		(put-cover-on-ddcu_a ?ev2 ?item ?cover) ;;;ev1 presents ev2 puts cover on
		(installed-item ?ev1 ?spare) ;; ev1 bolts it down
		)
    :effect (at end (replaced ?ev1 ?item))
    :comment "evs extract the ddcu, install the spare and bolt it down"
    )

 ;;; Problem change-out-d2 fails in put-cover-on-ddcu on the PC (at start (= (possesses ?presenter) ?ddcu))
;;; But problem change-out-d gets a plan (see action ddcu-change-out above), the only difference being that
;;; ev is var, not a parameter in the former.
(define (durative-action ddcu-change-out-test)
    :parameters (?ddcu - dc-to-dc-converter-unit)
    :vars (?ev - crew)
    :expansion (sequential (replaced ?ev ?ddcu))
    :effect (at end (ddcu-changed-out ?ddcu))
    
    )

;;; Now put the prep and change out together
(define (durative-action ddcu-r&r0)
    :parameters (?ev1 ?ev2 - crew
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?l - (located ?ddcu))
    :condition (at start (not (= ?ev1 ?ev2)))
    :expansion (sequential 
		(site-prepped-for-r&r ?ev1 ?ddcu)
		(located ?ev2 ?l)
		(replaced ?ev2 ?ddcu))
    :effect (at end (ddcu-replaced ?ev1 ?ev2 ?ddcu))
    )

(define (durative-action ddcu-r&r1)
    :parameters (?ev2 - crew
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?ev1 - crew
		?l - (located ?ddcu))
    :condition (at start (not (= ?ev1 ?ev2)))
    :expansion (sequential 
		(site-prepped-for-r&r ?ev1 ?ddcu)
		(located ?ev2 ?l)
		(replaced ?ev2 ?ddcu))
    :effect (at end (remove&replace_a ?ev2 ?ddcu))
    )

 ;;; Prob R&R-D2 fails but R&R-D gets a plan.  The only diff is
;;; that the evs are params in the latter, not vars
(define (durative-action ddcu-r&r2)
    :parameters (?ddcu - dc-to-dc-converter-unit)
    :vars (?ev1 ?ev2 - crew
		?l - (located ?ddcu))
    :condition (at start (not (= ?ev1 ?ev2)))
    :expansion (sequential 
		(site-prepped-for-r&r ?ev1 ?ddcu)
		(located ?ev2 ?l)
		(replaced ?ev2 ?ddcu))
    :effect (at end (ddcu-replaced2 ?ddcu))
    )

;;;
;;; Putting the ddcu stuff altogether
;;;

(define (durative-action Egress-agents-and-r&r)
    :parameters (?ev1 ?ev2 - crew
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?arm - robotic-arm
		  ?scoop - square-scoop
		  ?bag  - (contained_by ?scoop)
		  ?spare - dc-to-dc-converter-unit
		  ?cover - stanchion-mount-cover)
    :condition (and (at start (not (= ?ev1 ?ev2)))
		    (at start (not (= (operator ?arm) ?ev1))) 
		    (at start (not (= (operator ?arm) ?ev2)))
		    (at start (not (= ?ddcu ?spare)))
		    (at start (= (contained_by ?spare) ?cover))
		    )
    :expansion (sequential
		(located ?ev1 airlock) ;; get first guy outside
		(located ?bag AIRLOCK) ;; get bag with the scoop outside
		(located ?cover AIRLOCK) ;;
		(located ?ev2 airlock)
		(parallel
		 (prepare-for-eva_a ?ev1)
		 (prepare-for-eva_a ?ev2))
		(possesses ?ev2 ?bag)
		(possesses ?ev2 ?cover)
		(ddcu-replaced ?ev2 ?ev1 ?ddcu)
		(parallel
		 (located ?ev2 AIRLOCK)
		 (located ?ev1 AIRLOCK))
		(located ?ev1 INTRA-VEHICLE)
		(located ?ddcu INTRA-VEHICLE)
		(located ?ev2 INTRA-VEHICLE)
		(locked HATCH)
		(parallel
		 (prepare-for-repress_a ?ev1)
		 (prepare-for-repress_a ?ev2))
		 )
    :effect (at end (did-ddcu ?ev1 ?ev2 ?ddcu))
    :comment "Get crew and bag out, then go replace ddcu")

(define (durative-action Egress-agents-and-r&r1)
    :parameters (?ev1  - crew
		       ?ddcu - dc-to-dc-converter-unit)
    :vars (?ev2 - crew
		?scoop - square-scoop
		?arm - robotic-arm
		?bag  - (contained_by ?scoop)
		?spare - dc-to-dc-converter-unit
		?cover - stanchion-mount-cover)
    :condition (and (at start (not (= ?ev1 ?ev2)))
		    (at start (not (= (operator ?arm) ?ev1))) 
		    (at start (not (= (operator ?arm) ?ev2)))
		    (at start (not (= ?ddcu ?spare)))
		    (at start (= (contained_by ?spare) ?cover))
		    )
    :expansion (sequential
		(located ?ev1 airlock) ;; get first guy outside
		(located ?bag AIRLOCK) ;; get bag with the scoop outside
		(located ?cover AIRLOCK) ;;
		(located ?ev2 airlock)
		(parallel
		 (prepare-for-eva_a ?ev1)
		 (prepare-for-eva_a ?ev2))
		(possesses ?ev2 ?bag)
		(possesses ?ev2 ?cover)
		(ddcu-replaced ?ev2 ?ev1 ?ddcu)
		(parallel
		 (located ?ev2 AIRLOCK)
		 (located ?ev1 AIRLOCK))
		(located ?ev1 INTRA-VEHICLE)
		(located ?ddcu INTRA-VEHICLE)
		(located ?ev2 INTRA-VEHICLE)
		(locked HATCH)
		(parallel
		 (prepare-for-repress_a ?ev1)
		 (prepare-for-repress_a ?ev2))
		)
    :effect (at end (did-ddcu1 ?ev1 ?ddcu))
    :comment "Get crew and bag out, then go replace ddcu")

(define (durative-action Egress-agents-and-r&r2)
    :parameters (?ddcu - dc-to-dc-converter-unit)
    :vars (?ev1 ?ev2 - crew
		?scoop - square-scoop
		?arm - robotic-arm
		?bag  - (contained_by ?scoop)
		?spare - dc-to-dc-converter-unit
		?cover - stanchion-mount-cover)
    :condition (and (at start (not (= ?ev1 ?ev2)))
		    (at start (not (= (operator ?arm) ?ev1))) 
		    (at start (not (= (operator ?arm) ?ev2)))
		    (at start (not (= ?ddcu ?spare)))
		    (at start (= (contained_by ?spare) ?cover))
		    )
    :expansion (sequential
		(located ?ev1 airlock) ;; get first guy outside
		(located ?bag AIRLOCK) ;; get bag with the scoop outside
		(located ?cover AIRLOCK) ;;
		(located ?ev2 airlock)
		(parallel
		 (prepare-for-eva_a ?ev1)
		 (prepare-for-eva_a ?ev2))
		(possesses ?ev2 ?bag)
		(possesses ?ev2 ?cover)
		(ddcu-replaced ?ev2 ?ev1 ?ddcu)
		(parallel
		 (located ?ev2 AIRLOCK)
		 (located ?ev1 AIRLOCK))
		(located ?ev1 INTRA-VEHICLE)
		(located ?ddcu INTRA-VEHICLE)
		(located ?ev2 INTRA-VEHICLE)
		(locked HATCH)
		(parallel
		 (prepare-for-repress_a ?ev1)
		 (prepare-for-repress_a ?ev2))
		)
    :effect (at end (did-ddcu2 ?ddcu))
    :comment "Get crew and bag out, then go replace ddcu")

(DEFINE (DURATIVE-ACTION DO-JOBS) 
    :PARAMETERS (?AGENT1 ?AGENT2 - CREW) 
    :VARS (?ARM - ROBOTIC-ARM 
		?STP1 ?STP2 - SAFETY-TETHER-PACK 
		?BAG
		- MEDIUM-ORU-BAG 
		;;;?PHALCON - PHALCON
		)
    :CONDITION
    (AND (AT START (NOT (= ?AGENT1 ?AGENT2)))
	 (AT START (NOT (= (OPERATOR ?ARM) ?AGENT1)))
	 (AT START (NOT (= (OPERATOR ?ARM) ?AGENT2)))
	 (AT START (LOCATED ?AGENT1 INTRA-VEHICLE))
	 (AT START (LOCATED ?AGENT2 INTRA-VEHICLE))
	 (POSSESSES ?AGENT1 ?STP1) (POSSESSES ?AGENT2 ?STP2)
	 (OVER ALL (BAG-SIZE-FOR CETA-LIGHT1 ?BAG)))
    :EXPANSION
    (SEQUENTIAL	;;;(LOCK_SARJ_A ?PHALCON SARJ-PORT)
     (LOCATED ?AGENT1 AIRLOCK) 
     (LOCATED ?BAG AIRLOCK)
     (LOCATED ?AGENT2 AIRLOCK)
     (PARALLEL (PREPARE-FOR-EVA_A ?AGENT1) 
	       (PREPARE-FOR-EVA_A ?AGENT2))
     (RETRIEVE-ITEM_A ?AGENT1 CETA-LIGHT1)
     (PARALLEL (LOCATED ?AGENT2 P3-P4-JUNCTURE)
	       (LOCATED ?AGENT1 P3-P4-JUNCTURE))
     (REROUTED ?AGENT2 NH3-JUMPER-P3-P4)
     (PARALLEL ;;;(RECOVER-TO-MODE_A ?PHALCON SARJ-PORT)
      (LOCATED ?AGENT1 AIRLOCK) (LOCATED ?AGENT2 AIRLOCK))
     (LOCATED ?AGENT2 INTRA-VEHICLE) (LOCATED ?BAG INTRA-VEHICLE)
     (LOCATED ?AGENT1 INTRA-VEHICLE) (LOCKED HATCH)
     (PARALLEL (PREPARE-FOR-REPRESS_A ?AGENT1)
	       (PREPARE-FOR-REPRESS_A ?AGENT2)))
    :EFFECT (AT END (JOBS-DONE ?AGENT1 ?AGENT2)))


;;;
;;; Vent tool
;;;

#|
The vent tool equipment bag (VTE bag) is out on the P6 truss, past the port sarj, so the ev has to tether swap to get out there.  Also, the phalcon has to stop the sarj rotation before the ev gets to the p3/p4 truss joint.  Once there, the ev has to assemble the vent tool.  This consists of connecting the vent tool extender to the vent tool if it's not already (both are in the VTE bag).  The ev carries a multi-purpose tether end effector (MUT-EE see attached jpg) that he attaches to a handrail. The MUT-EE is a sort of portable workstation interface (wif).  One end of the vent tool is inserted into the MUT-EE.  Also in the VTE bag is a vent tool adapter that allows one to connect the vent tool to a gas line.  The ev has to connect that to the other end of vent tool and at that point the vent tool is ready for use.
|#

;;; The vent tool extender is attached to the vent tool and the edxtender is
;;; attached to the mut-ee.  Then an adapter is put on the vent tool QD to be able to
;;; eventually attach to a gas line.

(define (durative-action vent-tool-assemble)
    :parameters (?ev - crew
		      ?vent-tool - vent-tool
		     ?vt-bag - vent-tool-equipment-bag
		 )
    :duration 5.0
    :vars (?holder - multi-use-tether-end-effector
	       ?l - (located ?vt-bag)
	       ?vt-adapter - vent-tool-adapter)
    :condition (and (at start (located ?ev ?l))
		    (at start (= (located ?holder) ?l))
		    (at start (installed ?holder))
		    (at start (= (contained_by ?vent-tool) ?vt-bag))
		    (at start (= (contained_by ?vt-adapter) ?vt-bag)))
    :effect (and (at end (not (contains ?vt-bag ?vent-tool)))
		 (at end (not (contains ?vt-bag ?vt-adapter)))
		 (at end (mated ?vent-tool ?vt-adapter))
		 (at end (assembled ?ev ?vent-tool)))
    :comment "?ev assembles the vtool and adapter."
    )

(define (durative-action vent-tool-setup)
    :parameters (?ev - crew 
		     ?vent-tool - vent-tool)
    :vars (?vt-bag - vent-tool-equipment-bag
		   ?l - (located ?vt-bag)
		   ?holder - multi-use-tether-end-effector
		   )
    :condition (and (at start (contains ?vt-bag ?vent-tool))
		    (at start (possesses ?ev ?holder)))
    :expansion (sequential
		(located ?ev ?l)
		(installed-item ?ev ?holder) ;;; (installed ?holder) doesn't work in all plans
		(assembled ?ev ?vent-tool))
    :effect (at end (vent-tool-setup_a ?ev ?vent-tool))
    :comment "go to vent tool and ready it for venting"
    )

(define (durative-action vent-tool-stow)
    :parameters (?ev - crew
		      ?vent-tool - vent-tool
		     ?vt-bag - vent-tool-equipment-bag
		 )
    :duration 5.0
    :vars (?holder - multi-use-tether-end-effector
	       ?l - (located ?vt-bag)
	       ?vt-adapter - vent-tool-adapter)
    :condition (and (at start (located ?ev ?l))
		    (at start (= (located ?holder) ?l))
		    (at start (mated ?vent-tool ?vt-adapter)))
    :effect (and (at end (contained_by ?vent-tool ?vt-bag))
		 (at end (contained_by ?vt-adapter ?vt-bag))
		 (at end (not (mated ?vent-tool ?vt-adapter)))
		 (at end (disassembled ?ev ?vent-tool)))
    :comment "?ev disassembles the vtool and adapter."
    )

(define (durative-action vent-tool-clean-up)
    :parameters (?ev - crew 
		     ?vent-tool - vent-tool)
 ;;; there's only one but we need to link the bag with the tool someday
    :vars (?vte-bag - vent-tool-equipment-bag
		    ?l - (located ?vte-bag)
	      ?holder - multi-use-tether-end-effector
	      )
    :expansion (sequential
		(possesses ?ev ?holder) ;; extract the mut-ee
		(located ?ev ?l);; go to the bag
		(disassembled ?ev ?vent-tool))
    :effect (and (at end (contained_by ?vent-tool ?vte-bag))
		 (at end (vent-tool-clean-up_a ?ev ?vent-tool)))
    :comment "go to vent tool bag and tear down the vent tool and stow"
    )

(define (durative-action Egress-and-setup-vt)
    :parameters (?vent-tool - vent-tool)
    :vars (?outside-agent - crew
			  ?fc - phalcon 
			  ?arm - robotic-arm ?mut-ee - multi-use-tether-end-effector
			  ?stp - safety-tether-pack) ;;;in case a tether swap is necessary
    :condition (and (at start (possesses ?outside-agent ?mut-ee))
		    (at start (not (= (operator ?arm) ?outside-agent))))
    :expansion (sequential
		(lock_sarj_a ?fc sarj-port) ;; stop the port sarj
		(located ?outside-agent airlock)
		;;(located ?stp AIRLOCK)
		(possesses ?outside-agent ?stp) ;; or we could have bob already have the stp
		(prepare-for-eva_a ?outside-agent)
		(vent-tool-setup_a ?outside-agent ?vent-tool) 
		(located ?outside-agent airlock)
		(located ?outside-agent intra-vehicle))
    :effect (at end (crew-setup-vt_a ?vent-tool))
    :comment "First crew gets out, gets tools and goes and sets up vent tool.")

(define (durative-action Egress-and-setup-vt2)
    :parameters (?outside-agent - crew
		 ?vent-tool - vent-tool)
    :vars (?fc - phalcon 
	       ?arm - robotic-arm
	       ?stp - safety-tether-pack) ;;;in case a tether swap is necessary
    :condition (at start (not (= (operator ?arm) ?outside-agent))) 
    :expansion (sequential
		(lock_sarj_a ?fc sarj-port) ;; stop the port sarj
		(located ?outside-agent airlock)
		;;(located ?stp AIRLOCK)
		(possesses ?outside-agent ?stp) ;; or we could have bob already have the stp
		(prepare-for-eva_a ?outside-agent)
		(vent-tool-setup_a ?outside-agent ?vent-tool) ;; fails in possesses mut-ee
		(located ?outside-agent airlock)
		(located ?outside-agent intra-vehicle))
    :effect (at end (crew-setup-vt2_a ?outside-agent ?vent-tool))
    :comment "First crew gets out, gets tools and goes and sets up vent tool.")


;;;
;;; Filling the Photovoltaic Thermal Control System (PVTCS)
;;;
#| 
The PVTCS cools the photovoltaic modules using ammonia loops.  There are small leaks in the system that 
require its ammonia reservoir to be refilled.  The ammonia tank assembly (ATA)from which the PVTCS is filled 
is on the P1 truss while the PVTCS is out on P6, so the crew has to jumper the P3 end to the air lines that 
extend down the port side of the station (2 evs, 30 minutes), and jumper the p6 end (one ev). Once the 
jumpering is right, the THOR opens the ATA valve (there are two tanks, but we just model one) and everyone
watches for leaks (5 mins -- The THOR watches telemetry for low pressure warnings and the crew looks for 
"snow".) Given there are no leaks, the EV at P6 opens valve that connects to the PVTCS and they wait 10 mins 
to fill the PVTCS reservoir.
|#

;; P3/P4 nh3 jumper reroute
;; One ev goes to P4 inboard bulkhead to get a jumper end
;; and connect it to an outboard panel on P3.  The other ev
;; goes to the P4 radiator sidewall to open a QD.

(define (durative-action install-gas-jumper)
    :parameters (?evp3 - crew
		       ?j - gas-quick-disconnect-jumper) 
    :duration 15.0
    :effect (at end (installed-item-in-place ?evp3 ?j))
    :comment "ev gets nh3 jumper end and connects it to an outboard panel."
    )

(define (durative-action open-qd)
    :parameters (?evp4 - crew
		      ?qd - quick-disconnect)
    :duration 5.0
    :effect (at end (make-open ?evp4 ?qd))
    :comment "ev opens a QD."
    )

;;; This one works in problem jrr (see problems2.pddl)

(define (durative-action p3-p4-nh3-jumper-reroute)
    :parameters (?ev - crew
		     ?jumper - gas-quick-disconnect-jumper)
    :vars (?helper - crew)
    :condition (and (at start (located ?ev p3-p4-juncture))
		    (at start (located ?helper p3-p4-juncture))
		    (at start (not (= ?ev ?helper)))
		    (at start (= ?jumper nh3-jumper-p3-p4)))
    :expansion (parallel
		(installed-item-in-place ?ev ?jumper)
		(make-open ?helper qd15))
    :effect (and (at end (open qd15))
		 (at end (installed ?jumper))
		 (at end (rerouted ?ev ?jumper))
		 ) 
    :comment "joint task to reroute the ammonia jumper at p3-p4")

;; P3/P4 nh3 jumper stow
;; One ev can do this, but I make it the reverse of the above, i.e.,
;; one ev goes to an outboard panel on P3 and disconnects the jumper end
;; and stows it on the inboard bulkhead.
;; The other ev goes to the P4 radiator sidewall to close the QD.

(define (durative-action stow-gas-jumper)
    :parameters (?evp3 - crew
		       ?j - gas-quick-disconnect-jumper) 
    :duration 15.0
    :effect (at end (put-away ?evp3 ?j))
    :comment "ev gets nh3 jumper end from outboard panel and stores it."
    )

(define (durative-action close-qd)
    :parameters (?evp4 - crew
		      ?qd - quick-disconnect)
    :duration 5.0
    :effect (at end (close ?evp4 ?qd))
    :comment "ev closes a QD."
    )

;;; We will use this one for the gui...
(define (durative-action p3-p4-nh3-jumper-stow)
    :parameters (?ev - crew
		     ?jumper - gas-quick-disconnect-jumper)
    :vars (?helper - crew)
    :condition (and (at start (located ?ev p3-p4-juncture))
		    (at start (located ?helper p3-p4-juncture))
		    (at start (not (= ?ev ?helper)))
		    (at start (= ?jumper nh3-jumper-p3-p4)))
    :expansion (parallel
		(put-away ?ev ?jumper)
		(close ?helper qd15))
    :effect (and (at end (not (open qd15)))
		 (at end (not (installed ?jumper)))
		 (at end (stowed ?ev ?jumper))
		 ) 
    :probability 0.45 ;;; just to bow to the next one
    :comment "joint task to stow the ammonia jumper at p3-p4")

;;; 1/6/11  We need ?ev to pick up the sarj bag to save time later.
;;; So I made this action to see if it would happen.
;;; It works, but I can't get a clean graph on the last plan, because it
;;; uses this whole action to establish that the ev already has the sarj bag
;;; before cleaning up the spdm.  So I changed cleanup-for-spdm-lube.

(define (durative-action nh3-jumper-stow-with-pickup)
    :parameters (?ev - crew
		     ?jumper - gas-quick-disconnect-jumper)
    :vars (?helper - crew
		   ?sgun - straight-nozzle-grease-gun
		   ?sarj-bag - (contained_by ?sgun))
    :condition (and (at start (located ?ev p3-p4-juncture))
		    (at start (located ?helper p3-p4-juncture))
		    (at start (located ?sarj-bag p3-p4-juncture))
		    (at start (not (= ?ev ?helper)))
		    (at start (= ?jumper nh3-jumper-p3-p4)))
    :expansion (parallel
		(put-away ?ev ?jumper)
		(close ?helper qd15))
    :effect (and (at end (not (open qd15)))
		 (at end (not (installed ?jumper)))
		 (at end (stowed ?ev ?jumper))
		 (at end (possesses ?ev ?sarj-bag))) 
    :comment "joint task to stow the ammonia jumper at p3-p4")

;; going to have the crew possess the stps at the outset

(define (durative-action Egress-and-reroute)
    :parameters (?outside-agent - crew)
    :vars (?fc - phalcon 
	       ?ev-helper - crew
		       ?power-jumper - qtr-inch-power-cable
		       ?fs - fish-stringer
		       ?arm - robotic-arm
		       )
    :condition (and (at start (not (= ?outside-agent ?ev-helper)))
		    (at start (not (= (operator ?arm) ?outside-agent)))
		    (at start (not (operator ?arm ?ev-helper))))
    :expansion (sequential
		(lock_sarj_a ?fc sarj-port)
		(located ?outside-agent airlock)
		(located ?ev-helper airlock)
		;;		(located ?fs AIRLOCK)
		(parallel
		 (prepare-for-eva_a ?outside-agent)
		 (prepare-for-eva_a ?ev-helper))
		;;		(install-item_a ?outside-agent ?power-jumper)
		;;		(located ?outside-agent airlock)
		(parallel
		 (located ?outside-agent p3-p4-juncture)
		 (located ?ev-helper p3-p4-juncture))
		(rerouted ?outside-agent nh3-jumper-p3-p4)
		(parallel
		 (located ?ev-helper airlock)
		 (vent-tool-setup_a ?outside-agent vent-tool1))
		(located ?outside-agent airlock)
		(recover-to-mode_a ?fc sarj-port)
		)
    :effect (at end (crew-did-reroute ?outside-agent))
    :comment "First crew gets out, gets tools and goes and gets light.")

 ;;; P6 radiator fill
;;; One ev goes to P6 and opens the nh3 QD at the last link to the radiator of the PVTCS.
;;; Other ev goes to P1 and opens the QD to the nh3 tank there.  Then the THOR flight controller 
;;; opens the fluid valve, and the evs watch for leaks. Then the ev at P6 opens the valve to the radiator
;;; and they wait 17 mins for the radiator to be filled.

(define (durative-action leak-check)
    :parameters (?ev - crew)
    :duration 5.0
    :effect (at end (check-for-leaks_a ?ev))
    :comment "wait while observing for leaks."
    )

(define (durative-action configure-ata)
    :parameters (?ev - crew
		     ?vent-or-fill - state)
    :duration 10.0
    :condition (at start (located ?ev p1-ata-panel))
    :effect (and (at end (ata-configuration ?vent-or-fill))
		 (at end (configure_ata_a ?ev ?vent-or-fill))))

(define (durative-action open-final-qds)
    :parameters (?ev - crew
		       ?qds  - gas-qds)
    :vars (?helper - crew
		   ?thor - thor ;;; use ?thor instead of ?fc so it shows up on the GUI
		   )
    :condition (and (at start (installed nh3-jumper-p3-p4))
		    (at start (located ?ev p5-p6-juncture))
		    (at start (located ?helper p1-ata-panel))
		    (at start (not (= ?ev ?helper)))
		    (at start (= ?qds nh3)))
    :expansion (sequential
		(parallel
		 (make-open ?ev qd14)
		 ;;(make-open ?helper qdf185)
		 (configure_ata_a ?helper fill)
		 )
		(open-ata-tank_a ?thor ata1)
		(parallel 
		 (check-for-leaks_a ?ev)
		 (check-for-leaks_a ?helper)))
    :effect (and (at end (open qd14))
		 (at end (open qdf185))
		 (at end (final-qds-opened ?ev ?qds))
		 ) 
    :comment "joint task to open the final qds for filling the P6 radiator")

#|
;;; This fails in prob bob-open-qds in the second located even though (located sally p1-ata-panel) 
;; holds in the IS???
;;; It's the same as the above action but with the locateds as goals rather than pcs.
(define (durative-action open-final-qds)
    :parameters (?ev - crew
		       ?qds  - gas-qds)
    :vars (?helper - crew
		 ?fc - thor)
    :condition (and (at start (not (= ?ev ?helper)))
		    (at start (= ?qds nh3)))
    :expansion (sequential
		(parallel
		 (located ?ev p5-p6-juncture)
		 (located ?helper p1-ata-panel))
		(parallel
		 (make-open ?ev qd14)
		 (make-open ?helper qdf185))
		(open-ata-tank_a ?fc ata1)
		(parallel 
		 (check-for-leaks_a ?ev)
		 (check-for-leaks_a ?helper)))
    :effect (and (at end (open qd14))
		 (at end (open qdf185))
		 (at end (final-qds-opened ?ev ?qds))
		 ) 
    :comment "joint task to open the final qds for filling the P6 radiator")
;;|#

(define (durative-action fill-p6-radiator)
    :parameters (?ev - crew
		      ?rad - radiator
		 )
    :duration 10.0
    :vars (?l - (located ?rad))
    :condition (and (at start (= ?rad p6-radiator))
		    (at start (located ?ev ?l))
		    (at start (open qd14))
		    (at start (ata-configuration fill)))
    :effect (at end (radiator-filled ?ev ?rad))
    :comment "?ev opens the final valve to the radiator. Waits for the fill, then closes it."
    )

(define (durative-action p6-radiator-fill)
    :parameters (?ev - crew ?rad - radiator)
    :vars (?thor - thor)
    :expansion (sequential
		(radiator-filled ?ev p6-radiator)
		(close-ata-tank_a ?thor ata1))
    :effect (at end (p6-radiator-filled ?ev ?rad))
    :comment "two evs at the ends of the nh3 lines, open the final qds and fill the p6 radiator.")

;;; Let's put the reroute and fill together. Crew starts outside a/l
(define (durative-action nh3-reroute&rad-fill)
    :parameters (?ev - crew)
    :vars (?helper - crew
		   ?fc - phalcon ;;; this fails if I use phalcon
		   ?arm - robotic-arm)
    :condition (and (at start (not (= ?ev ?helper)))
		    ;;(at start (= (operator ?arm) ?ev)) removed, per Pete  3/9/2016
		    (at start (not (operator ?arm ?ev)))
		    (at start (not (operator ?arm ?helper)))
		    )
    :expansion (sequential
		(lock_sarj_a ?fc sarj-port)
		(located ?ev airlock)
		(located ?helper airlock)
		(parallel
		 (prepare-for-eva_a ?ev)
		 (prepare-for-eva_a ?helper))
		(parallel
		 (located ?ev p3-p4-juncture)
		 (located ?helper p3-p4-juncture))
		(rerouted ?ev nh3-jumper-p3-p4)
		(parallel
		 (located ?ev p5-p6-juncture)
		 (located ?helper p1-ata-panel))
		(final-qds-opened ?ev nh3)
		(radiator-filled ?ev p6-radiator)
                 ;;;(p6-radiator-filled ?ev)
		(parallel
		 (located ?helper p3-p4-juncture)
		 (located ?ev P6-Z-FACE1))
		(vent-tool-setup_a ?ev vent-tool1) 
		)
    :effect (at end (nh3-reroute&rad-fill_a ?ev))
    :comment "two evs go to the sites and fill the p6 radiator.")


;;;
;;;  Venting after fill
;;;
;;; After the fill, an ev vents first the Early Ammonia Servicer (EAS) jumpers
;;; then the whole NH3 pipeline.  All takes place at/around P6 so I use p6-z-face1
;;; as the place.

(defun time-for-jumper-vent (action)
  (let ((jumper (loop for (pvar . pval) in (ap::bindings action)
		    if (eq pvar '?j) return pval)))
  (print (list "at time for jumper vent " (name (template action)) jumper))
    (case jumper
      (eas-jumper 5.0)
      (otherwise 10.0)))) ;;; p1-p5-jumpers

(define (durative-action jumper-or-line-vent)
    :parameters (?ev - crew
		      ?j - (or gas-quick-disconnect-jumper gas-line)
		     )
    :vars (?l - (located ?j)
	      ?vt - vent-tool)
    :condition (and (at start (located ?ev ?l))
		    (at start (located ?vt ?l)))
    :duration time-for-jumper-vent
    :effect (at end (vented ?ev ?j))
    :comment "ev moves to jumper with vent tool abd vents the line."
    )

(define (durative-action vent-p6)
    :parameters (?ev - crew
		     ?rad - radiator);; just a reference to the jumper set
    :vars (?vt - vent-tool
	       ?l - location)
    :condition (and (at start (= ?rad p6-radiator))
		    (at start (= ?l p6-z-face1)))
    :expansion (sequential
		(possesses ?ev ?vt)
		(located ?ev ?l)
		(vented ?ev eas-jumpers)
		(vented ?ev p1-p5))
    :effect (at end (p6-lines-vented ?ev ?rad)))


;;;
;;; SARJ Lubrication
;;;

;;; The SARJ lubrication consists of a setup, a cover removal, an inspection and the lube
;;; A SARJ bag bundle -- an ORU bag with a SARJ crew lock bag inside -- is stowed on
;;; face P3, face 4.  The setup gets stuff out of the SARJ ORU bag, the cover removal gets
;;; each cover off the ring (there're 6 covers), the inspection consists
;;; of taking pictures and taking samples of the debris on the ring with some numbered EVA wipes,
;;; and the lube is done with a nozzle gun that has to be set up, used and safed.


#|
EV2 The SARJ medium ORU Bag has a set of equipment for the main ev (EV2) to lube the SARJs and also has 
a crew-lock-bag that holds a set of equipment for EV1.  The camera for taking pictures during the 
inspection as well as an extra PGT for EV1 is in the outer ORU bag. Both bags have adjustable equipment
tethers to hold the covers open, a set of wipes to take samples from the rings, and the grease guns 
needed for the lube.

SARJ Medium ORU Bag (bottom to top)
		     Adj Equip Tether (external)
		     RET w/ PIP Pin 
			     PGT [A6, CAL, 30.5]  s/n _______
					     PGT Battery		s/n _______
	 				     7/16 (wobble) Socket-6 ext
		     RET (sm-sm)
			     Large Trash Bag

		     Fish Stringer (1 hook inside bag, 1 outside bag- 
				Tape near hook #1)
			     Hook #1: Adj Equip Tether (2) (covers)
			     Hook #1: Adj Equip Tether  Lg- sm (2) 
					(covers)
			     Hook #2: RET (sm-sm) 
				     Straight-Nozzle Grease Gun 
					     Wire Tie (for tether point)
			     Hook #3: RET (sm-sm) 
				     J-Hook Nozzle Grease Gun
					     Wire Tie (for tether point)
			     Hook #4:  RET (sm-sm)
				     EVA Wipe Caddy 
					     EVA Wipes (6) (dry - numbers 6-12) 
			     Hook #5: EVA Camera w/ Flash bracket 

EV1 SARJ Crewlock Bag (inside ORU bag)
				(integral tether to ORU bag lid tether point)
			     Adj Equip Tether (2)
				(external, use same HR stanchion) (covers)
			     RET (sm-sm) (external) (C/L bag temp stow)
			     Wire Ties (2 - long) (external for grease gun)
				(see picture)
			     RET (sm-sm) (external)
				     Straight-Nozzle Grease Gun (external)
			     RET (sm-sm) (external)
				     J-Hook Nozzle Grease Gun (external)
			     EVA Gap Gauge LEE (int RET)
			     Taped Needle-Nose Pliers (int RET)
			      RET (sm-sm) (4) + (int RET) 
				     EVA Wipes (5) (dry) (number 1-5)
			     CLA Cover MLI (int RET)
			     CLA Cover 



|#
;;; First the setup. Basically this just makes all the tools available outside 
;;; of the bags.  So I just make a bunch of setup states that preconditionalize
;;; the other ops,

(define (durative-action sarj-lube-setup-aux)
    :parameters (?ev - crew 
		     ?sarj - solar-array-rotating-joint)
    :vars (?sarj-bag - medium-oru-bag
		     ?loc - (lube-location ?sarj)
		     ?wipes - wipe-set
		     ?sgun - straight-nozzle-grease-gun
		     ?jgun - j-hook-nozzle-grease-gun)
;;; Once the sarj bag is located, all the tools and equipment are located.  See the phalcon-eva sit.
    :condition (and (at start (located ?ev ?loc))
		    (at start (located ?sarj-bag ?loc))
		    (at start (contained_by ?wipes ?sarj-bag))
		    (at start (contained_by ?sgun ?sarj-bag))
		    (at start (contained_by ?jgun ?sarj-bag)))
    :duration 15.0
    :effect (and (at end (adjustable-tethers-ready-at ?sarj))
		 (at end (wipes-ready-at ?sarj))
		 (at end (grease-guns-ready-at ?sarj))
		 (at end (lube-setup-for ?ev ?sarj))))

;;; 12/17/10 we need the sarj-bag to be carried and put down,
;;; so that another ev can pick it up later.
(define (durative-action sarj-lube-setup)
    :parameters (?ev - crew 
		     ?sarj - solar-array-rotating-joint)
    :vars (?loc - (lube-location ?sarj)
		?wipes - wipe-set
		?sarj-bag - (contained_by ?wipes))
    :condition (at start (possesses ?ev ?sarj-bag))
    :expansion
    (sequential
     (located ?ev ?loc)
     (not (possesses ?ev ?sarj-bag))
     (lube-setup-for ?ev ?sarj))
    :effect (at end (sarj-lube-setup_a ?ev ?sarj)))

;;;Now the cover removal

;;; remove one cover
(define (durative-action remove-one-cover)
    :parameters (?ev - crew ?cov - sarj-cover)
    :vars (?adjt - adjustable-tether
		 ?loc - (located ?cov))
    :condition (and (at start (located ?adjt ?loc))
		    (at start (available ?adjt)))
    :duration 7.0
    :effect (and (at end (removed ?ev ?cov))
		 (at end (open ?cov))
		 (at end (not (available ?adjt)))))

;;; Now all of them
(define (durative-action sarj-cover-remove)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint)
    :vars (?pgt - power-grip-tool
		?loc - (lube-location ?sarj))
    :condition (and (at start (adjustable-tethers-ready-at ?sarj))
		    (at start (possesses ?ev ?pgt))
		    (at start (located ?ev ?loc)))
    :expansion (sequential
		(forall (?cov - (cover-for ?sarj))
			(removed ?ev ?cov)))
    :effect (and (at end (covers-removed ?sarj))
		 (at end (remove-covers_a ?ev ?sarj))))

;;; 12/30/10 We need a two person cover removal too.
(define (durative-action remove-sarj-cover-set)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint
		     ?cover-set-num - number)
    :expansion (sequential
		(forall (?cov - (cover-for-cover-set ?sarj ?cover-set-num))
			 (removed ?ev ?cov))
		)
    :effect (at end (remove-cover-set_a ?ev ?sarj ?cover-set-num)))

(define (durative-action sarj-cover-remove-by-two)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint)
    :vars (?pgt1 ?pgt2 - power-grip-tool
		?loc - (lube-location ?sarj)
		?helper - crew)
    :condition (and (at start (adjustable-tethers-ready-at ?sarj))
		    (at start (not (= ?ev ?helper)))
		    (at start (not (= ?pgt1 ?pgt2)))
		    (at start (possesses ?ev ?pgt1))
		    (at start (possesses ?helper ?pgt2))		    
		    (at start (located ?ev ?loc))
		    (at start (located ?helper ?loc))
		    )
    :expansion (parallel
		(remove-cover-set_a ?ev ?sarj 1)
		(remove-cover-set_a ?helper ?sarj 2))
    :effect (and (at end (covers-removed ?sarj))
		 (at end (remove-covers-by-two_a ?ev ?sarj))))

;;; Now the inspection. It needs a camera and a wipe set

(define (durative-action sarj-inspection)
    :parameters (?ev - crew 
		     ?sarj - solar-array-rotating-joint)
    :vars (?loc - (lube-location ?sarj)
		?camera - camera)
    :condition (and (at start (covers-removed ?sarj))
		    (at start (wipes-ready-at ?sarj))
		    (at start (located ?ev ?loc))
		    (at start (located ?camera ?loc))
		    )
    :duration 5.0
    :effect (inspected ?ev ?sarj))

;;; Now the lube
;;; Got to lube canted inner & outer outer and datuma surfaces
;;; for each cover


(define (durative-action lube-one-cover)
    :parameters (?ev - crew 
		     ?cov - sarj-cover
		     ?surface - sarj-surfaces) ;;; inner or datuma-outer
    :duration 3.0
    :effect (at end (lubed ?ev ?cov ?surface)))


(define (durative-action lube-sarj-cover-surfaces)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint
		     ?surfaces - sarj-surfaces)
    :expansion (sequential
		(forall (?cov - (cover-for ?sarj))
			(lubed ?ev ?cov ?surfaces))
		)
    :effect (and (at end (lube-surfaces_a ?ev ?sarj ?surfaces))
		 (at end (surfaces-lubed ?sarj ?surfaces))))

(define (durative-action sarj-cover-lubed)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint)
    :vars (?loc - (lube-location ?sarj))
    :condition (and (at start (grease-guns-ready-at ?sarj))
		    (at start (covers-removed ?sarj))
		    (at start (located ?ev ?loc)))
    :expansion (sequential
		(lube-surfaces_a ?ev ?sarj inner-canted-surfaces)
		(lube-surfaces_a ?ev ?sarj datum-a-and-outer-canted-surfaces))
    :effect (and (at end (covers-lubed ?sarj))
		 (at end (lube-covers_a ?ev ?sarj)))
    :probability 0.75
    )

;;; 12/29/10 We need to lube the sarj twice, so we need a nother set of lube actions,
;;; else AP will say the lubes have already been done.

(define (durative-action lube-one-cover2)
    :parameters (?ev - crew 
		     ?cov - sarj-cover
		     ?surface - sarj-surfaces) ;;; inner or datuma-outer
    :duration 3.0
    :effect (at end (lubed2 ?ev ?cov ?surface)))


(define (durative-action lube-sarj-cover-surfaces2)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint
		     ?surfaces - sarj-surfaces)
    :expansion (sequential
		(forall (?cov - (cover-for ?sarj))
			(lubed2 ?ev ?cov ?surfaces))
		)
    :effect (and (at end (lube-surfaces2_a ?ev ?sarj ?surfaces))
		 (at end (surfaces-lubed2 ?sarj ?surfaces))))

(define (durative-action sarj-cover-lubed2)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint)
    :vars (?loc - (lube-location ?sarj))
    :condition (and (at start (grease-guns-ready-at ?sarj))
		    (at start (covers-removed ?sarj))
		    (at start (located ?ev ?loc)))
    :expansion (sequential
		(lube-surfaces2_a ?ev ?sarj inner-canted-surfaces)
		(lube-surfaces2_a ?ev ?sarj datum-a-and-outer-canted-surfaces))
    :effect (and (at end (covers-lubed2 ?sarj))
		 (at end (lube-covers2_a ?ev ?sarj)))
    :probability 0.75
    )

;;; There appears to be a one person and two person lube.  One EV takes all the covers off and does the
;;; first lube for all six covers. Then when the two EVs get together for the second lube, the nominal 
;;; plan is: EV1 lubes under covers 12,13, 8, 9 ,and EV2 lubes under covers 16, 17 then installs 
;;; all covers.

(define (durative-action lube-sarj-cover-set)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint
		     ?cover-set-num - number)
    :expansion (sequential
		(forall (?cov - (cover-for-cover-set ?sarj ?cover-set-num))
			(sequential
			 (lubed ?ev ?cov inner-canted-surfaces)
			 (lubed ?ev ?cov datum-a-and-outer-canted-surfaces)))
		)
    :effect (at end (lube-cover-set_a ?ev ?sarj ?cover-set-num)))

(define (durative-action sarj-cover-lubed-by-two)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint)
    :vars (?loc - (lube-location ?sarj)
		?helper - crew)
    :condition (and (at start (not (= ?ev ?helper)))
		    (at start (grease-guns-ready-at ?sarj))
		    (at start (covers-removed ?sarj))
		    (at start (located ?ev ?loc))
		    (at start (located ?helper ?loc)))
    :expansion (parallel
		(lube-cover-set_a ?ev ?sarj 1)
		(lube-cover-set_a ?helper ?sarj 2))
    :effect (and (at end (covers-lubed ?sarj))
		 (at end (lube-covers-by-two_a ?ev ?sarj))))

;;; But this might be done the second time around
(define (durative-action lube-sarj-cover-set2)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint
		     ?cover-set-num - number)
    :expansion (sequential
		(forall (?cov - (cover-for-cover-set ?sarj ?cover-set-num))
			(sequential
			 (lubed2 ?ev ?cov inner-canted-surfaces)
			 (lubed2 ?ev ?cov datum-a-and-outer-canted-surfaces)))
		)
    :effect (at end (lube-cover-set2_a ?ev ?sarj ?cover-set-num)))

(define (durative-action sarj-cover-lubed-by-two2)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint)
    :vars (?loc - (lube-location ?sarj)
		?helper - crew)
    :condition (and (at start (not (= ?ev ?helper)))
		    (at start (grease-guns-ready-at ?sarj))
		    (at start (covers-removed ?sarj))
		    (at start (located ?ev ?loc))
		    (at start (located ?helper ?loc)))
    :expansion (parallel
		(lube-cover-set2_a ?ev ?sarj 1)
		(lube-cover-set2_a ?helper ?sarj 2))
    :effect (and (at end (covers-lubed2 ?sarj))
		 (at end (lube-covers-by-two2_a ?ev ?sarj))))

;;;Now the cover install

;;; install one cover
(define (durative-action install-one-cover)
    :parameters (?ev - crew ?cov - sarj-cover)
    :vars (?adjt - adjustable-tether
		 ?loc - (located ?cov))
    :condition (at start (located ?adjt ?loc))
    :duration 3.0
    :effect (and (at end (installed-item-in-place ?ev ?cov))
		 (at end (not (open ?cov)))
		 ))

;;; Now all of them
(define (durative-action sarj-cover-install)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint)
    :vars (?pgt - power-grip-tool
		?loc - (lube-location ?sarj))
    :condition (and (at start (possesses ?ev ?pgt))
		    (at start (located ?ev ?loc)))
    :expansion (sequential
		(forall (?cov - (cover-for ?sarj))
			(installed-item-in-place ?ev ?cov)))
    :effect (and (at end (covers-installed ?sarj))
		 (at end (install-covers_a ?ev ?sarj))))

;; We need a two-person install too

(define (durative-action sarj-cover-set-install)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint
		     ?cover-set-num - number)
    :expansion (sequential
		(forall (?cov - (cover-for-cover-set ?sarj ?cover-set-num))
			 (installed-item-in-place ?ev ?cov))
		)
    :effect (at end (install-cover-set_a ?ev ?sarj ?cover-set-num)))

(define (durative-action sarj-cover-install-by-two)
    :parameters (?ev - crew ?sarj - solar-array-rotating-joint)
    :vars (?helper - crew
		   ?pgt1 ?pgt2  - power-grip-tool
		?loc - (lube-location ?sarj))
    :condition (and (at start (not (= ?pgt1 ?pgt2)))
		    (at start (not (= ?ev ?helper)))
		    (at start (possesses ?ev ?pgt1))
		    (at start (possesses ?helper ?pgt2))
		    (at start (located ?ev ?loc))
		    (at start (located ?helper ?loc)))
    :expansion (parallel
		(install-cover-set_a ?ev ?sarj 1)
		(install-cover-set_a ?helper ?sarj 2))
    :effect (and (at end (covers-installed ?sarj))
		 (at end (install-covers-by-two_a ?ev ?sarj))))


;;;(new-relation '(big-lube-done ?ev - crew ?sarj - solar-array-rotating-joint) *domain*)
(define (durative-action lube-sarj)
    :parameters (?ev - crew
		     ?sarj - solar-array-rotating-joint)
    :expansion (sequential
		(lube-setup-for ?ev ?sarj)
		(remove-covers_a ?ev ?sarj)
		(inspected ?ev ?sarj)
		(lube-covers_a ?ev ?sarj)
		(install-covers_a ?ev ?sarj))
    :effect (at end (full-lube-done ?ev ?sarj)))

;;; There's a two person install as well

#|

FYI: This breaks AP
(define (durative-action sarj-cover-remove)
    :parameters (?ev - crew 
		     ?sarj - solar-array-rotating-joint)
    :vars (?loc - location
		 ?pgt - power-grip-tool)
    :condition (and (at start (adjustable-tethers-ready-at ?sarj))
		    (at start (possesses ?ev ?pgt))
		    )
    :duration 15.0
    :effect (and (at end (remove-covers_a ?ev ?sarj))
		 (at end (forall (?cov - (cover-for ?sarj))
				 (open ?cov)))))
|#

;;;-------------------------------------------------------------------
;;; SPDM Latching End Effector (LEE) Lube
;;;-------------------------------------------------------------------
;;; The ev takes the cover off the SPDM LEE, lube sit, waits until the IV opens 
;;; the snares and then lubes again.  
;;; Of course the iv has to get the spdm to the lube site, and the ev
;;; has to put a cover on the LEE tip camera, and take pictures of the LEE.
;;; The camera/light assembly (CLA) cover, wipes, camera and straight grease gun 
;;; are in a sarj crew lock bag.

#|

The timeline looks like this:
SPDM CLA COVER INSTALL (30 mins)
  spdm setup (20 mins) -- fetch the apfr from the ceta cart and install it on a wif 
     at the spdm lube site
  CLA cover install (10 mins)-- IV moves SPDM to the site & ev puts on the cover

SPDM LEE LUBE (40 mins)
 SPDM LEE LUBE (25 mins) 
   1) take pictures
   2) prep gun
   3) lube
   4) iv closes snare
   5) lube again
   6) safe and stow grease gun
   7) iv partially opens snare
   8) ev exercises all bearings

 Clean up (15 mins)
   clean tools with wipes
   take pictures
   move spdm back to its place
   get off the apfr
   put the apfr back on the ceta-cart

So I'll model:
 spdm setup(20) 
  fetch-apfr-to -- go somewhere and get apfr from wif there and take it to work place wif and install
  ingress-ssrms-for-spdm -- gca spdm to work place and ingress apfr

 cla cover install (10) -- install cla cover 
 
SPDM LEE lube (25)
 take-pix
 prep-gun
 lube-open
 iv close spdm lee
 lube-closed
 stow-gun
 exercise-bearings

Clean-up(15)
 clean-tools
 take-pix
 egress apfr
 return-apfr-to extract apfr from wif, go somewhere and install apfr on wif there 
 
;;|#

(define (durative-action fetch-apfr-to)
    :parameters (?ev - crew
		     ?apfr - articulating-portable-foot-restraint
		     ?end-loc - location)
    :vars (?wif1 - (contained_by ?apfr)
		?wif2 - workplace-interface
		?start-loc - (located ?wif1))
    :condition (at start (located ?wif2 ?end-loc))
    :expansion
    (sequential
     (located ?ev ?start-loc)
     (possesses ?ev ?apfr)
     (located ?ev ?end-loc)
     (installed-item ?ev ?apfr)
     )
    :effect (at end (fetched-to ?ev ?apfr ?end-loc)))

;;; we have ingress-transport modeled, but how about ingressing any installed apfr?
(define (durative-action Ingress-apfr)
    :parameters (?ev - crew
		     ?apfr - articulating-portable-foot-restraint
		 )
    :duration 5.0
    :vars (?holder - (contained_by ?apfr))
    :condition (and (at start (= (located ?ev)(located ?holder)))
		    (at start (available ?apfr))) 
    :effect (and (at end (ingressed ?ev ?apfr))
		 (at end (not (available ?apfr))))
    :comment "?ev gets on the ?apfr"
    )

;; This results in a 24 min setup.  We need the sarj bag to be where the ev is.
(define (durative-action setup-for-spdm-lube)
    :parameters (?ev - crew
		    ?transport - (or robotic-arm ceta-cart)) 
    :vars (?apfr - articulating-portable-foot-restraint
		 ?l - (worksite-for spdm-lube)
		 ?wipes - wipe-set
		 ?sarj-bag - (contained_by ?wipes)
		 ?phalcon - phalcon)
    :condition (and (at start (possesses ?ev ?sarj-bag))
		    (at start (contains ?transport spdm)))
    :expansion (parallel
		(rotated_a ?phalcon sarj-port 230)
		;;(angle sarj-port 230)
		(sequential 		
		(fetched-to ?ev ?apfr ?l)
		(arm-guided-to ?ev ?transport)
		(ingressed ?ev ?apfr)))
    :effect (at end (ready-for-spdm-lube ?ev ?transport))
    :comment "?ev readies an apfr at the worksite, moves the spdm to the worksite, and ingresses the apfr."
    )

;;; Here's one where you have to go to the sarj bag
(define (durative-action go-setup-for-spdm-lube)
    :parameters (?ev - crew
		     ?transport - (or robotic-arm ceta-cart)) 
    :vars (?apfr - articulating-portable-foot-restraint
		 ?l - (worksite-for spdm-lube)
		 ?wipes - wipe-set
		 ?sarj-bag - (contained_by ?wipes)
		 ?lsarj-bag - (located ?sarj-bag)
		 ?phalcon - phalcon)
    :condition (and (at start (not (possesses ?ev ?sarj-bag)))
		    (at start (contains ?transport spdm)))
    :expansion (parallel
		(rotated_a ?phalcon sarj-port 230)
		;;;(angle sarj-port 230)
		(sequential 
		 (located ?ev ?lsarj-bag)
		 (possesses ?ev ?sarj-bag)
		 (fetched-to ?ev ?apfr ?l)
		 (arm-guided-to ?ev ?transport)
		 (ingressed ?ev ?apfr)))
    :effect (at end (ready-for-spdm-lube ?ev ?transport))
    :comment "?ev readies an apfr at the worksite, moves the spdm to the worksite, and ingresses the apfr."
    )

;;; I believe this is a dual of extract-item-to-bag, but without tools.
;;; We just use it for the cover of a camera but it could be generalized...
;;; We use it here to put the cover on the cla.

(define (durative-action install-item-on)
    :parameters (?ev - crew
		     ?item - cover
		     ?receiver - camera)
    :vars (?l - (located ?receiver))
;;;changed from 10 to 5 mins
    :duration 5.0
    :condition (and (at start (located ?ev ?l))
		    (at start (possesses ?ev ?item)))
    :effect (and (at end (item-installed-on ?ev ?item ?receiver))
		 (at end (installed-on ?item ?receiver))
		 (at end (not (possesses ?ev ?item))))
	     
    :comment "crew puts ?item on ?receiver."
    )

;;; Now the lube. This is a big procedure but I'm going to make it one operator.
;;; We don't model the picture taking, just the requirement to have the camera.  
;;; And since the lube includes having
;;; the spdm operator operate the snares we only require
(define (durative-action spdm-snare-lube)
    :parameters (?ev - crew)
    :vars (?l - (worksite-for spdm-lube)
	      ?camera - camera
	      ?apfr - articulating-portable-foot-restraint
	      ?sarj-bag  - (contained_by ?camera) 
	      ?iv - (operator ssrms)) ;; someone to operate snares
    :duration 25.0
    :condition (and (at start (located ?ev ?l))
		    (at start (ingressed ?ev ?apfr))
		    (at start (located ssrms ?l))
		    (at start (possesses ?ev ?sarj-bag)))
    :effect (and (spdm-snares-lubed ?ev))
	     
    :comment "ev takes pictures, lubes and exercises spdm snares."
    )

;;; dual of fetch-apfr-to
(define (durative-action return-apfr-to)
    :parameters (?ev - crew
		     ?apfr - articulating-portable-foot-restraint
		     ?return-loc - location)
    :vars (?wif1 - (contained_by ?apfr)
		?wif2 - workplace-interface
		?start-loc - (located ?wif1))
    :condition (and (at start (located ?ev ?start-loc))
		    (at start (located ?wif2 ?return-loc)))
    :expansion
    (sequential
     (possesses ?ev ?apfr) ;;; extract
     (located ?ev ?return-loc)
     (installed-item ?ev ?apfr)
     ;;;(located ?ev ?start-loc)
     )
    :effect (at end (returned-to ?ev ?apfr ?return-loc)))

;;; dual of ingress-apfr
(define (durative-action egress-apfr)
    :parameters (?ev - crew
		     ?apfr - articulating-portable-foot-restraint
		 )
    :duration 5.0
    :condition (at start (ingressed ?ev ?apfr))
    :effect (and (at end (egressed ?ev ?apfr))
		 (at end (available ?apfr)))
    :comment "?ev gets on the ?apfr"
    )

;;; 1/10/11 One way to keep the last plan from barfing on the chart is
;;; to get rid of the pickup/putdown of the sarj bag.
(define (durative-action cleanup-for-spdm-lube)
    :parameters (?ev - crew
		    ?transport - (or robotic-arm ceta-cart)) 
    :vars (?apfr - articulating-portable-foot-restraint
		 ?start-loc - (storage-site-for ?apfr)
		 ?end-loc - (worksite-for spdm-lube)
		 ?wipes - wipe-set
		 ?sarj-bag - (contained_by ?wipes))
    :condition (at start (contains ?transport spdm))
    :expansion (sequential 
		(egressed ?ev ?apfr)
		;;(not (possesses ?ev ?sarj-bag))
		(returned-to ?ev ?apfr ?start-loc)
		(located ?ev ?end-loc)
		;;(possesses ?ev ?sarj-bag)
		)
    :effect (at end (spdm-lube-cleanup_a ?ev ?transport))
    :comment "?ev readies an apfr at the worksite, moves the spdm to the worksite, and ingresses the apfr."
    )

;;; Now make one task done by one agent for the whole spdm.

(define (durative-action complete-spdm-lube)
    :parameters (?ev - crew
		     ?transport - (or robotic-arm ceta-cart))
    :expansion
    (sequential
     (ready-for-spdm-lube ?ev ?transport)
     (item-installed-on ?ev cla-cover spdm-lee-cla)
     (spdm-snares-lubed ?ev)
     (spdm-lube-cleanup_a ?ev ?transport))
    :effect (at end (complete-spdm-lube_a ?ev ?transport)))

;;;-------------------------------------------------------------------
;;; Installation of a radiator grapple stow beam
;;;-------------------------------------------------------------------

;;; There are two parts to the beam, inboard and outboard.  The ev needs to have the beam ORU bag
;;; which contains the beams, pip pins and a 5/8 x 7.8" extension for the pgt.

(define (durative-action install-beam)
    :parameters (?ev - crew
		     ?beam - stow-beam-part
		 )
    :vars (?pgt - power-grip-tool
		?bag - (contained_by ?beam)
		?l - (located ?bag))
    :duration 15.0
    :condition (and (at start (possesses ?ev ?pgt))
		    (at start (located ?ev ?l)))
    :effect (and (at end (installed-item ?ev ?beam))
		 (at end (contained_by ?beam nothing)))
    :comment "?ev installs beam at location"
    )

;;; In the scenario, the ev goes and gets the bag that has the beam stuff
(define (durative-action install-s1-rad-stow-beam)
    :parameters (?ev - crew
		    ?b - stow-beam)
    :vars (?beam-bag - (tool-for ?b)
		     ?l - (location-for s1-radiator-stow-beam))
    :expansion (sequential 
		(possesses ?ev ?beam-bag)
		(located ?ev ?l)
		(installed-item ?ev s1-inboard-stow-beam)
		(installed-item ?ev s1-outboard-stow-beam)
		)
    :effect (at end (installed-item ?ev ?b))
    :comment "?ev takes beam bag to s1-stow-beam-loc and installs the s1 stow beam"
    )

(define (durative-action fetch-and-install-s1-stow-beam)
    :parameters (?ev - crew
		    ?b - stow-beam)
    :vars (?beam-bag - (tool-for ?b)
		     ?l - (location-for s1-radiator-stow-beam))
    :expansion (sequential 
		(fetched ?ev ?beam-bag)
		(located ?ev ?l)
		(installed-item ?ev s1-inboard-stow-beam)
		(installed-item ?ev s1-outboard-stow-beam)
		)
    :probability 0.75
    :effect (at end (installed-item ?ev ?b))
    :comment "?ev takes beam bag to s1-stow-beam-loc and installs the s1 stow beam"
    )

;;; A new decon action when there's been ammonia contamination
(define (durative-action nh3-decon-inside)
    :parameters (?ev - crew)
    :vars (?dt - drager-tube)
    :condition (and (at start (= (located ?dt) INTRA-VEHICLE))
		    (at start (= (located ?ev) INTRA-VEHICLE)))
    :effect (and (at end (contamination-state no-contamination))
		 (at end (decon-complete_a ?ev)))
    :duration 30
    :comment "?ev uses drager tube to check for ammonia contamination"
    )

;;;Put it in a sequence
(define (durative-action nh3-decon)
    :vars (?ev - crew)
    :condition (at start (= (located ?ev) INTRA-VEHICLE))
    :expansion (sequential
		(locked hatch)
		(prepare-for-repress_a ?ev)
		(decon-complete_a ?ev))
    :effect (at end (nh3-decon_a))
    :comment "?ev executes decon"
    )
 ;;;---------------------------------------------------------
;;; PHALCON & Other Core discipline actions
;;;--------------------------------------------------------
(define (durative-action Deactivate-rga)
    :parameters (?fc - adco
		      ?ddcu - dc-to-dc-converter-unit
		     )
    :vars (?rga - rate-gyro-assembly
		?rpc - remote-power-controller
		?rt - rt-fdir)
    :condition (and (at start (operational ?rga))
		    (at start (associated-rpc ?rga ?rpc))
		    (at start (power-source ?rpc ?ddcu))
		    (at start (associated-rt ?rga ?rt)))
    :duration 15.0
    :effect (and (at end (not (operational ?rga)))
		 (at end (Deactivate-rga_a ?fc ?ddcu))
		 )
    :comment "adco proc to shutdown ?rga connected to ?ddcu."
    )

(define (durative-action Reconfig-gps-power)
    :parameters (?fc - adco
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?old-rpc-string ?new-rpc-string - rpc-string
			   ?alt-ddcu - dc-to-dc-converter-unit)
    :condition (and (at start (gps-power-source ?ddcu))
		    (at start (gps-alternate-power-source ?alt-ddcu))
		    (at start (gps-rpc-string ?ddcu ?old-rpc-string))
		    (at start (gps-rpc-string ?alt-ddcu ?new-rpc-string)))
    :duration 15.0
    :effect (and (at end (gps-power-source ?alt-ddcu))
		 (at end (gps-alternate-power-source ?ddcu))	 
		 (at end (Reconfig-gps-power_a ?fc ?ddcu))
		 )
    :comment "adco proc to reconfigure gps power from ?ddcu to ?alt-ddcu"
    )

(define (durative-action Shutdown-cmg)
    :parameters (?fc - adco
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?cmg ?cmg-alt - control-moment-gyro
		?ddcu-alt - dc-to-dc-converter-unit
		?rpc - remote-power-controller)
    :condition (and (at start (not (= ?cmg ?cmg-alt)))
		    (at start (cmg-for ?ddcu ?cmg))
		    (at start (cmg-for ?ddcu-alt ?cmg-alt)) ;; another cmg is running
		    (at start (associated-rpc ?cmg ?rpc))) ;; the proc is done whenthis rpc is open
    :duration 15.0
    :effect (and (at end (parked ?cmg))
		 (at end (shutdown-cmg_a ?fc ?ddcu))
		 )
    :comment "adco proc to park the appropriate cmg."
    )

(define (durative-action Configure-sarj-monitor)
    :parameters (?fc - phalcon
		      ?sarj - solar-array-rotating-joint)
    :vars (?sarj-mode - (or AUTOTRACK BLIND DIRECTED-POSITION)
		      ?rpc-string - (string-for ?sarj)
		      ?alt-string - (alt-string-for ?sarj)
		 )
    :condition (and (at start (mode ?sarj ?sarj-mode))
		    (at start (mode ?rpc-string MONITOR))
		    )
    :duration 15.0
    :effect (and (at end (string-for ?sarj ?alt-string))
		 (at end (alt-string-for ?sarj ?rpc-string))
		 (at end (configure-sarj_a ?fc ?sarj))
		 )
    :comment "phalcon procedure for swapping the sarj to another power string when the current string mode is monitor."
    )

(define (durative-action Configure-sarj-commanded)
    :parameters (?fc - phalcon
		      ?sarj - solar-array-rotating-joint)
    :vars (?sarj-mode - (or AUTOTRACK BLIND DIRECTED-POSITION)
		      ?rpc-string - (string-for ?sarj)
		      ?alt-string - (alt-string-for ?sarj)
		 )
    :condition (and (at start (mode ?sarj ?sarj-mode))
		    (at start (mode ?rpc-string COMMANDED))
		    )
    :duration 15.0
    :effect (and (at end (string-for ?sarj ?alt-string))
		 (at end (alt-string-for ?sarj ?rpc-string))
		 (at end (configure-sarj_a ?fc ?sarj))
		 )
    :comment "phalcon procedure for swapping the sarj to another power string when the current string mode is commanded."
    )

;;; Each mdm has its own procedure
(define (durative-action Transition-S0-mdm)
    :parameters (?fc - odin
		      ?mdm-p - S0-mdm)
    :vars (?mdm-r - S0-mdm
           ?mdm-mode - (or NORMAL WAIT)
		 )
    :condition (and (at start (primary-S0-mdm ?mdm-p))
		    (at start (redundant-S0-mdm ?mdm-r))
		    (at start (mode ?mdm-p ?mdm-mode))
		    )
    :duration 15.0
    :effect (and (at end (primary-S0-mdm ?mdm-r))
		 (at end (redundant-S0-mdm ?mdm-p))
		 (at start (mode ?mdm-p OFF))
		 (at end (Transition-S0-mdm_a ?fc ?mdm-p))
		 )
    :comment "odin procedure for deactivating the S0 mdm and setting up SEPS redundancy."
    )

(define (durative-action Transition-S1-mdm)
    :parameters (?fc - odin
		      ?mdm-p - S1-mdm)
    :vars (?mdm-r - S1-mdm
           ?mdm-mode - (or NORMAL WAIT)
		 )
    :condition (and (at start (primary-S1-mdm ?mdm-p))
		    (at start (redundant-S1-mdm ?mdm-r))
		    (at start (mode ?mdm-p ?mdm-mode))
		    )
    :duration 15.0
    :effect (and (at end (primary-S1-mdm ?mdm-r))
		 (at end (redundant-S1-mdm ?mdm-p))
		 (at start (mode ?mdm-p OFF))
		 (at end (Transition-S1-mdm_a ?fc ?mdm-p))
		 )
    :comment "odin procedure for deactivating the S1 mdm and setting up SEPS redundancy."
    )

(define (durative-action Transition-S3-mdm)
    :parameters (?fc - odin
		      ?mdm-p - S3-mdm)
    :vars (?mdm-r - S3-mdm
           ?mdm-mode - (or NORMAL WAIT)
		 )
    :condition (and (at start (primary-S3-mdm ?mdm-p))
		    (at start (redundant-S3-mdm ?mdm-r))
		    (at start (mode ?mdm-p ?mdm-mode))
		    )
    :duration 15.0
    :effect (and (at end (primary-S3-mdm ?mdm-r))
		 (at end (redundant-S3-mdm ?mdm-p))
		 (at start (mode ?mdm-p OFF))
		 (at end (Transition-S3-mdm_a ?fc ?mdm-p))
		 )
    :comment "odin procedure for deactivating the S3 mdm and setting up SEPS redundancy."
    )

(define (durative-action Transition-P1-mdm)
    :parameters (?fc - odin
		      ?mdm-p - P1-mdm)
    :vars (?mdm-r - P1-mdm
           ?mdm-mode - (or NORMAL WAIT)
		 )
    :condition (and (at start (primary-P1-mdm ?mdm-p))
		    (at start (redundant-P1-mdm ?mdm-r))
		    (at start (mode ?mdm-p ?mdm-mode))
		    )
    :duration 15.0
    :effect (and (at end (primary-P1-mdm ?mdm-r))
		 (at end (redundant-P1-mdm ?mdm-p))
		 (at start (mode ?mdm-p OFF))
		 (at end (Transition-P1-mdm_a ?fc ?mdm-p))
		 )
    :comment "odin procedure for deactivating the P1 mdm and setting up SEPS redundancy."
    )

(define (durative-action Transition-P3-mdm)
    :parameters (?fc - odin
		      ?mdm-p - P3-mdm)
    :vars (?mdm-r - P3-mdm
           ?mdm-mode - (or NORMAL WAIT)
		 )
    :condition (and (at start (primary-P3-mdm ?mdm-p))
		    (at start (redundant-P3-mdm ?mdm-r))
		    (at start (mode ?mdm-p ?mdm-mode))
		    )
    :duration 15.0
    :effect (and (at end (primary-P3-mdm ?mdm-r))
		 (at end (redundant-P3-mdm ?mdm-p))
		 (at start (mode ?mdm-p OFF))
		 (at end (Transition-P3-mdm_a ?fc ?mdm-p))
		 )
    :comment "odin procedure for deactivating the P3 mdm and setting up SEPS redundancy."
    )

;; assume a generic mdm here (proc C&DH 4.619)
(define (durative-action Transition-mdm)
    :parameters (?fc - odin
		      ?mdm - multiplexer-demultiplexer)
    :vars (?mdm-mode - (or NORMAL WAIT))
    :condition (at start (mode ?mdm ?mdm-mode))
    :duration 15.0
    :effect (and (at end (mode ?mdm OFF))
		 (at end (Transition-mdm_a ?fc ?mdm))   )
    :comment "odin procedure for deactivating the STR mdm."
    )

;;; 1.252 step 14
(define (durative-action deactivate-ext-mdm)
    :parameters (?fc - odin
		      ?mdm - multiplexer-demultiplexer)
    :vars (?smdm - (redundant-ext-mdm))
    :condition (at start (primary-ext-mdm ?mdm))
    :duration 15.0
    :effect (and (at end (redundant-ext-mdm ?mdm))
		 (at end (mode ?mdm OFF))
		 (at end (primary-ext-mdm ?smdm))
		 (at end (deactivate-mdm_a ?fc ?mdm))   )
    :comment "odin procedure for deactivating the primary ext mdm."
    )

;;; 1.252 step 15
(define (durative-action reconfigure-itcs-to-sl)
    :parameters (?fc - thor
		      ?itcs - internal-tcs)
    :condition (at start (configuration ?itcs dual-loop))
    :duration 15.0
    :effect (and (at start (configuration ?itcs single-loop))
		 (at end (reconfigure-itcs_a ?fc ?itcs))   )
    :comment "thor procedure for switching from dual loop to single loop."
    )

(define (durative-action reconfigure-itcs-to-dl)
    :parameters (?fc - thor
		      ?itcs - internal-tcs)
    :condition (at start (configuration ?itcs single-loop))
    :duration 15.0
    :effect (and (at start (configuration ?itcs dual-loop))
		 (at end (reconfigure-itcs_a ?fc ?itcs))   )
    :comment "thor procedure for switching from single loop to dual loop."
    )

(define (durative-action Inhibit-rt-fdir)
    :parameters (?fc - phalcon
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?mdm - (rt-fdir-mdm ?ddcu)
		?rt-fdir - (rt-fdir-for ?mdm))
    :duration 15.0
    :effect (and (at end (inhibited ?rt-fdir))
		 (at end (Inhibit-rt-fdir_a ?fc ?ddcu))
		 )
    :comment "phalcon procedure for inhibiting rt-fdir of the C&C mdm."
    )

(define (durative-action S-band-swap)
    :parameters (?fc - cato
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?sband - (sband-for ?ddcu)
		  ?alt-sband - comms-antenna)
    :condition (and (at start (current-sband ?sband))
		    (at start (alternate-sband ?alt-sband)))
    :duration 15.0
    :effect (and (at end (current-sband ?alt-sband))
		 (at end (S-band-swap_a ?fc ?ddcu)))
    :comment "cato procedure for switching from the primary antenna to a secondary one.")

;;; This procedure is for all the lights
(define (durative-action Activate-ceta-lights)
    :parameters (?fc - phalcon)
    :duration 15.0
    :effect (at end (Activate-ceta-lights_a ?fc))
    :comment "A phalcon proc to turn on all the ceta-lights.")
		
;;; auto-route video
(define (durative-action Auto-route-video)
    :parameters (?fc - cato
		     ?evsu - external-video-switch-unit)
    :duration 15.0
    :effect (at end (Auto-route-video_a ?fc ?evsu))
    :comment "A cato proc to re-route video from an evsu.")

#|
(define (durative-action Auto-route-test)
    :parameters (?fc - cato
		     ?ddcu - dc-to-dc-converter-unit)
    :duration 15.0
    :expansion (sequential
		(forall (?evsu - (evsu-for ?ddcu)
			       (Auto-route-video_a ?fc ?evsu))))
    :effect (at end (Auto-route-test_a ?fc ?ddcu))
    :comment "A phalcon proc to turn on all the ceta-lights.")
;;|#

;;; 4/17/2012 an action to get some parallels to test the EM with
(define (durative-action do-fc-jobs) 
    :parameters (?ddcu - dc-to-dc-converter-unit) 
    :vars (?adco - adco ?phalcon - phalcon ?odin - odin) 
    :expansion
    (sequential
     (parallel 
      (deactivate-rga_a ?adco ddcus01a) 
      (configure-sarj_a ?phalcon sarj-starboard)
      (transition-s0-mdm_a ?odin s0-mdm1))
     (delay1hr_a done))
    :effect (at end (ddcu-r&r-done ?ddcu)))

;;; In our phase1 scenario, the PHALCON flight notes says to do
;;; steps 5-7, 9, 10, 18-22 of 1.252 DDCU Shutdown

(define (durative-action Prepare-for-ddcu-shutdown)
    :parameters (?phalcon - phalcon
			  ?ddcu - dc-to-dc-converter-unit)
    :vars (?adco - adco 
		?odin - odin
		;;;?cato - cato
		)
    ;;; we want an rga that is being used and connected to the ddcu in question
    :expansion (parallel
		(sequential
		 ;;;(S-band-swap_a ?cato ?ddcu)
		 ;;;(Activate-ceta-lights_a ?phalcon)
		 (Deactivate-rga_a ?adco ?ddcu) ;;; step 5
		 (Reconfig-gps-power_a ?adco ?ddcu) ;;; step 6
		 (shutdown-cmg_a ?adco ?ddcu)) ;;; step 7
		(sequential
		 ;;;(Activate-ceta-lights_a ?phalcon)
		 (Configure-sarj_a ?phalcon SARJ-PORT) ;;; step 9
		 (Configure-sarj_a ?phalcon SARJ-STARBOARD)) ;;; step 10
		(sequential
		 (Transition-S3-mdm_a ?odin S3-MDM1) ;;; step 18
		 (Transition-mdm_a ?odin STR-MDM) ;;; step 19
		 (Transition-P1-mdm_a ?odin P1-MDM2) ;;; step 20
		 (Transition-P3-mdm_a ?odin P3-MDM1)) ;;; step 21
		(Inhibit-rt-fdir_a ?phalcon ?ddcu) ;;; step 22
		)
    :effect (Prepare-for-ddcu-shutdown_a ?phalcon ?ddcu))

(define (durative-action Shutdown-etcs-loop)
    :parameters (?fc - thor
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?pump - (etcs-pump-for ?ddcu)
		 ?loop - (cooling-loop-for ?pump))
    :duration 15.0
    :effect (and (at end (not (operational ?pump)))
		 (at end (Shutdown-etcs-loop_a ?fc ?ddcu))
		 )
    :comment "thor procedure for shutting down the water pump powered by ?ddcu."
    )

(define (durative-action Deactivate-ddcu)
    :parameters (?fc - phalcon
		      ?ddcu - dc-to-dc-converter-unit)
    :duration 15.0
    :effect (and (at end (not (turned-on ?ddcu)))
		 (at end (Deactivate-ddcu_a ?fc ?ddcu))
		 )
    :comment "phalcon procedure for turning the ddcu off."
    )

(define (durative-action Powerdown-ddcu)
    :parameters (?fc - phalcon
		      ?ddcu - dc-to-dc-converter-unit)
    :vars (?rt-fdir - (rt-fdir-for ?ddcu)
		    ?rbi - (rbi-for ?ddcu))
    :duration 15.0
    :effect (and (at end (not (closed ?rbi)))
		 (at end (inhibited ?rt-fdir))
		 (at end (Powerdown-ddcu_a ?fc ?ddcu))
		 )
    :comment "phalcon procedure for opening the rbi for the ddcu."
    )

;;; In our phase1 scenario, the PHALCON flight notes says to do
;;; steps 15, 23 & 24
(define (durative-action Ddcu-shutdown)
    :parameters (?phalcon - phalcon
			  ?ddcu - dc-to-dc-converter-unit)
    :vars (;;?odin - odin
		 ?thor - thor
		)
    :expansion (sequential
		(Shutdown-etcs-loop_a ?thor ?ddcu) ;;; step 15
		;;;(Transition-S0-mdm_a ?odin S0-MDM1) 
		;;;(Transition-S1-mdm_a ?odin S1-MDM1)
		(Deactivate-ddcu_a ?phalcon ?ddcu) ;;; step 23
		(Powerdown-ddcu_a ?phalcon ?ddcu)) ;;; step 24
    :effect (ddcu-shutdown_a ?phalcon ?ddcu))

(define (durative-action Delay24hrs) 
    :duration time-for-delay
    :effect (at end (Delay24hrs_a done)))

(define (durative-action Delay1hr) 
    :duration time-for-delay
    :effect (at end (Delay1hr_a done)))

(define (durative-action full-flt-note)
    :parameters (?phalcon - phalcon
			  ?ddcu - dc-to-dc-converter-unit)
    :expansion (sequential
		(Prepare-for-ddcu-shutdown_a ?phalcon ?ddcu)
		(Delay24hrs_a done)
		(ddcu-shutdown_a ?phalcon ?ddcu))
    :effect (full-shutdown ?phalcon ?ddcu))


(define (durative-action Lock-sarj-with-shutdown) ;;; EPS 2.139 Steps 1 & 2
    :parameters (?fc - phalcon
		     ?sarj - solar-array-rotating-joint
		     )
    :vars (?sarj-mode - (or AUTOTRACK BLIND DIRECTED-POSITION)
		      ?rpc-string - (string-for ?sarj)
		      
		 )
    :condition (and (at start (mode ?sarj ?sarj-mode))
		    (at start (mode ?rpc-string COMMANDED))
		    )
    :duration 30.0
    :effect (and (at end (previous-sarj-mode ?sarj ?sarj-mode))
		 (at end (mode ?sarj SHUTDOWN))
		 (at end (angle ?sarj 50))
		 (at end (lock_sarj_a ?fc ?sarj))
		 )
    :comment "phalcon procedure for stopping the sarj at an angle"
    )

(define (durative-action Lock-sarj100-with-shutdown) ;;; for AR demo
    :parameters (?fc - phalcon
		     ?sarj - solar-array-rotating-joint
		     )
    :vars (?sarj-mode - (or AUTOTRACK BLIND DIRECTED-POSITION)
		      ?rpc-string - (string-for ?sarj)
		      
		 )
    :condition (and (at start (mode ?sarj ?sarj-mode))
		    (at start (mode ?rpc-string COMMANDED))
		    )
    :duration 30.0
    :effect (and (at end (previous-sarj-mode ?sarj ?sarj-mode))
		 (at end (mode ?sarj SHUTDOWN))
		 (at end (angle ?sarj 100))
		 (at end (lock_sarj100_a ?fc ?sarj))
		 )
    :comment "phalcon procedure for stopping the sarj at an angle"
    )

(define (durative-action recover-sarj-to-mode) ;;; EPS 2.139 Steps 4 - 5 and 6, 7 or 9
    :parameters (?fc - phalcon
		     ?sarj - solar-array-rotating-joint)
		     ;;; ?mode - (or AUTOTRACK BLIND DIRECTED-POSITION)  this fails on the function instance
    :vars (?mode - (previous-sarj-mode ?sarj))
    :condition (and (at start (not (= ?mode shutdown)))
		    (at start (= (mode ?sarj) SHUTDOWN)))
    :duration 30.0
    :effect (and (at end (mode ?sarj ?mode))
		 (at end (recover-to-mode_a ?fc ?sarj)))
    :comment "phalcon procedure for unlocking and bringing sarj from shutdown to new mode."
    )

(define (durative-action recover-sarj-to-mode) ;;; EPS 2.139 Steps 4 - 5 and 6, 7 or 9
    :parameters (?fc - phalcon
		     ?sarj - solar-array-rotating-joint)
		     ;;; ?mode - (or AUTOTRACK BLIND DIRECTED-POSITION)  this fails on the function instance
    :vars (?mode - (previous-sarj-mode ?sarj))
    :condition (and (at start (not (= ?mode shutdown)))
		    (at start (= (mode ?sarj) SHUTDOWN)))
    :duration 30.0
    :effect (and (at end (mode ?sarj ?mode))
		 (at end (recover-to-mode_a ?fc ?sarj)))
    :comment "phalcon procedure for unlocking and bringing sarj from shutdown to new mode."
    )

(define (durative-action rotate-sarj)
    :parameters (?fc - phalcon
		     ?sarj - solar-array-rotating-joint
		     ?angle - int)
    :duration 30.0
    :effect (and (at end (rotated_a ?fc ?sarj ?angle))
		 (at end (angle ?sarj ?angle)))
    :comment "phalcon procedure for rotating sarj."
    )

(define (durative-action open-ata-tank)
    :parameters (?fc - thor
		      ?ata - ammonia-tank)
    :duration 1.0
    :effect (and (at end (open ?ata))
		 (at end (open-ata-tank_a ?fc ?ata))
		 )
    :comment "thor procedure for opening an ata tank."
    )

(define (durative-action close-ata-tank)
    :parameters (?fc - thor
		      ?ata - ammonia-tank)
    :duration 1.0
    :effect (and (at end (not (open ?ata)))
		 (at end (close-ata-tank_a ?fc ?ata))
		 )
    :comment "thor procedure for closing an ata tank."
    )

