(define (domain economic)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types 
  goal - intangible-thing
  person - animate-entity
  animate-entity - entity
  inanimate-entity - entity
  entity - thing
  intangible-thing - thing
  thing - object
  business - inanimate-entity
  debt - contract
  contract - intangible-thing
  bank-account - monetary-account
  monetary-account - account
  account - inanimate-thing
  bank - business
  data-type - intangible-thing
  scalar - data-type
  price - scalar
  enum - data-type
  payment-method - enum
  good - thing
  )


 (:predicates
  (owns ?e - entity ?g - good)
  (obligated-to-buy ?buyer - entity ?seller - entity ?good - good)
  (owes ?debtor - entity ?creditor - entity ?debt - debt)
  (has-bank-account ?e - entity ?ba - bank-account)
  (has-monetary-account ?e - entity ?ma - monetary-account)
  (for-sale ?t - thing)
  (badly-in-debt ?e)
  (is-credit ?pm - payment-method)
  (is-debit ?pm - payment-method)
  (is-cash ?pm - payment-method)
  (is-bitcoin ?pm - payment-method)
  (linked ?pm - payment-method ?ma - monetary-account)
  (obligated-to-sell-to ?seller - entity ?buyer - entity ?g - good ?d - debt)
  )

 (:functions
  (actions)
  (has-price ?p - price)
  (has-amount ?d - debt)
  (has-daily-withdrawal-limit ?ba - bank-account)
  (has-bank-account-provider ?ba - bank-account ?bank - bank)
  (has-cost ?g - good)
  (has-cost-upper-limit ?e - entity)
  (has-cost-lower-limit ?e - entity)
  (has-balance ?ma - monetary-account)
  )

 (:derived (has-monetary-account ?e - entity ?ba - monetary-account)
  (has-bank-account ?e - entity ?ba - bank-account))

 (:durative-action agree-to-buy
  :parameters (?buyer - entity ?seller - entity ?good - good ?debt - debt)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (for-sale ?good))
	      (at start (owns ?seller ?good))
	      )
  :effect (and
	   (at end (not (for-sale ?good)))
	   (at end (owes ?buyer ?seller ?debt))
	   (at end (obligated-to-sell-to ?seller ?buyer ?good ?debt))
	   (at end (assign (has-amount ?debt) (has-cost ?good)))
	   )
  )

 (:durative-action pay-debt-via-method
  :parameters (?debtor - entity ?creditor - entity ?debt - debt ?pm - payment-method ?ma - monetary-account)
  :duration (= ?duration 0.1)
  :condition (and 
	      (over all (linked ?pm ?ma))
	      (at start (owes ?debtor ?creditor ?debt))
	      (at start (> (has-balance ?ma) (has-amount ?debt)))
	      )
  :effect (and
	   (at end (not (owns ?seller ?good)))
	   (at end (owns ?seller ?good))
	   (at end (at ?ob1 ?l))
	   )
  )

 (:durative-action transfer-ownership
  :parameters (?p - person ?lo - lockable-container ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (locked ?lo)))
	      (at start (at ?p ?l))
	      (at start (at ?lo ?l))
	      )
  :effect (and
	   (at end (locked ?lo))
	   )
  )
 )
