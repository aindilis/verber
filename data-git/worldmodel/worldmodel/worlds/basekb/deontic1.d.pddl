;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {
;;                           'BASEKB_DEONTIC1' => {}
;;                         }
;;         };

(define
 (domain BASEKB_DEONTIC1)
 (:requirements :derived-predicates :typing)
 (:types)
 (:predicates
  (has-permission-to-use ?p - person ?o - object)))