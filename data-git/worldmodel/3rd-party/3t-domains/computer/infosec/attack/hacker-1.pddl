(in-package :ap)
;;; CAPA domain definition

(define (domain hacker)
    (:extends computer)

  (:types
	  malware - software
	  malware-cat - string)

  (:constants ;; malware categories:
	      EXECUTABLE_ASP		; DBS:	     from ATTACK spreadsheet
	      EXECUTABLE_ASPX		; DBS:	     from ATTACK spreadsheet
	      EXECUTABLE_PHP		; DBS:	     from ATTACK spreadsheet
	      EXECUTABLE_CFM		; DBS:	     from ATTACK spreadsheet
	      EXECUTABLE_JSP		; DBS:	     from ATTACK spreadsheet
	      EXECUTABLE_HTML		; DBS:	     web page w/ malicious code
	      EXECUTABLE_PDF		; DBS:	     PDF with malicious code
	      GOGGLES			; Mandiant:  malware downloader
	      COMBOS			; Mandiant:  backdoor
	      STARSYPOUND		; Mandiant:  remote shell
	      ACCT_PWD_HARVESTER	; DBS:       UID & pwd harvester
	      PWD_CRACKER		; DBS:	     password file cracker
	      SHARE_HACK		; RLP:       shared folder hack
	      INFECTED_DLL		; RLP:       used in dll proxying
	      BACKDOOR			; RLP	    
		      - malware-cat	; add more as needed


	      )

  (:predicates	;--facts persist, everything else is non-monotonic (fluent)

   (hasObjectives ?hacker - Agent
   		  ?tgt - host)

   (tricksTarget ?phishMsg - content)

   (malware-category ?category - malware-cat
		     ?malware - malware)

   (malware-remote-Uid-host ?malware - malware
			    ?remoteUid - account
			    ?remoteHost - host)

   (malware-remote-Url ?malware - malware
		       ?urlhost - host
		       ?urldir - directory
		       ?urlfile - malware)

   (malware-installs-malware ?malware - malware
   			     ?secondary - malware)

   ;; indicates completion of higher-level action:
   (exploitDelivered ?exploit - malware
		     ?tgtUid - account
   		     ?tgtHost - host)

   (exploitInstalled ?exploit - malware
   		     ?uid - account
		     ?host - host)

   (outboundRequest ?fromUid - account
   		    ?srcHost - host
   		    ?destHost - host)

   (inboundResponse ?toUid - account
		    ?destHost - host
   		    ?srcHost - host
		    ?contents - file)

   (pwdFileCracked ?hacker - user
		   ?pwdFile - document)

   ;; indicates completion of higher-level action:
   (lateralMovement ?user - Agent
		    ?host1 ?host2 - host)

   (hasPersistence ?attacker - user
		   ?host - host)


   ;; added by Rich

   (hasDLLproxy ?host - host
   		?proxyDLL - file
		?originalDLL - file
		?movedDLL - file)
  )

  (:axiom
   :vars (?hacker - user
	  ?pwdFile - document
	  ?tHost - host
	  ?uid1 - account
	  ?pwd1 - password
	  )
   :context (and (pwdFileCracked ?hacker ?pwdFile)
		 (containsUserPasswords ?pwdFile ?tHost)
		 (containsUidPwd ?pwdFile ?uid1 ?pwd1))
   :implies (knowsPassword ?hacker ?tHost ?uid1)
   :documentation "once you crack a pwdFile, you know the user pwds for
   that host")
 ) ; end domain

  ;; new:

;;; content from new e-mail version included above but not yet below -dbs

  ;; adapted from cna.pddl:
  ;; this should really be expanded
(define (action "Recon for Spearphish Attack")
    :parameters (?hacker - user
		 ?tgtUid - account
                 ?tgtHost - host)
    :vars (?tgtUser - user)
    :precondition (and (hasObjectives ?hacker ?tgtHost)
		       (hasShell ?tgtUser ?tgtHost ?tgtUid))
    :effect (knowsHostUid ?hacker ?tgtUid ?tgtHost)
    :comment "research, identify, and select targets")

(define (action "Lateral movement via rLogin using common password")
    :parameters (?hacker - user
		 ?host1 ?host2 - host)
    :vars (?uid1 ?uid2 - account)
    :precondition (and (hasShell ?hacker ?host1 ?uid1))
    :expansion (series
		;; If axiom generated this, wouldn't need this step... but
		;; since we need an action to generate this, we do:
		(knowsPassword ?hacker ?host2 ?uid2)
		(hasShell ?hacker ?host2 ?uid2))
    :effect (lateralMovement ?hacker ?host1 ?host2))


(define (action "Deliver via Spearphish Attachment")
    :parameters (?exploit - malware
		 ?tgtUid - account
		 ?tgtHost - host
		 )
    :vars (?hacker - user
	   ?hackerHost - host
	   ?hackerUid - (hasShell ?hacker ?hackerHost) ; account
	   ?hackerDir - directory
	   ?tgtDir - directory
	   ?phishText - content
	   ?phishAttach - (malware-category EXECUTABLE_PDF) ; malware
	   )
    :precondition
        (and (tricksTarget ?phishText)
	     (hasFile ?hackerHost ?hackerDir ?phishAttach)
	     (malware-category EXECUTABLE_PDF ?phishAttach)
	     (malware-installs-malware ?phishAttach ?exploit)
	     )
    :expansion
        (series
	 (transmitted ?hackerUid ?hackerHost ?tgtUid ?tgtHost ?phishAttach)
	 (transmitted ?hackerUid ?hackerHost ?tgtUid ?tgtHost ?phishText)
	 (hasFile ?tgtHost ?tgtDir ?phishAttach))
    :effect
        (exploitDelivered ?exploit ?tgtUid ?tgtHost))

; need to resolve issue described below!:
(define (action "Deliver via Spearphish Weblink")
    :parameters (?exploit - malware
		 ?tgtUid - account
		 ?tgtHost - host
		 )
    :vars (?hacker - user
	   ?hackerHost - host
	   ?hackerUid - (hasShell ?hacker ?hackerHost) ; account
	   ?hackerDir - directory
	   ?tgtDir - directory
	   ?phishText - content
	   ?fileAtUrl - (malware-category EXECUTABLE_HTML) ; malware
	   )
    :precondition
        (and (tricksTarget ?phishText)
	     ; Two problems:
	     ;  1 Fails to distinguish between file and filename!  Should
	     ;    fix but good enough for now?
	     ;  2 URL is defined implicitly, not explicitly as a class!
	     ;    Need to expand concept of URL similarly to e-mail:
	     ;      URL is a subtype of object (or content or whatever)
	     ;      special predicates pertain only to URLs & define the
	     ;      URL, e.g.:
	     ;        (urlHostname ?url - url ?host - host)
	     ;        (urlPath ?url - url ?path - path)
	     ;        (urlFileName ?url - url ?fileName - filename)
	     (containsUrl ?phishText ?hackerHost ?hackerDir ?fileAtUrl)
	     (hasFile ?hackerHost ?hackerDir ?fileAtUrl)
	     (malware-category EXECUTABLE_HTML ?fileAtUrl)
	     (malware-installs-malware ?fileAtUrl ?exploit)
	     )
    :expansion
        (series
	 ;; ### 1:
	 ;; PROBLEM:  Uses SendEmailWithAttachment instead of the
	 ;; simpler SendEmailNoAttachment!
	 (transmitted ?hackerUid ?hackerHost ?tgtUid ?tgtHost ?phishText)
	 (visitsUrl ?tgtUid ?tgtHost ?hackerHost ?hackerDir ?fileAtUrl)
	 )
    :effect (exploitDelivered ?exploit ?tgtUid ?tgtHost))


;;; OF COURSE this isn't the only way for the clicker to "have" or know the
;;; URL - it could come from visiting a web-page, having it bookmarked, etc.
(define (action WebsiteInstallsExploit)
      :parameters (?exploit - malware
		   ?clickerUid - account
		   ?clickerHost - host
		   )
      :vars (?clicker - user
	     ?gid - group
	     ?dir - (hasAccount ?clicker
				?clickerHost
				?clickerUid
				?gid) ; directory
	     ?urlHost - host
	     ?urlDir - directory
	     ?urlFile - (malware-category EXECUTABLE_HTML)
	     )
      ;;; ### ADD PRECONDITION FOR USER VISITING THE WEBSITE!
      ;;; ### IN GENERAL, KEEP MAKING PLAN MORE HIERARCHICAL
      :precondition (and (hasFile ?urlHost ?urlDir ?urlFile)
			 (malware-category EXECUTABLE_HTML ?urlFile)
			 (malware-installs-malware ?urlFile ?exploit)
			 (visitsUrl ?clickerUid
				    ?clickerHost
				    ?urlHost
				    ?urlDir
				    ?urlFile))
      :effect (exploitInstalled ?exploit ?clickerUid ?clickerHost))

;;; Note that SaveMaliciousAttachment differs from a generic SaveAttachment
;;; in that it requires a message to have been sent that tricks the
;;; target (recipient) (and the attachment is malware!).
(define (action SaveMaliciousAttachment)
      :parameters (?tHost - host
		   ?rDir - directory
      		   ?attach - malware)
      :vars (?fUid - account
             ?fHost - host
	     ?tUid - account
	     ?recip - user
	     ?rGid - group
	     ?message - (tricksTarget) ; content
	     )
      :precondition (and (transmitted ?fUid ?fHost ?tUid ?tHost ?attach)
			 (transmitted ?fUid ?fHost ?tUid ?tHost ?message)
			 (tricksTarget ?message)
      			 (hasAccount ?recip ?tHost ?tUid ?rGid ?rDir))
      :effect (hasFile ?tHost ?rDir ?attach))

(define (action OpenMaliciousFile) ; effect depends on type of file
      :parameters (?exploit - malware
      		   ?uid - account
		   ?h - host)
      :vars (?u - user
	     ?gid - group
	     ?dir - (hasAccount ?u ?h ?uid ?gid) ; directory
	     ;; Obviously, could also be other categories
	     ;; besides pdf.  But we don't have an object
	     ;; hierarchy when it comes to constants used
	     ;; for malware categories.  Hmmm....
	     ?f - (malware-category EXECUTABLE_PDF)
	     ; ?f - (hasFile ?h ?dir)
	     )
      :precondition (and (hasFile ?h ?dir ?f)
			 (malware-category EXECUTABLE_PDF ?f)
			 (malware-installs-malware ?f ?exploit))
      :effect (and (exploitInstalled ?exploit ?uid ?h)
		   (executed ?exploit ?uid ?h ?dir)		; side effect
		   ))

;;; Note that ClickMaliciousUrl differs from a generic ClickUrl in that it
;;; requires a message to have been sent that tricks the target (clicker)
;;; (and the urlFile is malware!)
;;;
;;; OF COURSE this isn't the only way for the clicker to "have" or know the
;;; URL - it could come from visiting a web-page, having it bookmarked, etc.
(define (action ClickMaliciousUrl)
      :parameters (?clickerUid - account
		   ?clickerHost - host
      		   ?urlHost - host
		   ?urlDir - directory
		   ?urlFile - malware
		   )
      :vars (?senderUid - account
	     ?urlText - (tricksTarget) ; content
	     )
      :precondition (and (transmitted ?senderUid
				      ?urlHost
				      ?clickerUid
				      ?clickerHost
				      ?urlText)
			 (tricksTarget ?urlText)
			 (containsUrl ?urlText
			 	      ?urlHost
				      ?urlDir
				      ?urlFile))
      :effect (visitsUrl ?clickerUid ?clickerHost ?urlHost ?urlDir ?urlFile))

(define (action GogglesBeacon)
      :parameters (?tgtUid - account
                   ?tgtHost - host
		   ?malwareRepository - host
		   )
      :vars (?exploit - malware
	     ?malwareDir - segment
	     ?malware - malware
	     )
      :precondition (and (malware-category GOGGLES ?exploit)
			 (exploitInstalled ?exploit ?tgtUid ?tgtHost)
			 (malware-remote-Url ?exploit
					     ?malwareRepository
					     ?malwareDir
					     ?malware))
      ;; This still needs fixin'!  See above re generalizing
      ;; outboundRequest/Response
      :effect (outboundRequest ?tgtUid ?tgtHost ?malwareRepository))

;;; ### separate into two actions?!  Have one action with a goal of
;;; installing the exploit, with a sequence that entails beacon, inbound
;;; response, and install exploits
(define (action MalwareResponse)
      :parameters (?tgtUid - account
		   ?tgtHost - host
		   ?malwareRepository - host
		   ?malware - malware
		   )
      :vars (?malwareDir - directory
	     )
      :precondition (and (outboundRequest ?tgtUid ?tgtHost ?malwareRepository)
			 (hasFile ?malwareRepository ?malwareDir ?malware))
      :effect (and (inboundResponse ?tgtUid ?tgtHost ?malwareRepository ?malware)
		   (exploitInstalled ?malware ?tgtUid ?tgtHost)))

(define (action DumpPwdFile)
      :parameters (?tUid - account
		   ?tHost - host
		   ?aUid - account
		   ?aHost - host
		   ?tPwdFile - document
		   )
      :vars (
	     ; ?bdMalware - malware
	     ; ?remAdmMalware - malware
	     ?pwdHarvester - malware
	     ; following vars only needed to define directories:
	     ?target - user
	     ?tGid - group
	     ?tDir - (hasAccount ?target ?tHost ?tUid ?tGid)
	     ?hacker - user
	     ?aGid - group
	     ?aDir - (hasAccount ?hacker ?aHost ?aUid ?aGid)
	     )
      :precondition (and
			 ; (malware-category COMBOS ?bdMalware)
			 ; (malware-category STARSYPOUND ?remAdmMalware)
			 (malware-category ACCT_PWD_HARVESTER ?pwdHarvester)
			 (containsUserPasswords ?tPwdFile ?tHost)
			 (malware-remote-Uid-host ?pwdHarvester
						  ?aUid
						  ?aHost)
			 ;; ### 2:
			 ;; Don't need all 3 as preconditions; should
			 ;; presumably implement multiple actions, one
			 ;; for each of the three kinds of malware that
			 ;; were installed.  But for now i don't need
			 ;; the hacker to use the other exploits to
			 ;; complete the Mr. Wu attack!
      			 ;(exploitInstalled ?bdMalware ?tUid ?tHost)
			 ;(exploitInstalled ?remAdmMalware ?tUid ?tHost)
			 (exploitInstalled ?pwdHarvester ?tUid ?tHost))
      :effect (and (executed ?pwdHarvester ?tUid ?tHost ?tDir)	; side effect
		   (transmitted ?tUid ?tHost ?aUid ?aHost ?tPwdFile)
		   ;; This has to be included explicitly, because unlike
		   ;; e-mail transmit, the file doesn't have to be
		   ;; saved explicitly by the recipient, in order for
		   ;; the destination host to have the file.
		   (hasFile ?aHost ?aDir ?tPwdFile)))

(define (action CrackPwdFile)
      :parameters (?hacker - user
		   ?pwdFile - document
		   ?crackTool - malware
		   ?aHost - host
		   ?aUid - account
		   ?aDir - directory)
      :vars (?tHost - host
	     ?aGid - group)
      :precondition (and (hasAccount ?hacker ?aHost ?aUid ?aGid ?aDir)
			 (hasFile ?aHost ?aDir ?pwdFile)
			 (containsUserPasswords ?pwdFile ?tHost)
			 (hasFile ?aHost ?aDir ?crackTool)
			 (malware-category PWD_CRACKER ?crackTool))
      :effect (and (executed ?crackTool ?aUid ?aHost ?aDir)
		   (pwdFileCracked ?hacker ?pwdFile)))

;;;### NOTE:  very unsatisfactory... doesn't require the user to possess
;;; or crack the second pwdFile!  In other words, the user will know the
;;; common uids and passwords, but will not KNOW that he knows them!
;;; So an attempted rLogin using the newly discovered uid and pwd will
;;; work, but the user has no way of knowing in advance whether or not
;;; it will work.  This must be fixed in conjunction with implementing
;;; the hacker *TRYING* to rLogin, sometimes failing, and sometimes
;;; succeeding.
(define (action discoverCommonUidPwds)
     :parameters (?aUser - user
		  ?host2 - host
		  ?commonUid - account)
     :vars (?pwdFile1 ?pwdFile2 - document
	    ?host1 - host
	    ?commonPwd - password)
     :precondition (and (containsUserPasswords ?pwdFile1 ?host1)
			(containsUserPasswords ?pwdFile2 ?host2)
			(containsUidPwd ?pwdFile1 ?commonUid ?commonPwd)
			(containsUidPwd ?pwdFile2 ?commonUid ?commonPwd)
			(knowsPassword ?aUser ?host1 ?commonUid))
     :effect (knowsPassword ?aUser ?host2 ?commonUid))


;;; SITUATIONS AND PROBLEMS:

(define (problem "lateral test")
    (:domain hacker)
  (:objects hacker bob - user
	    hackerUid bobsUid fredsUid joesUid - account
	    www-malware-com - host
            MM123-computer MM125-computer - host
	    MM123-computer-pwdFile MM125-computer-pwdFile - document
	    bobsMM123Pwd fredsCommonPwd joesMM123Pwd - password
	    bobsMM125Pwd joesMM125Pwd - password
	    users - group
	    bobsHomeDir malwareDir - directory
	    corp-net - network
	    )
  (:init
    (connected www-malware-com THE_INTERNET)
    (connected MM123-computer THE_INTERNET)

    (connected MM123-computer corp-net)
    (connected MM125-computer corp-net)

    (containsUserPasswords MM123-computer-pwdFile MM123-computer)
    (containsUidPwd MM123-computer-pwdFile bobsUid bobsMM123Pwd)
    (containsUidPwd MM123-computer-pwdFile fredsUid fredsCommonPwd)
    (containsUidPwd MM123-computer-pwdFile joesUid joesMM123Pwd)

    (containsUserPasswords MM125-computer-pwdFile MM125-computer)
    (containsUidPwd MM125-computer-pwdFile bobsUid bobsMM125Pwd)
    (containsUidPwd MM125-computer-pwdFile fredsUid fredsCommonPwd)
    (containsUidPwd MM125-computer-pwdFile joesUid joesMM125Pwd)

    (pwdFileCracked hacker MM123-computer-pwdFile)
    (hasShell hacker MM123-computer hackerUid)
  )
  (:goal (knowsPassword hacker MM125-computer fredsUid)))


(define (problem "rLogin test")
    (:domain hacker)
  (:objects hacker bob - user
	    hackerUid bobsUid fredsUid joesUid - account
	    bobsMM123Pwd fredsMM123Pwd joesMM123Pwd - password
	    users - group
	    bobsHomeDir malwareDir - directory
            MM123-computer MM125-computer - host
	    www-malware-com - host
	    MM123-computer-pwdFile - document
	    corp-net - network
	    rLoginProg - software
	    )
  (:init 
    (hasAccount hacker www-malware-com hackerUid users malwareDir)
    (hasAccount bob MM123-computer bobsUid users bobsHomeDir)

    (connected www-malware-com THE_INTERNET)
    (connected MM123-computer THE_INTERNET)

    (containsUserPasswords MM123-computer-pwdFile MM123-computer)
    (containsUidPwd MM123-computer-pwdFile bobsUid bobsMM123Pwd)
    (containsUidPwd MM123-computer-pwdFile fredsUid fredsMM123Pwd)
    (containsUidPwd MM123-computer-pwdFile joesUid joesMM123Pwd)

    (hasShell hacker www-malware-com hackerUid)

    ;; Not needed yet:
    ;(connected MM123-computer corp-net)
    ;(connected MM125-computer corp-net)

    (pwdFileCracked hacker MM123-computer-pwdFile)

    ;; Axiom asserts this from pwdFileCracked, containsUserPasswords,
    ;; and containsUidPwd:
    ;(knowsPassword hacker MM123-computer bobsUid)

    (software-category RLOGIN rLoginProg)
   )
  (:goal (hasShell hacker MM123-computer bobsUid)))
