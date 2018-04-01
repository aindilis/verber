(in-package :ap)

;; Logistics domain, PDDL 1.2 version.

(define (domain logistics)
    (:requirements :typing) 
  (:types  city location thing - object
	   package vehicle - thing
	   truck airplane - vehicle
	   airport - location)
  
  (:predicates  (in-city ?l - location ?c - city)
		(at ?obj - thing ?l - location)
		(in ?p - package ?veh - vehicle))

  (:action drive
	   :parameters (?t - truck 
			?from ?to - location 
			?c - city)
	   :precondition (and (at ?t ?from)
			      (in-city ?from ?c)
			      (in-city ?to ?c))
	   :effect (and (not (at ?t ?from))
			(at ?t ?to)))
  (:action fly
	   :parameters (?a - airplane 
			?from ?to - airport)
	   :precondition (at ?a ?from)
	   :effect (and (not (at ?a ?from))
			(at ?a ?to)))
  (:action load
	   :parameters (?v - vehicle 
			?p - package 
			?l - location)
	   :precondition  (and (at ?v ?l)
			       (at ?p ?l))
	   :effect  (and (not (at ?p ?l))
			 (in ?p ?v)))
  (:action unload
	   :parameters (?v - vehicle 
			?p - package
			?l - location)
	   :precondition  (and (at ?v ?l)
			       (in ?p ?v))
	   :effect (and (not (in ?p ?v))
			(at ?p ?l)))
  )

(define (problem logistics-4-0)
    (:domain logistics)
  (:objects  apn1 - airplane
	     tru1 tru2 - truck
	     obj11 obj12 obj13 obj21 obj22 obj23 - package
	     apt1 apt2 - airport
	     pos1 pos2 - location
	     cit1 cit2 - city)
  (:init  (at apn1 apt2)
	  (at tru1 pos1)
	  (at tru2 pos2)
	  (at obj11 pos1)
	  (at obj12 pos1)
	  (at obj13 pos1)
	  (at obj21 pos2)
	  (at obj22 pos2)
	  (at obj23 pos2)
	  (in-city apt1 cit1)
	  (in-city apt2 cit2)
	  (in-city pos1 cit1)
	  (in-city pos2 cit2))
  (:goal  (and (at obj11 apt1)
	       (at obj13 apt1)
	       (at obj21 pos1)
	       (at obj23 pos1)))
  )
