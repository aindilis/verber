(define (problem attack_tree_figure1)
 (:domain AttackTree)
 (:init (possible))
 (:goal (open_safe))
 )

(define (problem attack_tree_figure1)
 (:domain AttackTree)
 (:init
  (none)
  (= (cost) 0)
  )
 (:goal (open_safe))
 (:metric MINIMIZE (cost))
 )

(:functions
 (cost)
 (:requirements :TYPING :FLUENTS)
 )

(:predicates
 (possible)
 (impossible)
 (open_safe)
 (safe_combination)
 (safe_combination_from_target)
 (conversation_eavesdropped)
 (target_states_combo)
 )

(:action FindWrittenCombo
 (none)
 :precondition (none)
 (special_equipment)
 :effect (and
	  (open_safe)
	  (safe_combination)
	  (safe_combination)
	  (increase (cost) 75))
 (safe_combination_from_target)
 )

;; (conversation_eavesdropped)
;; (target_states_combo)

(:action IP_connect
 :parameters (?s - host ?t - host)
 :precondition (and (compromised ?s)
		(exists (?n - network)
		 (and (connected_to_network ?s ?n)
		  (connected_to_network ?t ?n))))
 :effect (IP_connectivity ?s ?t)
 )

(:action TCP_connect
 :parameters (?s - host ?t - host ?p - port)
 :precondition (and (compromised ?s)
		(IP_connectivity ?s ?t)
		(TCP_listen_port ?t ?p))
 :effect (TCP_connectivity ?s ?t ?p)
 )

(:action Mark_as_compromised
 :parameters (?a - agent ?h - host)
 :precondition (installed ?a ?h)
 :effect (compromised ?h)
 )

(:action HP_OpenView_Remote_Buffer_Overflow_Exploit
 :parameters (?s - host ?t - host)
 :precondition (and (compromised ?s)
		(and (has_OS ?t Windows)
		 (has_OS_edition ?t Professional)
		 (has_OS_servicepack ?t Sp2)
		 (has_OS_version ?t WinXp)
		 (has_architecture ?t I386))
		(has_service ?t ovtrcd)
		(TCP_connectivity ?s ?t port5053)
		)
 :effect(and (installed_agent ?t high_privileges)
	 (increase (time) 10)
	 ))

(:action HP_OpenView_Remote_Buffer_Overflow_Exploit
 :parameters (?s - host ?t - host)
 :precondition (and (compromised ?s)
		(and (has_OS ?t Solaris)
		 (has_OS_version ?t V_10)
		 (has_architecture ?t Sun4U))
		(has_service ?t ovtrcd)
		(TCP_connectivity ?s ?t port5053)
		)
 :effect(and (installed_agent ?t high_privileges)
	 (increase (time) 12)
	 ))

(:action PickLock
 :precondition (impossible)
 (:action UseLearnedCombo
  :effect (open_safe)
  :precondition (safe_combination)
  )
 :effect (open_safe)
 )

(:action Blackmail
 :precondition (impossible)
 (:action CutOpenSafe
  :effect (safe_combination_from_target)
  :precondition (possible)
  )
 :effect (open_safe)
 )

(:action Eavesdrop
 :precondition (and
		(:action InstallImproperly
		 (conversation_eavesdropped)
		 :precondition (impossible)
		 (target_states_combo)
		 :effect (open_safe)
		 )
		)
 :effect (safe_combination_from_target)
 )

(:action FindWrittenCombo
 :precondition (impossible)
 )

(:action Bribe
 :effect (safe_combination)
 :precondition (possible)
 :effect (safe_combination_from_target)
 )

(:action GetComboFromTarget
 :precondition
 (safe_combination_from_target)
 (:action ListenToConversation
  :precondition (possible)
  :effect (safe_combination)
  :effect (conversation_eavesdropped)
  )
 )

(:action Threaten
 (:action GetTargetToStateCombo
  :precondition (impossible)
  :precondition (impossible)
  :effect (safe_combination_from_target):effect (target_states_combo)
  )
 )

(:action GetComboFromTarget
 :precondition
 (safe_combination_from_target)
 (:action PickLock
  :effect (and
	   :precondition (special_equipment)
	   (safe_combination)
	   :effect (and
		    (increase (cost) 0))
	   (open_safe)
	   )
  (increase (cost) 30))
 )

(:action Threaten
 :precondition (none)
 (:action UseLearnedCombo
  :effect (and
	   :precondition (safe_combination)
	   (safe_combination_from_target)
	   :effect (open_safe)
	   (increase (cost) 60))
  )
 )

(:action CutOpenSafe
 (:action Blackmail
  :precondition (special_equipment)
  :precondition (none)
  :effect (and
	   :effect (and
		    (open_safe)
		    (safe_combination_from_target)
		    (increase (cost) 10))
	   (increase (cost) 100))
  )
 )

(:action InstallImproperly
 (:action Eavesdrop
  :precondition (none)
  :precondition (and
		 :effect (and
			  (conversation_eavesdropped)
			  (open_safe)
			  (increase (cost) 100))
		 )
  (target_states_combo))
 :effect (safe_combination_from_target)
 )

(:action Bribe
 (increase (cost) 20)
 (:precondition (none))
 (:effect (and
	   (safe_combination_from_target)
	   (:action GetTargetToStateCombo
	    (increase (cost) 20))
	   :precondition (none)
	   )
  )
 )

;; :effect (and
;; 	   (target_states_combo)
;; 	   (:action ListenToConversation
;; 	    (increase (cost) 40))
;; 	   :precondition (special_equipment)
;; 	   )
;; :effect (and
;; 	   )

(:action IBM_Tivoli_Storage_Manager_Client_Exploit
 :parameters (?s - host ?t - host)
 :precondition (and
		(compromised ?s)
		(and (has_OS ?t Windows)
		 (has_OS_edition ?t Professional)
		 (has_OS_servicepack ?t Sp2)
		 (has_OS_version ?t WinXp)
		 (has_architecture ?t I386))
		(has_service ?t mil-2045-47001)
		(TCP_connectivity ?s ?t port1581)
		)
 :effect(and
	 (installed_agent ?t high_privileges)
	 (increase (time) 4)
	 ))

