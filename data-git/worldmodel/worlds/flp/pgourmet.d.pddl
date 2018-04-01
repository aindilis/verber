;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain pgourmet)
 (:requirements :durative-actions :derived-predicates :fluents :conditional-effects :typing :equality :negative-preconditions)
 (:types person - object nutritionix_id info_type - abstract)
 (:predicates
  (brand_id ?nid - nutritionix_id '51db37c1176fe9790a89907e')
  (brand_name ?nid - nutritionix_id 'Campbell_SINGLEQUOTE_s')
  (item_id ?nid - nutritionix_id '?nid - nutritionix_id')
  (item_name ?nid - nutritionix_id 'Chunky Soup, Chicken Tortilla with Grilled Chicken')
  (nf_serving_size_unit ?nid - nutritionix_id cup)
  (rdv_preference ?type - info_type ?p - person ?preftype - rdv_preference_type))
 (:functions
  (nf ?type - info_type ?nid - nutritionix_id)
  (rdv ?type - info_type ?p - person))
 (:durative-action eat :parameters
  (?ia - intelligentAgent ?dts - dateTimeStamp ?fi - foodItem) :duration 0.1 :condition
  (and
   (over all
    (> 1 0))) :effect
  (and
   (at end (and (ate ?ia ?dts ?fi))))))