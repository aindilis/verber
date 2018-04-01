(in-package :ap)

;;; This domain demonstrates:
;;;    1. using Classes like generalized objects
;;;    2. OPT, implemented with (link <prop> :input|:output ?var) and :value
;;;    3. selective use of :multi-agent
;;;    4. PPDDL :probabilistic-effects
;;;    5. Plan recognition

(define (domain YSP)
    (:comment "Yale Shooting Problem meets Kill Bill, vols. 1 & 2")
  (:requirements :probabilistic-effects :durative-actions)
  (:extends commerce travel weapon)	
  ;; types not defined here are inherited from domains that YSP extends
  (:types Assassin "Sword Smith" - Person ; subclass of foaf:Agent
	  "Deadly Viper" - Assassin
	  Sword Knife - EdgedWeapon
	  Katana - Sword
  	  "Hattori Hanzo Sword" - Katana
	  Boolean - EnumeratedClass)	; makes values owl:oneOf
  (:constants false true - Boolean)	; objects available in all situations
  (:predicates				; can have multiple values
   (alive ?a - Agent)
   (loaded ?g - Firearm)
   (obtainWeapon ?p - Person)		; test OPT link subgoal
   (hasEnemy ?p1 ?p2 - Person)
   (enemyOf ?p2 ?p1 - Person)
   (shootAt ?p1 ?p2 - Person)
   (kill ?p1 ?p2 - Person)
   (attack ?p1 ?p2 - Person))
  (:functions				; injective, range is number unless specified
   (bulletCapacity ?g - Firearm)
   (bullets ?g - Firearm)
   (aimGunAt ?p1 - Person) - Person)
  ;;-- axioms without context cause defaults to be asserted in domain-situations
  ;;   Useful if you have a lot of propositions you'd rather not assert.
  (:axiom
   :vars (?h - Person)
   :implies (alive ?h))
  ;;-- normal axioms that apply when the context holds in a situation
  (:axiom
   :vars (?a - Agent
	  ?w - Weapon
	  ?l - Location)
   :context (and (possesses ?a ?w)
		 (located ?a ?l))
   :implies (located ?w ?l)
   :documentation "weapon is located where possessor is located")
  (:axiom
   :vars (?f - Firearm)
   :context (not (loaded ?f))
   :implies (bullets ?f 0))
  )

(inverseOf 'hasEnemy enemyOf)

(remove-action 'Steal)
(remove-action 'Obtain)

;;;=== action definitions ===
;;;
;;;    These could be defined within the domain structure above,
;;;     but often it is easier to do them incrementally.

(define (action "Go And Kill")
    :parameters (?killer - Assassin
		 ?victim - Person)
    :vars (?loc - (located ?victim)
	   ?w - Weapon)
    :precondition (and (alive ?killer)	; for counterplanning
		       (enemyOf ?killer ?victim)
		       (not (located ?killer ?loc)))
    :expansion (series
		(located ?killer ?loc)
		(link (obtainWeapon ?killer) :output ?w)
		(link (attack ?killer ?victim) :input ?w))
    :effect (and (kill ?killer ?victim)
		 (not (alive ?victim))))

(define (action "Get Weapon And Kill")
    :parameters (?killer - Assassin
		 ?victim - Person)
    :vars (?loc - (located ?victim)
	   ?w - Weapon)
    :precondition (and (alive ?killer)	; for counterplanning
		       (enemyOf ?killer ?victim)
		       (located ?killer ?loc))
    :expansion (series
		(link (obtainWeapon ?killer) :output ?w)
		(located ?killer ?loc)
		(link (attack ?killer ?victim) :input ?w))
    :effect (and (kill ?killer ?victim)
		 (not (alive ?victim)))
    :comment "test OPT passing ?w up and down the HTN")

;;;--- This is the YSP part ---
;;;
;;;  Note that each attack takes an :input of the weapon to be used

(define (action YSP_shoot)
    :subClassOf Kill
    :parameters (?shooter ?victim - Person)
    :vars (?g - Firearm
	   ?loc - (located ?victim))
    :input ?g
    :precondition (and (located ?shooter ?loc)
		       (possesses ?shooter ?g)
		       (loaded ?g))
    :effect (and (shootAt ?shooter ?victim)
		 (attack ?shooter ?victim)
		 (probabilistic 0.3 (not (alive ?victim))))
    :comment "that ?g still contains ?b is crux of Yale Shooting Problem")

(define (action "Shoot To Kill")
    :subClassOf Kill
    :parameters (?shooter ?victim - Person)
    :vars (?g - Firearm
	   ?b - Bullet
	   ?loc - (located ?victim))
    :input ?g
    :precondition (and (alive ?shooter)	; for counterplanning
		       (enemyOf ?shooter ?victim)
		       (not (possesses ?victim ?g))
		       (not (= ?shooter ?victim)))
    :expansion (series
		(parallel 
		 (possesses ?shooter ?g)
		 (possesses ?shooter ?b)
		 (located ?shooter ?loc))
		(link (shootAt ?shooter ?victim) :input ?g))
    :effect (attack ?shooter ?victim)
    :probability 0.9
    :comment "that ?g still contains ?b is crux of Yale Shooting Problem")

(define (action "Load & Shoot At")
    :parameters (?shooter ?victim - Person)
    :vars (?g - Firearm
	   ?b - Bullet
	   ?loc - (located ?victim))
    :input ?g
    :precondition (and (enemyOf ?shooter ?victim)
		       (possesses ?shooter ?g)
		       (possesses ?shooter ?b)
		       (located ?shooter ?loc)
		       (not (= ?shooter ?victim))) ; not suicide
    :expansion (series
		(link (contains ?g ?b) :input ?shooter)
		(link (aimGunAt ?shooter ?victim) :input ?g)
		(not (contains ?g ?b)))
    :effect (and (shootAt ?shooter ?victim)
		 (attack ?shooter ?victim)))

(define (durative-action "Load Firearm")
    :subClassOf Integrate
    :parameters (?g - Firearm
		 ?b - Bullet)
    :vars (?shooter - Person)
    :value ?shooter			; can be :input or :output
    :condition (and (at start (not (contains ?g ?b)))
		    (over all (possesses ?shooter ?g))
		    (over all (possesses ?shooter ?b)))
    :effect (and (at end (contains ?g ?b))
		 (at end (loaded ?g)))
    :duration 0.01
    :probability 0.99
    :comment "load Bullet into Firearm")

(define (durative-action Aim)
    :subClassOf Guide
    :parameters (?shooter ?victim - Person)
    :vars (?g - Firearm
	   ?loc - (located ?victim))
    :value ?g				; probably input
    :condition (and (located ?shooter ?loc)
		    (enemyOf ?shooter ?victim)
		    (possesses ?shooter ?g))
    :effect (aimGunAt ?shooter ?victim)
    :duration 0.01
    :probability 0.9)			; harder than it looks
    
(define (durative-action Shoot)
    :parameters (?g - Firearm
		 ?b - Bullet)
    :condition (at start (contains ?g ?b))
    :effect (at end (not (contains ?g ?b)))
    :duration 0.005
    :probability 0.98			; could misfire
    :comment "fire a loaded Firearm")

;;-- generic Weapon acqusition --
;;
;; Note that all obtainWeapon actions have :output of the weapon

(define (durative-action SteaWeapon)
    :parameters (?w - Weapon
		 ?a - Person)
    :vars (?owner - Person
	   ?weapon-location - (located ?w))
    :output ?w
    :precondition (and (possesses ?owner ?w)
		       (located ?a ?weapon-location)
		       (not (= ?a ?owner)))
    :effect (and (obtainWeapon ?a)
		 (possesses ?a ?w)
		 (not (possesses ?owner ?w)))
    :duration 1.0
    :probability 0.6
    :comment "could be called Disarm in counterplanning")

(define (action Obtain)
    :precondition (not (instance ?o ControlledSubstance))
    :effect (possesses ?a ?o)
    :comment "change possession of an object")

;;;--- Swords ---

(define (action "Have Sword Made")
    :subClassOf Make
    :parameters (?p - Person)
    :vars (?s - Sword
	   ?maker - SwordSmith
	   ?loc - (located ?p))
    :output ?s
    :precondition (and (located ?maker ?loc)
		       (not (possessed_by ?s :ignore)))
    :effect (and (obtainWeapon ?p)
		 (possesses ?p ?s))
    :duration 30.0)

(define (durative-action Kenjutsu)
    :subClassOf Fight
    :parameters (?killer ?victim - Person)
    :vars (?s - Sword
	      ?loc - (located ?victim))
    :value ?s
    :precondition (and (possesses ?killer ?s)
		       (enemyOf ?killer ?victim)
		       (located ?killer ?loc))
    :effect (and (attack ?killer ?victim)
		 (probabilistic 0.3 (not (alive ?victim))))
    :duration 0.1)

(define (action Stab)
    :parameters (?killer ?victim - Person)
    :vars (?s - Knife
	   ?loc - (located ?victim))
    :value ?s
    :precondition (and (alive ?victim)
		       (enemyOf ?killer ?victim)
		       (possesses ?killer ?s)
		       (located ?killer ?loc)
		       (not (= ?killer ?victim)))
    :effect (and (attack ?killer ?victim)
		 (probabilistic 0.2 (not (alive ?victim))))
    :duration 0.1)

;;;=== situation where all problems start ===

(define (situation Yale)
    (:domain YSP)
  (:objects Beatrix - Assassin	
	    Bill - (and Planner Assassin)	; creates _anon class
	    "Vernita Green" "O-Ren Ishii" ElleDriver Budd - DeadlyViper
	    ;;"Pai Mei" - Sensi
	    "Sofie Fatale" - Person
	    "Hattori Hanzo" - SwordSmith
	    Budds_HHS Bills_HHS New_HHS - HattoriHanzoSword
	    Bills_Gun - Handgun
	    Vernitas_Knife Beatrixs_Knife - Knife
	    NorthAmerica Asia - Continent
	    Texas California - StateOrProvince
	    Tokyo Okinawa - City
	    Japan Mexico USA - Country)
  ;; Note use of PDDL object-fluent construct (= (located foo) bar)
  ;;  AP allows you to use this or PDDL predicate [list] syntax
  (:init (geographicSubregionOf Mexico NorthAmerica)
	 (geographicSubregionOf USA NorthAmerica)
	 (geographicSubregionOf Texas USA)
	 (geographicSubregionOf California USA)
	 (geographicSubregionOf Japan Asia)
	 (geographicSubregionOf Tokyo Japan)
	 (geographicSubregionOf Okinawa Japan)
	 (distance Texas Mexico 50)
	 (distance Texas California 200)
	 (distance California Tokyo 3000)
	 (distance California Okinawa 3000)
	 (= (located Beatrix) Texas)
	 (possesses Beatrix Beatrixs_Knife)
	 (alive Bill)
	 (enemyOf Beatrix Bill)
	 (possesses Bill Bills_HHS)
	 (possesses Bill Bills_Gun)
	 (= (located Bill) Mexico)
	 (enemyOf Beatrix Budd)
	 (= (located Budd) Texas)
	 (possesses Budd Budds_HHS)
	 (enemyOf Beatrix VernitaGreen)
	 (= (located VernitaGreen) California)
	 (possesses VernitaGreen Handgun)
	 (possesses VernitaGreen Vernitas_Knife)
	 (enemyOf Beatrix ElleDriver)
	 (located ElleDriver Texas)
	 (enemyOf Beatrix O-RenIshii)
	 (located O-RenIshii Tokyo)
	 (enemyOf Beatrix SofieFatale)
	 (located SofieFatale Tokyo)
	 ;;(located PaiMei China)
	 (located HattoriHanzo Tokyo)))

;;;=== test problems ===

(define (problem "Acquire Firearm & Bullet")
    (:comment "someone exists from whom Beatrix can get Firearm")
  (:situation Yale)
  (:objects UNSUB - Person
	    B1 - Bullet
	    G1 - Firearm)
  (:init (possesses UNSUB B1)
	 (possesses UNSUB G1))
  (:deadline 30.0)			; test latest-startTime
  (:goal (kill Beatrix Bill)))

(define (problem "Kill Bill")
  (:situation Yale)
  ;;(:planner Beatrix)			; try counterplanning
  (:objects B3 - Bullet)
  (:init (possesses Beatrix Money))
  (:goal (kill Beatrix Bill))
  (:comment "should get same solution as Acquire Firearm & Bullet"))

(define (problem "Kill O-Ren")
    (:comment "Beatrix goes to Tokyo, gets sword from Hattori Honzo, kills O-Ren")
  (:situation Yale)
  (:goal (kill Beatrix O-RenIshii)))

;;;--- plan a negation ---

(define (problem "Test Negation Goal")
    (:comment "most efficient if Beatrix kills Bill")
  (:situation Yale)
  (:requirements :negative-preconditions :assumptions)
  (:init (located Beatrix Mexico))
  (:goal (not (alive Bill))))

(define (problem "Test Negation Goal 2")
    (:comment "Beatrix gets Budd's HHS, goes to Mexico")
  (:requirements :negative-preconditions)
  (:situation Yale)
  (:goal (not (alive Bill))))

;;;--- complex goals ---

(define (problem "First Kill Vernita")
    (:situation Yale)
  (:goal (kill Beatrix VernitaGreen))
  (:comment "step 1 of Series Test"))

(define (problem "Next Kill Budd")
    (:situation Yale)
  (:init (located Beatrix California))
  (:goal (kill Beatrix Budd))
  (:comment "step 2 of Series Test"))

(define (problem "Series Test")
    (:situation Yale)
  (:init (possesses VernitaGreen Vernitas_Knife)
	 (possesses Beatrix Beatrixs_Knife))
  (:goal (series
	  (kill Beatrix VernitaGreen)
	  (kill Beatrix Budd)))
  (:comment "Beatrix has to go to California, then back to Texas"))

(define (problem "Series Test 2")
    (:situation Yale)
  (:requirements :assumptions)
  (:goal (series
	  (kill Beatrix ElleDriver)
	  (kill Beatrix Budd)))
  (:comment "all three are in Texas"))

;;;--- plan recognition problems ---

(define (problem "Who Killed Bill?")
    (:comment "plan recognition where observation is effect of a HTN")
  (:requirements :negative-preconditions)
  (:situation Yale)
  (:observation (not (alive Bill))))

(define (problem "Exhibit Intent")
    (:comment "plan recognition where observation is effect of a leaf")
  (:situation Yale)
  (:requirements :assumptions)
  (:observation (aimGunAt Beatrix Bill)))

(define (problem "PR Conjunction Test")
    (:comment "deal with two observations")
  (:situation Yale)
  (:objects B4 - Bullet)
  (:init (located Beatrix Mexico)
	 (contains Bills_Gun B4))
  (:deadline 10.0)			; test in PR problem
  (:goal (kill Beatrix Bill))
  ;; StealWeapon matches but its direct-effects include
  ;;  (possesses Beatrix Bills_Gun), not possessed_by
  ;; But that effect is added to the "anchor" because
  ;;  it is the inverseOf possessed_by, hence the match
  ;; Nifty, eh?
  (:observation (and (possessed_by Bills_Gun Beatrix)
		     (aimGunAt Beatrix Bill))))

	      
