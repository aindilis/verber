;;;; CNA = Computer Network Attack

(in-package :ap)

(define (domain cna)
    (:comment "Computer Network Attack: intrusion kill chain")
  (:extends physob)
  (:prefix "cna")
  (:uri)
  (:types
   Host Software - object
   "Advanced Persistent Threat" - Agent)
  (:constants
   ;;Attacker - AdvancedPersistentThreat
   ;;Victim - Host
   Malware - Software
   )
  (:predicates
   (hasObjectives ?a - Agent ?target - object)
   (objectivesAchieved ?a - Agent ?target - object)
   (targetSelected ?a - Agent ?target - object)
   (hasDeliverablePayload ?a - Agent ?target - object)
   (weaponDelivered ?a - Agent ?target - object)
   (exploitTriggered ?a - Agent ?target - object)
   (backdoorInstalled ?a - Agent ?target - object)
   (controlEstablished ?a - Agent ?target - object)
   (actionsTaken ?a - Agent ?target - object)
   (knowsIPAddress ?a - Agent ?h - Host)
   (installedOn ?s - Software ?h - Host)
   (activatedOn ?s - Software ?h - Host)
   (runningOn ?s - Software ?h - Host)
   ;; some bogus predicates for example
   (able ?h - Host)
   (baker ?h - Host)
   (charlie ?h - Host)
   (dog ?h - Host)
   (easy ?h - Host)
   (fox ?h - Host))
  (:init)
  (:defaults)
  )

(define (action "Intrusion Kill Chain")
    :parameters (?apt - AdvancedPersistentThreat
                 ?target - Host)
    :precondition (hasObjectives ?apt ?target)
    :expansion (series
                (targetSelected ?apt ?target)
                (hasDeliverablePayload ?apt ?target)
                (weaponDelivered ?apt ?target)
                (exploitTriggered ?apt ?target)
                (backdoorInstalled ?apt ?target)
                (controlEstablished ?apt ?target)
                (actionsTaken ?apt ?target))
    :effect (objectivesAchieved ?apt ?target)
    :comment "target and engage adversary for desired effects")

(define (action Reconnaissance)
    :parameters (?apt - AdvancedPersistentThreat
                 ?target - Host)
    :effect (targetSelected ?apt ?target)
    :comment "research, identify, and select targets")

(define (action Weaponization)
    :parameters (?apt - AdvancedPersistentThreat
                 ?target - Host)
    :precondition (targetSelected ?apt ?target)
    :effect (hasDeliverablePayload ?apt ?target)
    :comment "couple remote access trojan or backdoor with exploit into
    deliverable payload")

(define (action Delivery)
    :parameters (?apt - AdvancedPersistentThreat
                 ?target - Host
                 ?sw - Software)
    :precondition (hasDeliverablePayload ?apt ?target)
    :effect (weaponDelivered ?apt ?target)
    :expansion (runningOn ?sw ?target)
    :comment "transmit the weapon to the target")

(define (action Exploitation)
    :parameters (?apt - AdvancedPersistentThreat
                 ?target - Host)
    :precondition (and (weaponDelivered ?apt ?target)
                       (able ?target))
    :effect (and (exploitTriggered ?apt ?target)
                 (charlie ?target))
    :comment "trigger intruder's code")

(define (action Installation)
    :parameters (?apt - AdvancedPersistentThreat
                 ?target - Host)
    :precondition (exploitTriggered ?apt ?target)
    :effect (backdoorInstalled ?apt ?target)
    :comment "install the trojan or backdoor on the victim")

(define (action "Command and Control")
    :parameters (?apt - AdvancedPersistentThreat
                 ?target - Host)
    :precondition (and (backdoorInstalled ?apt ?target)
                       (charlie ?target))
    :effect (controlEstablished ?apt ?target)
    :comment "establish intruder hands on keyboard access to victim")

(define (action "Actions on Objectives")
    :parameters (?apt - AdvancedPersistentThreat
                 ?target - Host)
    :precondition (and (controlEstablished ?apt ?target)
                       (baker ?target))
    :effect (actionsTaken ?apt ?target)
    :comment "take actions to achieve objectives, often exfilling data")

(define (action "Install and Run Software")
    :subClassOf Delivery
    :parameters (?user - Agent
                 ?sw - Software
                 ?h - Host)
    :precondition (and (possesses ?user ?sw)
                       (knowsIPAddress ?user ?h))
    :expansion (series 
                (installedOn ?sw ?h) 
                (activatedOn ?sw ?h))
    :effect (and (runningOn ?sw ?h)
                 (dog ?h)))

(define (action Download)
    :parameters (?user - Agent
                 ?sw - Software
                 ?h - Host)
    :precondition (possesses ?user ?sw)
    :effect (and (installedOn ?sw ?h)
                 (able ?h)
                 (baker ?h)))

(define (action Execute)
    :parameters (?sw - Software
                 ?h - Host)
    :precondition (installedOn ?sw ?h)
    :effect (activatedOn ?sw ?h))

(define (situation background)
    (:domain cna)
  (:objects Attacker - AdvancedPersistentThreat
            Victim - Host)
  (:init
   (hasObjectives Attacker Victim)
   (possesses Attacker Malware)
   (knowsIPAddress Attacker Victim)))

(define (problem attack)
    (:domain cna)
  (:situation background)
  (:goal (objectivesAchieved Attacker Victim)))

(define (problem "Install Malware")
    (:domain cna)
  (:situation background)
  (:goal (runningOn Malware Victim)))

