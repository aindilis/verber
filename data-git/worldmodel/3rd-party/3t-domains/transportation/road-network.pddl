(in-package :ap)

(define (situation road-network)
    (:comment "multi-robot problems")
  (:domain land-movement)
  (:objects g2 - Garage
            loc0 loc1 loc2 loc3 - (and Point Location)
	    i1 i2 i3 i4 i5 i6 - Intersection
            r1 r3 r4 r8 r9 r10 r11 - Road ;; r2 r7
	    r5 - DividedHighway		; long but fast
	    r6 - PavedRoad)		; little bit faster
  ;;-connects and direction both necessary for axioms 
  ;; to insert all necessary info
  ;;;;; r2 -> r1, r7 -> r1
  (:init (connects r1 g2 i1)
	 (connects r1 i1 i2)
	 (connects r3 loc1 i1)
         (connects r4 loc3 i1)
         (connects r5 i4 i2)
	 (connects r6 i5 i4)
         (connects r1 i2 i3)
         (connects r8 loc2 i3)
         (connects r9 i6 i3)
         (connects r10 i6 loc0)
         (connects r11 i5 i3)
         (direction r3 loc1 i1 West)
         (direction r4 i1 loc3 West)
	 (direction r1 g2 i1 North)
         (direction r1 i1 i2 North)
         (direction r1 i2 i3 North)
         (direction r8 i3 loc2 North)
         (direction r9 i6 i3 East)
         (direction r11 i3 i5 East)
         (direction r5 i4 i2 West)
	 (direction r6 i5 i4 South)
         (direction r10 i6 loc0 South))
  )

(define (situation robot-level2)
    (:documentation "add the points between the intersections")
  (:domain land-movement)
  (:after road-network)
  (:objects g2-i1
	    i1-loc1 i1-loc3 i1-i2
	    i2-i3 i2-i4 i4-i5
	    i3-loc2 i3-i5 i3-i6 i6-loc0 - Point)
  (:init (neighbor g2 g2-i1)
	 (neighbor g2-i1 i1)
	 (neighbor i1 i1-loc3)
	 (neighbor i1-loc3 loc3)
	 (neighbor i1 i1-loc1)
	 (neighbor i1-loc1 loc1)
	 (neighbor i1 i1-i2)
	 (neighbor i1-i2 i2)
	 (neighbor i2 i2-i3)
	 (neighbor i2-i3 i3)
	 (neighbor i2 i2-i4)
	 (neighbor i2-i4 i4)
	 (neighbor i4 i4-i5)
	 (neighbor i4-i5 i5)
	 (neighbor i5 i3-i5)
	 (neighbor i3-i5 i3)
	 (neighbor i3 i3-loc2)
	 (neighbor i3-loc2 loc2)
	 (neighbor i3 i3-i6)
	 (neighbor i3-i6 i6)
	 (neighbor i6 i6-loc0)
	 (neighbor i6-loc0 loc0)))

(define (situation start_g2)
    (:comment "introduce robot domain")
  (:domain land-movement)
  (:after robot-level2)
  (:objects centaur1 centaur2 - (and TrackedVehicle Robot))
  (:init (heading centaur1 North)
	 (heading centaur2 North)
	 ;;(adequate_fuel centaur1)
	 ;;(adequate_fuel centaur2)
	 (maxSpeed centaur1 18)
	 (maxSpeed centaur2 18)
	 (located centaur1 g2)
	 (located centaur2 g2) ; unless specified, get-distance fails
	 (hasFuel centaur1 100.0)
	 (hasFuel centaur2 100.0)))

(define (problem google-g2-i5)
    (:comment "for conversion into a lower-level plan")
  (:domain land-movement)
  (:situation start_g2)
  (:goal (located centaur1 i5)))

(define (problem google-g2-loc0)
    (:comment "for conversion into a lower-level plan")
  (:domain land-movement)
  (:situation start_g2)
  (:goal (located centaur1 loc0)))

(define (problem drive-sequence)
    (:comment "two at once, discover coordination constraints")
  (:domain land-movement)
  (:situation start_g2)
  (:situation mission-level-test2)
  (:goal (parallel
	  (located centaur1 i4)
	  (located centaur2 i6))))

;;;--- lower level ---

(define (problem move-i5)
    (:comment "fine-grained movement")
  (:domain land-movement)
  (:situation start_g2)
  (:goal (move centaur1 i5)))

(define (problem move-loc2-no-turns)
    (:comment "start and dest are on same road")
  (:domain land-movement)
  (:situation start_g2)
  (:goal (move centaur1 loc2)))