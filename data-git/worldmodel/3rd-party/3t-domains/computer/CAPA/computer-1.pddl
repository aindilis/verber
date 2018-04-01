(in-package :ap)
;;; CAPA domain definition
;;;
;;; Parts adapted from:
;;;     computer.pddl
;;;	internet.pddl
;;;
;;; Initially tailored to Mr Wu's Surprise attack

(define (domain computer)
    (:requirements :domain-axioms) ;; :true-negation)	; :equality doesn't work
  (:types 
  	  ;; adapted from 'computer.pddl':
  	  string service segment - object 
	  host network - object
	  user - Agent
	  file directory link - segment
	  ;; adapted from 'internet.pddl':
	  content website - object
	  URL text email - content
	  operating-system password - string ; a uid is really just a string w/ semantics
	  ;; new:
	  software document - file
	  protocol software-cat - string
	  privilege - object
	  account group - privilege
  	  permission - object
	  device - object
	  thumbDrive - device
	  encryption-method - string
	  fileName - string

	  )

  (:constants THE_INTERNET
	      	      - network
	      ;; These categories define what a particular program does.
	      ;; Needless to say, this list will need to be expanded.
	      ;; Very likely, this entire construct will need to be enhanced.
	      RLOGIN - software-cat
	      ADMIN SUPERUSER - group
	      WRITE READ EXECUTE - permission
	      UNIX WINDOWS - operating-system
	      ImagePath PATH - string ;; registry key and env var names
	      mv - software
	      HTTP HTTPS - protocol
	      BASE64 JPEG - encryption-method
	      )

  (:predicates	;--facts persist, everything else is non-monotonic (fluent)
     ;; adapted from 'computer.pddl':

   ;; ### here through next "###" not yet working ###########################:
   (uninstantiated ?obj - object)		    ; for objects that can be
   (instantiated ?obj - object)			    ; dynamically created

   ;; predicates that describe components of e-mail objects:
   (emailFromAcct ?message - email ?fromAcct - account)
   (emailFromHost ?message - email ?fromHost - host)
   (emailApparentlyFromAcct ?message - email ?apparentlyFromAcct - string)
   (emailApparentlyFromHost ?message - email ?apparentlyFromHost - string)
   (emailContent ?message - email ?messageContent - content)
   (emailAttachment ?message - email ?attachment - file)
   ;; ### end not working yet section ########################################

   ;; Represents connections between a host and another host, a host and
   ;; a network, or a network and another network:
   (connected ?entity1 ?entity2 - (or host network))
   (asv connected 'owl:inverseOf connected)

   (hasAccount ?u - user
   	       ?h - host
   	       ?uid - account
   	       ?gid - group
	       ?home - directory)

   (accountExists ?h - host ?uid - account) ; derived by axiom from has-account
     					    ; not needed currently?

   (knowsPassword ?u - user ?h - host ?uid - account)

   (fileOwner ?h - host ?dir - directory ?ownership - object ?s - segment)
     ; not YET used but may need to enhance distinctions between user & account
     ;  and between having a file and having access to the file....
     ; why '?ownership - object' - why not '?owner - user'?
   (hasAccess ?from - (or host account) ?h - host ?s - segment) ; not YET used

   ;; adapted from cna.pddl:
   (hasShell ?user - user
   	     ?h - host
	     ?uid - account)
   (hasFile ?host - host
	    ?dir - directory
	    ?segment - segment)
   (knowsHostUid ?attacker - Agent
		 ?targetUid - account
		 ?targetHost - host)

   ;; ultimately, may need versions of this with different temporal
   ;; extents, e.g. "executing" & "executed"
   (executed ?program - software
	     ?uid - account
	     ?host - host
	     ?dir - directory)

     ;; adapted from 'internet.pddl':
   (transmitted ?fromUid - account
		?srcHost - host
   		?toUid - account
		?destHost - host
		?contents - object)
     ;; new:
   (containsUrl ?phishMsg - content
		?urlHost - host
		?urlDir - directory
		?urlFile - file)		    ; actually f-name, not file!
   (visitsUrl ?user - account
	      ?userHost - host
   	      ?urlHost - host
	      ?urlDir - directory
	      ?urlFile - file)

   ;; This predicate indicates that a file is a password file, i.e. it
   ;; contains user IDs and passwords
   (containsUserPasswords ?pwdFile - file
			  ?h - host)
   
   ;; This predicate indicates that a file contains a specific user ID -
   ;; password combination - slightly different from
   ;; containsUserPasswords.
   (containsUidPwd ?pwdFile - file
		   ?uid - account
		   ?pwd - password)

   ;; This predicate indicates that the software implements the rLogin
   ;; service.  It seems a bit kludgy but good enough for now....
   (software-category ?category - software-cat
		      ?software - software)

   ;; added by Rich

     (hasPrivileges ?h - host
		    ?uid - account
		    ?priv - privilege)

     (hasPermissions ?h - host
		     ?priv - privilege
		     ?d - segment
		     ?permission - permission)

     (is_service_executable_file ?host - host
     				 ?file - file)

     (fileChanged ?file - file
     		  ?software - software
		  ?uid - account
		  ?host - host)	

     (envir_var_changed ?var - string
     			?host - host
			?uid - account 
			?oldValue - string 
			?newValue - string)

     (containsSubstring ?sub - string
      			 ?whole - string)
		
     (launches ?software - software
      	       ?dll - file)

     (hasName ?o - object 
              ?name - string)

     (os ?host - host
         ?operatingSystem - operating-system)

     (softwareGeneratesData ?software - software
     			    ?data - object)

     (appendToFile ?data - object 
     		   ?file - file)

     (data_encypted ?data - object
     		    ?encryption_method - encryption-method)

     (mounted ?device - device
              ?dir - directory
	      ?destHost - host)
	      
     (connection_using_protocol_and_port ?data - string
     					 ?protocol - protocol
					 ?port - integer)

     (common_protocol_port ?protocol - protocol
     			   ?port - integer)

     (follows_protocol_standards ?data - string
     				 ?protocol - protocol)
     
     ;; the data can be encypted using some strange, not standard, method
     (standard_encryption ?encryption_method - encryption-method)

;;   WINDOWS specific

     (registryChanged ?key - string
     		      ?valueName - string
		      ?software - software
		      ?uid - account
		      ?host - host)

     (isShortcut ?host - host 
     	         ?shortcut - file)

     (artifact_in_autorun_list ?thing - software
     			       ?host - host
			       ?uid - account)

;;   UNIX specific

     (cronjob_enabled ?host - host
     		      ?cronjob - software)

     (filesLinked ?host - host
     		  ?link - link
		  ?thing - segment)

;; from new-attack.pddl

     (installedOn ?sw - software
		  ?h - host)

     (client-server-pair ?client ?server - software)

     (enabled ?client - software
	      ?host - host)

     (hasShare ?h - host
	       ?share - directory)

     (isAdminShare ?h - host
		   ?share - directory)


     (shareEnabled ?share - directory 
		   ?host_1 - host
		   ?dir_2 - directory 
		   ?host_2 - host) 

     (isWebroot ?dir - directory
		 ?webHost - host)


  )

  (:init
      (common_protocol_port HTTP 80)
      (common_protocol_port HTTPS 443)
  )

  (:axiom
   :vars (?obj - object)
   :context (uninstantiated ?obj)
   :implies (not (instantiated ?obj))
   :documentation "housekeeping")
  (:axiom
   :vars (?obj - object)
   :context (instantiated ?obj)
   :implies (not (uninstantiated ?obj))
   :documentation "housekeeping")
  (:axiom
   :vars (?u - user
   	  ?host - host 
	  ?uid - account 
	  ?home-dir - directory)
   :context (hasAccount ?u ?host ?uid :ignore ?home-dir)
   :implies (accountExists ?host ?uid)
   :documentation "housekeeping")
  (:axiom
   :vars (?u - user
   	  ?host - host 
	  ?uid - account 
	  ?home-dir - directory)
   :context (hasAccount ?u ?host ?uid :ignore ?home-dir)
   :implies (knowsPassword ?u ?host ?uid)
   :documentation "housekeeping")
  (:axiom 
   :vars (?u - user
          ?host - host 
	  ?uid - account 
	  ?home-dir - directory)
   :context (hasAccount ?u ?host ?uid :ignore ?home-dir)
   :implies (hasAccess ?uid ?host ?home-dir)
   :documentation "account owner has hasAccess to his home directory")
  (:axiom 
   :vars (?host - host 
	  ?uid - account 
	  ?segment - segment
	  ?dir - directory)
   :context (fileOwner ?host ?dir ?uid ?segment)
   :implies (hasAccess ?uid ?host ?segment)
   :documentation "owner can hasAccess segments")
  (:axiom 
   :vars (?h1 ?h2 - host 
	  ?net - network)
   :context (and (connected ?h1 ?net) (connected ?h2 ?net))
   :implies (connected ?h1 ?h2)
   :documentation "two hosts connected to the same network are connected
	to one another")
  ;;;### NOT WORKING:
;  (:axiom
;   :vars (?aUser - user
;	  ?pwdFile1 ?pwdFile2 - document
;	  ?host1 ?host2 - host
;	  ?commonUid - account
;	  ?commonPwd - password
;	  )
;   :context (and (containsUserPasswords ?pwdFile1 ?host1)
;		 (containsUserPasswords ?pwdFile2 ?host2)
;		 (containsUidPwd ?pwdFile1 ?commonUid ?commonPwd)
;		 (containsUidPwd ?pwdFile2 ?commonUid ?commonPwd)
;		 (knowsPassword ?aUser ?host1 ?commonUid)
;	     )
;   :implies (knowsPassword ?aUser ?host2 ?commonUid)
;   :documentation "if a user has the same uid and pwd on two hosts, and
;   you know the uid and pwd on one host, you know the uid and pwd on the
;   other host.")

 ) ; end domain

;; Adapted from computer.pddl.  Doesn't make use of working-directory.
;; Probably should!  Don't have a plain login yet - that would require
;; physical access....
(define (action rLogin)
      :parameters (?u - user
		   ?tgtHost - host
		   ?tgtUid - account
		   ;%% needed to implement execution of rLogin process:
		   ?remHost - host
		   ?remUid - account
		   ?remHomeDir - directory
		   ;;###? using the efficiency shortcut here BREAKS THE PLAN!!!
		   ?rLoginProg - software ; (software-category RLOGIN)
		   )
      :vars (?remHost - host
	     ?remUid - account
	     ;?tgtHomeDir - directory
	     ;%% needed to implement execution of rLogin process:
	     ?acctOwner - user
	     ?remGrp - group
	     )
      :precondition (and (knowsPassword ?u ?tgtHost ?tgtUid)
			 (hasShell ?u ?remHost ?remUid)
			 (connected ?remHost ?tgtHost)
			 ;;### Why does this break things?!?
			 ;(hasAccount :ignore ; ?u needn't be account owner!
			 ;	     ?tgtHost
			 ;	     ?tgtUid
			 ;	     :ignore ; don't care about groups
			 ;	     ?tgtHomeDir)
			 ;;### Why does this break things?!?
			 ;(not (hasShell ?u ?tgtHost ?tgtUid))
			 ;%% needed to implement execution of rLogin process:
			 (software-category RLOGIN ?rLoginProg)
			 (hasAccount ?acctOwner
			 	     ?remHost
			 	     ?remUid
			 	     ?remGrp
			 	     ?remHomeDir)
			 )
      :effect (and
		   (hasShell ?u ?tgtHost ?tgtUid)
		   (executed ?rLoginProg ?remUid ?remHost ?remHomeDir)
	       	   )
      :documentation "Remote login:  User ?u is initially logged into
      ?remHost as ?remUid.  ?remHost is connected to ?tgtHost via some
      [unspecified here] network.  ?u knows the password for some
      ?tgtUid on ?tgtHost.  Via this action, ?u is logged in as ?tgtUid
      on ?targetHost, and the ?rLoginProg is executed on the ?remHost.")

;; Adapted from computer.pddl.  Doesn't represent back-to host.
;; Probably should.
(define (action logout)
      :parameters (?u - user
		   ?h - host
		   ?uid - account)
      :precondition (hasShell ?u ?h ?uid)
      :effect (not (hasShell ?u ?h ?uid)))


(define (action SendEmailNoAttachment)
      :parameters (?senderUid - account
		   ?srcHost - host
      		   ?recipUid - account
		   ?destHost - host
		   ?message - content
		   )
      :vars (?sender - user
	     ?srcDir - directory)
      :precondition (and (knowsHostUid ?sender ?recipUid ?destHost)
			 (hasShell ?sender ?srcHost ?senderUid))
      :effect (transmitted ?senderUid ?srcHost ?recipUid ?destHost ?message)
      :documentation "Send email with no attachment:  Initially, ?sender
      knows the uid ?recipUid on host ?destHost.  ?sender has a shell on
      ?srcHost with the uid ?senderUid.  Via this action, the ?message
      with no attachments is transmitted from the ?senderUid account on
      ?srcHost to the ?recipUid on ?destHost.")

;### Temporarily comment out to force sending web exploit with no attachment!
; Otherwise, it gets sent with an irrelevant attachment.  New
; implementation of e-mail actions (not yet working) should eliminate
; the need to do this!
(define (action SendEmailWithAttachment)
      :parameters (?senderUid - account
		   ?srcHost - host
      		   ?recipUid - account
		   ?destHost - host
		   ?message - content
      		   ?attach - file	;? how to make optional?
					;? how to enable multiple attachments?
					;; Re-work is in progress!  -dbs
		   )
      :vars (?sender - user
	     ?srcDir - directory)
      :precondition (and (knowsHostUid ?sender ?recipUid ?destHost)
			 (hasShell ?sender ?srcHost ?senderUid)
			 (hasFile ?srcHost ?srcDir ?attach))
      :effect (and (transmitted ?senderUid ?srcHost ?recipUid ?destHost ?message)
      	           (transmitted ?senderUid ?srcHost ?recipUid ?destHost ?attach)
	       )
      :documentation "Send email with one attachment:  Initially,
      ?sender knows the uid ?recipUid on host ?destHost.  There is a
      file, ?attach, in the ?srcDir of ?srcHost.  ?sender has a shell on
      ?srcHost with the uid ?senderUid.  Via this action, both the
      ?message and the ?attachment are transmitted from the ?senderUid
      account on ?srcHost to the ?recipUid on ?destHost.")

;;; If a file is executable, then opening it causes it to execute:
;;;### Note that, as in other actions, this action requires the program
;;; to be in the user's home directory.  This is a kludge until i
;;; implement a more complex representation of file and directory
;;; ownership and permissions.
(define (action OpenExecutableFile)
      :parameters (?program - software
		   ?uid - account
		   ?h - host)
      :vars (?u - user
	     ?gid - group
	     ?dir - (hasAccount ?u ?h ?uid ?gid)) ; directory
      :precondition (and
		      (hasFile ?h ?dir ?program)
		      (hasShell ?u ?h ?uid))
      :effect (executed ?program ?uid ?h ?dir)
      :documentation "Initially, a ?program exists in a directory ?dir
      on host ?h.  User ?u has an account ?uid on ?h with the
      (irrelevant) group ID ?gid and the home dir ?dir.  Via this
      action, the ?program is executed by ?uid on ?h in ?dir.")

;;; ### Temporarily commented out until i figure out how to ensure that
;;; these more generic actions are NOT used when parameters fit a more
;;; specific version (which has more stringent preconditions).
;;; TODO:  Test the (not ...) construct in the preconditions.
#|
(define (action SaveAttachment)
      :parameters (?tHost - host
		   ?rDir - directory
      		   ?attach - file)
      :vars (?fUid - account
             ?fHost - host
	     ?tUid - account
	     ?recip - user
	     ?rGid - group)
      :precondition (and (transmitted ?fUid ?fHost ?tUid ?tHost ?attach)
      			 (hasAccount ?recip ?tHost ?tUid ?rGid ?rDir))
      :effect (hasFile ?tHost ?rDir ?attach)
      :documentation "")

;;; OF COURSE this isn't the only way for the clicker to "have" or know the
;;; URL - it could come from visiting a web-page, having it bookmarked, etc.
(define (action ClickUrl)
      :parameters (?clickerUid - account
		   ?clickerHost - host
      		   ?urlHost - host
		   ?urlDir - directory
		   ?urlFile - file
		   )
      :vars (?senderUid - account
	     ?urlText - content)
      :precondition (and (transmitted ?senderUid
				      ?urlHost
				      ?clickerUid
				      ?clickerHost
				      ?urlText)
			 (containsUrl ?urlText
			 	      ?urlHost
				      ?urlDir
				      ?urlFile))
      :effect (visitsUrl ?clickerUid ?clickerHost ?urlHost ?urlDir ?urlFile)
      :documentation "")
|#

(define (action createFile)
      :parameters (?h - host
		   ?dir - directory
		   ?f - file)
      :vars (?u - user
	     ?uid - account)
      :precondition (and (hasShell ?u ?h ?uid)
			 (hasAccount :ignore ; ?u needn't be account owner!
			 	     ?h
			 	     ?uid
			 	     :ignore ; don't care about groups
			 	     ?dir)
			 (not (hasFile ?h ?dir ?f))
			 )
      :effect (hasFile ?h ?dir ?f)
      :documentation "Create a new file:  initially, user ?u has a shell
      on host ?h via the account ?uid, with the working directory ?dir,
      and the file ?f does not exist.  Via this action, ?f exists on
      ?h in ?dir")
