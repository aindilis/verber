;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
(define (domain sat-domain)
    (:requirements :multi-agent :durative-actions)
  (:extends physob Geography)
  (:types state - object
	  satellite-resource - resource
	  afsat1 - agent
	  image - object
	  fuel - object
	  image_name - object
	  down-link-loc - location)
  (:constants 
              shutter imager comms afsat1 - object
	      open closed on off - state
	      mozambique paris great_wall entebbe africa - location
	      downlink1 downlink2 - down-link-loc
	      moz_fuel paris_fuel gw_fuel ent_fuel start_fuel - fuel
	      moz_img1 moz_img2 moz_img3 paris_img1 paris_img2 paris_img3 
	      gw_img1 gw_img2 gw_img3 ent_img1 ent_img2 ent_img3 - image_name
	     )
  (:predicates (att_for ?n - image_name ?a - (int 0 360))
	       (loc_for ?n - image_name ?l - location)
	       (image_taken ?n - image_name)
	       (images_taken ?mg1 ?ing2 ?img3 - image_name)
	       (image_stored ?name - image_name)
	       (image_sent ?name - image_name)
	       (image_downloaded ?name - image_name)
	       (images_downloaded ?mg1 ?ing2 ?img3 - image_name)
	       (images_taken&stored ?img1 ?img2 ?img3)
	       (processed ?loc1 ?loc2 ?loc3 - location)
	       (imaged ?loc1 ?loc2 ?loc3 - location)
	       (pointed_at ?img - image_name)
	       (ready_for_loc ?loc - location)
	       (current-attitude ?catt - (int 0 360))
	       (location-attitude ?loc - location ?gatt - (int 0 360))
	       (fuel-level ?v - fuel)
	       (fuel-for ?loc - location ?f - fuel)
	       (open - predicate ?o - object)
	       (on - predicate ?o - object)
	       (state ?item - object ?st - state)
	)
  
  )

#|
ANML 
// time units are seconds
action open_imager_shutter() {
  duration := 1;
  [all] shutter_position == CLOSED :-> OPEN;
}
action close_imager_shutter() {
  duration := 1;
  [all] shutter_position == OPEN :-> CLOSED;
}
|#

(define (durative-action open_imager_shutter)
    :duration 1.0 
    :condition (at start (not (open shutter)))
    :effect (at end (open shutter))
    :comment "opens shutter.")
	
(define (durative-action close_imager_shutter)
    :duration 1.0 
    :condition (at start (open shutter))
    :effect (at end (not (open shutter)))
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
|#

(define (durative-action power_on_imager)
    :duration 10.0 
    :condition (at start (not (on imager)))
    :effect (at end (on imager))
    :comment "turn imager on.")
	
(define (durative-action power_off_imager)
    :duration 1.0 
    :condition (at start (on imager))
    :effect (at end (not (on imager)))
    :comment "turn imager off.")

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

(defun time-from-attitudes (action)
  (let* ((start-att (gsv action '?catt))
	 (end-att (gsv action '?gatt))
	 (diff (- end-att start-at)))
    (format t "~%~%---------------------------------")
    (format t "~%~% start, end, diff = ~a,~a,~a." start-att end-att diff)
    (max (4.0 diff))))

(define (durative-action point_at_image)
    :parameters (?img - image_name)
    :vars (?catt ?gatt - int
		 ?sfuel ?lfuel - fuel
		 )
    :condition (and (at start (current-attitude ?catt))
	            (at start (att_for ?img ?gatt))
		    (at start (fuel-level ?sfuel))
		    (at start (fuel-for ?img ?lfuel))
		    )
    :duration time-from-attitudes
    :effect (and (at end (pointed_at ?img))
		 (at end (current-attitude ?gatt))
	         (at end (fuel-level ?lfuel))
		 )
    :comment "reorient the imager from curent attitude to attitude of the image.")

(define (durative-action take-image)
    :parameters (?name - image_name)
    :duration 1.0 
    :condition (and (at start (on imager))
		    (at start (open shutter)))
    :effect (at end (image_stored ?name))
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

(define (durative-action orbit-to)
    :parameters (?tgt-loc - location)
    :vars (?start-loc - location)
    :condition (at start (located afsat1 ?start-loc))
    :effect (at end (located afsat1 ?tgt-loc))
    :duration 15.0
    :comment "get satellite over a location.")

(define (durative-action go_and_shoot)
    :parameters (?name - image_name)
    :vars (?loc - location)
    :condition (at start (loc_for ?name ?loc))
    :expansion (sequential
		(located afsat1 ?loc)
		(simultaneous
		 (on imager)
		 (pointed_at ?name))
		(open shutter)
		(image_stored ?name)
		(not (open shutter))
		(not (on imager)))
    :effect (at end (image_taken ?name))
    :comment "travel to loc and shoot image.")

(define (durative-action shoot_lots)
    :parameters (?img1 ?img2 ?img3 - image_name)
    :expansion (sequential
		(image_taken ?img1)
		(image_taken ?img2)
		(image_taken ?img3))
    :effect (at end (images_taken ?img1 ?img2 ?img3))
    :comment "travel to loc and shoot image.")

(define (durative-action open-comms)
    :duration 1.0 
    :condition (at start (not (open comms)))
    :effect (at end (open comms))
    :comment "open a comms channel.")

(define (durative-action close-comms)
    :duration 1.0 
    :condition (at start (open comms))
    :effect (at end (not (open comms)))
    :comment "close comms channel.")

(define (durative-action send-image)
    :parameters (?name - image_name)
    :duration 1.0 
    :condition (and (over all (open comms))
		    (at start (not (on imager))))

    :effect (at end (image_sent ?name))
    :comment "download picture.")

(define (durative-action download-image)
    :parameters (?img - image_name)
    :vars (?dloc - down-link-loc)
    :expansion (sequential
		(not (on imager))
		(located afsat1 ?dloc)
		(open comms)
		(image_sent ?img)
		(not (open comms)))
    :effect (at end (image_downloaded ?img))
    :comment "travel to downlink loc and send image.")

(define (durative-action download-images)
    :parameters (?img1 ?img2 ?img3 - image_name)
    :vars (?dloc - down-link-loc)
    :expansion (sequential
		(not (on imager))
		(located afsat1 ?dloc)
		(open comms)
		(image_sent ?img1)
		(image_sent ?img2)
		(image_sent ?img3)
		(not (open comms)))
    :effect (at end (images_downloaded ?img1 ?img2 ?img3))
    :comment "travel to downlink loc and downlink images.")

(define (durative-action shoot_lots&store)
    :parameters (?img1 ?img2 ?img3 - image_name)
    :expansion (sequential
		(image_taken ?img1)
		(image_taken ?img2)
		(image_taken ?img3)
		(images_downloaded ?img1 ?img2 ?img3))
    :effect (at end (images_taken&stored ?img1 ?img2 ?img3))
    :comment "travel to loc and shoot image.")

(define (situation for-afsat-1)
    (:domain sat-domain)
  (:init 
   (current-attitude 100)
   (att_for moz_img1 100)
   (att_for moz_img2 200)
   (att_for moz_img3 300)
   (att_for paris_img1 125)
   (att_for paris_img2 225)
   (att_for paris_img3 325)
   (att_for gw_img1 150)
   (att_for gw_img2 250)
   (att_for gw_img3 350)
   (att_for ent_img1 175)
   (att_for ent_img2 275)
   (att_for ent_img3 375)
   (loc_for moz_img1 mozambique)
   (loc_for moz_img2 mozambique)
   (loc_for moz_img3 mozambique)
   (loc_for paris_img1 paris)
   (loc_for paris_img2 paris)
   (loc_for paris_img3 paris)
   (loc_for gw_img1 great_wall)
   (loc_for gw_img2 great_wall)
   (loc_for gw_img3 great_wall)
   (loc_for ent_img1 entebbe)
   (loc_for ent_img2 entebbe)
   (loc_for ent_img3 entebbe)
   (fuel-level start_fuel)
   (fuel-for moz_img1 moz_fuel)
   (fuel-for moz_img2 moz_fuel)
   (fuel-for moz_img3 moz_fuel)
   (fuel-for paris_img1 paris_fuel)
   (fuel-for paris_img2 paris_fuel)
   (fuel-for paris_img3 paris_fuel)
   (fuel-for gw_img1 gw_fuel)
   (fuel-for gw_img2 gw_fuel)
   (fuel-for gw_img3 gw_fuel)
   (fuel-for ent_img1 ent_fuel)
   (fuel-for ent_img2 ent_fuel)
   (fuel-for ent_img3 ent_fuel)
   (located afsat1 africa)
   )
  )

(define (problem open-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (open shutter)))

(define (problem close-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (not (open shutter))));;;doesn't work

(define (problem power-on)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (on imager)))

(define (problem point-at-pic)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (pointed_at moz_img1)))

(define (problem p&s)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (image_taken moz_img1)))

(define (problem go-moz)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (located afsat1 mozambique)))

(define (problem send-one)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:init (open comms))
  (:deadline 400.0)
  (:goal (image_sent moz_img1)))

(define (problem dlink-one)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (image_downloaded moz_img1)))

(define (problem take-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (images_taken moz_img1 moz_img2 moz_img3)))

(define (problem dlink-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (images_downloaded  moz_img1 moz_img2 moz_img3)))

(define (problem take&store-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (images_taken&stored moz_img1 paris_img1 paris_img3)))
