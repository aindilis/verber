(in-package :ap)

(define (domain PreAttack)
    (:extends ATTetCK org event)
  (:requirements :durative-actions :multi-agent :probabilistic-effects)
  (:types CorporateNetwork - Network
	  3rdPartyInfrastructure - Host
	  WebForum - Resource)
  (:predicates
   (selectTarget ?a - Agent)
   (hasTarget ?a ?target - Agent)
   (determineOperationalElement ?a - Agent)
   (determineTacticalElement ?a - Agent ?target - FormalOrganization)
   (determineSecondaryTacticalElement ?a - Agent ?target - FormalOrganization)

   (preparedToAttack ?a - Agent ?target - Organization)

   (performOPSEC ?a - Agent)
   (proxyEstablished ?a - Agent)
   (useAnonymity ?a - Agent)
   (acquire ?a - Agent ?o - Thing)
   
   (personaDevelopment ?a - Agent)
   (gatherInformation ?a - Agent ?o - Organization)
   (identifyBusinessRelationships ?a - Agent ?o - Organization)
   (obtainBrandingMaterials ?a - Agent ?o - Organization)
   (IDpeopleOfInterest ?a - Agent ?o - Organization)
   (IDgroups ?a - Agent ?o - Organization)
   (gatherOSINT ?a - Agent ?o - Organization)
   
   (identifyWeaknesses ?a - Agent ?target - Organization)
   (assessSecurityPosture ?a - Agent ?target - Organization)
   
   (acquireInfrastructure ?a - Agent)
   (stageCapabilities ?a - Agent ?h - Host)
   (install ?a - Agent ?d - DigitizedInformationBearingEntity ?h - Host)
   (testCapabilities ?a - Agent ?h - Host)
   (test ?a - Agent ?p - Program)

   (compromiseTarget ?a - Agent)
   )
  )

(define (action attack-target)
    :parameters (?a - Agent)
    :vars (?target - OrganizationalUnit)
    :expansion (series 
		(link (selectTarget ?a) :output ?target)
		(preparedToAttack ?a ?target)
		(attack ?a ?target))
    :effect (compromiseTarget ?a))

;;;== 1. Target Selection ==

(define (action Target_Selection)
    :parameters (?a - Agent)
    :vars (?org - BusinessEntity
	   ?division - OrganizationalUnit)
    :value ?division
    :expansion (series
		(link (determineOperationalElement ?a) :output ?org)
		(link (determineTacticalElement ?a ?org) :output ?division)
		(determineSecondaryTacticalElement ?a ?division))
    :effect (selectTarget ?a))

(define (action Determine_operational_element)
    :parameters (?a - Agent)
    :vars (?org - FormalOrganization)
    :value ?org
    :effect (and (determineOperationalElement ?a)
		 (hasTarget ?a ?org))
    :probability 0.99
    :duration 5.0
    :comment "e.g., company, agency. Not typically detectable")

(define (action Determine_tactical_element)
    :parameters (?a - Agent
		 ?org - FormalOrganization)
    :vars (?division - OrganizationalUnit)
    :value ?division
    :precondition (and (hasTarget ?a ?org)
		       (hasUnit ?org ?division))
    :effect (and (determineTacticalElement ?a ?org)
		 (hasTarget ?a ?division))
    :probability 0.95
    :duration 5.0
    :comment "division or corporate network")

(define (action Determine_secondary_tactical_element)
    :parameters (?a - Agent
		 ?division - OrganizationalUnit)
    :precondition (hasTarget ?a ?division)
    :effect (determineSecondaryTacticalElement ?a ?division)
    :probability 0.9
    :duration 5.0
    :comment "specific network and area of network most vulnerable to attack")

;;;=== 2. Pre-attack ===

(define (action prepare-to-attack)
    :parameters (?a - Agent
		 ?target - Organization)
    :vars (?host - Host)
    :precondition (hasTarget ?a ?target)
    :expansion (series
		(link (acquireInfrastructure ?a) :output ?host)
		(performOPSEC ?a)
		(personaDevelopment ?a)
		(parallel
		 (series
		  (gatherInformation ?a ?target)
		  (identifyWeaknesses ?a ?target))
		 (series
		  (stageCapabilities ?a ?host)
		  (testCapabilities ?a ?host))))
    :effect (preparedToAttack ?a ?target)
    :probability 0.8)

;;;--- 2.1 OPSEC ---

(define (action Adversary_OPSEC)
    :parameters (?a - Agent)
    :precondition (acquireInfrastructure ?a)
    :effect (and (performOPSEC ?a)
		 (proxyEstablished ?a)
		 (useAnonymity ?a))
    :probability 0.9
    :comment "Use technologies or 3rd party to obfusticate")

;;;--- Persona Development --

(define (action Persona_Development)
    :parameters (?a - Agent)
    :vars (?f - WebForum)
    :expansion (memberOf ?a ?f)
    :effect (personaDevelopment ?a)
    :probability 0.95)

;;;--- 2.2 Information gathering ---
#|
Case 1:
 
Create Facebook page
Register at 1 forum and 1 portal (target)
Previously posted to another forum on the same site
Ping IP related to target
Using translation service from personal account
Vulnerability scan 3 days certain IP net blocks
Saved 2 related to target
Conducted OSINT on seemingly unrelated target
Download 100s of email addresses from OSINT (included target addresses)
Create email address (account?)
Register for new forum
Send spearphish emails based on OSINT
 
Case 2:
 
Log in to spearphish account (i.e., later used for spearphishing)
Send test message (empty of content) to previously used spearphish account
OSINT on theme
RDP to 2 hop points
Transfer 3 malicious files
Send malicious files as email attachment to target
|#
 
(define (action Gather_target_info)
    :parameters (?a - Agent
		 ?t - Organization)
    :precondition (hasTarget ?a ?t)
    :expansion (parallel
		(IDpeopleOfInterest ?a ?t)
		(gatherOSINT ?a ?t))
    :effect (gatherInformation ?a ?t))

(define (action ID_People_of_interest)
    :parameters (?a - Agent
		 ?t - Organization)
    :vars (?f - WebForum
	   ?m - Person)
    :precondition (and (hasTarget ?a ?t)
		       (memberOf ?m ?t)
		       (memberOf ?m ?f)
		       (not (= ?m ?a)))
    :expansion (memberOf ?a ?f)
    :effect (and (probabilistic 0.9 (IDpeopleOfInterest ?a ?t))
		 (probabilistic 0.8 (IDgroups ?a ?t))))

(define (action Gather_OSINT)
    :parameters (?a - Agent
		    ?t - Organization)
    :precondition (hasTarget ?a ?t)
    :effect (and (gatherOSINT ?a ?t)
		 (identifyBusinessRelationships ?a ?t)
		 (obtainBrandingMaterials ?a ?t))
    :probability 0.9)

(define (action Identify_weaknesses)
    :parameters (?a - Agent
		    ?t - Organization)
    :precondition (gatherInformation ?a ?t)
    ;;:expansion (scanFor ?t Vulnerability)
    :effect (and (identifyWeaknesses ?a ?t)
		 (assessSecurityPosture ?a ?t))
    :probability 0.9)

;;;--- 2.3 Acquire Infrastructure ---

(define (action Acquire_infrastructure)
    :parameters (?a - Agent)
    :vars (?h - 3rdPartyInfrastructure)
    :value ?h
    :expansion (compromised ?a ?h)
    :effect (and (acquireInfrastructure ?a)
		 (hasAccessTo ?a ?h))
    :probability 0.7)

(define (action Acquire_Cloud_Services)
    :parameters (?a - Agent)
    :vars (?s - CloudService)
    :value ?s
    :expansion (memberOf ?a ?s)
    :effect (and (acquireInfrastructure ?a)
		 (hasAccessTo ?a ?s))
    :probability 0.9)

;;;--- 2.4 Stage ---

(define (action Stage_capabilities)
    :parameters (?a - Agent
		    ?h - Host)
    :precondition (hasAccessTo ?a ?h)
    :expansion (install ?a Malware ?h)
 #|   :expansion (series
		(install ?a Server ?h)
		(install ?a PortRedirector ?h))|#
    :effect (stageCapabilities ?a ?h)
    :probability 0.99)

(define (action Install_malware)
    :parameters (?a - Agent
		    ?h - Host)
    :vars (;;?p - NetworkProtocol
	   ?m - Malware)
    :precondition (hasAccessTo ?a ?h)
    :expansion (transmitted ?a ?h RDP ?m)
    :effect (install ?a Malware ?h)
    :probability 0.99)

#|
Log in to spearphish account (i.e., later used for spearphishing)
Send test message (empty of content) to previously used spearphish account
|#

(define (action Test_capabilities)
    :parameters (?a - Agent
                 ?h - Host)
    :precondition (and (hasAccessTo ?a ?h)
		       (stageCapabilities ?a ?h))
  #|  :expansion (series
		(hasShell ?a Host OnlineAccount)
		(transmitted EmailAccount EmailAccount SMTP noContent)
		)|#
    :effect (testCapabilities ?a ?host)
    :probability 0.9)

;;;== 3. Attack ===

(define (action Email_phishing)
    :parameters (?a ?target - Agent)
    :precondition (and (testCapabilities ?a)
		       (IDpeopleOfInterest ?a ?target))
   ;; :expansion (transmitted ?a ?target PPTP PhishingEmail) 
    :effect (attack ?a ?target)
    :comment "attempt to penetrate target"
    :probability 0.8)

;;;;;;;;;;;; test problems ;;;;;;;;;;;;;;;

(define (situation Test_sit)
    (:objects Unit_61398 - Agent
	      GeneralAtomics - BusinessEntity
	      GA_R&D - OrganizationalUnit)
  (:init (hasUnit GeneralAtomics GA_R&D)))

(define (problem Test_select_target_sit)
    (:situation Test_sit)
  (:goal (selectTarget Unit_61398)))

(define (problem Test_Acquire_infrastruture)
    (:situation Test_sit)
  (:requirements :assumptions)		; to assume 3rdPartyInfrastructure
  (:goal (acquireInfrastructure Unit_61398)))

(define (problem Test_Install_malware)
     (:requirements :multi-agent)
  (:situation Test_sit)
  (:objects myHost - Host)
  (:init (hasAccessTo Unit_61398 myHost))
  (:goal (install Unit_61398 Malware myHost)))

(define (problem Test_Identify_Weaknesses)
    (:requirements :assumptions)
  (:situation Test_sit)
  (:observation
   (identifyWeaknesses Unit_61398 GA_R&D)))

(define (problem Test_Prepare_sit)
    (:requirements :assumptions)
  (:situation Test_sit)
  (:init (hasTarget Unit_61398 GA_R&D))
  (:goal (preparedToAttack Unit_61398 GA_R&D)))

(define (problem Test_compromise_sit)
    (:requirements :assumptions)
  (:situation Test_sit)
  (:goal (compromiseTarget Unit_61398)))

;;;---- generic observatons ---

(define (problem "observe Upload Malware")
    (:requirements :assumptions)
  (:observation (transmitted Agent Host RDP Gh0stRAT)))


(define (problem "Identify Weaknesses")
    (:requirements :assumptions)
  (:observation (identifyWeaknesses Agent BusinessEntity)))
