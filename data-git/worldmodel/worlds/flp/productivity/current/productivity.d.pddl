;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain flpproductivity)
 (:requirements :disjunctive-preconditions :typing :equality :durative-actions :derived-predicates :conditional-effects :negative-preconditions :fluents :timed-initial-literals)
 (:types service date account - type type product person pain location item device - object environment - location workEnvironment shelter - environment batteryPoweredDevice - electricityDevice electricityDevice - device task service interruption event distraction crisis capability action - abstraction)
 (:predicates
  (broken ?object - object)
  (dependsCapabilityOnService ?object - object ?service - service)
  (desiresToWorkOn ?person - person ?task - task)
  (hasCapability ?object - object ?capability - capability)
  (hasCrisis ?person - person ?crisis - crisis)
  (hasDistraction ?person - person ?distraction - distraction)
  (hasDistractions ?person - person)
  (hasInterruption ?person - person ?interruption - interruption)
  (hasProperty ?object - object ?property - property)
  (hasServiceUntil ?environment - environment ?service - service ?date - date)
  (hasSocialAnxiety ?person - person)
  (hasSomethingForPersonToDo ?person1 ?person2 - person)
  (hasStressor ?person - person ?stressor - stressor)
  (hasTimeToBuildConcentration ?person - person)
  (hasUpcomingSocialEvent ?person - person ?event - event)
  (isCurrent ?object - object)
  (languishing ?person - person)
  (lastReplaced ?object - object ?date - date)
  (tired ?person - person)
  (today ?date - date)
  (unableToBeProductive ?person - person)
  (wantsToRecreateNow ?person - person)
  (wasThrownOut ?object - object))
 (:functions
  (consumeOnAveragePerDay ?person - person ?object - object)
  (costs ?action - action ?object - object)
  (duration ?action - action ?object - object)
  (hasBalance ?person - person ?account - account)
  (hasBillAmount ?service - service ?startdate ?enddate - date)
  (hasInventory ?location - location ?object - object)
  (hasReliability ?service - service)
  (lastBillAmount ?service - service ?startdate ?enddate - date)
  (numberOfDaysOfServiceRemaining ?service - service)
  (numberOfDaysWhereReplete ?date - date)
  (numberOfMonthsOfServiceRemaining ?service - service))
 (:derived
  (hasDistractions ?person - person)
  (or
   (hasSocialAnxiety ?person)))
 (:derived
  (hasSocialAnxiety ?person1 - person)
  (or
   (exists
    (?event - event)
    (hasUpcomingSocialEvent ?person1 ?event))))
 (:derived
  (unableToBeProductive ?person - person)
  (hasDistractions ?person))
 (:durative-action fix :parameters
  (?person - person ?object - object ?account - account) :duration
  (= ?duration 1) :condition
  (and
   (at start (> (hasBalance ?person ?account) (costs fix ?object)))
   (at start (broken ?object))) :effect
  (and
   (at end (assign (hasBalance ?person ?account) (- (hasBalance ?person ?account) (costs fix ?object))))
   (at end (not (broken ?object)))))
 (:durative-action replace :parameters
  (?person - person ?object - object ?account - account) :duration
  (= ?duration 1) :condition
  (and
   (at start (> (hasBalance ?person ?account) (costs replace ?object)))
   (at start (broken ?object))) :effect
  (and
   (at end (assign (hasBalance ?person ?account) (- (hasBalance ?person ?account) (costs replace ?object))))
   (at end (not (broken ?object))))))