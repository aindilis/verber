;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)

(define (situation phalcon-eva)
    (:documentation "CE reomved props that seem unnecessary and cause problems
                     suggest you add as needed.")
  (:domain nasa-domain)
  (:objects
   drager-tube1 - drager-tube
   s1-radiator-stow-beam - stow-beam
   s1-inboard-stow-beam s1-outboard-stow-beam - stow-beam-part
   cla-cover - cover
   spdm-lube - activity
   spdm - special-purpose-dextrous-manipulator
   jhookgun1 - j-hook-nozzle-grease-gun
   sngun1 - straight-nozzle-grease-gun
   spdm-lee-cla camera1 - camera
   cover8 cover9 cover12 cover13 cover16 cover17 - sarj-cover
   adjt1 adjt2 adjt3 adjt4 adjt5 adjt6 - adjustable-tether
   wipes1 - wipe-set
   sarj-bag1 s1-beam-bag - medium-oru-bag
   ata1 ata2 - ammonia-tank
   vte-bag1 - vent-tool-equipment-bag
   vent-tool1 - vent-tool
   vt-adapter1 - vent-tool-adapter
   stanchion-mount-cover1 - stanchion-mount-cover
   ddcus01a ddcus01b ddcu-spare1 - dc-to-dc-converter-unit
   ;;;sally joe bob - crew
  ;;; fish-stringer1 - fish-stringer
   spd1 spd2 - space-positioning-device
   ;;;fqd-jumper1 - fluid-quick-disconnect-jumper
;;;;power-cable1 - qtr-inch-power-cable
   cpa1 - control-panel-assembly
   ctp1 - cpa-tether-point
   apfr1 apfr2 apfr3 - articulating-portable-foot-restraint
;;; 2 and 4 used for spdm stuff
   wif1 wif2 wif3 wif4 - workplace-interface
   wifa1 wifa2 - wif-adapter
   ssrms - robotic-arm
   evsu1 evsu2 - external-video-switch-unit
   ceta-cart1 ceta-cart2 port-ceta-cart - ceta-cart
   hr1 hr2 hr3 hr4 - ISS-EVA-handrail
   ISS-safety-tether1 ISS-safety-tether2 ISS-safety-tether3 ISS-safety-tether4 - safety-tether
   square-scoop1 square-scoop2 square-scoop3 - square-scoop
   ratchet-wrench1 - ratchet-wrench 
   pgt1 pgt3 pgt4 - pgt-with-turn-setting
   pgt2 - pgt-with-torque-break-setting
   ceta-light-bag1 ceta-light-bag2  ceta-light-bag3 cpa-bag1 - medium-oru-bag
   crew-lock-bag1 sarj-clb - crew-lock-bag
   stp1 stp2 - safety-tether-pack
   CETA-LIGHT1 CETA-LIGHT2 CETA-LIGHT3 - ceta-light
   P3-BAY1 P3-BAY4 - station-bay
   P3-BAY1-FACE1 P3-BAY4-FACE1 P3-BAY4-FACE3 - bay-face
   P0 P1 P2 P3 S0 S1 S3 - truss-segment
   LAB-CETA-LIGHT-LOC PWR-JUMPER-LOC FQD-JUMPER-LOC 
   ddcus01a-loc ssrms-loc1 ceta-cart-loc1 ceta-cart-loc2 port-ceta-cart-loc 
   p1-nadir-bay12 s1-stow-beam-loc - location
;;; START To demo the plan diagnostics
   LAB-CETA-LIGHT-LOC-to-P3-Z-FACE1 P3-Z-FACE1-to-LAB-CETA-LIGHT-LOC
   LAB-CETA-LIGHT-LOC-to-p3-p4-juncture p3-p4-juncture-to-LAB-CETA-LIGHT-LOC
;;; END
   AIRLOCK-to-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC-to-AIRLOCK AIRLOCK-to-PWR-JUMPER-LOC PWR-JUMPER-LOC-to-AIRLOCK 
   AIRLOCK-to-FQD-JUMPER-LOC FQD-JUMPER-LOC-to-AIRLOCK AIRLOCK-to-DDCUS01A-LOC DDCUS01A-LOC-to-AIRLOCK AIRLOCK-to-SSRMS-LOC1 
   SSRMS-LOC1-to-AIRLOCK AIRLOCK-to-CETA-CART-LOC1 CETA-CART-LOC1-to-AIRLOCK AIRLOCK-to-CETA-CART-LOC2 CETA-CART-LOC2-to-AIRLOCK
   LAB-CETA-LIGHT-LOC-to-PWR-JUMPER-LOC PWR-JUMPER-LOC-to-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC-to-FQD-JUMPER-LOC 
   FQD-JUMPER-LOC-to-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC-to-DDCUS01A-LOC DDCUS01A-LOC-to-LAB-CETA-LIGHT-LOC 
   LAB-CETA-LIGHT-LOC-to-SSRMS-LOC1
   SSRMS-LOC1-to-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC-to-CETA-CART-LOC1 CETA-CART-LOC1-to-LAB-CETA-LIGHT-LOC 
   LAB-CETA-LIGHT-LOC-to-CETA-CART-LOC2 CETA-CART-LOC2-to-LAB-CETA-LIGHT-LOC PWR-JUMPER-LOC-to-FQD-JUMPER-LOC 
   FQD-JUMPER-LOC-to-PWR-JUMPER-LOC PWR-JUMPER-LOC-to-DDCUS01A-LOC DDCUS01A-LOC-to-PWR-JUMPER-LOC PWR-JUMPER-LOC-to-SSRMS-LOC1 
   SSRMS-LOC1-to-PWR-JUMPER-LOC PWR-JUMPER-LOC-to-CETA-CART-LOC1 CETA-CART-LOC1-to-PWR-JUMPER-LOC PWR-JUMPER-LOC-to-CETA-CART-LOC2 
   CETA-CART-LOC2-to-PWR-JUMPER-LOC FQD-JUMPER-LOC-to-DDCUS01A-LOC DDCUS01A-LOC-to-FQD-JUMPER-LOC FQD-JUMPER-LOC-to-SSRMS-LOC1 
   SSRMS-LOC1-to-FQD-JUMPER-LOC FQD-JUMPER-LOC-to-CETA-CART-LOC1 CETA-CART-LOC1-to-FQD-JUMPER-LOC FQD-JUMPER-LOC-to-CETA-CART-LOC2 
   CETA-CART-LOC2-to-FQD-JUMPER-LOC DDCUS01A-LOC-to-SSRMS-LOC1 SSRMS-LOC1-to-DDCUS01A-LOC DDCUS01A-LOC-to-CETA-CART-LOC1 
   CETA-CART-LOC1-to-DDCUS01A-LOC DDCUS01A-LOC-to-CETA-CART-LOC2 CETA-CART-LOC2-to-DDCUS01A-LOC SSRMS-LOC1-to-CETA-CART-LOC1 
   CETA-CART-LOC1-to-SSRMS-LOC1 SSRMS-LOC1-to-CETA-CART-LOC2 CETA-CART-LOC2-to-SSRMS-LOC1 CETA-CART-LOC1-to-CETA-CART-LOC2 
   CETA-CART-LOC2-to-CETA-CART-LOC1

   ;;;P3-Z-FACE1 is the intermediate tether swap place for all paths out beyond P3
   
   AIRLOCK-TO-P6-Z-FACE1 AIRLOCK-TO-p3-p4-juncture
   AIRLOCK-TO-P3-Z-FACE1 P3-Z-FACE1-to-p3-p4-juncture
   P6-Z-FACE1-TO-AIRLOCK p3-p4-juncture-to-P3-Z-FACE1
   p3-p4-juncture-to-airlock p3-p4-juncture-to-P6-Z-FACE1
   P3-Z-FACE1-TO-AIRLOCK P6-Z-FACE1-TO-p3-p4-juncture
   P3-Z-FACE1-TO-P6-Z-FACE1
   P6-Z-FACE1-TO-P3-Z-FACE1 
   p5-p6-juncture-to-p3-p4-juncture p3-p4-juncture-to-p5-p6-juncture 
   p1-ata-panel-to-p3-p4-juncture p3-p4-juncture-to-p1-ata-panel
   p5-p6-juncture-to-p3-z-face1 p3-z-face1-to-p1-ata-panel p1-ata-panel-to-p3-z-face1
   p5-p6-juncture-to-p6-z-face1 
   p1-ata-panel-to-airlock airlock-to-p1-ata-panel p5-p6-juncture-to-airlock
   P1-ATA-PANEL-TO-P6-Z-FACE1 P6-Z-FACE1-TO-P1-ATA-PANEL 
   P1-ATA-PANEL-TO-P5-P6-JUNCTURE P5-P6-JUNCTURE-TO-P1-ATA-PANEL 
   AIRLOCK-TO-P1-NADIR-BAY12 P1-NADIR-BAY12-TO-AIRLOCK 
   AIRLOCK-TO-PORT-CETA-CART-LOC PORT-CETA-CART-LOC-TO-AIRLOCK 
   P1-NADIR-BAY12-TO-PORT-CETA-CART-LOC PORT-CETA-CART-LOC-TO-P1-NADIR-BAY12 
   PORT-CETA-CART-LOC-TO-P1-ATA-PANEL P1-ATA-PANEL-TO-PORT-CETA-CART-LOC 
   PORT-CETA-CART-LOC-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE-TO-PORT-CETA-CART-LOC 
   PORT-CETA-CART-LOC-TO-P6-Z-FACE1 P6-Z-FACE1-TO-PORT-CETA-CART-LOC
   S1-STOW-BEAM-LOC-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE-TO-S1-STOW-BEAM-LOC 
   S1-STOW-BEAM-LOC-TO-AIRLOCK AIRLOCK-TO-S1-STOW-BEAM-LOC 
   P3-P4-JUNCTURE-TO-P1-NADIR-BAY12 P1-NADIR-BAY12-TO-P3-P4-JUNCTURE
   S1-STOW-BEAM-LOC-TO-P1-ATA-PANEL P1-ATA-PANEL-TO-S1-STOW-BEAM-LOC 
   S1-STOW-BEAM-LOC-TO-P6-Z-FACE1 P6-Z-FACE1-TO-S1-STOW-BEAM-LOC S1-STOW-BEAM-LOC-TO-P3-P4-JUNCTURE 
   P3-P4-JUNCTURE-TO-S1-STOW-BEAM-LOC P3-P4-JUNCTURE-TO-P6-Z-FACE1 P6-Z-FACE1-TO-P3-P4-JUNCTURE - path
   dave davejr - phalcon 
   john michelle  - cato 
   jane frank - adco
   charlotte Jim - odin
   mike nancy - thor)
  (:init 
   (contamination-state no-contamination)
   (worksite-for spdm-lube p1-nadir-bay12)
   (ata-configuration vent)
   (cover-for sarj-port cover8)
   (cover-for sarj-port cover9)
   (cover-for sarj-port cover12)
   (cover-for sarj-port cover13)
   (cover-for sarj-port cover16)
   (cover-for sarj-port cover17)
   (cover-for-cover-set sarj-port 1 cover8)
   (cover-for-cover-set sarj-port 1 cover9)
   (cover-for-cover-set sarj-port 1 cover12)
   (cover-for-cover-set sarj-port 1 cover13)
   (cover-for-cover-set sarj-port 2 cover16)
   (cover-for-cover-set sarj-port 2 cover17)
   (located drager-tube1 INTRA-VEHICLE)
   (located cover8 p3-p4-juncture)
   (located cover9 p3-p4-juncture)
   (located cover12 p3-p4-juncture)
   (located cover13 p3-p4-juncture)
   (located cover16 p3-p4-juncture)
   (located cover17 p3-p4-juncture)
   (possesses bob MUT-EE1)
   (possesses sally MUT-EE2)
   (possesses bob pgt1)
   (possesses bob wifa1)
   (available wifa1)
   (possesses sally pgt2)
   (possesses sally pgt3)
   (possesses sally wifa2)
   (possesses sally square-scoop3)
   (location-for s1-radiator-stow-beam s1-stow-beam-loc)
   (location-for ddcus01a DDCUS01A-LOC)
   (location-for power-cable1 PWR-JUMPER-LOC)
   (location-for fqd-jumper1 FQD-JUMPER-LOC)
   (location-for spd1 FQD-JUMPER-LOC)
   (location-for spd2 FQD-JUMPER-LOC)
   (location-for ceta-light1 LAB-CETA-LIGHT-LOC)
   (location-for ceta-light2 LAB-CETA-LIGHT-LOC)
   (location-for vte-bag1 P6-Z-FACE1)
;;; START To demo the plan diagnostics
   (too-far LAB-CETA-LIGHT-LOC-to-p3-p4-juncture)
   (too-far p3-p4-juncture-to-LAB-CETA-LIGHT-LOC)
;;; END
   ;;   (too-far AIRLOCK-TO-p3-p4-juncture)
   ;;   (too-far p3-p4-juncture-TO-AIRLOCK)
   (too-far AIRLOCK-TO-P6-Z-FACE1)
   (too-far P6-Z-FACE1-TO-AIRLOCK)
   ;;   (too-far p3-p4-juncture-to-p1-ata-panel)
   ;;   (too-far p1-ata-panel-to-p3-p4-juncture)
   (too-far p5-p6-juncture-to-airlock)
   (too-far P1-ATA-PANEL-TO-P6-Z-FACE1)(too-far P6-Z-FACE1-TO-P1-ATA-PANEL)
   (too-far P1-ATA-PANEL-TO-P5-P6-JUNCTURE)(too-far P5-P6-JUNCTURE-TO-P1-ATA-PANEL)
;;; Start To demo the plan diagnostics
   (intermediate-loc-for LAB-CETA-LIGHT-LOC-to-p3-p4-juncture P3-Z-FACE1)
   (intermediate-loc-for p3-p4-juncture-to-LAB-CETA-LIGHT-LOC P3-Z-FACE1)
;;; END
   (intermediate-loc-for P1-ATA-PANEL-TO-P5-P6-JUNCTURE p3-z-face1)
   (intermediate-loc-for P5-P6-JUNCTURE-TO-P1-ATA-PANEL p3-z-face1)   
   (intermediate-loc-for P1-ATA-PANEL-TO-P6-Z-FACE1 p3-z-face1)
   (intermediate-loc-for P6-Z-FACE1-TO-P1-ATA-PANEL p3-z-face1)
   (intermediate-loc-for AIRLOCK-TO-P6-Z-FACE1 P3-Z-FACE1)
   (intermediate-loc-for P6-Z-FACE1-TO-AIRLOCK P3-Z-FACE1)
;;;   (intermediate-loc-for P3-p4-juncture-TO-AIRLOCK P3-Z-FACE1)
;;;   (intermediate-loc-for AIRLOCK-TO-P3-p4-juncture P3-Z-FACE1)
;;;   (intermediate-loc-for p3-p4-juncture-to-p1-ata-panel P3-Z-FACE1)
   (intermediate-loc-for p1-ata-panel-to-p3-p4-juncture P3-Z-FACE1)
   (intermediate-loc-for p5-p6-juncture-to-airlock P3-Z-FACE1)
   (needs-bag ceta-light1)
   (needs-bag ceta-light2)(needs-bag ceta-light3)
   (needs-bag cpa1)
   (o2-use-rate sally 0.3)
   (o2-use-rate bob 0.5)
   (o2-use-rate joe 0.75)
   (body-size sally small)
   (body-size bob medium)
   (body-size joe large)
   (segment lab-ceta-light-loc P3)
   (bay lab-ceta-light-loc P3-BAY4)
   (face lab-ceta-light-loc P3-BAY4-FACE3)
   (END-LOC CETA-CART-LOC2-TO-CETA-CART-LOC1 CETA-CART-LOC1) (START-LOC CETA-CART-LOC2-TO-CETA-CART-LOC1 CETA-CART-LOC2)
   (END-LOC CETA-CART-LOC1-TO-CETA-CART-LOC2 CETA-CART-LOC2) (START-LOC CETA-CART-LOC1-TO-CETA-CART-LOC2 CETA-CART-LOC1)
   (END-LOC CETA-CART-LOC2-TO-SSRMS-LOC1 SSRMS-LOC1) (START-LOC CETA-CART-LOC2-TO-SSRMS-LOC1 CETA-CART-LOC2)
   (END-LOC SSRMS-LOC1-TO-CETA-CART-LOC2 CETA-CART-LOC2) (START-LOC SSRMS-LOC1-TO-CETA-CART-LOC2 SSRMS-LOC1)
   (END-LOC CETA-CART-LOC1-TO-SSRMS-LOC1 SSRMS-LOC1) (START-LOC CETA-CART-LOC1-TO-SSRMS-LOC1 CETA-CART-LOC1)
   (END-LOC SSRMS-LOC1-TO-CETA-CART-LOC1 CETA-CART-LOC1) (START-LOC SSRMS-LOC1-TO-CETA-CART-LOC1 SSRMS-LOC1)
   (END-LOC CETA-CART-LOC2-TO-DDCUS01A-LOC DDCUS01A-LOC) (START-LOC CETA-CART-LOC2-TO-DDCUS01A-LOC CETA-CART-LOC2)
   (END-LOC DDCUS01A-LOC-TO-CETA-CART-LOC2 CETA-CART-LOC2) (START-LOC DDCUS01A-LOC-TO-CETA-CART-LOC2 DDCUS01A-LOC)
   (END-LOC CETA-CART-LOC1-TO-DDCUS01A-LOC DDCUS01A-LOC) (START-LOC CETA-CART-LOC1-TO-DDCUS01A-LOC CETA-CART-LOC1)
   (END-LOC DDCUS01A-LOC-TO-CETA-CART-LOC1 CETA-CART-LOC1) (START-LOC DDCUS01A-LOC-TO-CETA-CART-LOC1 DDCUS01A-LOC)
   (END-LOC SSRMS-LOC1-TO-DDCUS01A-LOC DDCUS01A-LOC) (START-LOC SSRMS-LOC1-TO-DDCUS01A-LOC SSRMS-LOC1)
   (END-LOC DDCUS01A-LOC-TO-SSRMS-LOC1 SSRMS-LOC1) (START-LOC DDCUS01A-LOC-TO-SSRMS-LOC1 DDCUS01A-LOC)
   (END-LOC CETA-CART-LOC2-TO-FQD-JUMPER-LOC FQD-JUMPER-LOC) (START-LOC CETA-CART-LOC2-TO-FQD-JUMPER-LOC CETA-CART-LOC2)
   (END-LOC FQD-JUMPER-LOC-TO-CETA-CART-LOC2 CETA-CART-LOC2) (START-LOC FQD-JUMPER-LOC-TO-CETA-CART-LOC2 FQD-JUMPER-LOC)
   (END-LOC CETA-CART-LOC1-TO-FQD-JUMPER-LOC FQD-JUMPER-LOC) (START-LOC CETA-CART-LOC1-TO-FQD-JUMPER-LOC CETA-CART-LOC1)
   (END-LOC FQD-JUMPER-LOC-TO-CETA-CART-LOC1 CETA-CART-LOC1) (START-LOC FQD-JUMPER-LOC-TO-CETA-CART-LOC1 FQD-JUMPER-LOC)
   (END-LOC SSRMS-LOC1-TO-FQD-JUMPER-LOC FQD-JUMPER-LOC) (START-LOC SSRMS-LOC1-TO-FQD-JUMPER-LOC SSRMS-LOC1)
   (END-LOC FQD-JUMPER-LOC-TO-SSRMS-LOC1 SSRMS-LOC1) (START-LOC FQD-JUMPER-LOC-TO-SSRMS-LOC1 FQD-JUMPER-LOC)
   (END-LOC DDCUS01A-LOC-TO-FQD-JUMPER-LOC FQD-JUMPER-LOC) (START-LOC DDCUS01A-LOC-TO-FQD-JUMPER-LOC DDCUS01A-LOC)
   (END-LOC FQD-JUMPER-LOC-TO-DDCUS01A-LOC DDCUS01A-LOC) (START-LOC FQD-JUMPER-LOC-TO-DDCUS01A-LOC FQD-JUMPER-LOC)
   (END-LOC CETA-CART-LOC2-TO-PWR-JUMPER-LOC PWR-JUMPER-LOC) (START-LOC CETA-CART-LOC2-TO-PWR-JUMPER-LOC CETA-CART-LOC2)
   (END-LOC PWR-JUMPER-LOC-TO-CETA-CART-LOC2 CETA-CART-LOC2) (START-LOC PWR-JUMPER-LOC-TO-CETA-CART-LOC2 PWR-JUMPER-LOC)
   (END-LOC CETA-CART-LOC1-TO-PWR-JUMPER-LOC PWR-JUMPER-LOC) (START-LOC CETA-CART-LOC1-TO-PWR-JUMPER-LOC CETA-CART-LOC1)
   (END-LOC PWR-JUMPER-LOC-TO-CETA-CART-LOC1 CETA-CART-LOC1) (START-LOC PWR-JUMPER-LOC-TO-CETA-CART-LOC1 PWR-JUMPER-LOC)
   (END-LOC SSRMS-LOC1-TO-PWR-JUMPER-LOC PWR-JUMPER-LOC) (START-LOC SSRMS-LOC1-TO-PWR-JUMPER-LOC SSRMS-LOC1)
   (END-LOC PWR-JUMPER-LOC-TO-SSRMS-LOC1 SSRMS-LOC1) (START-LOC PWR-JUMPER-LOC-TO-SSRMS-LOC1 PWR-JUMPER-LOC)
   (END-LOC DDCUS01A-LOC-TO-PWR-JUMPER-LOC PWR-JUMPER-LOC) (START-LOC DDCUS01A-LOC-TO-PWR-JUMPER-LOC DDCUS01A-LOC)
   (END-LOC PWR-JUMPER-LOC-TO-DDCUS01A-LOC DDCUS01A-LOC) (START-LOC PWR-JUMPER-LOC-TO-DDCUS01A-LOC PWR-JUMPER-LOC)
   (END-LOC FQD-JUMPER-LOC-TO-PWR-JUMPER-LOC PWR-JUMPER-LOC) (START-LOC FQD-JUMPER-LOC-TO-PWR-JUMPER-LOC FQD-JUMPER-LOC)
   (END-LOC PWR-JUMPER-LOC-TO-FQD-JUMPER-LOC FQD-JUMPER-LOC) (START-LOC PWR-JUMPER-LOC-TO-FQD-JUMPER-LOC PWR-JUMPER-LOC)
   (END-LOC CETA-CART-LOC2-TO-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC)
   (START-LOC CETA-CART-LOC2-TO-LAB-CETA-LIGHT-LOC CETA-CART-LOC2)
   (END-LOC LAB-CETA-LIGHT-LOC-TO-CETA-CART-LOC2 CETA-CART-LOC2)
   (START-LOC LAB-CETA-LIGHT-LOC-TO-CETA-CART-LOC2 LAB-CETA-LIGHT-LOC)
   (END-LOC CETA-CART-LOC1-TO-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC)
   (START-LOC CETA-CART-LOC1-TO-LAB-CETA-LIGHT-LOC CETA-CART-LOC1)
   (END-LOC LAB-CETA-LIGHT-LOC-TO-CETA-CART-LOC1 CETA-CART-LOC1)
   (START-LOC LAB-CETA-LIGHT-LOC-TO-CETA-CART-LOC1 LAB-CETA-LIGHT-LOC)
   (END-LOC SSRMS-LOC1-TO-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC) (START-LOC SSRMS-LOC1-TO-LAB-CETA-LIGHT-LOC SSRMS-LOC1)
   (END-LOC LAB-CETA-LIGHT-LOC-TO-SSRMS-LOC1 SSRMS-LOC1) (START-LOC LAB-CETA-LIGHT-LOC-TO-SSRMS-LOC1 LAB-CETA-LIGHT-LOC)
   (END-LOC DDCUS01A-LOC-TO-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC) (START-LOC DDCUS01A-LOC-TO-LAB-CETA-LIGHT-LOC DDCUS01A-LOC)
   (END-LOC LAB-CETA-LIGHT-LOC-TO-DDCUS01A-LOC DDCUS01A-LOC) (START-LOC LAB-CETA-LIGHT-LOC-TO-DDCUS01A-LOC LAB-CETA-LIGHT-LOC)
   (END-LOC FQD-JUMPER-LOC-TO-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC)
   (START-LOC FQD-JUMPER-LOC-TO-LAB-CETA-LIGHT-LOC FQD-JUMPER-LOC)
   (END-LOC LAB-CETA-LIGHT-LOC-TO-FQD-JUMPER-LOC FQD-JUMPER-LOC)
   (START-LOC LAB-CETA-LIGHT-LOC-TO-FQD-JUMPER-LOC LAB-CETA-LIGHT-LOC)
   (END-LOC PWR-JUMPER-LOC-TO-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC)
   (START-LOC PWR-JUMPER-LOC-TO-LAB-CETA-LIGHT-LOC PWR-JUMPER-LOC)
   (END-LOC LAB-CETA-LIGHT-LOC-TO-PWR-JUMPER-LOC PWR-JUMPER-LOC)
   (START-LOC LAB-CETA-LIGHT-LOC-TO-PWR-JUMPER-LOC LAB-CETA-LIGHT-LOC) (END-LOC CETA-CART-LOC2-TO-AIRLOCK AIRLOCK)
   (START-LOC CETA-CART-LOC2-TO-AIRLOCK CETA-CART-LOC2) (END-LOC AIRLOCK-TO-CETA-CART-LOC2 CETA-CART-LOC2)
   (START-LOC AIRLOCK-TO-CETA-CART-LOC2 AIRLOCK) (END-LOC CETA-CART-LOC1-TO-AIRLOCK AIRLOCK)
   (START-LOC CETA-CART-LOC1-TO-AIRLOCK CETA-CART-LOC1) (END-LOC AIRLOCK-TO-CETA-CART-LOC1 CETA-CART-LOC1)
   (START-LOC AIRLOCK-TO-CETA-CART-LOC1 AIRLOCK) (END-LOC SSRMS-LOC1-TO-AIRLOCK AIRLOCK)
   (START-LOC SSRMS-LOC1-TO-AIRLOCK SSRMS-LOC1) (END-LOC AIRLOCK-TO-SSRMS-LOC1 SSRMS-LOC1)
   (START-LOC AIRLOCK-TO-SSRMS-LOC1 AIRLOCK) (END-LOC DDCUS01A-LOC-TO-AIRLOCK AIRLOCK)
   (START-LOC DDCUS01A-LOC-TO-AIRLOCK DDCUS01A-LOC) (END-LOC AIRLOCK-TO-DDCUS01A-LOC DDCUS01A-LOC)
   (START-LOC AIRLOCK-TO-DDCUS01A-LOC AIRLOCK) (END-LOC FQD-JUMPER-LOC-TO-AIRLOCK AIRLOCK)
   (START-LOC FQD-JUMPER-LOC-TO-AIRLOCK FQD-JUMPER-LOC) (END-LOC AIRLOCK-TO-FQD-JUMPER-LOC FQD-JUMPER-LOC)
   (START-LOC AIRLOCK-TO-FQD-JUMPER-LOC AIRLOCK) (END-LOC PWR-JUMPER-LOC-TO-AIRLOCK AIRLOCK)
   (START-LOC PWR-JUMPER-LOC-TO-AIRLOCK PWR-JUMPER-LOC) (END-LOC AIRLOCK-TO-PWR-JUMPER-LOC PWR-JUMPER-LOC)
   (START-LOC AIRLOCK-TO-PWR-JUMPER-LOC AIRLOCK) (END-LOC LAB-CETA-LIGHT-LOC-TO-AIRLOCK AIRLOCK)
   (START-LOC LAB-CETA-LIGHT-LOC-TO-AIRLOCK LAB-CETA-LIGHT-LOC)
   (END-LOC AIRLOCK-TO-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC) (START-LOC AIRLOCK-TO-LAB-CETA-LIGHT-LOC AIRLOCK)
;;; START to demo the plan diagnostics, take these out
   (start-loc P3-Z-FACE1-to-LAB-CETA-LIGHT-LOC P3-Z-FACE1)
   (end-loc P3-Z-FACE1-to-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC)
   (end-loc LAB-CETA-LIGHT-LOC-to-P3-Z-FACE1 P3-Z-FACE1)
   (start-loc LAB-CETA-LIGHT-LOC-to-P3-Z-FACE1 LAB-CETA-LIGHT-LOC)
   (start-loc LAB-CETA-LIGHT-LOC-to-p3-p4-juncture LAB-CETA-LIGHT-LOC)
   (end-loc LAB-CETA-LIGHT-LOC-to-p3-p4-juncture p3-p4-juncture)
   (end-loc p3-p4-juncture-to-LAB-CETA-LIGHT-LOC LAB-CETA-LIGHT-LOC)
   (start-loc p3-p4-juncture-to-LAB-CETA-LIGHT-LOC p3-p4-juncture)
;;; END
   (start-loc S1-STOW-BEAM-LOC-TO-P1-ATA-PANEL S1-STOW-BEAM-LOC)
   (end-loc S1-STOW-BEAM-LOC-TO-P1-ATA-PANEL P1-ATA-PANEL)
   (start-loc P1-ATA-PANEL-TO-S1-STOW-BEAM-LOC P1-ATA-PANEL)
   (end-loc P1-ATA-PANEL-TO-S1-STOW-BEAM-LOC S1-STOW-BEAM-LOC)
   (start-loc P3-P4-JUNCTURE-TO-P1-NADIR-BAY12 P3-P4-JUNCTURE)
   (end-loc P3-P4-JUNCTURE-TO-P1-NADIR-BAY12 P1-NADIR-BAY12)
   (start-loc P1-NADIR-BAY12-TO-P3-P4-JUNCTURE P1-NADIR-BAY12)
   (end-loc P1-NADIR-BAY12-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE)
   (start-loc S1-STOW-BEAM-LOC-TO-AIRLOCK S1-STOW-BEAM-LOC)
   (end-loc S1-STOW-BEAM-LOC-TO-AIRLOCK AIRLOCK)
   (start-loc AIRLOCK-TO-S1-STOW-BEAM-LOC AIRLOCK)
   (end-loc AIRLOCK-TO-S1-STOW-BEAM-LOC S1-STOW-BEAM-LOC)
   (start-loc S1-STOW-BEAM-LOC-TO-P3-P4-JUNCTURE S1-STOW-BEAM-LOC)
   (end-loc S1-STOW-BEAM-LOC-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE)
   (start-loc P3-P4-JUNCTURE-TO-S1-STOW-BEAM-LOC P3-P4-JUNCTURE)
   (end-loc P3-P4-JUNCTURE-TO-S1-STOW-BEAM-LOC S1-STOW-BEAM-LOC)
   (start-loc p3-p4-juncture-to-p6-z-face1 p3-p4-juncture)
   (end-loc p3-p4-juncture-to-p6-z-face1 p6-z-face1)
   (start-loc p6-z-face1-to-p3-p4-juncture p6-z-face1)
   (end-loc  p6-z-face1-to-p3-p4-juncture p3-p4-juncture)
   (start-loc p3-p4-juncture-to-p5-p6-juncture p3-p4-juncture)
   (end-loc  p3-p4-juncture-to-p5-p6-juncture p5-p6-juncture)
   (start-loc p5-p6-juncture-to-p3-p4-juncture p5-p6-juncture)
   (end-loc  p5-p6-juncture-to-p3-p4-juncture p3-p4-juncture)
   (start-loc p5-p6-juncture-to-p6-z-face1 p5-p6-juncture)
   (end-loc  p5-p6-juncture-to-p6-z-face1 p6-z-face1)
   (start-loc p1-ata-panel-to-airlock p1-ata-panel)
   (end-loc  p1-ata-panel-to-airlock airlock)
   (start-loc airlock-to-p1-ata-panel airlock)
   (end-loc airlock-to-p1-ata-panel p1-ata-panel)
   (start-loc p5-p6-juncture-to-p3-z-face1 p5-p6-juncture)
   (end-loc p5-p6-juncture-to-p3-z-face1 p3-z-face1)
   (start-loc AIRLOCK-TO-P1-NADIR-BAY12 AIRLOCK)(end-loc AIRLOCK-TO-P1-NADIR-BAY12 P1-NADIR-BAY12)
   (start-loc P1-NADIR-BAY12-TO-AIRLOCK P1-NADIR-BAY12)(end-loc P1-NADIR-BAY12-TO-AIRLOCK AIRLOCK)
   (start-loc AIRLOCK-TO-PORT-CETA-CART-LOC AIRLOCK)(end-loc AIRLOCK-TO-PORT-CETA-CART-LOC PORT-CETA-CART-LOC)
   (start-loc PORT-CETA-CART-LOC-TO-AIRLOCK PORT-CETA-CART-LOC)(end-loc PORT-CETA-CART-LOC-TO-AIRLOCK AIRLOCK)
   (start-loc P1-NADIR-BAY12-TO-PORT-CETA-CART-LOC P1-NADIR-BAY12)
   (end-loc P1-NADIR-BAY12-TO-PORT-CETA-CART-LOC PORT-CETA-CART-LOC)
   (start-loc PORT-CETA-CART-LOC-TO-P1-NADIR-BAY12 PORT-CETA-CART-LOC)
   (end-loc PORT-CETA-CART-LOC-TO-P1-NADIR-BAY12 P1-NADIR-BAY12)
   ;; a/l to mid place
   (END-LOC  AIRLOCK-TO-P3-Z-FACE1 P3-Z-FACE1)
   (START-LOC AIRLOCK-TO-P3-Z-FACE1 AIRLOCK)
   ;;mid-place to a/l
   (END-LOC  P3-Z-FACE1-TO-AIRLOCK AIRLOCK)
   (START-LOC P3-Z-FACE1-TO-AIRLOCK  P3-Z-FACE1)
   ;;; a/l to far loc
   (END-LOC AIRLOCK-TO-P6-Z-FACE1 P6-Z-FACE1) 
   (START-LOC AIRLOCK-TO-P6-Z-FACE1 AIRLOCK)
   ;; far place to a/l
   (END-LOC P6-Z-FACE1-TO-AIRLOCK AIRLOCK)
   (START-LOC P6-Z-FACE1-TO-AIRLOCK P6-Z-FACE1)
   ;;mid-place to far place 
   (END-LOC P3-Z-FACE1-TO-P6-Z-FACE1 P6-Z-FACE1)
   (START-LOC P3-Z-FACE1-TO-P6-Z-FACE1 P3-Z-FACE1)
   ;; far place to mid place
   (END-LOC  P6-Z-FACE1-TO-P3-Z-FACE1 P3-Z-FACE1)
   (START-LOC P6-Z-FACE1-TO-P3-Z-FACE1 P6-Z-FACE1)
   ;; a/l to far place
   (END-LOC AIRLOCK-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE) 
   (START-LOC AIRLOCK-TO-P3-P4-JUNCTURE AIRLOCK)
   ;; far place to a/l
   (END-LOC P3-P4-JUNCTURE-TO-AIRLOCK AIRLOCK) 
   (START-LOC P3-P4-JUNCTURE-TO-AIRLOCK P3-P4-JUNCTURE)
   ;; mid place to far place
   (END-LOC P3-Z-FACE1-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE) 
   (START-LOC P3-Z-FACE1-TO-P3-P4-JUNCTURE P3-Z-FACE1)
   ;; far place to mid place
   (END-LOC P3-P4-JUNCTURE-TO-P3-Z-FACE1 P3-Z-FACE1) 
   (START-LOC P3-P4-JUNCTURE-TO-P3-Z-FACE1 P3-P4-JUNCTURE)
   ;; far place to ata panel
   (END-LOC P3-P4-JUNCTURE-TO-P1-ATA-PANEL P1-ATA-PANEL)
   (START-LOC P3-P4-JUNCTURE-TO-P1-ATA-PANEL P3-P4-JUNCTURE)
   ;; mid place to ata panel
   (END-LOC P3-Z-FACE1-TO-P1-ATA-PANEL P1-ATA-PANEL) 
   (START-LOC P3-Z-FACE1-TO-P1-ATA-PANEL P3-Z-FACE1)
   ;; ata panel to far place
   (END-LOC P1-ATA-PANEL-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE)
   (START-LOC P1-ATA-PANEL-TO-P3-P4-JUNCTURE P1-ATA-PANEL)
   ;; ata panel to mid-place
   (END-LOC P1-ATA-PANEL-TO-P3-Z-FACE1 P3-Z-FACE1)
   (START-LOC P1-ATA-PANEL-TO-P3-Z-FACE1 P1-ATA-PANEL)
   ;; far place to a/l
   (END-LOC P5-p6-JUNCTURE-TO-AIRLOCK AIRLOCK) 
   (START-LOC P5-p6-JUNCTURE-TO-AIRLOCK P5-p6-JUNCTURE)
   
   (start-loc P1-ATA-PANEL-TO-P6-Z-FACE1 P1-ATA-PANEL)(end-loc P1-ATA-PANEL-TO-P6-Z-FACE1 P6-Z-FACE1)
   (start-loc P6-Z-FACE1-TO-P1-ATA-PANEL P6-Z-FACE1)(end-loc P6-Z-FACE1-TO-P1-ATA-PANEL P1-ATA-PANEL)
   (start-loc P1-ATA-PANEL-TO-P3-Z-FACE1 P1-ATA-PANEL)(end-loc P1-ATA-PANEL-TO-P3-Z-FACE1 p3-z-face1)
   (start-loc P3-Z-FACE1-TO-P1-ATA-PANEL p3-z-face1)(end-loc P3-Z-FACE1-TO-P1-ATA-PANEL P1-ATA-PANEL)
   (start-loc P3-Z-FACE1-TO-P6-Z-FACE1 p3-z-face1)(end-loc P3-Z-FACE1-TO-P6-Z-FACE1 P6-Z-FACE1)
   (start-loc P6-Z-FACE1-TO-P3-Z-FACE1 P6-Z-FACE1)(end-loc P6-Z-FACE1-TO-P3-Z-FACE1 p3-z-face1)
   (start-loc P1-ATA-PANEL-TO-P5-P6-JUNCTURE P1-ATA-PANEL)(end-loc P1-ATA-PANEL-TO-P5-P6-JUNCTURE P5-P6-JUNCTURE)
   (start-loc P5-P6-JUNCTURE-TO-P1-ATA-PANEL P5-P6-JUNCTURE)(end-loc P5-P6-JUNCTURE-TO-P1-ATA-PANEL P1-ATA-PANEL)
   (start-loc PORT-CETA-CART-LOC-TO-P1-NADIR-BAY12 PORT-CETA-CART-LOC)
   (end-loc PORT-CETA-CART-LOC-TO-P1-NADIR-BAY12 P1-NADIR-BAY12)
   (start-loc PORT-CETA-CART-LOC-TO-P1-ATA-PANEL PORT-CETA-CART-LOC)(end-loc PORT-CETA-CART-LOC-TO-P1-ATA-PANEL P1-ATA-PANEL)
   (start-loc P1-ATA-PANEL-TO-PORT-CETA-CART-LOC P1-ATA-PANEL)(end-loc P1-ATA-PANEL-TO-PORT-CETA-CART-LOC PORT-CETA-CART-LOC)
   (start-loc PORT-CETA-CART-LOC-TO-P3-P4-JUNCTURE PORT-CETA-CART-LOC)
   (end-loc PORT-CETA-CART-LOC-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE)
   (start-loc P3-P4-JUNCTURE-TO-PORT-CETA-CART-LOC P3-P4-JUNCTURE)
   (end-loc P3-P4-JUNCTURE-TO-PORT-CETA-CART-LOC PORT-CETA-CART-LOC)
   (start-loc PORT-CETA-CART-LOC-TO-P6-Z-FACE1 PORT-CETA-CART-LOC)(end-loc PORT-CETA-CART-LOC-TO-P6-Z-FACE1 P6-Z-FACE1)
   (start-loc P6-Z-FACE1-TO-PORT-CETA-CART-LOC P6-Z-FACE1)(end-loc P6-Z-FACE1-TO-PORT-CETA-CART-LOC PORT-CETA-CART-LOC)

;;; for AR demo
   (too-far S1-STOW-BEAM-LOC-TO-P6-Z-FACE1)(too-far P6-Z-FACE1-TO-S1-STOW-BEAM-LOC)
   (intermediate-loc-for S1-STOW-BEAM-LOC-TO-P6-Z-FACE1 P3-P4-JUNCTURE)(intermediate-loc-for P6-Z-FACE1-TO-S1-STOW-BEAM-LOC P3-P4-JUNCTURE)
   (start-loc S1-STOW-BEAM-LOC-TO-P6-Z-FACE1 S1-STOW-BEAM-LOC)(end-loc S1-STOW-BEAM-LOC-TO-P6-Z-FACE1 P6-Z-FACE1)
   (start-loc P6-Z-FACE1-TO-S1-STOW-BEAM-LOC P6-Z-FACE1)(end-loc P6-Z-FACE1-TO-S1-STOW-BEAM-LOC S1-STOW-BEAM-LOC)
   (start-loc S1-STOW-BEAM-LOC-TO-P3-P4-JUNCTURE S1-STOW-BEAM-LOC)(end-loc S1-STOW-BEAM-LOC-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE)
   (start-loc P3-P4-JUNCTURE-TO-S1-STOW-BEAM-LOC P3-P4-JUNCTURE)(end-loc P3-P4-JUNCTURE-TO-S1-STOW-BEAM-LOC S1-STOW-BEAM-LOC)
   (start-loc P3-P4-JUNCTURE-TO-P6-Z-FACE1 P3-P4-JUNCTURE)(end-loc P3-P4-JUNCTURE-TO-P6-Z-FACE1 P6-Z-FACE1)
   (start-loc P6-Z-FACE1-TO-P3-P4-JUNCTURE P6-Z-FACE1)(end-loc P6-Z-FACE1-TO-P3-P4-JUNCTURE P3-P4-JUNCTURE)

   (distance AIRLOCK LAB-CETA-LIGHT-LOC 30)
   (located p6-radiator p5-p6-juncture)
   (located cpa1 intra-vehicle)
   (located cpa-bag1 intra-vehicle)
   (located crew-lock-bag1 intra-vehicle)
   (located sarj-bag1 intra-vehicle)
   (located  s1-beam-bag intra-vehicle)
   (bag-size-for ceta-light1 ceta-light-bag1)
   (bag-size-for ceta-light2 ceta-light-bag1)
   (bag-size-for ceta-light3 ceta-light-bag1)
   (bag-size-for ceta-light1 ceta-light-bag2)
   (bag-size-for ceta-light2 ceta-light-bag2)
   (bag-size-for ceta-light3 ceta-light-bag2)
   (bag-size-for ceta-light1 ceta-light-bag3)
   (bag-size-for ceta-light2 ceta-light-bag3)
   (bag-size-for ceta-light3 ceta-light-bag3)
   (bag-size-for cpa1 cpa-bag1)
   (installed vte-bag1)
   ;;;(installed sarj-bag1)
   (located vte-bag1 P6-Z-FACE1)
   ;;;(located sarj-bag1 p3-p4-juncture)
   (located eas-jumpers P6-Z-FACE1)(located p1-p5 P6-Z-FACE1)
   (located p1-p5-jumpers P6-Z-FACE1)
   (contains s1-beam-bag s1-inboard-stow-beam)
   (contains s1-beam-bag s1-outboard-stow-beam)
   (contains ssrms spdm)
   (contains spdm spdm-lee-cla)
   (contains sarj-bag1 cla-cover)
   (contains sarj-bag1 jhookgun1)
   (contains sarj-bag1 sngun1)
   (contains sarj-bag1 camera1)
   (contains sarj-bag1 sarj-clb)
   (contains sarj-bag1 wipes1)
   (contains sarj-bag1 adjt1)
   (contains sarj-bag1 adjt2)
   (contains sarj-bag1 adjt3)
   (contains sarj-bag1 adjt4)
   (contains sarj-bag1 adjt5)
   (contains sarj-bag1 adjt6)
   (available adjt1)   (available adjt2)   (available adjt3)   (available adjt4)   (available adjt5)   (available adjt6)
   (contains vte-bag1 vt-adapter1)
   (contains vte-bag1 vent-tool1)
   (contains stanchion-mount-cover1 ddcu-spare1)
   (contains crew-lock-bag1 square-scoop1)
   (contains stp1 ISS-safety-tether3)
   (contains stp2 ISS-safety-tether4)
   (possesses bob ratchet-wrench1)
   (possesses bob square-scoop2)
   (contains cpa-bag1 cpa1)
   (contains cpa-bag1 ctp1)
   (located fqd-jumper1 FQD-JUMPER-LOC)
   (located hr1 AIRLOCK)
   (located hr2 INTRA-VEHICLE)
   (located hr3 AIRLOCK)
   (located hr4 INTRA-VEHICLE)
   (located sally intra-vehicle)
   (located joe intra-vehicle)
   (operator ssrms joe)
   (can-reach ssrms p1-nadir-bay12)
   (can-reach ssrms ceta-cart-loc1)
   (can-reach ssrms airlock)
   (located bob intra-vehicle)
   ;;;(state thermal-cover open)
   (open hatch)
   (located fish-stringer1 intra-vehicle)
   (contains fish-stringer1 power-cable1)
   (contains fish-stringer1 spd1)
   (contains fish-stringer1 spd2)
   (available square-scoop1)
   (available square-scoop2)
   (available ddcu-spare1)
   (available ISS-safety-tether1)
   (available ISS-safety-tether2)
   (located ISS-safety-tether1 AIRLOCK)
   (located ISS-safety-tether2 AIRLOCK)
   (installed ISS-safety-tether1)
   (installed ISS-safety-tether2)
   (located stanchion-mount-cover1 intra-vehicle)
   (located ddcus01b intra-vehicle)
   (located ceta-light-bag2 intra-vehicle)
   (possesses bob stp1)
   (possesses sally stp2)
   ;;(located stp1 intra-vehicle)(located stp2 intra-vehicle)
   (located ceta-light-bag1 intra-vehicle)
   ;;;(located CETA-LIGHT1 P6-Z-FACE1)
   (located CETA-LIGHT1 LAB-CETA-LIGHT-LOC)
   (located CETA-LIGHT2 LAB-CETA-LIGHT-LOC)
   (located CETA-LIGHT3 P6-Z-FACE1)
   (installed CETA-LIGHT1)
   (installed CETA-LIGHT2)
   (tool-for s1-radiator-stow-beam s1-beam-bag)
   (tool-for sarj-port sarj-bag1)
   (tool-for ceta-light1 ceta-light-bag1)
   (tool-for ceta-light2 ceta-light-bag2)
   (tool-for ceta-light3 ceta-light-bag3)
   (tool-for power-cable1 fish-stringer1)
   (tool-for fqd-jumper1 fish-stringer1) ;;; has the spds
   (tool-for ddcus01a square-scoop1)
   ;;;(available apfr1)  used to be used for tests but want apfr3 to be used now
   (available apfr2)(available apfr3)
   (located apfr2 intra-vehicle)
   (contains wif1 apfr1)
   (located wif1 airlock)
   (located wif3 port-ceta-cart-loc)   
   (contains wif3 apfr3)
   (storage-site-for apfr3 port-ceta-cart-loc)
   (contains port-ceta-cart wif3)
   (installed wif3)			; note: NOT (available wif3)
   (located wif4 p1-nadir-bay12)
   (installed wif4)(available wif4)
   (located ceta-cart2 ceta-cart-loc2)
   (located ceta-cart1 ceta-cart-loc1)
   (contains ceta-cart1 wif2)
   (located wif2 ceta-cart-loc1) ;; the axioms don't establish this
   (installed wif2)
   (available wif2)
   (installed ddcus01a)
   (located ddcus01a ddcus01a-loc)
   (located ssrms ssrms-loc1)
   (available ssrms)
   (operational rga1)
   (power-source rpc1 ddcuS01a)
   (power-source rpc2 ddcuS01a)
   (associated-rpc rga1 rpc1)
   (associated-rpc rga2 rpc2)
   (associated-rpc cmg1 rpc3)
   (associated-rpc cmg2 rpc4)
   (associated-rt rga1 lab-gnc-1-rt)
   (associated-rt rga2 lab-gnc-2-rt)
   (gps-power-source ddcus01a)
   (gps-alternate-power-source ddcus01b)
   (gps-rpc-string ddcus01a rpc4-5-6-7)
   (gps-rpc-string ddcus01b rpc5-6-7-8)
   (cmg-for ddcus01a cmg1)
   (cmg-for ddcus01b cmg2)
   (string-for sarj-port sarj-string1)
   (lube-location sarj-port p3-p4-juncture)
   (alt-string-for sarj-port sarj-string2)
   (string-for sarj-starboard sarj-string3)
   (alt-string-for sarj-starboard sarj-string4)
   (mode sarj-starboard autotrack)
   (mode sarj-port autotrack)
   ;;;(mode sarj-string1 monitor) 
   (mode sarj-string1 commanded)
   (mode sarj-string3 commanded)
   (configuration lab-itcs dual-loop)
   (primary-ext-mdm ext-MDM1)
   (redundant-ext-mdm ext-MDM2)
   (primary-S0-mdm S0-MDM1)
   (redundant-S0-mdm S0-MDM2)
   (mode S0-MDM1 normal)
   (primary-S1-mdm S1-MDM1)
   (redundant-S1-mdm S1-MDM2)
   (mode S1-MDM1 normal)
   (primary-S3-mdm S3-MDM1)
   (redundant-S3-mdm S3-MDM2)
   (mode S3-MDM1 wait)
   (primary-P1-mdm P1-MDM2)
   (redundant-P1-mdm P1-MDM1)
   (mode P1-MDM2 wait)
   (primary-P3-mdm P3-MDM1)
   (redundant-P3-mdm P3-MDM2)
   (mode P3-MDM1 wait)
   (mode STR-MDM normal)
   (turned-on ddcus01a)
   (turned-on ddcus01b)
   (rt-fdir-mdm ddcus01a S01A-C&C-MDM)
   (rt-fdir-mdm ddcus01b S01B-C&C-MDM)
   (rt-fdir-for S01A-C&C-MDM S01A-rt-fdir)
   (rt-fdir-for S01B-C&C-MDM S01B-rt-fdir)
   (rt-fdir-for ddcus01a ddcus01a-rt-fdir)
   (rt-fdir-for ddcus01b ddcus01b-rt-fdir)
   (rbi-for ddcus01a rbi4)(closed rbi4)
   (rbi-for ddcus01b rbi2)(closed rbi2)
   (etcs-pump-for ddcus01a LOOP-A)
   (etcs-pump-for ddcus01b LOOP-B)
   (cooling-loop-for LOOP-A MTL)
   (cooling-loop-for LOOP-B LTL)
   (sband-for ddcus01a s-band-1)
   (sband-for ddcus01b s-band-2)
   (current-sband s-band-1)(alternate-sband s-band-2))
  )
#|
I use the following to load and run:

ap:  (load-a-domain)

this gives a numbered list of all .PDDL files in the directory =
AP:domains; you can load one by typing the number (<cr> to exit), or you =
can type a sequence of numbers, such as:  22,28,26=20
and it will load those in that order. =20

[BTW, if your <domain> in the file <domain>.pddl then it will be loaded =
automatically if not already done when it tries to load a situation with =
:domain <domain> in the PDDL.  I generally keep all my situations and =
the problems that reference them in a single file and the domain in a =
different one. then I only have to load the situation/problem file. Just =
one more (undocumented) feature]

ap:  (run-again)

this will put up a numbered list of the problems defined for *domain*. =
It has a keyword arg if you want a different domain.

or you can run them all:

ap:  (run-all-problems)
|#