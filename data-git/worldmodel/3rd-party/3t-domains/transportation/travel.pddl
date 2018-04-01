(in-package :ap)

(define (domain travel)
    (:extends ground air)
  (:requirements :durative-actions)
  )

(define (durative-action "Airline Flight")
    :subClassOf Fly
    :parameters (?p - Person
		 ?dest - GeopoliticalArea)
    :vars (?start - (located ?p))
    :value ?start			; documentation
    :precondition (not (located ?p ?dest))
    :effect (located ?p ?dest)
    :probability 0.99
    :duration fly-duration)

(define (durative-action "Ground Transport")
    :subClassOf Drive
    :parameters (?p - Person
		 ?dest - GeopoliticalArea)
    :vars (?start - (located ?p)
	   ?c - Continent)
    :value ?start
    :precondition (and (geographicSubregionOf ?start ?c)
		       (geographicSubregionOf ?dest ?c)
		       (not (located ?p ?dest)))
    :effect (located ?p ?dest)
    :probability 0.97
    :duration 2.0)

