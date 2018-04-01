(in-package :AP)

;;; leave out constants because there would be so many as to make planning very slow.
;;; Instead, create a situation in the Geography domain that has only the stuff of
;;;   interest to your application and put the stuff there. See examples below.

(define (domain Geography)
    (:extends wgs84_pos)
  (:prefix "gn")
  (:uri "http://www.geonames.org/ontology#")
  (:types Direction - EnumeratedClass	; makes it a list of objects
	  Location - SpatialThing
	  SpatialRegion - Location
	  GeographicRegion Path - SpatialRegion
	  GeographicArea GeopoliticalArea - GeographicRegion
	  Continent - GeographicArea
	  Country City County StateOrProvince - GeopoliticalArea
	  Intersection - (and Point Location)
	  )
  (:constants				; do NOT put countries, etc. here!
   North NorthEast East SouthEast South SouthWest West NorthWest - Direction
   nowhere - Location)
  (:predicates 
   (hasGeographicSubregion - fact ?super ?sub - GeographicRegion)
   (geographicSubregionOf - fact ?sub ?super - GeographicRegion)
   (meetsSpatially - fact ?s1 ?s2 - SpatialRegion)
   ;; Paths between Locations
   (connected - fact ?s1 ?s2 - Location)
   (connects ?p - Path ?end1 ?end2 - Location) ; connection might be broken
   (connectedBy ?s1 ?s2 - Location ?Path - Path))
  (:functions
   (opposite - fact ?d1 - Direction) - Direction ; used to determine corners
   (direction - fact ?p - Path ?from ?to - Location) - Direction
   (distance - fact ?start ?dest - Location)
   (located ?o - Thing) - Location)
  (:init
   (opposite North South)		; eventually convert to compass heading
   (opposite South North)
   (opposite East West)
   (opposite West East)
   (opposite NorthEast SouthWest)
   (opposite SouthWest NorthEast)
   (opposite NorthWest SouthEast)
   (opposite SouthEast NorthWest))
  (:axiom 
   :vars (?small ?med ?large - GeographicArea)
   :context (and (geographicSubregionOf ?small ?med)
		 (geographicSubregionOf ?med ?large)
		 (not (= ?small ?med))
		 (not (= ?small ?large))
		 (not (= ?med ?large)))
   :implies (geographicSubregionOf ?small ?large)
   :comment "geographicSubregionOf is transitive")
  (:axiom 
   :vars (?Path - Path
	  ?dir - Direction
	  ?s ?e - Point
	  ?i - Intersection)
   :context (and (direction ?Path ?s ?i ?dir)
		 (direction ?Path ?i ?e ?dir)
		 (not (= ?s ?i))
		 (not (= ?i ?e))
		 (not (= ?s ?e)))
   :implies (direction ?Path ?s ?e ?dir)
   :comment "direction is transitive")
  (:axiom 
   :context (connects ?p ?l1 ?l2)
   :implies (connects ?p ?l2 ?l1)
   :comment "connects via Path is reflexive")
  (:axiom
   :context (connects ?p ?l1 ?l2)
   :implies (connected ?l1 ?l2)
   :comment "only the ends of Paths are connected
             to each other. connnected is NOT transitive")
  (:axiom 
   :context (connects ?p ?l1 ?l2)
   :implies (connectedBy ?l1 ?l2 ?p)
   :comment "connects via Path is reflexive
             connectedBy is sort of its inverse.")
;   (:axiom
;    :vars (?l1 ?l2 ?l3 - Location
; 	      ?d12 - (distance ?l1 ?l2)
; 	      ?d23 - (distance ?l2 ?l3))
;    :context (and (not (= ?l1 ?l2))
; 		 (not (= ?l2 ?l3))
; 		 (not (= ?l1 ?l3)))
;    :implies (assign (distance ?l1 ?l3) (+ ?d12 ?d23)))
  )

;;--modify default characteristics of relations

(inverseOf 'geographicSubregionOf 'hasGeographicSubregion)
(inverseOf 'hasGeographicSubregion 'geographicSubregionOf)
(inverseOf 'meetsSpatially 'meetsSpatially)
(inverseOf 'connected 'connected)
(inverseOf 'connectedBy 'connectedBy)
(inverseOf 'distance 'distance)


(defun connected-neighbors (loc)
  "return list of locations connected to LOC by some path"
  (get-value 'connected loc))


;;(asv 'meetsSpatially 'owl:inverseOf 'meetsSpatially)

#|
(define (situation our_world)
    (:objects Pentagon "White House" Capital - (and OfficeBuilding GovernmentBuilding hardTarget
						  IconicTarget)
	      SearsTower EmpireStateBuilding - (and OfficeBuilding softTarget IconicTarget)
	      BrooklynBridge GoldenGateBridge - (and bridge softTarget IconicTarget)
	      NYC LA WashingtonDC SanFrancisco Chicago Jacksonville Toronto - City
	      Mexico Canada Amsterdam - Country
	      IAD ORD LAX SFO JFK TPI - InternationalAirport)
  (:init 
   (geographicSubregion NYC USA)(geographicSubregion ?c ?n2)
   (geographicSubregion LA USA)
   (geographicSubregion Chicago USA)
   (geographicSubregion WashingtonDC USA)
   (geographicSubregion SanFrancisco USA)
   (geographicSubregion Jacksonville USA)
   (located White_house WashingtonDC)
   (located Capital WashingtonDC)
   (located Pentagon WashingtonDC)
   (located IAD WashingtonDC) ;;-close enough
   (located SearsTower Chicago)
   (located ORD Chicago)
   (located BrooklynBridge NYC)
   (located EmpireStateBuilding NYC)
   (located JFK NYC)
   (located GoldenGateBridge SanFrancisco)
   (located SFO SanFrancisco)
   (located AcademyAwards LA)
   (located LAX LA)
   (located SuperBowl Jacksonville)
   (located TPI Toronto)
   (located Toronto Canada)
   (meetsSpatially USA Mexico)
   (meetsSpatially USA Canada))
  (:comment "This will Eventually grow and grow and ..."))

;; test axioms

(define (situation simple_world)
    (:objects Chicago Toronto Winsor Detroit - City
	      Mexico Canada USA - Country)
  (:init 
   (geographicSubregion Chicago USA)
   (geographicSubregion Detroit USA)
   (geographicSubregion Toronto Canada)
   (geographicSubregion Winsor Canada)
   (distance Winsor Detroit 2)
   (distance Detroit Chicago 50)
   (distance Toronto Chicago 200)
   (distance Toronto Detroit 150)))

|#
