;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
(define (domain sat-domain)
    (:requirements :multi-agent :durative-actions)
  (:extends physob Geography)
  (:types state - object
	  satellite-resource - resource
	  afsat1 - agent
	  image - object)
  (:constants 
	      open closed on off - state
	      mozambique paris great_wall entebbe - location
	     )
  (:predicates (processed ?loc1 ?loc2 ?loc3 - location)
	       (pointed_at ?loc - location)
	       (ready_for_loc ?loc - location)
	       (current-attitude ?catt - (int 0 360))
	       (location-attitude ?loc - location ?gatt - (int 0 360))
	       (fuel-level ?v - (int 0 1000))
	       (fuel-used ?catt ?gatt - (int 0 360) ?cfuel - (int 0 1000))
	       (fuel-left ?sfuel ?cfuel ?efuel - (int 0 1000))
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
    :comment "change shutter position from open to closed.")
	
(define (durative-action close_imager_shutter)
    :duration 1.0 
    :condition (at start (shutter_position open))
    :effect (at end (shutter_position closed))
    :comment "change shutter position from closed to open.")

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
    :duration 60.0 
    :condition (at start (imager_state off))
    :effect (at end (imager_state on))
    :comment "turn imager on.")
	
(define (durative-action power_off_imager)
    :duration 10.0 
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
    :vars (?catt ?gatt - int
		 ?sfuel ?cfuel ?efuel - int
		 )
    :condition (and (at start (current-attitude ?catt))
	            (at start (location-attitude ?loc ?gatt))
		    (at start (fuel-level ?sfuel))
	            (at start (fuel-used ?catt ?gatt ?cfuel))
		    (at start (fuel-left ?sfuel ?cfuel ?efuel)))
    :duration 4.0 
    :effect (and (at end (pointed_at ?loc))
		 (at end (current-attitude ?gatt))
	         (at end (fuel-level ?efuel)))
    :comment "reorient the imager from curent attitude to attitude of the location.")

(define (durative-action ready_for_location)
    :parameters (?loc - location)
    :expansion (series
		(pointed_at ?loc)
		(imager_state on)
		(shutter_position open))
		
    :effect (at end (ready_for_loc ?loc))
    :comment "reorient the imager  to loc, powr it up and open the shutter.")

(define (durative-action point_at_locations)
    :parameters (?loc1 ?loc2 ?loc3 - location)
    :expansion (series
		(ready_for_loc ?loc1)
		(ready_for_loc ?loc2)
		(ready_for_loc ?loc3))
    :effect (at end (processed ?loc1 ?loc2 ?loc3))
    :comment "point at 3 locations")

(define (situation for-afsat-1)
  (:domain sat-domain)
  (:init 
   (current-attitude 40)
   (location-attitude mozambique 60)
   (location-attitude paris 100)
   (location-attitude great_wall 220)
   (location-attitude entebbe 300)
   (fuel-level 500)
   (fuel-used 40 60 20)
   (fuel-used 60 100 40)
   (fuel-used 100 220 60)
   (fuel-used 220 300 80)
   (fuel-left 500 20 480)
   (fuel-left 480 40 440)
   (fuel-left 440 60 380)
   (fuel-left 380 80 300)
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

(define (problem point-at-locs)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (processed mozambique paris great_wall)))
