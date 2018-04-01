(in-package :ap)

(define (domain ebay)
    (:extends commerce internet)
  (:requirements :assumptions)
  (:types PaymentSite - (and Website FinancialOrganization)
	  AuctionSite - (and Website Vendor)
	  SaleOutcome - msgContent)
  (:predicates
   (seller ?p - Agent ?s - AuctionSite)
   (listedForSale ?c - AuctionSite ?m - Merchandise ?seller - Agent)
   (attemptToSell ?seller - Agent ?m - Merchandise)
   (shipTo ?from - Agent ?m - Merchandise ?to - Agent)
   ;; buying
   (determineInterest ?buyer - Agent ?m - Merchandise)
   (itemFound ?p - Agent ?m - Merchandise)
   (attemptToPurchase ?buyer - Agent ?m - Merchandise)
   (knowsPrice ?buyer ?seller - Agent ?m - Merchandise)
   ;;-- Auction
   (bidPlaced ?buyer - Agent ?s - Vendor ?m - Merchandise)
   (auctionConducted ?c - AuctionSite ?seller - Agent ?m - Merchandise)
   (auctionResult ?m - Merchandise ?result - SaleOutcome)
   (participantsNotified ?c - Vendor ?m - Merchandise ?o - SaleOutcome)
   (auctionMonitored ?p - Agent ?m - Merchandise)
   )
  (:constants ebay.com - AuctionSite
	      PayPal.com - PaymentSite
	      selleracctform member_rating
	      listingform bidform auctionpgreq auctionpg - webform
              memberack sellerack listingack bidack paymentAck outbid 
	      price shipment_notice - msgContent
	      itemSold itemNotSold - SaleOutcome
	      saleprice - (and msgContent Money))
  (:defaults 
      (msg_response bidform bidack)
      (msg_response auctionpgreq auctionpg)))

;;;==== top of abstraction hierarchy: conducting sales =====

(define (action try_sell)
    :parameters (?seller - Agent
		 ?m - Merchandise)
    :vars (?site - AuctionSite)
    :expansion (series
                (listedForSale ?site ?m ?seller)
		(auctionConducted ?site ?seller ?m))
    :effect (attemptToSell ?seller ?m))

(define (action "List For Sale")
    :parameters (?site - AuctionSite
		 ?m - Merchandise 
		 ?seller - Agent)
    :precondition (possesses ?seller ?m)
    :expansion (series
		(seller ?seller ?site)
		(transmitted ?seller ?site http listingform)
		(link (auctionMonitored ?seller ?m) :input ?site)
		)
    :effect (listedForSale ?site ?m ?seller))

;;;--- buyer actions ---

(define (action try_buy)
    :parameters (?buyer - Agent
		 ?m - Merchandise)
    :vars (?site - AuctionSite
	   ?seller - Agent)
    :precondition (not (= ?buyer ?seller))
    :expansion (series
		(link (determineInterest ?buyer ?m) :output ?seller)
		(bidPlaced ?buyer ?site ?m)
                (link (auctionConducted ?site ?seller ?m) :input ?buyer))
    :effect (attemptToPurchase ?buyer ?m))

(define (action browse_to_buy)
    :parameters (?buyer - Agent
		 ?m - Merchandise)
    :vars (?site - AuctionSite
	   ?seller - Agent)
    :precondition (not (= ?buyer ?seller))
    :value ?seller 
    :expansion (series
                (link (itemFound ?buyer ?m) :output ?seller)
                (parallel
                 (knowsPrice ?buyer ?site ?m)
                 (link (knows ?buyer ?seller) :input ?site)))
    :effect (determineInterest ?buyer ?m))

(define (action find_auction)
    :parameters (?buyer - Agent
                 ?m - Merchandise)
    :vars (?seller - Agent
	   ?site - AuctionSite)
    :value ?seller
    :precondition (and (listedForSale ?site ?m ?seller)
		       (not (= ?buyer ?seller)))
    :effect (itemFound ?buyer ?m))

(define (action review_member)
    :parameters (?p1 ?p2 - Agent)
    :vars (?site - Website)
    :value ?site			; possible input
    :precondition (and (memberOf ?p1 ?site)
		       (memberOf ?p2 ?site)
		       (not (= ?p1 ?p2)))
    :effect (and (knows ?p1 ?p2)
		 (transmitted ?site ?p1 http member_rating))
    :comment "buyers and sellers have records")

(define (action "Place Bid")
    :parameters (?buyer - Agent
		 ?site - AuctionSite
		 ?m - Merchandise)
    :precondition (memberOf ?buyer ?site)
    :expansion (series
		(knowsPrice ?buyer ?site ?m)
                (transmitted ?buyer ?site http bidform)
                (transmitted ?site ?buyer SMTP bidack))
    :effect (bidPlaced ?buyer ?site ?m)
    :probability 0.9
    :comment "someone else assures that ?m is listedForSale")

(define (action "Determine Price")
    :parameters (?buyer - Agent
		 ?site - CommercialOrganization
		 ?m - Merchandise)
    :precondition (listedForSale ?site ?m :ignore)
    :expansion (transmitted ?site ?buyer http price)
    :effect (knowsPrice ?buyer ?site ?m))

(define (action "Determine Sellers Price")
    :parameters (?buyer ?seller - Agent
		 ?m - Merchandise)
    :precondition (listedForSale ?seller ?m :ignore)
    :expansion (transmitted ?seller ?buyer SMTP price)
    :effect (knowsPrice ?buyer ?seller ?m)
    :comment "person-to-person sales")

;;;--- conducting an auction ---

(define (action no_bidders)
    :parameters (?site - AuctionSite
		 ?seller - Agent
		 ?m - Merchandise)
    :vars (?buyer - Agent)
    :value ?buyer			; if there is on, should not work
    :precondition (and (listedForSale ?site ?m ?seller)
		       (not (bidPlaced ?buyer ?site ?m))
		       (not (= ?buyer ?seller)))
    :expansion (series
		(parallel
                 (link (auctionMonitored ?seller ?m) :input ?site)
		 (link (auctionResult ?m itemNotSold) :input ?seller))
		(link (transmitted ?site ?seller SMTP itemNotSold) :input ?m))
    :effect (auctionConducted ?site ?seller ?m)
    :probability 0.2
    :comment "transiton to bids outside scope of auctionConducted abstraction")

(define (action bid_not_sold)
    :parameters (?site - AuctionSite
		 ?seller - Agent
		 ?m - Merchandise)
    :vars (?bidder - Agent)
    :value ?bidder
    :precondition (and (listedForSale ?site ?m ?seller)
		       (bidPlaced ?bidder ?site ?m)
		       (not (= ?bidder ?seller)))
    :expansion (series
		(link (auctionMonitored ?seller ?m) :input ?site)
		(link (auctionResult ?m itemNotSold) :input ?seller)
		(link (participantsNotified ?site ?m itemNotSold) :input ?bidder))
    :effect (auctionConducted ?site ?seller ?m)
    :probability 0.3)

(define (action auction_sold)
    :parameters (?site - AuctionSite 
		 ?seller - Agent
		 ?m - Merchandise)
    :vars (?buyer - Agent)
    :value ?buyer
    :precondition (and (not (possesses ?buyer ?m))
		       (bidPlaced ?buyer ?site ?m)
		       (listedForSale ?site ?m ?seller)
		       (not (= ?buyer ?seller)))
    :expansion (series
		;;--needed for notify_seller to work
		(link (auctionMonitored ?seller ?m) :input ?site)
		(auctionResult ?m itemSold)
		(link (participantsNotified ?site ?m itemSold) :input ?buyer)
		(link (possesses ?buyer ?m) :input ?site))
    :effect (auctionConducted ?site ?seller ?m)
    :probability 0.5)

(define (action notsold)
    :parameters (?m - Merchandise)
    :vars (?seller - Agent
	   ?site - AuctionSite)
    :value ?seller ;;?site input
    :precondition (listedForSale ?site ?m ?seller)
    :effect (auctionResult ?m itemNotSold)
    :probability 0.2)

(define (action sold)
    :parameters (?m - Merchandise)
    :vars (?buyer - Agent
	   ?site - AuctionSite)
    :precondition (bidPlaced ?buyer ?site ?m)
    :effect (auctionResult ?m itemSold)
    :probability 0.8)

(define (action monitor_auction)
    :parameters (?p - Agent
		 ?m - Merchandise)
    :vars (?site - AuctionSite)
    :value ?site
    :precondition (memberOf ?p ?site)
    :expansion (series
		(transmitted ?p ?site http auctionpgreq)
		(transmitted ?site ?p http auctionpg))
    :effect (auctionMonitored ?p ?m)
    :comment "any memberOf can monitor an auction")

;;---2 notify actions so they can depend on different preconditions

(define (action notify_participants)
    :parameters (?site - AuctionSite
		 ?m - Merchandise
		 ?outcome - SaleOutcome)
    :vars (?seller ?buyer - Agent)
    :value ?buyer			; input from auction_sold
    :precondition (and (listedForSale ?site ?m ?seller)
		       (bidPlaced ?buyer ?site ?m)
		       (not (= ?buyer ?seller)))
    :expansion (parallel
		 (link (transmitted ?site ?seller SMTP ?outcome) :input ?m)
		 (link (transmitted ?site ?buyer SMTP ?outcome) :input ?m))
    :effect (participantsNotified ?site ?m ?outcome)
    :documentation "email buyer and seller, in no particular order")

;;;======= creating acccounts ===================

(define (action "Create Seller Account")
    :parameters (?p - Agent
		 ?site - AuctionSite) 
    :precondition (not (seller ?p ?site))
    :expansion (series
		(memberOf ?p ?site)
		(transmitted ?p ?site https selleracctform))
    :effect (seller ?p ?site))

;;;--- electronic funds transfer ---

(define (action "Complete Transaction")
    :parameters (?m - Merchandise
		 ?buyer - Agent)
    :vars (?seller - Agent
	   ?site - AuctionSite
	   ?intermediary - PaymentSite)
    :value ?site ;;?seller  ; input
    :precondition (and (listedForSale ?site ?m ?seller)
		       (not (= ?buyer ?seller)))
    :expansion (series
		(transmitted ?buyer ?intermediary eft saleprice)
		(transmitted ?intermediary ?seller SMTP paymentAck)
		(parallel
		 (link (shipTo ?seller ?m ?buyer) :input ?intermediary)
		 (link (transmitted ?intermediary ?seller eft saleprice) :input ?buyer)))
    :effect (possesses ?buyer ?m))

(define (action "Pay Site")
    :parameters (?buyer - Agent
		 ?site - Website)
    :precondition (transmitted ?site ?buyer :ignore itemSold)
    :effect (transmitted ?buyer ?site eft saleprice)
    :probability 0.9)

(define (action "Pay Seller")
    :parameters (?site - Website
		 ?seller - Agent)
    :vars (?buyer - Agent)
    :value ?buyer			; input
    :precondition (and (transmitted ?site ?seller :ignore itemSold)
		       (transmitted ?buyer ?site eft saleprice))
    :effect (transmitted ?site ?seller eft saleprice))

;;;--- transfer of possession ---

(define (action Ship)
    :parameters (?m - Merchandise
		 ?seller ?buyer - Agent)
    :vars (?site - Website)
    :value ?site	
    :precondition (and (possesses ?seller ?m)
		       (transmitted ?site ?seller :ignore paymentAck))
    :expansion (transmitted ?site ?buyer SMTP shipment_notice)
    :effect (and (shipTo ?seller ?m ?buyer)
		 (not (possesses ?seller ?m)))
    :probability 0.9)

(define (action "Shipped By Site")
    :subClassOf Ship
    :parameters (?m - Merchandise
		 ?site - Website
		 ?buyer - Agent)
    :precondition (and (possesses ?site ?m)
		       (transmitted ?buyer ?site eft saleprice))
    :expansion (transmitted ?site ?buyer SMTP shipment_notice)
    :effect (and (shipTo ?site ?m ?buyer)
		 (not (possesses ?site ?m)))
    :probability 0.95
    :comment "?site is seller")

;;;=== test problems ===

(define (situation eBaysit)
    (:objects 
     Wally - Employee
     office_supplies DellComputer1 - Merchandise)
 ;; (:init (memberOf Wally ebay.com))
  (:comment "initial-situation for testing"))


;;;--- test planning to be sure stuff works ---

(define (situation plan_test)
    (:immediately-after eBaysit)
  (:objects MCF RAS RAM RH - Agent)
  (:init (possesses Wally DellComputer1)
	 (possesses MCF office_supplies)
	 ;;(memberOf Wally ebay.com)
	 ;;(seller Wally ebay.com);;--shortcut for testing
	 )
  (:comment "don't want plan recognition to know this"))

(define (problem try_to_sell)
    (:situation plan_test)
  (:init (memberOf MCF ebay.com))
  (:goal (attemptToSell Wally DellComputer1))
  (:documentation "data generator for reports"))


(define (problem conduct_auction)
    (:situation plan_test)
  (:init (listedForSale ebay.com DellComputer1 Wally);;--axiom to note Wally is a seller?
	 (memberOf MCF ebay.com))
  (:goal (auctionConducted ebay.com Wally DellComputer1)))

(define (problem try_buy_wally)
    (:situation plan_test)
  (:init (memberOf MCF ebay.com)
	 (listedForSale ebay.com office_supplies MCF))
  (:goal (attemptToPurchase Wally office_supplies))
  (:documentation "data generator for reports"))

;; tests that have worked for a long time
(define (problem try_to_buy)
    (:situation plan_test)
  (:init (memberOf Wally ebay.com)
	 (listedForSale ebay.com DellComputer1 Wally)) ;;--shortcut for testing
  (:goal (attemptToPurchase RH DellComputer1)))

;;;--- plan recognition problems ---

;; for testing, (remove-template 'try_sell *domain* :forever t)
;;              (remove-template 'bid_not_sold *domain* :forever t)

(define (problem recognize_bidack)
    (:requirements :assumptions)
  (:situation eBaysit)
  (:objects unsub - Agent)
  (:init ;;(memberOf Wally ebay.com)
   (listedForSale ebay.com DellComputer1 Wally) ;; testing 07/17/09
   (memberOf unsub ebay.com)
   (seller unsub ebay.com));;faster testing, 12-04-06
  (:anchor (transmitted ebay.com Wally SMTP bidack))
  (:comment "should result in only try_buy"))

(define (problem recognize_itemSold)
    (:requirements :assumptions)
  (:situation eBaysit)
  (:anchor (transmitted ebay.com Wally SMTP itemSold))
  (:comment "results in both try_buy and try_sell"))

#|
;;;----testing assumptinos for missing info
(define (problem test_ass_auctionConducted)
    (:situation eBaysit)
  (:requirements :assumptions)
  (:init (memberOf Wally eBay.com)
	 (listedForSale eBay.com DellComputer1 Wally))
  (:goal (auctionConducted eBay.com Wally DellComputer1))
  (:comment "use all-plans-p, then remove auction_not_sold to test"))

(define (problem test_ass_attemptToSell)
    (:situation eBaysit)
  (:requirements :assumptions)
  (:init (memberOf Wally eBay.com))
  (:goal (attemptToSell Wally DellComputer1)))

(define (problem test_ass_attemptToPurchase)
    (:situation eBaysit)
  (:requirements :assumptions)
  (:goal (attemptToPurchase mike gun)))
|#
