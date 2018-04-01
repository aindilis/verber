(define
 (domain flp)
 (:requirements :negative-preconditions :conditional-effects :equality :typing :fluents :durative-actions :derived-predicates)
 (:types intelligentAgent residence vehicle tool container - object modeOfTransportation - category object physicalLocation - thing person - intelligentAgent residence - physicalLocation vehicle - container)
 (:predicates
  (autonomous ?A - intelligentAgent)
  (location ?O - object ?L - physicalLocation)
  (contains ?C - container ?O - object)
  (mobile ?Ob - object)
  (directly-holding ?A - intelligentAgent ?O - object)
  (travel-path ?M - modeOfTransportation ?L0 ?L1 - physicalLocation)
  (driving-p ?M - modeOfTransportation)
  (walking-p ?M - modeOfTransportation))
 (:functions
  (travel-distance ?M - modeOfTransportation ?L0 ?L1 - physicalLocation)
  (travel-duration ?M - modeOfTransportation ?L0 ?L1 - physicalLocation))
 (:durative-action walk :parameters
  (?A - intelligentAgent ?L0 ?L1 - physicalLocation ?M - modeOfTransportation) :duration
  (= ?duration (travel-duration ?M ?L0 ?L1)) :condition
  (and
   (over all
    (walking-p ?M))
   (over all
    (travel-path ?M ?L0 ?L1))
   (over all
    (autonomous ?A))
   (at start
    (location ?A ?L0))) :effect
  (and
   (at end
    (not
     (location ?A ?L0)))
   (at end
    (location ?A ?L1))))
 (:durative-action pick-up :parameters
  (?A - intelligentAgent ?O - object ?L - physicalLocation) :duration
  (= ?duration 0) :condition
  (and
   (over all
    (autonomous ?A))
   (over all
    (mobile ?O))
   (at start
    (not
     (directly-holding ?A ?O)))
   (at start
    (location ?A ?L))
   (at start
    (location ?O ?L))) :effect
  (and
   (at end
    (directly-holding ?A ?O))))
 (:durative-action set-down :parameters
  (?A - intelligentAgent ?O - object ?L - physicalLocation) :duration
  (= ?duration 0) :condition
  (and
   (over all
    (autonomous ?A))
   (over all
    (mobile ?O))
   (at start
    (directly-holding ?A ?O))
   (at start
    (location ?A ?L))) :effect
  (and
   (at end
    (location ?O ?L))
   (at end
    (not
     (directly-holding ?A ?O)))))
 (:durative-action carry :parameters
  (?A - intelligentAgent ?O - object ?L0 ?L1 - physicalLocation ?M - modeOfTransportation) :duration
  (= ?duration (travel-duration ?M ?L0 ?L1)) :condition
  (and
   (over all
    (walking-p ?M))
   (over all
    (travel-path ?M ?L0 ?L1))
   (over all
    (autonomous ?A))
   (over all
    (mobile ?O))
   (over all
    (directly-holding ?A ?O))
   (at start
    (location ?A ?L0))
   (at start
    (location ?O ?L0))) :effect
  (and
   (at end
    (not
     (location ?A ?L0)))
   (at end
    (not
     (location ?O ?L0)))
   (at end
    (location ?A ?L1))
   (at end
    (location ?O ?L1))))
 (:durative-action place-into :parameters
  (?A - intelligentAgent ?O - object ?C - container ?L - physicalLocation) :duration
  (= ?duration 0) :condition
  (and
   (over all
    (autonomous ?A))
   (over all
    (mobile ?O))
   (at start
    (directly-holding ?A ?O))
   (at start
    (location ?A ?L))
   (at start
    (location ?O ?L))
   (at start
    (location ?C ?L))
   (at start
    (not
     (contains ?C ?O)))) :effect
  (and
   (at end
    (contains ?C ?O))
   (at end
    (not
     (directly-holding ?A ?O)))))
 (:durative-action drive :parameters
  (?A - intelligentAgent ?V - vehicle ?L0 ?L1 - physicalLocation ?M - modeOfTransportation) :duration
  (= ?duration (travel-duration ?M ?L0 ?L1)) :condition
  (and
   (over all
    (driving-p ?M))
   (over all
    (travel-path ?M ?L0 ?L1))
   (over all
    (autonomous ?A))
   (over all
    (mobile ?V))
   (at start
    (location ?A ?L0))
   (at start
    (location ?V ?L0))) :effect
  (and
   (at end
    (not
     (location ?A ?L0)))
   (at end
    (not
     (location ?V ?L0)))
   (at end
    (location ?A ?L1))
   (at end
    (location ?V ?L1)))))