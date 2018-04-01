;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain flp)
 (:requirements :equality :conditional-effects :negative-preconditions :typing  :fluents :durative-actions)
 (:types physicalLocation object - thing residence - physicalLocation vehicle tool residence intelligentAgent container - object person - intelligentAgent vehicle - container modeOfTransportation - category)
 (:predicates
  (autonomous ?a - intelligentAgent)
  (contains ?c - container ?o - object)
  (directly-holding ?a - intelligentAgent ?o - object)
  (location ?o - object ?l - physicalLocation)
  (mobile ?ob - object)
  (travel-path ?m - modeOfTransportation ?l0 ?l1 - physicalLocation))
 (:functions
  (travel-distance ?m - modeOfTransportation ?l0 ?l1 - physicalLocation)
  (travel-duration ?m - modeOfTransportation ?l0 ?l1 - physicalLocation))
 (:durative-action carry :parameters
  (?a - intelligentAgent ?o - object ?l0 ?l1 - physicalLocation) :duration
  (= ?duration (travel-duration walking ?l0 ?l1)) :condition
  (and
   (over all
    (travel-path driving ?l0 ?l1))
   (over all
    (autonomous ?a))
   (over all
    (mobile ?o))
   (over all
    (directly-holding ?a ?o))
   (at start (location ?a ?l0))
   (at start (location ?o ?l0))) :effect
  (and
   (at end (not (location ?a ?l0)))
   (at end (not (location ?o ?l0)))
   (at end (location ?a ?l1))
   (at end (location ?o ?l1))))
 (:durative-action drive :parameters
  (?a - intelligentAgent ?v - vehicle ?l0 ?l1 - physicalLocation) :duration
  (= ?duration (travel-duration driving ?l0 ?l1)) :condition
  (and
   (over all
    (travel-path driving ?l0 ?l1))
   (over all
    (autonomous ?a))
   (over all
    (mobile ?v))
   (at start (location ?a ?l0))
   (at start (location ?v ?l0))) :effect
  (and
   (at end (not (location ?a ?l0)))
   (at end (not (location ?v ?l0)))
   (at end (location ?a ?l1))
   (at end (location ?v ?l1))))
 (:durative-action pick-up :parameters
  (?a - intelligentAgent ?o - object ?l - physicalLocation) :duration
  (= ?duration 0) :condition
  (and
   (over all
    (autonomous ?a))
   (over all
    (mobile ?o))
   (at start (not (directly-holding ?a ?o)))
   (at start (location ?a ?l))
   (at start (location ?o ?l))) :effect
  (and
   (at end (directly-holding ?a ?o))))
 (:durative-action place-into :parameters
  (?a - intelligentAgent ?o - object ?c - container ?l - physicalLocation) :duration
  (= ?duration 0) :condition
  (and
   (over all
    (autonomous ?a))
   (over all
    (mobile ?o))
   (at start (directly-holding ?a ?o))
   (at start (location ?a ?l))
   (at start (location ?o ?l))
   (at start (location ?c ?l))
   (at start (not (contains ?c ?o)))) :effect
  (and
   (at end (contains ?c ?o))
   (at end (not (directly-holding ?a ?o)))))
 (:durative-action set-down :parameters
  (?a - intelligentAgent ?o - object ?l - physicalLocation) :duration
  (= ?duration 0) :condition
  (and
   (over all
    (autonomous ?a))
   (over all
    (mobile ?o))
   (at start (directly-holding ?a ?o))
   (at start (location ?a ?l))) :effect
  (and
   (at end (location ?o ?l))
   (at end (not (directly-holding ?a ?o)))))
 (:durative-action walk :parameters
  (?a - intelligentAgent ?l0 ?l1 - physicalLocation) :duration
  (= ?duration (travel-duration walking ?l0 ?l1)) :condition
  (and
   (over all
    (travel-path driving ?l0 ?l1))
   (over all
    (autonomous ?a))
   (at start (location ?a ?l0))) :effect
  (and
   (at end (not (location ?a ?l0)))
   (at end (location ?a ?l1)))))