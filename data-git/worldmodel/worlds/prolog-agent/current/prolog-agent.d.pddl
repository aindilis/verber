;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain prolog-agent)
 (:requirements :strips :typing)
 (:types)
 (:predicates
  (adj ?i ?j - pos)
  (alive)
  (at ?i - pos)
  (breeze ?i - pos)
  (gold-at ?i - pos)
  (got-the-treasure)
  (pit-at ?p - pos)
  (safe ?i - pos)
  (stench ?i - pos)
  (wumpus-at ?x - pos))
 (:action feel-breeze :parameters
  (?pos - pos) :precondition
  (and
   (alive)
   (at ?pos)) :observe
  (breeze ?pos))
 (:action grab :parameters
  (?i - pos) :precondition
  (and
   (at ?i)
   (gold-at ?i)
   (alive)) :effect
  (and
   (got-the-treasure)
   (not
    (gold-at ?i))))
 (:action move :parameters
  (?i - pos ?j - pos) :precondition
  (and
   (adj ?i ?j)
   (at ?i)
   (alive)
   (safe ?j)) :effect
  (and
   (not
    (at ?i))
   (at ?j)))
 (:action smell_wumpus :parameters
  (?pos - pos) :precondition
  (and
   (alive)
   (at ?pos)) :observe
  (stench ?pos)))