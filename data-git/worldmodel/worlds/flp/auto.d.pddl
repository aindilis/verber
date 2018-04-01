;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain auto)
 (:requirements :negative-preconditions :typing :equality :disjunctive-preconditions :fluents :derived-predicates :durative-actions :conditional-effects :timed-initial-literals)
 (:types person document car - physicalObject state physicalLocation formField date - partiallyTangibleThing physicalObject - object)
 (:predicates
  (documentHasFormField ?d - document ?f - formField)
  (hasDated ?d - document ?f - formField ?d - date)
  (hasDriversLicenseInState ?p - person ?s - state)
  (hasPhysicalLocation ?o - physicalObject ?l - physicalLocation)
  (hasSigned ?d - document ?f - formField ?p - person))
 (:durative-action date-document-signature :parameters
  (?document - document ?formField - formField ?signatory - person ?physicalLocation - physicalLocation ?date - date) :duration
  (= ?duration 0) :condition
  (and
   (over all
    (documentHasFormField ?document ?formField))
   (over all
    (hasPhysicalLocation ?signatory ?physicalLocation))
   (over all
    (hasPhysicalLocation ?document ?physicalLocation))
   (at start (not (hasDated ?document ?formField ?date)))) :effect
  (and
   (at end (hasDated ?document ?formField ?date))))
 (:durative-action sign-document :parameters
  (?document - document ?formField - formField ?signatory - person ?physicalLocation - physicalLocation) :duration
  (= ?duration 0) :condition
  (and
   (over all
    (documentHasFormField ?document ?formField))
   (over all
    (hasPhysicalLocation ?signatory ?physicalLocation))
   (over all
    (hasPhysicalLocation ?document ?physicalLocation))
   (at start (not (hasSigned ?document ?formField ?signatory)))) :effect
  (and
   (at end (hasSigned ?document ?formField ?signatory)))))