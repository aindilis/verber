;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
(define (domain sat-domain)
    (:requirements :multi-agent :durative-actions)
  (:extends physob Geography)
  (:types state - object
	  satellite-resource - resource
	  afsat1 - agent
	  image - object
	  attitude - object
	  fuel - object
	  image_name - object)
  (:constants 
	      open closed on off - state
	      mozambique paris great_wall entebbe - location
	      moz_att paris_att gw_att ent_att start_att - attitude
	      moz_fuel paris_fuel gw_fuel ent_fuel start_fuel - fuel
	      moz_img1 moz_img2 moz_img3 paris_img1 paris_img2 paris_img3
	      gw_img1 gw_img2 gw_img3 ent_img1 ent_img2 ent_img3 - image_name
	     )
  (:predicates (image_for ?l - location ?n - image_name)
	       (image_taken ?l - location ?n - image_name)
	       (image_stored ?l - location ?name - image_name)
	       (processed ?loc1 ?loc2 ?loc3 - location)
	       (imaged ?loc1 ?loc2 ?loc3 - location)
	       (pointed_at ?loc - location)
	       (ready_for_loc ?loc - location)
	       (current-attitude ?catt - attitude)
	       (location-attitude ?loc - location ?gatt - attitude)
	       (fuel-level ?v - fuel)
	       (fuel-for ?loc - location ?f - fuel)
	       (shutter_position ?s - state)
	       (imager_state ?s - state)
	       (available - predicate ?r - satellite-resource)
	       (open - predicate ?o - object)
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
    :condition (at start (shutter_position closed))
    :effect (at end (shutter_position open))
    :comment "opens shutter.")
	
(define (durative-action close_imager_shutter)
    :duration 1.0 
    :condition (at start (shutter_position open))
    :effect (at end (shutter_position closed))
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
    :condition (at start (imager_state off))
    :effect (at end (imager_state on))
    :comment "turn imager on.")
	
(define (durative-action power_off_imager)
    :duration 1.0 
    :condition (at start (imager_state on))
    :effect (at end (imager_state off))
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

(define (durative-action point_at_location)
    :parameters (?loc - location)
    :vars (?catt ?gatt - attitude
		 ?sfuel ?lfuel - fuel
		 )
    :condition (and (at start (current-attitude ?catt))
	            (at start (location-attitude ?loc ?gatt))
		    (at start (fuel-level ?sfuel))
		    (at start (fuel-for ?loc ?lfuel)))
    :duration 4.0 
    :effect (and (at end (pointed_at ?loc))
		 (at end (current-attitude ?gatt))
	         (at end (fuel-level ?lfuel)))
    :comment "reorient the imager from curent attitude to attitude of the location.")


(define (durative-action ready_for_location)
    :parameters (?loc - location)
    :expansion (sequential
		(pointed_at ?loc)
		(imager_state on)
		(shutter_position open))
		
    :effect (at end (ready_for_loc ?loc))
    :comment "reorient the imager  to loc, powr it up and open the shutter.")

(define (durative-action point_at_locations)
    :parameters (?loc1 ?loc2 ?loc3 - location)
    :expansion (sequential
		(ready_for_loc ?loc1)
		(ready_for_loc ?loc2)
		(ready_for_loc ?loc3))
    :effect (at end (processed ?loc1 ?loc2 ?loc3))
    :comment "point at 3 locations")

#|
action take_images(int number_of_images) {
  duration := 0.1 * number_of_images;
  [start] {
    shutter_position == OPEN;
    imager_state == ON;
  }
  [start] constant Attitude cAtt := attitude;
  [all] attitude == cAtt		
  |#					;

(define (durative-action take-image)
    :parameters (?loc - location
		     ?name - image_name)
    :duration 1.0 
    :condition (and (at start (imager_state on))
		    (at start (shutter_position open)))
    :effect (at end (image_stored ?loc ?name))
    :comment "take picture at loc and call it name.")

(define (durative-action point_and_shoot)
    :parameters (?loc - location
		       ?name - image_name)
    :condition (at start (imager_state on))
    :expansion (sequential
		(pointed_at ?loc)
		(shutter_position open)
		(image_stored ?loc ?name)
		(shutter_position closed))
    :effect (at end (image_taken ?loc ?name))
    :comment "point at loc and shoot image name.")

(define (durative-action shoot_at_locs)
    :parameters (?loc1 ?loc2 ?loc3 - location)
    :vars (?im1 ?im2 ?im3 - image_name)
    :condition (and (at start (image_for ?loc1 ?im1))
		    (at start (image_for ?loc2 ?im2))
		    (at start (image_for ?loc3 ?im3)))
    :expansion (sequential
		(imager_state on)
		(image_taken ?loc1 ?im1)
		(image_taken ?loc2 ?im2)
		(image_taken ?loc3 ?im3)
		(imager_state off))
    :effect (at end (imaged ?loc1 ?loc2 ?loc3))
    :comment "point at 3 locations")

(define (situation for-afsat-1)
  (:domain sat-domain)
  (:init 
   (current-attitude start_att)
   (location-attitude mozambique moz_att)
   (location-attitude paris paris_att)
   (location-attitude great_wall gw_att)
   (location-attitude entebbe ent_att)
   (fuel-level start_fuel)
   (fuel-for mozambique moz_fuel)
   (fuel-for paris paris_fuel)
   (fuel-for great_wall gw_fuel)
   (fuel-for entebbe ent_fuel)
   (image_for mozambique moz_img1)
   (image_for paris paris_img1)
   (image_for great_wall gw_img1)
   (imager_state off)
   (shutter_position closed))
  )

(define (problem open-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (shutter_position open)))

(define (problem power-on)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (imager_state on)))

(define (problem point-at-loc)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (pointed_at mozambique)))

(define (problem ready-loc)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (ready_for_loc mozambique)))

(define (problem point-at-locs)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (processed mozambique paris great_wall)))

(define (problem p&s)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:init
   (imager_state on))
  (:goal (image_taken mozambique moz_img1)))

(define (problem shoot-at-locs)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (imaged mozambique paris great_wall)))
