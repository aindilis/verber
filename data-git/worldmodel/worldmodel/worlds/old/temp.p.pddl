(define (problem date-20120729)

 (:domain date-20120729)

 (:objects
  andrew-dougherty - person

  outside - location

  den - officeroom
  den-door - door
  basement-door - door
  garage - space
  garage-door - door
  crawl-space - space
  crawl-space-door - door
  garage-entry-way - entry-way
  basement-to-entry-stairwell - stairwell
  entry - entry-way
  coat-closet - closet
  front-door - perimeter-door
  entry-to-first-floor-stairwell - stairwell
  living-room - room
  guest-bathroom - bathroom
  dining-room - room
  dining-room-closet - closet
  kitchen - room
  kitchen-closet - closet
  balcony - space
  balcony-door - perimeter-door
  first-floor-to-landing-stairwell - stairwell
  landing - landing
  landing-closet - closet
  landing-to-second-floor-stairwell - stairwell
  second-floor-landing - landing
  utility-room - space
  bedroom - room
  bedroom-closet - closet
  upstairs-bathroom - bathroom

  walmart-oswego starbucks-aurora caribou-coffee-batavia - store

  electric-razor-0 - electric-razor
  laundry - laundry
  towel - towel
  upstairs-washer-dryer - laundry-machine

  food-store - meals
  couch guestbed - bed
  upstairs-bathroom-outlets kitchen-outlets den-outlets - outlet
  upstairs-shower - shower
  columcille - laptop
  laptop-backpack - lockable-container
  den - office
  townhome - building
  woodmans tigerdirect frys cvs-indian-trail-and-orchard - store
  cell-phone bluetooth-headset - battery-powered-device
  finger-clippers towel shampoo - hygiene-tool
  hair-trimmers food-cans shirts can-opener hair-brush - stuff
  padlock shampoo wallet sleeping-bag camouflage - stuff
  )

 (:init
  ;; relatively necessary facts
  (has-door garage-door garage outside)
  (has-door basement-door garage garage-entry-way)
  (has-door crawl-space-door crawl-space garage-entry-way)
  (has-door front-door entry outside)
  (has-door balcony-door balcony dining-room)
  (has-door den-door den garage-entry-way)

  ;; somewhat necessary facts
  (autonomous andrew-dougherty)
  (= (hourly-wage-net andrew-dougherty) 28.5)

  ;; store hours
  (at 0 (inaccessible walmart-oswego))
  (at 7 (not (inaccessible walmart-oswego)))

  (at 0 (isolated living-room))
  (at 7 (not (isolated living-room)))
  (at 23 (isolated living-room))
  (at 31 (not (isolated living-room)))

  ;; contingent facts stuff
  (= (quantity food-store) 10)
  (locked-door garage-door)
  (locked-door basement-door)
  (locked-door front-door)
  (= (cash andrew-dougherty) 1000)

  (at-location electric-razor-0 upstairs-bathroom)
  (at-location laundry bedroom)
  (at-location towel bedroom)
  (at-location food-store kitchen-closet)
  (at-location laptop-backpack den)
  (at-location finger-clippers den)

  (at-location upstairs-washer-dryer utility-room)
  (at-location guestbed bedroom)
  (at-location couch living-room)

  (at-location upstairs-bathroom-outlets upstairs-bathroom)
  (at-location kitchen-outlets kitchen)
  (at-location den-outlets den)

  (at-location upstairs-shower upstairs-bathroom)
  (at-location andrew-dougherty den)
  (at-location columcille living-room)

  (mobile laptop-backpack)
  (mobile electric-razor-0)
  (mobile towel)
  (mobile laundry)
  (mobile columcille)
  (mobile finger-clippers)
  (mobile cell-phone)
  (mobile bluetooth-headset)

  (tired andrew-dougherty)
  (hungry andrew-dougherty)

  (= (speed andrew-dougherty) 1)
  (= (actions) 0)
  (= (total-walking-distance) 0)

  (= (charge-level cell-phone) 0.1)
  (= (charge-rate cell-phone) 1)
  (= (discharge-rate cell-phone) 0.07)

  (= (charge-level columcille) 1)
  (= (charge-rate columcille) 0.6)
  (= (discharge-rate columcille) 0.3)

  (= (charge-level bluetooth-headset) 0.3)
  (= (charge-rate bluetooth-headset) 0.5)
  (= (discharge-rate bluetooth-headset) 0.01) ;; fixme

  (= (charge-level electric-razor-0) 0.0)
  (= (charge-rate electric-razor-0) 0.5)
  (= (discharge-rate electric-razor-0) 2.5)

  (use-is-required finger-clippers)

  )

 (:goal 
  (and
   (>= (cash andrew-dougherty) 500)
   (all-pending-work-accomplished andrew-dougherty)
   ;; (not (tired andrew-dougherty))
   ;; (not (hungry andrew-dougherty))
   ;; (not (use-is-required finger-clippers))
   ;; (showered andrew-dougherty)
   ;; (clean laundry)
   )
  )

 (:metric minimize (+
		    (+ 
		     (total-time) 
		     (actions))
		    (total-walking-distance)))

 )