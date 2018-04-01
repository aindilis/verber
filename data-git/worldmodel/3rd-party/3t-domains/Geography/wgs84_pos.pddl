(in-package :ap)

(define (domain wgs84_pos)
  (:prefix "wgs84_pos")
  (:uri "http://www.w3.org/2003/01/geo/wgs84_pos#")
  (:imports owl)
  (:types SpatialThing - Thing
	  Point - SpatialThing)
  (:functions				; means each has number as range
   (latitude - fact ?s - SpatialThing)
   (longitude - fact ?s - SpatialThing)
   (altitude - fact ?s - SpatialThing)
   )
  )
