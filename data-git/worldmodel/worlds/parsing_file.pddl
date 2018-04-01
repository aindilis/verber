;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain date-20170205)
 (:requirements :negative-preconditions :conditional-effects :derived-predicates :equality :typing :disjunctive-preconditions :durative-actions :fluents :timed-initial-literals)
 (:types hygiene-tool - tool day date - text-string stairwell room landing entry-way closet - space officeroom bathroom - room tool stuff shower person outlet object location laundry informational-object furniture electric-device door container collection bed - object locker - lockable-container space building - location towel bedding article-of-clothing - laundry text-string set - informational-object desk - furniture computer battery-powered-device - electric-device perimeter-door - door lockable-container laundry-washing-machine laundry-load laundry-dryer-machine bag - container mealtype - collection store - building laptop electric-razor - battery-powered-device shirt pants - article-of-clothing)
 (:predicates
  (acceptable-to-perform-hygiene-actions ?p - person ?l - location)
  (all-pending-work-accomplished ?p - person ?d - date)
  (at-location ?ob - object ?l - location)
  (autonomous ?ob - object)
  (closed ?d - door)
  (connected-to ?s1 - space ?s2 - space)
  (day-of-week ?date - date ?day - day)
  (dirty ?o - object)
  (exhausted ?p - person)
  (has-door ?d - door ?l1 - location ?l2 - location)
  (has-fee-for-use ?o - object)
  (has-permission-to-use ?p - person ?o - object)
  (holding ?ob0 ?ob1 - object)
  (holiday ?d - date)
  (inaccessible ?l - location)
  (is-contained-by ?ob1 - object ?c - container)
  (isolated ?l - location)
  (location-is-clean ?o - location)
  (locked-container ?lo - lockable-container)
  (locked-door ?d - door)
  (mobile ?ob - object)
  (plugged-in ?b - electric-device)
  (presentable ?p - person)
  (ready-for-work ?p - person)
  (shaved ?p - person)
  (ship-shape)
  (showered ?p - person)
  (tired ?p - person)
  (today ?d - date)
  (use-is-required ?o - object)
  (wearing ?person - person ?aoc - article-of-clothing)
  (weekday ?d - date)
  (wet ?la - laundry)
  (workday ?d - date))
 (:functions
  (actions)
  (cash ?p - person)
  (charge-level ?r - battery-powered-device)
  (charge-rate ?r - battery-powered-device)
  (discharge-rate ?r - battery-powered-device)
  (fee-for-use ?o - object)
  (food-ingested ?p - person)
  (hours-worked-on-date ?p - person ?d - date)
  (how-filling ?m - mealtype ?p - person)
  (hunger-level ?p - person)
  (quantity ?c - collection ?l - location)
  (rate-of-eating ?p - person)
  (speed ?ob - object)
  (total-walking-distance))
 (:derived
  (acceptable-to-perform-hygiene-actions ?p - person ?br - bathroom)
  (has-permission-to-use ?p ?br))
 (:derived
  (connected-to ?space1 - space ?space2 - space)
  (connected-to ?space2 ?space1))
 (:derived
  (has-door ?door - door ?space1 - space ?space2 - space)
  (has-door ?door ?space2 ?space1))
 (:derived
  (location-is-clean ?location - location)
  (not
   (exists
    (?o - object)
    (not
     (imply
      (at-location ?o ?location)
      (not
       (dirty ?o)))))))
 (:derived
  (mobile ?ob - object)
  (autonomous ?ob))
 (:derived
  (presentable ?p - person)
  (and
   (shaved ?p)
   (showered ?p)))
 (:derived
  (ready-for-work ?p - person)
  (and
   (presentable ?p)
   (not
    (exhausted ?p))))
 (:derived
  (ship-shape)
  (exists
   (?p - person ?la - laundry ?r - electric-razor ?t - towel ?l - location)
   (and
    (presentable ?p)
    (at-location ?la ?l)
    (at-location ?r ?l)
    (at-location ?t ?l))))
 (:derived
  (workday ?d - date)
  (and
   (weekday ?d)
   (not
    (holiday ?d))))
 (:durative-action arm :parameters
  (?p - person ?o - object ?l - location) :duration
  (= ?duration 0) :condition
  (and
   (at start (at-location ?p ?l))
   (at start (at-location ?o ?l))
   (at start (mobile ?o))) :effect
  (and
   (at end (use-is-required ?o))))
 (:durative-action charge-fully :parameters
  (?b - battery-powered-device ?o - outlet ?p - person ?l - location) :duration
  (= ?duration (/ (- 1 (charge-level ?b)) (charge-rate ?b))) :condition
  (and
   (at start (at-location ?p ?l))
   (over all
    (at-location ?o ?l))
   (over all
    (at-location ?b ?l))) :effect
  (and
   (at end (assign (charge-level ?b) 1))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action clean-location :parameters
  (?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (at-location ?p ?l))) :effect
  (and
   (at end (not (dirty ?l)))))
 (:durative-action dry-laundry-load :parameters
  (?p - person ?d - laundry-dryer-machine ?l - location ?ll - laundry-load ?la1 ?la2 ?la3 - laundry) :duration
  (= ?duration 0.75) :condition
  (and
   (at start (at-location ?p ?l))
   (at start (at-location ?ll ?l))
   (at start (at-location ?d ?l))
   (over all
    (is-contained-by ?la1 ?ll))
   (over all
    (is-contained-by ?la2 ?ll))
   (over all
    (is-contained-by ?la3 ?ll))
   (at start (wet ?la1))
   (at start (wet ?la2))
   (at start (wet ?la3))
   (at start (>= (cash ?p) (fee-for-use ?d)))
   (over all
    (is-contained-by ?ll ?d))) :effect
  (and
   (at end (and (not (wet ?la1)) (not (wet ?la2)) (not (wet ?la3))))
   (at end (decrease (cash ?p) (fee-for-use ?d)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action eat :parameters
  (?p - person ?m - mealtype ?l - location) :duration
  (= ?duration (/ (how-filling ?m ?p) (rate-of-eating ?p))) :condition
  (and
   (at start (>= (quantity ?m ?l) 1))
   (at start (at-location ?p ?l))) :effect
  (and
   (at end (assign (hunger-level ?p) (- (hunger-level ?p) (how-filling ?m ?p))))
   (at end (assign (food-ingested ?p) (+ (food-ingested ?p) (how-filling ?m ?p))))
   (at end (assign (quantity ?m ?l) (- (quantity ?m ?l) 1)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action load :parameters
  (?p - person ?ob - object ?lo - container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (mobile ?ob))
   (over all
    (not
     (exists
      (?lc - lockable-container)
      (and
       (= ?lc ?lo)
       (locked-container ?lc)))))
   (at start (at-location ?p ?l))
   (at start (at-location ?ob ?l))
   (at start (at-location ?lo ?l))) :effect
  (and
   (at end (is-contained-by ?ob ?lo))
   (at end (not (at-location ?ob ?l)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action lock-container :parameters
  (?p - person ?lo - lockable-container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (not (locked-container ?lo)))
   (at start (at-location ?p ?l))
   (at start (at-location ?lo ?l))) :effect
  (and
   (at end (locked-container ?lo))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action lock-door :parameters
  (?p - person ?d - door ?l1 - location ?l2 - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (not (locked-door ?d)))
   (at start (closed ?d))
   (at start (at-location ?p ?l1))
   (at start (has-door ?d ?l1 ?l2))) :effect
  (and
   (at end (locked-door ?d))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action move :parameters
  (?ob0 - object ?l0 ?l1 - location) :duration
  (= ?duration 0.15) :condition
  (and
   (over all
    (autonomous ?ob0))
   (at start (at-location ?ob0 ?l0))
   (at start (not (inaccessible ?l0)))
   (at end (not (inaccessible ?l1)))
   (at end (not (exists (?lo - lockable-container) (not (locked-container ?lo)))))) :effect
  (and
   (at end (not (at-location ?ob0 ?l0)))
   (at end (at-location ?ob0 ?l1))
   (at end (assign (actions) (+ (actions) 1)))
   (at end (assign (total-walking-distance) (+ (total-walking-distance) 1)))))
 (:durative-action pick-up :parameters
  (?ob0 - object ?ob1 - object ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (autonomous ?ob0))
   (over all
    (mobile ?ob1))
   (over all
    (at-location ?ob0 ?l))
   (at start (at-location ?ob1 ?l))) :effect
  (and
   (at end (holding ?ob0 ?ob1))
   (at end (not (at-location ?ob1 ?l)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action plug-in :parameters
  (?p - person ?b - battery-powered-device ?o - outlet ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (at-location ?p ?l))
   (over all
    (at-location ?o ?l))
   (over all
    (at-location ?b ?l))
   (over all
    (not
     (exists
      (?co - lockable-container)
      (is-contained-by ?b ?co))))) :effect
  (and
   (at end (plugged-in ?b))))
 (:durative-action set-down :parameters
  (?ob0 - object ?ob1 - object ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (autonomous ?ob0))
   (at start (holding ?ob0 ?ob1))
   (over all
    (at-location ?ob0 ?l))) :effect
  (and
   (at end (not (holding ?ob0 ?ob1)))
   (at end (at-location ?ob1 ?l))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action shave :parameters
  (?r - electric-razor ?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (holding ?p ?r))
   (over all
    (acceptable-to-perform-hygiene-actions ?p ?l))
   (at start (>= (charge-level ?r) 0.25))
   (over all
    (at-location ?p ?l))) :effect
  (and
   (at end (shaved ?p))
   (at end (assign (charge-level ?r) (- (charge-level ?r) 0.25)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action shower :parameters
  (?p - person ?t - towel ?s - shower ?l - location) :duration
  (= ?duration 1) :condition
  (and
   (at start (at-location ?p ?l))
   (over all
    (at-location ?s ?l))
   (at start (use-is-required ?t))
   (over all
    (not
     (exists
      (?o - object)
      (holding ?p ?o))))) :effect
  (and
   (at end (showered ?p))
   (at end (assign (actions) (+ (actions) 1)))
   (at end (not (use-is-required ?t)))))
 (:durative-action sleep :parameters
  (?p - person ?b - bed ?l - location) :duration
  (= ?duration 3) :condition
  (and
   (over all
    (at-location ?p ?l))
   (over all
    (at-location ?b ?l))
   (over all
    (not
     (exists
      (?o - object)
      (holding ?p ?o))))
   (at start (isolated ?l))) :effect
  (and
   (at end (not (exhausted ?p)))
   (at end (not (tired ?p)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unload :parameters
  (?p - person ?ob - object ?lo - lockable-container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (mobile ?ob))
   (over all
    (not
     (exists
      (?lc - lockable-container)
      (and
       (= ?lc ?lo)
       (locked-container ?lc)))))
   (at start (is-contained-by ?ob ?lo))
   (at start (at-location ?lo ?l))
   (at start (at-location ?p ?l))) :effect
  (and
   (at end (not (is-contained-by ?ob ?lo)))
   (at end (at-location ?ob ?l))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unlock-container :parameters
  (?p - person ?lo - lockable-container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (locked-container ?lo))
   (at start (at-location ?p ?l))
   (at start (at-location ?lo ?l))) :effect
  (and
   (at end (not (locked-container ?lo)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unlock-door :parameters
  (?p - person ?d - door ?l1 - location ?l2 - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (locked-door ?d))
   (at start (at-location ?p ?l1))
   (at start (has-door ?d ?l1 ?l2))) :effect
  (and
   (at end (not (locked-door ?d)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unplug :parameters
  (?p - person ?b - battery-powered-device ?o - outlet ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (plugged-in ?b))) :effect
  (and
   (at end (not (plugged-in ?b)))))
 (:durative-action use-object :parameters
  (?p - person ?o - object ?l - location) :duration
  (= ?duration 1) :condition
  (and
   (over all
    (at-location ?p ?l))
   (over all
    (at-location ?o ?l))) :effect
  (and
   (at end (not (use-is-required ?o)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action use-the-restroom :parameters
  (?p - person ?br - bathroom) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (acceptable-to-perform-hygiene-actions ?p ?br))
   (over all
    (at-location ?p ?br))
   (at start (autonomous ?p))) :effect
  (and
   (at end (not (autonomous ?p)))))
 (:durative-action wait :parameters
  (?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (at-location ?p ?l))) :effect
  (and
   (at end (at-location ?p ?l))))
 (:durative-action wash-laundry-load :parameters
  (?p - person ?w - laundry-washing-machine ?l - location ?ll - laundry-load ?la1 ?la2 ?la3 - laundry) :duration
  (= ?duration 0.75) :condition
  (and
   (at start (at-location ?p ?l))
   (at start (at-location ?ll ?l))
   (at start (at-location ?w ?l))
   (over all
    (is-contained-by ?la1 ?ll))
   (over all
    (is-contained-by ?la2 ?ll))
   (over all
    (is-contained-by ?la3 ?ll))
   (at start (dirty ?la1))
   (at start (dirty ?la2))
   (at start (dirty ?la3))
   (at start (>= (cash ?p) (fee-for-use ?w)))
   (over all
    (is-contained-by ?ll ?w))) :effect
  (and
   (at end (and (not (dirty ?la1)) (not (dirty ?la2)) (not (dirty ?la3)) (wet ?la1) (wet ?la2) (wet ?la3)))
   (at end (decrease (cash ?p) (fee-for-use ?w)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action work-fifteen-minutes :parameters
  (?p - person ?c - computer ?o - officeroom ?d - date) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (ready-for-work ?p))
   (over all
    (at-location ?p ?o))
   (over all
    (at-location ?c ?o))
   (over all
    (not
     (exhausted ?p)))
   (over all
    (workday ?d))
   (over all
    (today ?d))
   (over all
    (<=
     (hours-worked-on-date ?p ?d) 10))
   (over all
    (<=
     (food-ingested ?p) 0))) :effect
  (and
   (at end (assign (hours-worked-on-date ?p ?d) (+ (hours-worked-on-date ?p ?d) 0.25)))
   (at end (assign (actions) (+ (actions) 1))))))

(define
 (problem date-20170205)
 (:domain date-20170205)
 (:objects towel-3 towel-2 towel-1 - towel wallet sleeping-bag shirts shampoo padlock hair-trimmers hair-brush food-cans can-opener camouflage - stuff woodmans walmart-oswego tigerdirect starbucks-aurora frys cvs-indian-trail-and-orchard caribou-coffee-batavia - store landing-to-second-floor-stairwell first-floor-to-landing-stairwell entry-to-first-floor-stairwell basement-to-entry-stairwell - stairwell utility-room garage crawl-space balcony - space upstairs-shower - shower clothing-grey-shirt-2 clothing-grey-shirt-1 clothing-green-shirt-1 clothing-blue-shirt-1 - shirt living-room kitchen dining-room bedroom - room andrew-dougherty - person front-door balcony-door - perimeter-door clothing-khaki-shorts-2 clothing-khaki-shorts-1 - pants upstairs-bathroom-outlets kitchen-outlets den-outlets - outlet den - officeroom meal-velveeta-shells-and-cheese meal-pindi-chana meal-palek-paneer meal-miso-soup - mealtype laptop-backpack - lockable-container outside - location upstairs-washer - laundry-washing-machine laundry-load - laundry-load upstairs-dryer - laundry-dryer-machine columcille-computer - laptop second-floor-landing landing - landing finger-clippers - hygiene-tool garage-entry-way entry - entry-way electric-razor-0 - electric-razor garage-door den-door crawl-space-door basement-door - door computer-desk - desk Wednesday Tuesday Thursday Sunday Saturday Monday Friday - day date-20120827 date-20120826 date-20120825 date-20120824 date-20120823 date-20120822 date-20120821 - date dennis-computer - computer landing-closet kitchen-closet dining-room-closet coat-closet bedroom-closet - closet townhome - building guestbed couch - bed cell-phone bluetooth-headset - battery-powered-device upstairs-bathroom guest-bathroom - bathroom)
 (:init
  (= (actions) 0)
  (= (cash andrew-dougherty) 49)
  (= (charge-level bluetooth-headset) 0.3)
  (= (charge-level cell-phone) 0.1)
  (= (charge-level columcille-computer) 1)
  (= (charge-level electric-razor-0) 0.0)
  (= (charge-rate bluetooth-headset) 0.5)
  (= (charge-rate cell-phone) 1)
  (= (charge-rate columcille-computer) 0.6)
  (= (charge-rate electric-razor-0) 0.5)
  (= (discharge-rate bluetooth-headset) 0.01)
  (= (discharge-rate cell-phone) 0.07)
  (= (discharge-rate columcille-computer) 0.3)
  (= (discharge-rate electric-razor-0) 2.5)
  (= (fee-for-use upstairs-dryer) 0)
  (= (fee-for-use upstairs-washer) 0)
  (= (hours-worked-on-date Andrew-Dougherty date-20120821) 0)
  (= (hours-worked-on-date Andrew-Dougherty date-20120822) 0)
  (= (hours-worked-on-date Andrew-Dougherty date-20120823) 0)
  (= (hours-worked-on-date Andrew-Dougherty date-20120824) 0)
  (= (how-filling meal-miso-soup Andrew-Dougherty) 0.7)
  (= (how-filling meal-palek-paneer Andrew-Dougherty) 0.4)
  (= (how-filling meal-pindi-chana Andrew-Dougherty) 0.4)
  (= (how-filling meal-velveeta-shells-and-cheese Andrew-Dougherty) 1.0)
  (= (hunger-level andrew-dougherty) 1)
  (= (quantity meal-miso-soup kitchen-closet) 3)
  (= (quantity meal-palek-paneer kitchen-closet) 2)
  (= (quantity meal-pindi-chana kitchen-closet) 2)
  (= (quantity meal-velveeta-shells-and-cheese kitchen-closet) 1)
  (= (rate-of-eating Andrew-Dougherty) 5.0)
  (= (speed andrew-dougherty) 1)
  (= (total-walking-distance) 0)
  (at 0 (inaccessible walmart-oswego))
  (at 0 (isolated living-room))
  (at 0 (today date-20120821))
  (at 120 (not (today date-20120825)))
  (at 120 (today date-20120826))
  (at 144 (not (today date-20120826)))
  (at 144 (today date-20120827))
  (at 168 (not (today date-20120827)))
  (at 23 (isolated living-room))
  (at 24 (not (today date-20120821)))
  (at 24 (today date-20120822))
  (at 31 (not (isolated living-room)))
  (at 48 (not (today date-20120822)))
  (at 48 (today date-20120823))
  (at 7 (not (inaccessible walmart-oswego)))
  (at 7 (not (isolated living-room)))
  (at 72 (not (today date-20120823)))
  (at 72 (today date-20120824))
  (at 96 (not (today date-20120824)))
  (at 96 (today date-20120825))
  (at-location andrew-dougherty den)
  (at-location balcony townhome)
  (at-location basement-to-entry-stairwell townhome)
  (at-location bedroom townhome)
  (at-location bedroom-closet townhome)
  (at-location clothing-blue-shirt-1 bedroom)
  (at-location clothing-green-shirt-1 bedroom)
  (at-location clothing-grey-shirt-1 bedroom)
  (at-location clothing-grey-shirt-2 bedroom)
  (at-location clothing-khaki-shorts-1 bedroom)
  (at-location clothing-khaki-shorts-2 bedroom)
  (at-location coat-closet townhome)
  (at-location columcille-computer living-room)
  (at-location computer-desk den)
  (at-location couch living-room)
  (at-location crawl-space townhome)
  (at-location den townhome)
  (at-location den-outlets den)
  (at-location dennis-computer den)
  (at-location dining-room townhome)
  (at-location dining-room-closet townhome)
  (at-location electric-razor-0 upstairs-bathroom)
  (at-location entry townhome)
  (at-location entry-to-first-floor-stairwell townhome)
  (at-location finger-clippers den)
  (at-location first-floor-to-landing-stairwell townhome)
  (at-location garage townhome)
  (at-location garage-entry-way townhome)
  (at-location guest-bathroom townhome)
  (at-location guestbed bedroom)
  (at-location kitchen townhome)
  (at-location kitchen-closet townhome)
  (at-location kitchen-outlets kitchen)
  (at-location landing townhome)
  (at-location landing-closet townhome)
  (at-location landing-to-second-floor-stairwell townhome)
  (at-location laptop-backpack den)
  (at-location laundry-load bedroom)
  (at-location living-room townhome)
  (at-location second-floor-landing townhome)
  (at-location towel-1 bedroom)
  (at-location towel-2 bedroom)
  (at-location towel-3 bedroom)
  (at-location upstairs-bathroom townhome)
  (at-location upstairs-bathroom-outlets upstairs-bathroom)
  (at-location upstairs-dryer utility-room)
  (at-location upstairs-shower upstairs-bathroom)
  (at-location upstairs-washer utility-room)
  (at-location utility-room townhome)
  (autonomous andrew-dougherty)
  (day-of-week date-20120821 Tuesday)
  (day-of-week date-20120822 Wednesday)
  (day-of-week date-20120823 Thursday)
  (day-of-week date-20120824 Friday)
  (day-of-week date-20120825 Saturday)
  (day-of-week date-20120826 Sunday)
  (day-of-week date-20120827 Monday)
  (dirty clothing-blue-shirt-1)
  (dirty clothing-green-shirt-1)
  (dirty clothing-grey-shirt-1)
  (dirty clothing-grey-shirt-2)
  (dirty clothing-khaki-shorts-1)
  (dirty clothing-khaki-shorts-2)
  (dirty den)
  (dirty garage)
  (dirty towel-1)
  (dirty towel-2)
  (dirty towel-3)
  (dirty upstairs-bathroom)
  (exhausted andrew-dougherty)
  (has-door balcony-door balcony dining-room)
  (has-door basement-door garage garage-entry-way)
  (has-door crawl-space-door crawl-space garage-entry-way)
  (has-door den-door den garage-entry-way)
  (has-door front-door entry outside)
  (has-door garage-door garage outside)
  (has-permission-to-use Andrew-Dougherty upstairs-bathroom)
  (locked-door basement-door)
  (locked-door front-door)
  (locked-door garage-door)
  (mobile bluetooth-headset)
  (mobile cell-phone)
  (mobile clothing-blue-shirt-1)
  (mobile clothing-green-shirt-1)
  (mobile clothing-grey-shirt-1)
  (mobile clothing-grey-shirt-2)
  (mobile clothing-khaki-shorts-1)
  (mobile clothing-khaki-shorts-2)
  (mobile columcille-computer)
  (mobile electric-razor-0)
  (mobile finger-clippers)
  (mobile laptop-backpack)
  (mobile laundry-load)
  (mobile towel-1)
  (mobile towel-2)
  (mobile towel-3)
  (plugged-in dennis-computer)
  (wearing Andrew-Dougherty clothing-grey-shirt-1)
  (wearing Andrew-Dougherty clothing-khaki-shorts-1)
  (weekday date-20120821)
  (weekday date-20120822)
  (weekday date-20120823)
  (weekday date-20120824)
  (weekday date-20120827))
 (:goal
  (and
   (ready-for-work Andrew-Dougherty)))
 (:metric minimize
  (+
   (+
    (total-time)
    (actions))
   (total-walking-distance))))