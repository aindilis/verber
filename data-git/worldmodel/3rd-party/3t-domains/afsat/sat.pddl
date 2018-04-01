;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
(define (domain sat-domain)
    (:requirements :durative-actions)
  (:extends physob Geography)
  (:types state - object	  
	  image - object
	  attitude - object
	  fuel - object
	  image_name - object
	  down-link-loc - location
	  satellite - agent
	  camera shutter comms target - object)
  (:constants 
   shutter1 - shutter
   imager1 - camera 
   comms1 - comms 
   afsat1 - satellite
   opened closed on off - state
   africa libya iraq iran afghan_pakistan_border china north_korea mozambique - location
   downlink1 downlink2 - down-link-loc
   libya_fuel iraq_fuel iran_fuel afghan_pakistan_border_fuel china_fuel north_korea_fuel
   start_fuel - fuel
   BaghdadAirport_img SadrCity_img IraqDefenseMinistry_img AlShabStadiumIraq_img
   Fallujha_img AfgPakBorder_img china_img north_korea_img1 north_korea_img2 
   iran_img libya_img - image_name
   start_att ba_img_att sc_img_att idm_img_att stad_img_att Fallujha_img_att apb_img_att 
   china_img_att nk_img1_att nk_img2_att iran_img_att libya_img_att - attitude
   )
  (:predicates (has-camera ?sat - satellite ?c - camera)
	       (has-shutter ?sat - satellite ?s - shutter)
	       (has-comms ?sat - satellite ?co - comms)
	       (shutter-state ?sat - satellite ?s - state)
	       (camera-state ?sat - satellite ?s - state)
	       (comms-state ?sat - satellite ?s - state)
	       (downlink-location ?dloc - down-link-loc)
	       (att_for ?n - image_name ?a - attitude)
	       (loc_for ?n - image_name ?l - location)
	       (image_taken ?s - satellite ?n - image_name)
	       (images_taken ?mg1 ?ing2 ?img3 - image_name)
	       (image_stored ?s - satellite ?name - image_name)
	       (image_sent ?s ?name - image_name)
	       (image_downloaded ?s - satellite ?name - image_name)
	       (images_downloaded ?s - satellite ?mg1 ?ing2 ?img3 - image_name)
	       (images_taken&stored ?s - satellite ?img1 ?img2 ?img3 - image_name)
	       (processed ?loc1 ?loc2 ?loc3 - location)
	       (imaged ?loc1 ?loc2 ?loc3 - location)
	       (pointed_at ?s - satellite ?img - image_name)
	       (pointed&imaged ?s - satellite ?img - image_name)
	       (ready_for_loc ?loc - location)
	       (current-attitude ?s - satellite ?catt - attitude)
	       (location-attitude ?loc - location ?gatt - attitude)
	       (fuel-level ?s - satellite ?v - fuel)
	       (fuel-for ?loc - location ?f - fuel)
	       (opened - predicate ?o - object)
	       (on - predicate ?o - object)
	       (state ?item - object ?st - state)
	       )
  
  )

(owl:Restriction 'camera-state 'owl:cardinality 1)
(owl:Restriction 'shutter-state 'owl:cardinality 1)
(owl:Restriction 'comms-state 'owl:cardinality 1)

#|
ANML 
// time units are seconds
action opened_imager_shutter() {
  duration := 1;
  [all] shutter_position == CLOSED :-> OPENED;
}
action close_imager_shutter() {
  duration := 1;
  [all] shutter_position == OPENED :-> CLOSED;
}
(define (durative-action opened_imager_shutter)
    :duration 1.0 
    :condition (at start (not (opened shutter)))
    :effect (at end (opened shutter))
    :comment "openeds shutter.")
	
(define (durative-action close_imager_shutter)
    :duration 1.0 
    :condition (at start (opened shutter))
    :effect (at end (not (opened shutter)))
    :comment "closes shutter.")
;;|#

(define (durative-action open_shutter)
    :parameters (?o - satellite)
    :vars (?shutter - (has-shutter ?o))
    :duration 1.0 
    :effect (at end (shutter-state ?o opened))
    :comment "opens shutter.")
	
(define (durative-action close_shutter)
    :parameters (?o - satellite)
    :vars (?shutter - (has-shutter ?o))
    :duration 1.0 
    :effect (at end (shutter-state ?o closed))
    :comment "closes shutter.")


#|
ANML 
action power_on_imager() {
	duration := 60;
	[all] imager_state == OFF :-> ON;
}
action power_off_imager() {
	duration := 10;
	[all] imager_state == ON :-> OFF;
}
(define (durative-action power_on_imager)
    :duration 4.0 
    :condition (at start (not (on imager)))
    :effect (at end (on imager))
    :comment "turn imager on.")
(define (durative-action power_off_imager)
    :duration 1.0 
    :condition (at start (on imager))
    :effect (at end (not (on imager)))
    :comment "turn imager off.");;|#

(define (durative-action turn-on-camera)
    :parameters (?o - satellite)
    :vars (?cam - (has-camera ?o))
    :duration 1.0 
    :effect (at end (camera-state ?o on))
    :comment "turns on camera.")
	
(define (durative-action turn-off-camera)
    :parameters (?o - satellite)
    :vars (?cam - (has-camera ?o))
    :duration 1.0 
    :effect (at end (camera-state ?o off))
    :comment "turns off camera.")

#|
ANML
action point_at_location(Location location) {
  [start] {
    constant Attitude 
      cAtt := attitude,
      gAtt := location_to_attitude(location);
  }
  duration := swing_time(cAtt,gAtt);

  (all] attitude :-> gAtt;
  [all] fuel :consumes fuel_consumption(cAtt,gAtt); 
}
|#

(defparameter *attitudes*
    '((start_att 100)
      (moz_img1 50)
      (moz_img1_att 50)
      (moz_img2 75)
      (moz_img2_att 75)
      (moz_img3 100)
      (moz_img3_att 100)
      (paris_img1 125)
      (paris_img1_att 125)
      (paris_img2 150)
      (paris_img2_att 150)
      (paris_img3 175)
      (paris_img3_att 175)
      (gw_img1 200)
      (gw_img1_att 200)
      (gw_img2 225)
      (gw_img2_att 225)
      (gw_img3 275)
      (gw_img3_att 275)
      (ent_img1 300)
      (ent_img1_att 300)
      (ent_img2 325)
      (ent_img2_att 325)
      (ent_img3 350)
      (ent_img3_att 350)
      (libya_img 23)
      (libya_img_att 23)
      (BaghdadAirport_img 33)
      (ba_img_att 33)
      (SadrCity_img 34)
      (sc_img_att 34)
      (IraqDefenseMinistry_img 35)
      (idm_img_att 35)
      (AlShabStadiumIraq_img 36)
      (stad_img_att 36)
      (Fallujha_img 37)
      (Fallujha_img_att 37)
      (iran_img 50)
      (iran_img_att 50)
      (AfgPakBorder_img 66)
      (apb_img_att 66)
      (china_img 111)
      (china_img_att 111)
      (north_korea_img1 125)
      (nk_img1_att 125)
      (north_korea_img2 126)
      (nk_img2_att 126)))
      

(defun time-from-attitudes (action)
  (let* ((start-att (second (assoc (name (gsv action '?catt)) *attitudes*)))
	 (end-att (second (assoc (name (gsv action '?img)) *attitudes*)))
	 (diff (- end-att start-att)))
    (format t "~%~%---------------------------------")
    (format t "~%~% start, end, diff = ~a(~a),~a(~a),~a." (name (gsv action '?catt)) start-att (name (gsv action '?img)) end-att diff)
    (format t "~%~% Value for ~a is ~a." (name action) (max 4.0 (/ (abs diff) 5.0)))
    (format t "~%~%---------------------------------")
    (max 4.0 (/ (abs diff) 5.0))))

 ;;; slew rate is two degress per second

(define (durative-action point_at_image)
    :parameters (?s - satellite
		    ?img - image_name)
    :vars (?catt - (current-attitude ?s)
	   ?gatt - attitude
	   ;; ?gatt - (att_for ?img ?gatt) doesn't work for non-designators
	   ?sfuel - (fuel-level ?s)
	   ?lfuel - (fuel-for ?img)
	   )
    :condition (at start (att_for ?img ?gatt))
    :duration  time-from-attitudes
    :effect (and (at end (pointed_at ?s ?img))
		 (at end (current-attitude ?s ?gatt))
	         (at end (fuel-level ?s ?lfuel))
		 )
    :comment "reorient the satellite from curent attitude to attitude of the image.")

(define (durative-action store-an-image)
    :parameters (?s - satellite
		    ?name - image_name)
    :duration  8.333333	;;; 500 secs 
    :condition (and (at start (camera-state ?s on))
		    (at start (shutter-state ?s opened)))
    :effect (at end (image_stored ?s ?name))
    :comment "take picture.")

#|
action send_images(int start_image_index, int number_of_images) {
  duration := 0.5 * number_of_images;
      	
  [all] comm_link == free := busy := free;
  [end] memory :produces size_of_image * number_of_images;
// [all] memory :produces size_of_image * number_of_images;
// is a safer model, but that is less of an issue than
// the example above b/c of the way memory works
// for energy storage on a battery, upper and lower
// bounds are both very serious concerns
}
|#

(defparameter *orbit-distances*
    '((africa libya 100)
      (africa iraq 200)
      (africa iran 300)
      (africa afghan_pakistan_border 350)
      (africa china 400)
      (africa north_korea 450)
      (libya iraq 100)
      (libya iran 200)
      (libya afghan_pakistan_border 250)
      (libya china 300)
      (libya north_korea 350)
      (iraq iran 100)
      (iraq afghan_pakistan_border 150)
      (iraq china 200)
      (iraq north_korea 250)
      (iran afghan_pakistan_border 50)
      (iran china 100)
      (iran north_korea 150)
      (afghan_pakistan_border china 50)
      (afghan_pakistan_border north_korea 100)
      (china north_korea 50)
      (africa downlink1 100)
      (africa downlink2 150)
      (libya downlink1 50)
      (libya downlink2 50)
      (iraq downlink1 100)
      (iraq downlink2 120)
      (iran downlink1 100)
      (iran downlink2 120)
      (afghan_pakistan_border downlink1 150)
      (afghan_pakistan_border downlink2 170)
      (china downlink1 200)
      (china downlink2 220)
      (north_korea downlink1 250)
      (north_korea downlink2 270)))

(defun time-from-locs (action)
  (let* ((start-loc (name (gsv action '?start-loc)))
	 (end-loc (name (gsv action '?tgt-loc)))
	 (dist (loop for (start end dist) in *orbit-distances*
		   if (or (and (eq start start-loc)
			       (eq end end-loc))
			  (and (eq end start-loc)
			       (eq start end-loc)))
		      return dist)))
			  
    (format t "~%~%---------------------------------")
    (format t "~%~% start, end, dist = ~a,~a,~a." start-loc end-loc dist)
    (format t "~%~%---------------------------------")
    (if (not dist)
	15.0
      (max 15.0 (/ (abs dist) 2.0)))))
  
(define (durative-action orbit-to)
    :parameters (?s - satellite
		    ?tgt-loc - location)
    :vars (?start-loc - (located ?s))
    :condition (at start (located ?s ?start-loc))
    :effect (at end (located ?s ?tgt-loc))
    :duration time-from-locs
    :comment "get satellite over a location.")

;;; Make two version out of the next two actions.
;;; The first uses nothing but agent-based preds.
;;; Run probs p&s and take-iraq_test to see the plans.
;;; These plans reuse the agent-based preds and have a good timeline.
;;; Secondly, replace the camera and shutter actions with the states of
;;; those devices by commenting out the former and uncommenting the latter.
;;; Now run those probs and you'll see the improper use of the IS to
;;; establish all but the first of those states.

(define (durative-action point&image)
    :parameters (?s - satellite
		    ?img - image_name)
    :vars (?catt - (current-attitude ?s)
	   ?gatt - attitude
	   ?sfuel - (fuel-level ?s)
	   ?lfuel - (fuel-for ?img)
	   )
    :condition (at start (att_for ?img ?gatt))
    :duration  time-from-attitudes
    :effect (and (at end (pointed&imaged ?s ?img))
		 (at end (current-attitude ?s ?gatt))
	         (at end (fuel-level ?s ?lfuel))
		 (at end (camera-state ?s on))
		 )
    :comment "reorient the satellite from curent attitude to attitude of the image.")

(define (durative-action go_and_shoot)
    :parameters (?sat - satellite
		      ?name - image_name)
    :vars (?loc - location)
    :condition (and (at start (loc_for ?name ?loc))
		    (at start (not (located afsat1 ?loc))))
    :expansion (sequential
		(camera-state ?sat off)
		;;(not (on imager))
		(located ?sat ?loc)
		(pointed&imaged ?sat ?name)
		#|(parallel
		 (camera-state ?sat on)
		 ;;(on imager)
		 (pointed_at ?sat ?name))|#
		(shutter-state ?sat opened)
		;;(opened shutter)
		(image_stored ?sat ?name)
		(shutter-state ?sat closed)
		;;(not (opened shutter))
		)
    :effect (at end (image_taken ?sat ?name))
    :comment "travel to loc and shoot image.")

(define (durative-action just_shoot)
    :parameters (?s - satellite
		    ?name - image_name)
    :vars (?loc - (located afsat1))
    :condition (at start (loc_for ?name ?loc))
    :expansion (sequential
		(pointed&imaged ?s ?name)
		#|(parallel
		 (camera-state ?s on)
		 ;;(on imager)
		 (pointed_at ?s ?name))|#
		(shutter-state ?s opened)
		;;(opened shutter)
		(image_stored ?s ?name)
		(shutter-state ?s closed)
		;;(not (opened shutter))
		)
    :effect (at end (image_taken ?s ?name))
    :comment "travel to loc and shoot image.")

 ;;; See problem take_moz-TEST for a way to avoid doing the folling
;;;   with a different predicate for each goal  CE
(define (durative-action shoot_lots)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - image_name)
    :expansion (sequential
		(image_taken ?s ?img1)
		(image_taken ?s ?img2)
		(image_taken ?s ?img3))
    :effect (at end (images_taken ?s ?img1 ?img2 ?img3))
    :comment "travel to loc and shoot image.")

#|(define (durative-action opened-comms)
    :duration 1.0 
    :condition (at start (not (opened comms)))
    :effect (at end (opened comms))
    :comment "opened a comms channel.")

(define (durative-action close-comms)
    :duration 1.0 
    :condition (at start (opened comms))
    :effect (at end (not (opened comms)))
    :comment "close comms channel.")
(define (durative-action send-image)
    :parameters (?name - image_name)
    :duration 1.0 
    :condition (and (over all (opened comms))
		    (at start (not (on imager))))

    :effect (at end (image_sent ?name))
    :comment "download picture.");;|#

(define (durative-action open-comms)
    :parameters (?o - satellite)
    :vars (?c - (has-comms ?o))
    :duration 1.0 
    :effect (at end (comms-state ?o opened))
    :comment "open a comms channel.")

(define (durative-action close-comms)
    :parameters (?o - satellite)
    :vars (?c - (has-comms ?o))
    :duration 1.0 
    :effect (at end (comms-state ?o closed))
    :comment "close a comms channel.")

(define (durative-action send-image)
    :parameters (?s - satellite
		    ?name - image_name)
    :vars (?c - (has-comms ?s)
	      ?cam - (has-camera ?s))
    :duration 1.0 
    :condition (and (over all (comms-state ?s opened))
		    (at start (camera-state ?s off)))

    :effect (at end (image_sent ?s ?name))
    :comment "download picture.")

(define (durative-action downlinked-at-location)
    :parameters (?dloc - down-link-loc)
    :effect (at end (downlink-location ?dloc))
    :comment "used just to get the dloc passed to the maketasks functions.")

(define (durative-action download-image)
    :parameters (?s - satellite 
		    ?img - image_name)
    :vars (?dloc - down-link-loc
		 ?cam - (has-camera ?s)
		 ?c - (has-comms ?s))
    :expansion (sequential
		(camera-state ?s off)
		;;(not (on imager))
		(located ?s ?dloc)
		(comms-state ?s opened)
		;;(opened comms)
		(image_sent ?s ?img)
		;;;(not (opened comms))
		(comms-state ?s closed))
    :effect (at end (image_downloaded ?s ?img))
    :comment "travel to downlink loc and send image.")

(define (durative-action download-images)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - image_name)
    :vars (?dloc - down-link-loc
		 ?cam - (has-camera ?s)
		 ?c - (has-comms ?s))
    :expansion (sequential
		(camera-state ?s off)
                ;;(not (on imager))
		(located ?s ?dloc)
		(comms-state ?s opened)
		;;(opened comms)
		(image_sent ?s ?img1)
		(image_sent ?s ?img2)
		(image_sent ?s ?img3)
		;(not (opened comms))
		(comms-state ?s closed))
    :effect (at end (images_downloaded ?s ?img1 ?img2 ?img3))
    :comment "travel to downlink loc and downlink images.")

(define (durative-action shoot_lots&store)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - image_name)
    :expansion (sequential
		(image_taken ?s ?img1)
		(image_taken ?s ?img2)
		(image_taken ?s ?img3)
		(images_downloaded ?s ?img1 ?img2 ?img3)
		)
    :effect (at end (images_taken&stored ?s ?img1 ?img2 ?img3))
    :comment "travel to each loc shoot image then go downlink them.")

(define (situation for-afsat-1)
    (:domain sat-domain)
  (:init 
   (has-camera afsat1 imager1)
   (has-shutter afsat1 shutter1)
   (has-comms afsat1 comms1)
   (camera-state afsat1 off)
   (shutter-state afsat1 closed)
   (comms-state afsat1 closed)
   (current-attitude afsat1 start_att)
   (att_for BaghdadAirport_img ba_img_att)
   (att_for SadrCity_img sc_img_att)
   (att_for IraqDefenseMinistry_img idm_img_att)
   (att_for AlShabStadiumIraq_img stad_img_att)
   (att_for Fallujha_img Fallujha_img_att)
   (att_for AfgPakBorder_img apb_img_att)
   (att_for china_img china_img_att)
   (att_for north_korea_img1 nk_img1_att)
   (att_for north_korea_img2 nk_img2_att)
   (att_for iran_img iran_img_att)
   (att_for libya_img libya_img_att)
   (loc_for BaghdadAirport_img iraq)
   (loc_for SadrCity_img iraq)
   (loc_for IraqDefenseMinistry_img iraq)
   (loc_for AlShabStadiumIraq_img iraq)
   (loc_for Fallujha_img iraq)
   (loc_for AfgPakBorder_img afghan_pakistan_border)
   (loc_for china_img china)
   (loc_for north_korea_img1 north_korea)
   (loc_for north_korea_img2 north_korea)
   (loc_for iran_img iran)
   (loc_for libya_img libya)
   (fuel-level afsat1 start_fuel)
   (fuel-for BaghdadAirport_img iraq_fuel)
   (fuel-for SadrCity_img iraq_fuel)
   (fuel-for IraqDefenseMinistry_img iraq_fuel)
   (fuel-for AlShabStadiumIraq_img iraq_fuel)
   (fuel-for Fallujha_img iraq_fuel)
   (fuel-for AfgPakBorder_img afghan_pakistan_border_fuel)
   (fuel-for china_img china_fuel)
   (fuel-for north_korea_img1 north_korea_fuel)
   (fuel-for north_korea_img2 north_korea_fuel)
   (fuel-for iran_img iran_fuel)
   (fuel-for libya_img libya_fuel)
   (located afsat1 africa)
   )
  )

#|(define (problem opened-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  ;;;(:goal (opened shutter))
  (:goal (state shutter opened)))

  (define (problem close-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  ;;;(not (opened shutter))
  (:goal (state shutter opened)))|#

(define (problem open-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (shutter-state afsat1 opened)))

(define (problem close-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (shutter-state afsat1 closed)))

(define (problem turn-on-camera)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (camera-state afsat1 on)))

(define (problem turn-off-camera)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (camera-state afsat1 off)))

(define (problem point-at-pic)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (pointed_at afsat1 BaghdadAirport_img)))

(define (problem orbit1)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (located afsat1 iraq)))

(define (problem store-image)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:init (CAMERA-STATE AFSAT1 ON) (SHUTTER-STATE AFSAT1 OPENED))
  (:deadline 400.0)
  (:goal (image_stored afsat1 BaghdadAirport_img)))

(define (problem p&s)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (image_taken afsat1 north_korea_img1)))

(define (problem go-iran)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (located afsat1 iran)))

(define (problem send-one)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:init 
   (comms-state afsat1 opened)
   (camera-state afsat1 off)
   ;;(opened comms)
   )
  (:deadline 400.0)
  (:goal (image_sent afsat1 libya_img)))

(define (problem dlink-one)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (image_downloaded afsat1 libya_img)))

;;; example so you don't have to create new relation for each case
(define (problem take-iraq_TEST)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:init 
   (located afsat1 mozambique))
  (:goal (sequential (image_taken afsat1 IraqDefenseMinistry_img)
		     (image_taken afsat1 Fallujha_img))))

(define (problem take-iraq)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:init 
   (located afsat1 china))
  (:goal (sequential (image_taken afsat1 BaghdadAirport_img)
		     (image_taken afsat1 Fallujha_img)
		     (image_taken afsat1 SadrCity_img))))

(define (problem take-iraq1)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:init 
   (located afsat1 china))
  (:goal (images_taken afsat1 BaghdadAirport_img Fallujha_img SadrCity_img)))

(define (problem take-mix1)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_taken afsat1 china_img BaghdadAirport_img north_korea_img2)))

(define (problem take-mix2)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_taken afsat1 BaghdadAirport_img north_korea_img2 china_img)))

(define (problem dlink-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_downloaded  afsat1 BaghdadAirport_img north_korea_img2 china_img)))

(define (problem take&store-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_taken&stored afsat1 BaghdadAirport_img Fallujha_img SadrCity_img)))

#|
 ;;; auto-gen'd stuff

 (DEFINE (DURATIVE-ACTION SHOOT_LOTS&STORE) 
 :PARAMETERS (?IMG1 - IMAGE_NAME) 
 :EXPANSION
 (SEQUENTIAL (IMAGE_TAKEN ?IMG1) 
             (STATE IMAGER OFF) 
	     (LOCATED AFSAT1 DOWNLINK1) 
	     (STATE COMMS OPENED) 
	     (IMAGE_SENT ?IMG1)
	     (STATE COMMS CLOSED))
 :EFFECT (AT END (IMAGES_TAKEN&STORED ?IMG1)))


(NEW-RELATION '(IMAGES_TAKEN&STORED ?IMG2 - IMAGE_NAME) SAT-DOMAIN)

(DEFINE (PROBLEM TAKE&STORE-ALL) 
    (:DOMAIN SAT-DOMAIN) 
  (:SITUATION FOR-AFSAT-1) 
  (:DEADLINE 390.0) 
  (:GOAL (IMAGES_TAKEN&STORED BAGHDADAIRPORT_IMG)))


(DEFINE (DURATIVE-ACTION SHOOT_LOTS&STORE) 
    :PARAMETERS (?IMG1 ?IMG2 ?IMG3 - IMAGE_NAME) 
    :EXPANSION
    (SEQUENTIAL 
     (IMAGE_TAKEN ?IMG1) 
     (IMAGE_TAKEN ?IMG2) 
     (IMAGE_TAKEN ?IMG3) 
     (NOT (ON IMAGER))
     (LOCATED AFSAT1 DOWNLINK2) 
     (OPENED COMMS) 
     (IMAGE_SENT ?IMG1) 
     (IMAGE_SENT ?IMG2) 
     (IMAGE_SENT ?IMG3)
     (NOT (OPENED COMMS)))
    :EFFECT (AT END (IMAGES_TAKEN&STORED ?IMG1 ?IMG2 ?IMG3)))

(NEW-RELATION '(IMAGES_TAKEN&STORED ?IMG1 ?IMG2 ?IMG3 - IMAGE_NAME) SAT-DOMAIN)
(DEFINE (PROBLEM TAKE&STORE-ALL) 
    (:DOMAIN *DOMAIN*) 
  (:SITUATION FOR-AFSAT-1) 
  (:DEADLINE 1000.0)
  (:GOAL (IMAGES_TAKEN&STORED BAGHDADAIRPORT_IMG CHINA_IMG NORTH_KOREA_IMG2)))

(define (problem take&store-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_taken&stored BaghdadAirport_img north_korea_img2 china_img)))

(defun time-from-attitudes (action)
  (let* ((start-att (second (assoc (name (gsv action '?catt)) *attitudes*)))
	 (end-att (second (assoc (name (gsv action '?img)) *attitudes*)))
	 (diff (- end-att start-att)))
    (format t "~%~%---------------------------------")
    (format t "~%  ?catt = ~a  ?gatt = ~a" (gsv action '?catt)(gsv action '?gatt))
    (format t "~%~% start, end, diff = ~a(~a),~a(~a),~a." (name (gsv action '?catt)) start-att (name (gsv action '?img)) end-att diff)
    (format t "~%~% duration ~a = ~a." action (max 4.0 (/ (abs diff) 5.0)))
    (format t "~%~%---------------------------------")
    (max 1.0 (* (abs diff) (/ 2.0 60.0)))))
|#
