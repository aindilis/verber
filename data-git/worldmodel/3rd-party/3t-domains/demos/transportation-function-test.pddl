(in-package :ap)

;; problems to test :functions feature of PDDL 2.1
;; transportation domain has one function, hasFuel.

(define (situation "Reston VA")
    (:domain ground)
  (:objects NorthPointSunoco - GasStation
	    HomeDepot - (and HardwareStore Point)
	    Hyatt - (and CommercialFacility Point)
	    Honda - Automobile
	    RestonPkwy BaronCameron - PavedRoad
	    )
  (:init
   (hasFuel Honda 1)			; almost out
   (located Honda HomeDepot)
   (heading Honda North)
   (onRoad HomeDepot RestonPkwy)
   (onRoad HomeDepot BaronCameron)
   (onRoad NorthPointSunoco RestonPkwy)
   (onRoad Hyatt RestonPkwy)
   (distance HomeDepot NorthPointSunoco 1)
   (distance HomeDepot Hyatt 1)
   (distance NorthPointSunoco Hyatt 2)
   (speedLimit RestonPkwy 45)
   (speedLimit BaronCameron 45)
   )
  )
  