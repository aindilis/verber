(define
 (domain CYCLE_WEEKLY2)
 (:requirements :typing :conditional-effects :disjunctive-preconditions :durative-actions :equality  :fluents :derived-predicates :negative-preconditions)
 (:types hygiene_tool - tool day_of_week date day - text_string stairwell room landing entry_way closet - space officeroom bathroom - room tool stuff shower person outlet location laundry informational_object furniture electric_device door container collection bed - object locker - lockable_container space building - location towel bedding article_of_clothing - laundry text_string set - informational_object desk - furniture computer battery_powered_device - electric_device perimeter_door - door lockable_container laundry_washing_machine laundry_load laundry_dryer_machine bag - container mealtype - collection store - building laptop electric_razor - battery_powered_device shirt pants - article_of_clothing)
 (:predicates
  (let_the_games_begin)
  (acceptable_to_perform_hygiene_actions ?p - person ?l - location)
  (all_pending_work_accomplished ?p - person ?d - date)
  (at_location ?ob - object ?l - location)
  (autonomous ?ob - object)
  (closed ?d - door)
  (connected_to ?s1 - space ?s2 - space)
  (day_of_week ?date - date ?dow - day_of_week)
  (dirty ?o - object)
  (exhausted ?p - person)
  (has_door ?d - door ?l1 - location ?l2 - location)
  (has_fee_for_use ?o - object)
  (has_permission_to_use ?p - person ?o - object)
  (holding ?ob0 ?ob1 - object)
  (holiday ?date - date)
  (inaccessible ?l - location)
  (is_contained_by ?ob1 - object ?c - container)
  (isolated ?l - location)
  (location_is_clean ?o - location)
  (locked_container ?lo - lockable_container)
  (locked_door ?d - door)
  (mobile ?ob - object)
  (plugged_in ?b - electric_device)
  (presentable ?p - person)
  (ready_for_work ?p - person)
  (shaved ?p - person)
  (ship_shape)
  (showered ?p - person)
  (tired ?p - person)
  (today ?date - date)
  (use_is_required ?o - object)
  (wearing ?person - person ?aoc - article_of_clothing)
  (weekday ?date - date)
  (weekend ?date - date)
  (wet ?la - laundry)
  (workday ?date - date))
 (:functions
  (actions)
  (cash ?p - person)
  (charge_level ?r - battery_powered_device)
  (charge_rate ?r - battery_powered_device)
  (discharge_rate ?r - battery_powered_device)
  (fee_for_use ?o - object)
  (food_ingested ?p - person)
  (hours_worked_on_date ?p - person ?d - date)
  (how_filling ?m - mealtype ?p - person)
  (hunger_level ?p - person)
  (quantity ?c - collection ?l - location)
  (rate_of_eating ?p - person)
  (speed ?ob - object)
  (total_walking_distance))
 (:derived
  (acceptable_to_perform_hygiene_actions ?p - person ?br - bathroom)
  (has_permission_to_use ?p ?br))
 (:derived
  (connected_to ?space1 - space ?space2 - space)
  (connected_to ?space2 ?space1))
 (:derived
  (has_door ?door - door ?space1 - space ?space2 - space)
  (has_door ?door ?space2 ?space1))
 (:derived
  (mobile ?ob - object)
  (autonomous ?ob))
 (:derived
  (presentable ?p - person)
  (and
   (shaved ?p)
   (showered ?p)))
 (:derived
  (ready_for_work ?p - person)
  (and
   (presentable ?p)
   (not
    (exhausted ?p))))
 (:derived
  (ship_shape)
  (exists
   (?p - person ?la - laundry ?r - electric_razor ?t - towel ?l - location)
   (and
    (presentable ?p)
    (at_location ?la ?l)
    (at_location ?r ?l)
    (at_location ?t ?l))))
 (:derived
  (weekday ?date - date)
  (or
   (day_of_week ?date Monday)
   (day_of_week ?date Tuesday)
   (day_of_week ?date Wednesday)
   (day_of_week ?date Thursday)
   (day_of_week ?date Friday)))
 (:derived
  (weekend ?date - date)
  (or
   (day_of_week ?date Sunday)
   (day_of_week ?date Saturday)))
 (:derived
  (workday ?d - date)
  (and
   (weekday ?d)
   (not
    (holiday ?d))))
  
(:durative-action start :parameters () :duration
  (= ?duration 0) :condition
  (and)
  :effect
  (and
   (at start (let_the_games_begin))))
 (:durative-action at_0 :parameters
  () :duration
  (= ?duration 0) :condition
  (and
   (at start (let_the_games_begin)))
  :effect
  (and
   (at end (inaccessible walmart_oswego))
   (at end (isolated living_room))
   (at end (today date_20120821))))
  (:durative-action at_7 :parameters
  () :duration
  (= ?duration 7) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
   (at end (not (inaccessible walmart_oswego)))
   (at end (not (isolated living_room)))
   ))
  (:durative-action at_23 :parameters
  () :duration
  (= ?duration 23) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
   (at end (isolated living_room))
   ))
(:durative-action at_24 :parameters
  () :duration
  (= ?duration 24) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
   (at end (isolated living_room))
   ))
(:durative-action at_31 :parameters
  () :duration
  (= ?duration 31) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
  (at end (not (isolated living_room)))
   ))
(:durative-action at_48 :parameters
  () :duration
  (= ?duration 48) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
  (at end (not (today date_20120822)))
  (at end (today date_20120823))
   ))
(:durative-action at_72 :parameters
  () :duration
  (= ?duration 72) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
  (at end (not (today date_20120823)))
  (at end (today date_20120824))
   ))
(:durative-action at_96 :parameters
  () :duration
  (= ?duration 96) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
  (at end (not (today date_20120824)))
  (at end (today date_20120825))
   ))
(:durative-action at_120 :parameters
  () :duration
  (= ?duration 120) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
   (at end (not (today date_20120825)))
   (at end (today date_20120826))
   ))
(:durative-action at_144 :parameters
  () :duration
  (= ?duration 144) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
   (at end (not (today date_20120826)))
   (at end (today date_20120827))
   ))
(:durative-action at_168 :parameters
  () :duration
  (= ?duration 168) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
   (at end (not (today date_20120827)))
   (at end (today date_20120828))
   ))
(:durative-action at_192 :parameters
  () :duration
  (= ?duration 192) :condition
  (and
   (at start (let_the_games_begin)))
   :effect
  (and
   (at end (not (today date_20120828)))
   ))
  
 (:durative-action arm :parameters
  (?p - person ?o - object ?l - location) :duration
  (= ?duration 0) :condition
  (and
   (at start (at_location ?p ?l))
   (at start (at_location ?o ?l))
   (at start (mobile ?o))) :effect
  (and
   (at end (use_is_required ?o))))
 (:durative-action charge_fully :parameters
  (?b - battery_powered_device ?o - outlet ?p - person ?l - location) :duration
  (= ?duration (/ (- 1 (charge_level ?b)) (charge_rate ?b))) :condition
  (and
   (at start (at_location ?p ?l))
   (over all
    (at_location ?o ?l))
   (over all
    (at_location ?b ?l))) :effect
  (and
   (at end (assign (charge_level ?b) 1))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action clean_location :parameters
  (?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (at_location ?p ?l))) :effect
  (and
   (at end (not (dirty ?l)))))
 (:durative-action dry_laundry_load :parameters
  (?p - person ?d - laundry_dryer_machine ?l - location ?ll - laundry_load ?la1 ?la2 ?la3 - laundry) :duration
  (= ?duration 0.75) :condition
  (and
   (at start (at_location ?p ?l))
   (at start (at_location ?ll ?l))
   (at start (at_location ?d ?l))
   (over all
    (is_contained_by ?la1 ?ll))
   (over all
    (is_contained_by ?la2 ?ll))
   (over all
    (is_contained_by ?la3 ?ll))
   (at start (wet ?la1))
   (at start (wet ?la2))
   (at start (wet ?la3))
   (at start (>= (cash ?p) (fee_for_use ?d)))
   (over all
    (is_contained_by ?ll ?d))) :effect
  (and
   (at end (and (not (wet ?la1)) (not (wet ?la2)) (not (wet ?la3))))
   (at end (decrease (cash ?p) (fee_for_use ?d)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action eat :parameters
  (?p - person ?m - mealtype ?l - location) :duration
  (= ?duration (/ (how_filling ?m ?p) (rate_of_eating ?p))) :condition
  (and
   (at start (>= (quantity ?m ?l) 1))
   (at start (at_location ?p ?l))) :effect
  (and
   (at end (assign (hunger_level ?p) (- (hunger_level ?p) (how_filling ?m ?p))))
   (at end (assign (food_ingested ?p) (+ (food_ingested ?p) (how_filling ?m ?p))))
   (at end (assign (quantity ?m ?l) (- (quantity ?m ?l) 1)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action load :parameters
  (?p - person ?ob - object ?lo - container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (mobile ?ob))
   (over all
    (forall
     (?lc - lockable_container)
     (not
      (and
       (= ?lc ?lo)
       (locked_container ?lc)))))
   (at start (at_location ?p ?l))
   (at start (at_location ?ob ?l))
   (at start (at_location ?lo ?l))) :effect
  (and
   (at end (is_contained_by ?ob ?lo))
   (at end (not (at_location ?ob ?l)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action lock_container :parameters
  (?p - person ?lo - lockable_container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (not (locked_container ?lo)))
   (at start (at_location ?p ?l))
   (at start (at_location ?lo ?l))) :effect
  (and
   (at end (locked_container ?lo))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action lock_door :parameters
  (?p - person ?d - door ?l1 - location ?l2 - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (not (locked_door ?d)))
   (at start (closed ?d))
   (at start (at_location ?p ?l1))
   (at start (has_door ?d ?l1 ?l2))) :effect
  (and
   (at end (locked_door ?d))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action move :parameters
  (?ob0 - object ?l0 ?l1 - location) :duration
  (= ?duration 0.15) :condition
  (and
   (over all
    (autonomous ?ob0))
   (at start (at_location ?ob0 ?l0))
   (at start (not (inaccessible ?l0)))
   (at end (not (inaccessible ?l1)))
   (at end (not (exists (?lo - lockable_container) (not (locked_container ?lo)))))) :effect
  (and
   (at end (not (at_location ?ob0 ?l0)))
   (at end (at_location ?ob0 ?l1))
   (at end (assign (actions) (+ (actions) 1)))
   (at end (assign (total_walking_distance) (+ (total_walking_distance) 1)))))
 (:durative-action pick_up :parameters
  (?ob0 - object ?ob1 - object ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (autonomous ?ob0))
   (over all
    (mobile ?ob1))
   (over all
    (at_location ?ob0 ?l))
   (at start (at_location ?ob1 ?l))) :effect
  (and
   (at end (holding ?ob0 ?ob1))
   (at end (not (at_location ?ob1 ?l)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action plug_in :parameters
  (?p - person ?b - battery_powered_device ?o - outlet ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (at_location ?p ?l))
   (over all
    (at_location ?o ?l))
   (over all
    (at_location ?b ?l))
   (over all
    (not
     (exists
      (?co - lockable_container)
      (is_contained_by ?b ?co))))) :effect
  (and
   (at end (plugged_in ?b))))
 (:durative-action set_down :parameters
  (?ob0 - object ?ob1 - object ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (autonomous ?ob0))
   (at start (holding ?ob0 ?ob1))
   (over all
    (at_location ?ob0 ?l))) :effect
  (and
   (at end (not (holding ?ob0 ?ob1)))
   (at end (at_location ?ob1 ?l))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action shave :parameters
  (?r - electric_razor ?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (holding ?p ?r))
   (over all
    (acceptable_to_perform_hygiene_actions ?p ?l))
   (at start (>= (charge_level ?r) 0.25))
   (over all
    (at_location ?p ?l))) :effect
  (and
   (at end (shaved ?p))
   (at end (assign (charge_level ?r) (- (charge_level ?r) 0.25)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action shower :parameters
  (?p - person ?t - towel ?s - shower ?l - location) :duration
  (= ?duration 1) :condition
  (and
   (at start (at_location ?p ?l))
   (over all
    (at_location ?s ?l))
   (at start (use_is_required ?t))
   (over all
    (not
     (exists
      (?o - object)
      (holding ?p ?o))))) :effect
  (and
   (at end (showered ?p))
   (at end (assign (actions) (+ (actions) 1)))
   (at end (not (use_is_required ?t)))))
 (:durative-action sleep :parameters
  (?p - person ?b - bed ?l - location) :duration
  (= ?duration 3) :condition
  (and
   (over all
    (at_location ?p ?l))
   (over all
    (at_location ?b ?l))
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
  (?p - person ?ob - object ?lo - lockable_container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (over all
    (mobile ?ob))
   (over all
    (forall
     (?lc - lockable_container)
     (not
      (and
       (= ?lc ?lo)
       (locked_container ?lc)))))
   (at start (is_contained_by ?ob ?lo))
   (at start (at_location ?lo ?l))
   (at start (at_location ?p ?l))) :effect
  (and
   (at end (not (is_contained_by ?ob ?lo)))
   (at end (at_location ?ob ?l))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unlock_container :parameters
  (?p - person ?lo - lockable_container ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (locked_container ?lo))
   (at start (at_location ?p ?l))
   (at start (at_location ?lo ?l))) :effect
  (and
   (at end (not (locked_container ?lo)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unlock_door :parameters
  (?p - person ?d - door ?l1 - location ?l2 - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (locked_door ?d))
   (at start (at_location ?p ?l1))
   (at start (has_door ?d ?l1 ?l2))) :effect
  (and
   (at end (not (locked_door ?d)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action unplug :parameters
  (?p - person ?b - battery_powered_device ?o - outlet ?l - location) :duration
  (= ?duration 0.1) :condition
  (and
   (at start (plugged_in ?b))) :effect
  (and
   (at end (not (plugged_in ?b)))))
 (:durative-action use_object :parameters
  (?p - person ?o - object ?l - location) :duration
  (= ?duration 1) :condition
  (and
   (over all
    (at_location ?p ?l))
   (over all
    (at_location ?o ?l))) :effect
  (and
   (at end (not (use_is_required ?o)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action use_the_restroom :parameters
  (?p - person ?br - bathroom) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (acceptable_to_perform_hygiene_actions ?p ?br))
   (over all
    (at_location ?p ?br))
   (at start (autonomous ?p))) :effect
  (and
   (at end (not (autonomous ?p)))))
 (:durative-action wait :parameters
  (?p - person ?l - location) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (at_location ?p ?l))) :effect
  (and
   (at end (at_location ?p ?l))))
 (:durative-action wash_laundry_load :parameters
  (?p - person ?w - laundry_washing_machine ?l - location ?ll - laundry_load ?la1 ?la2 ?la3 - laundry) :duration
  (= ?duration 0.75) :condition
  (and
   (at start (at_location ?p ?l))
   (at start (at_location ?ll ?l))
   (at start (at_location ?w ?l))
   (over all
    (is_contained_by ?la1 ?ll))
   (over all
    (is_contained_by ?la2 ?ll))
   (over all
    (is_contained_by ?la3 ?ll))
   (at start (dirty ?la1))
   (at start (dirty ?la2))
   (at start (dirty ?la3))
   (at start (>= (cash ?p) (fee_for_use ?w)))
   (over all
    (is_contained_by ?ll ?w))) :effect
  (and
   (at end (and (not (dirty ?la1)) (not (dirty ?la2)) (not (dirty ?la3)) (wet ?la1) (wet ?la2) (wet ?la3)))
   (at end (decrease (cash ?p) (fee_for_use ?w)))
   (at end (assign (actions) (+ (actions) 1)))))
 (:durative-action work_fifteen_minutes :parameters
  (?p - person ?c - computer ?o - officeroom ?d - date) :duration
  (= ?duration 0.25) :condition
  (and
   (over all
    (ready_for_work ?p))
   (over all
    (at_location ?p ?o))
   (over all
    (at_location ?c ?o))
   (over all
    (not
     (exhausted ?p)))
   (over all
    (and
     (today ?d)
     (workday ?d)))
   (over all
    (<=
     (hours_worked_on_date ?p ?d) 10))
   (over all
    (<=
     (food_ingested ?p) 0))) :effect
  (and
   (at end (assign (hours_worked_on_date ?p ?d) (+ (hours_worked_on_date ?p ?d) 0.25)))
   (at end (assign (actions) (+ (actions) 1))))))