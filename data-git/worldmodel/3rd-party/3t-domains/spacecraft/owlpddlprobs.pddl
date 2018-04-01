;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)

(define (problem open&close-shutter)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (sequential (shutter-state cassini-visible&-infrared-mapping-spectrometer[-vims] open)
		     (shutter-state cassini-visible&-infrared-mapping-spectrometer[-vims] closed))))

(define (problem power&unpower)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (sequential (has-power-state cassini-rcdr power_on)
		     (has-power-state cassini-rcdr power_off))))

(define (problem sens-on&off)
     (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (sequential (state-of-sensors cassini power_on)
		     (state-of-sensors cassini power_off))))
	 
(define (problem comp-on-off)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (sequential (state-of-components cassini power_on)
		     (state-of-components cassini power_off))))

(define (problem point)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:init (current-target cassini mars))
  (:goal (pointed-at  cassini earth)))

(define (problem points)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:init (current-target cassini mars))
  (:goal (sequential (pointed-at  cassini earth)
		     (Delay10_a cassini on)
		     (pointed-at  cassini saturn)
		     (Delay10_a cassini done)
		     (pointed-at  cassini jupiter))))

(define (problem point&shoot)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (pointed&imaged cassini jupiter)))

(define (problem point&shoot_dawn)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (pointed&imaged dawn jupiter)))

;;; both of the following fail on the 4th subgoal of point&image
;;;  which is (IMAGE-STORED ?usc JUPITER) 
;;; According to the point&shoot problem above, that should
;;;  be fulfilled by store-image.        CE 2014-09-24

(define (problem point&image_earth)
    (:comment "test first parallel subgoal of do-jobs")
  (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:vars ?usc - (or cassini dawn)) ;;unmanned-space-craft)
  (:goal (pointed&imaged ?usc earth)))

(define (problem point&image_earth_cassini)
    (:comment "is it possible with something other than dawn? yes")
  (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (pointed&imaged cassini earth)))

(define (problem point&image_jupiter)
    (:comment "test second parallel subgoal of do-jobs")
  (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:vars ?usc - unmanned-space-craft)	; designator
  (:goal (pointed&imaged ?usc jupiter)))

(define (problem point&image_jupiter_cassini)
    (:comment "is it possible with something other than dawn? yes")
  (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (pointed&imaged cassini jupiter)))

#|
(define (problem store-images_earth)
    (:comment "test third subgoal of point&image")
  (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:init				; these should force ?usc <- Cassini
   (has-power-state CASSINI-IMAGING-SCIENCE-SUBSYSTEM[-ISS] power_on)
   (shutter-state CASSINI-IMAGING-SCIENCE-SUBSYSTEM[-ISS] open))
  (:deadline 400.0)
  (:vars ?usc - unmanned-space-craft)
  (:goal (image-stored ?usc earth)))
|#

(NEW-PREDICATE '(TASKS-DONE4 ?S1 ?S2 - SPACE-CRAFT) SPACECRAFT-DOMAIN)
(DEFINE (DURATIVE-ACTION DO-JOBS-agents) :VARS (?S4 ?S5 - UNMANNED-SPACE-CRAFT) :CONDITION
           (AND (AT START (NOT (= ?S4 ?S5)))) :EXPANSION
           (PARALLEL (POINTED&IMAGED ?S4 EARTH) (POINTED&IMAGED ?S5 JUPITER)) 
	   :EFFECT (TASKS-DONE4 ?S4 ?S5))
(DEFINE (PROBLEM DONE-JOBS-agents) (:DOMAIN SPACECRAFT-DOMAIN) (:SITUATION SPACECRAFT1) (:DEADLINE 390.0)
           (:GOAL (TASKS-DONE4 cassini dawn)))

;;; This one fails ...
(DEFINE (DURATIVE-ACTION DO-JOBS) :VARS (?S4 ?S5 - UNMANNED-SPACE-CRAFT) :CONDITION
           (AND (AT START (NOT (= ?S4 ?S5)))) :EXPANSION
           (PARALLEL (POINTED&IMAGED ?S4 EARTH) (POINTED&IMAGED ?S5 JUPITER)) :EFFECT (ALL-JOBS DONE))
(DEFINE (PROBLEM DONE-JOBS) (:DOMAIN SPACECRAFT-DOMAIN) (:SITUATION SPACECRAFT1) (:DEADLINE 390.0)
           (:GOAL (ALL-JOBS DONE)))
#|


(define (problem orbit1)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (located afsat1 iraq)))

(define (problem store-image)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:init (CAMERA-STATE AFSAT1 ON) (SHUTTER-STATE AFSAT1 OPENED))
  (:deadline 400.0)
  (:goal (image_stored afsat1 BaghdadAirport_img)))

(define (problem p&s)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (image_taken afsat1 north_korea_img1)))

(define (problem go-iran)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (located afsat1 iran)))

(define (problem send-one)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:init 
   (comms-state afsat1 opened)
   (camera-state afsat1 off)
   ;;(opened comms)
   )
  (:deadline 400.0)
  (:goal (image_sent afsat1 libya_img)))

(define (problem dlink-one)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:goal (image_downloaded afsat1 libya_img)))

;;; example so you don't have to create new relation for each case
(define (problem take-iraq_TEST)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:init 
   (located afsat1 mozambique))
  (:goal (sequential (image_taken afsat1 IraqDefenseMinistry_img)
		     (image_taken afsat1 Fallujha_img))))

(define (problem take-iraq)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:init 
   (located afsat1 china))
  (:goal (sequential (image_taken afsat1 BaghdadAirport_img)
		     (image_taken afsat1 Fallujha_img)
		     (image_taken afsat1 SadrCity_img))))

(define (problem take-iraq1)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 400.0)
  (:init 
   (located afsat1 china))
  (:goal (images_taken afsat1 BaghdadAirport_img Fallujha_img SadrCity_img)))

(define (problem take-mix1)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 600.0)
  (:goal (images_taken afsat1 china_img BaghdadAirport_img north_korea_img2)))

(define (problem take-mix2)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 600.0)
  (:goal (images_taken afsat1 BaghdadAirport_img north_korea_img2 china_img)))

(define (problem dlink-all)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 600.0)
  (:goal (images_downloaded  afsat1 BaghdadAirport_img north_korea_img2 china_img)))

(define (problem take&store-all)
    (:domain spacecraft-domain)
  (:situation spacecraft1)
  (:deadline 600.0)
  (:goal (images_taken&stored afsat1 BaghdadAirport_img Fallujha_img SadrCity_img)))


|#