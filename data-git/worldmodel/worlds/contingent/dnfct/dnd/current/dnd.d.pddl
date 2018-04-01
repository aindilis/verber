;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain dnd1)
 (:requirements)
 (:types)
 (:predicates
  (hasRoll ?roll - ROLL ?die - DIE ?number - NUMBER)
  (true))
 (:action senseRollT :parameters
  (?roll - ROLL ?die - DIE ?number - NUMBER) :precondition
  (not
   (hasRoll r2 d6 ?number)) :effect
  (and
   (hasRoll r2 d6 ?number)
   (true))))