;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {
;;                           'TEST_TEST2' => {
;;                                             'UTIL_DATE1' => 1
;;                                           }
;;                         }
;;         };

(define
 (domain TEST_TEST2)
 (:requirements :typing)
 (:types day-of-week date - string string - object)
 (:predicates
  (day-of-week ?date - date ?dow - day-of-week)
  (pay-day ?date - date)
  (today ?date - date)
  (weekday ?date - date)
  (weekend ?date - date))
 (:derived
  (weekday ?date - date)
  (or
   (day-of-week ?date Monday)
   (day-of-week ?date Tuesday)
   (day-of-week ?date Wednesday)
   (day-of-week ?date Thursday)
   (day-of-week ?date Friday)))
 (:derived
  (weekend ?date - date)
  (or
   (day-of-week ?date Sunday)
   (day-of-week ?date Saturday))))