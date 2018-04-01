(define (problem hygiene)

 (:domain hygiene)

 (:objects
  andy justin - person
  electric-razor0 - electric-razor
  laundry - laundry
  towel - towel
  basement-laundry-machines forbes-ave-laundromat - laundromat
  food-store - meals
  sleeping-bag - bed
  hidden-sleeping-spot - bed
  outlet0 - outlet
  UC-mens-locker-room-shower - shower
  IBM-R30 - laptop
  bookbag laptop-backpack duffel-bag - container
  doherty-4201 casos-office - office
  doherty-hall wean-hall baker-hall fouroseven-craig-st-hall - building
  flagstaff-hill cs-lounge wean-hall-bathroom doherty-hall-bathroom - location
  UC-gym forbes-and-chesterfield cathedral-of-learning - location
  baker-locker-18 baker-locker-67 baker-locker-69 doherty-locker-161 - locker
  doherty-locker-1 doherty-locker-4 doherty-locker-20 - locker


  squirrel-hill-giant-eagle oakland-giant-eagle greenville-giant-eagle - store
  water-front-giant-eagle airport-walmart indiana-walmart - store
  forbes-ave-cvs - store
  finger-clippers towel shampoo - hygiene-tool
  hair-trimmers food-cans shirts can-opener hair-brush - stuff
  padlock shampoo headset wallet sleeping-bag camouflage - stuff

  svrs-1 - location
  )

 (:init

  (at 0 (inaccessible UC-gym))
  (at 7 (not (inaccessible UC-gym)))
  (at 20 (isolated doherty-hall-bathroom))
  (at 0 (isolated flagstaff-hill))
  (at 8 (not (isolated flagstaff-hill)))
  (at 24 (isolated flagstaff-hill))
  (at 32 (not (isolated flagstaff-hill)))

  (= (quantity food-store) 10)

  (at doherty-locker-1 doherty-hall)
  (at doherty-locker-4 doherty-hall)
  (at doherty-locker-20 doherty-hall)
  (at doherty-locker-161 doherty-hall)
  (at baker-locker-18 baker-hall)
  (at baker-locker-67 baker-hall)
  (at baker-locker-69 baker-hall)

  (locked doherty-locker-1)
  (locked doherty-locker-4)
  (locked doherty-locker-20)
  (locked doherty-locker-161)
  (locked baker-locker-18)
  (locked baker-locker-67)
  (locked baker-locker-69)


  (isolated cathedral-of-learning)

  (= (cash andy) 10)
  (= (hourly-wage-net andy) 7)

  (is-contained-by electric-razor0 baker-locker-18)
  (is-contained-by laundry doherty-locker-161)
  (is-contained-by towel baker-locker-18)
  (is-contained-by food-store doherty-locker-1)
  (is-contained-by bookbag baker-locker-69)
  (is-contained-by laptop-backpack baker-locker-69)
  (is-contained-by finger-clippers doherty-locker-1)

  (at forbes-ave-laundromat forbes-and-chesterfield)
  (at hidden-sleeping-spot cathedral-of-learning)
  (at sleeping-bag flagstaff-hill)
  (at outlet0 doherty-4201)
  (at UC-mens-locker-room-shower UC-gym)
  (at andy cs-lounge)
  (at ibm-r30 cs-lounge)
  (at duffel-bag cs-lounge)

  (autonomous andy)
  (autonomous justin)

  (mobile food-store)
  (mobile laptop-backpack)
  (mobile duffel-bag)
  (mobile bookbag)
  (mobile electric-razor0)
  (mobile towel)
  (mobile laundry)
  (mobile ibm-r30)
  (mobile finger-clippers)

  (tired andy)
  (hungry andy)

  (= (speed andy) 1)
  (= (actions) 0)
  (= (total-walking-distance) 0)
  (= (charge-level electric-razor0) 0.1)
  (= (charge-level ibm-r30) 0.1)
  (= (charge-rate electric-razor0) 0.1)
  (= (charge-rate ibm-r30) 0.3)

  (use-is-required finger-clippers)

  )

 (:goal 
  (and
   (>= (cash andy) 20)
   (all-pending-work-accomplished andy)
   (not (tired andy))
   (not (hungry andy))
   (not (use-is-required finger-clippers))
   (is-contained-by duffel-bag bookbag)
   (is-contained-by bookbag laptop-backpack)
   (showered andy)
   (clean laundry)
   )
  )

 (:metric minimize (+
		    (+ 
		     (total-time) 
		     (actions))
		    (total-walking-distance)))

 )


