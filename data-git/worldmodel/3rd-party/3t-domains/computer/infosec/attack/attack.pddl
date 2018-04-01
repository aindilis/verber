(in-package :ap)

(define (domain attack)
    (:comment "CAPA domain definition")
  (:extends hacker)
  (:predicates
   (installedOn ?s - Software ?h - Host)
   (client-server-pair ?client ?server - Software)
   (enabled ?client - Software ?h - Host)
   (isShare ?h - Host ?share - Directory)
   (isAdminShare ?h - Host ?share - Directory)
   (shareEnabled ?dir - Directory ?h - Host)
   (hasPrivileges ?h - Host ?uid - Account ?p - Privilege)
   (isWebroot ?d - Directory ?webHost - Host)
   (executed ?s - Software ?a - Account ?h - Host ?d - Directory)
   (exploitDelivered ?m - Malware ?tgtUid ?tgtHost - Host)
   (visitsUrl ?u - User ?from ?to - Host ?d - Directory ?p - Program)
   )		
  (:axiom
   :vars (?h - Host 
	  ?share - Directory)
   :context (isAdminShare ?h ?share)
   :implies (isShare ?h ?share)
   :documentation "all AdminShare directories are Share directories")
  )				


(define (action "Use Remote Service")
    :parameters (?usr - User
		 ?host_2 - Host
		 ?uid_2 - Account)
    :vars (?clientSoftware ?serverSoftware - Software
	   ?uid_1 - Account
	   ?host_1 - Host)
    :precondition (and 
		    (client-server-pair ?clientSoftware ?serverSoftware)
		    ;; e.g. (client-server_pair SSH SSHD)
		    (installedOn ?clientSoftware ?host_1)
		    (enabled ?clientSoftware ?host_1)
		    (installedOn ?serverSoftware ?host_2)
		    (enabled ?serverSoftware ?host_2)
		    (connected ?host_1 ?host_2)
		    (hasShell ?usr ?host_1 ?uid_1)
		    (knowsPassword ?usr ?host_2 ?uid_2)
		    (not (= ?host_1 ?host_2))
		    (not (= ?clientSoftware ?serverSoftware)))
    :effect (hasShell ?usr ?host_2 ?uid_2)
    :documentation "Given enabled client-server Software that provides
		    remote login capability from the client to the
		    server, if a User has a shell on Host_1, this action
		    results in him having a shell on Host_2.")	

;;shows that Use Remote Service is quite explosive - 1680 possibilities
;;   if :assumptions, but only 1 if not!   CE 2016-01-19
(define (problem "Use Remote Service Test")
    (:domain attack)
  (:objects clientSW serverSW - Software
	    clientHost serverHost - Host
	    usr - User
	    clientUid serverUid - Account)
  (:init
    (client-server-pair clientSW serverSW)
    (installedOn clientSW clientHost)
    (enabled clientSW clientHost)
    (installedOn serverSW serverHost)
    (enabled serverSW serverHost)
    (connected clientHost serverHost)
    (hasShell usr clientHost clientUid)
    (knowsPassword usr serverHost serverUid))
  (:goal 
   (hasShell usr serverHost serverUid)))

;;; This is general enough to be moved to the computer file:
(define (action "Drop File via Share")
    :documentation "Given two connected Hosts, with a share
			directory on Host_1 that's shareEnabled on
			host_2, if a User knows a UID and password on
			host_2 and has a file on Host_1, this action
			results in the file being placed in the share
			directory on Host_2."
    :parameters (?file - ComputerFile
		 ?host_2 - Host
		 ?share - Directory)
    :vars (?usr - User
	   ?dir_1 - Directory
	   ?host_1 - Host
	   ?uid_1 ?uid_2 - Account)
    :precondition (and
		   (connected ?host_1 ?host_2)	
		   (not (= ?host_1 ?host_2))
		   (isShare ?host_1 ?share)   
			;### Apparently, not only are disjunctions
			; forbidden in :preconditions, but (not) can
			; only be used for a lisp function, not for
			; a predicate.  Thus, this breaks things.
			; Need to re-work this still further!  -dbs
		   (not (isAdminShare ?host_1 ?share))
		   (shareEnabled ?share ?host_2) 
		   (hasShell ?usr ?host_1 ?uid_1)
		   (knowsPassword ?usr ?host_2 ?uid_2)
		   (hasFile ?host_1 ?dir_1 ?file))
    :effect (hasFile ?host_2 ?share ?file))


(define (problem "Drop File via Share Test")
    (:domain attack)
  (:objects hack - Malware
	    initHost tgtHost - Host
	    initDir shareDir - Directory
	    apt - User
	    initUid tgtUid - Account)
  (:init
    (connected initHost tgtHost)
    (isShare initHost shareDir)
    (shareEnabled shareDir tgtHost)
    (hasShell apt initHost initUid)
    (knowsPassword apt tgtHost tgtUid)
    (hasFile initHost initDir hack))
  (:goal 
   (hasFile tgtHost shareDir hack)))

;;; This is general enough to be moved to the computer file:
(define (action "Drop File via Admin Share")
    :documentation "Given two connected Hosts, with an adminShare
			directory on Host_1 that's shareEnabled on
			host_2, if a User knows a UID with ADMIN
			privileges and corresponding password on
			host_2 and has a file on Host_1, this action
			results in the file being placed in the share
			directory on Host_2."
    :parameters (?file - ComputerFile
		 ?host_2 - Host
		 ?share - Directory)
    :vars (?usr - User
	   ?dir_1 - Directory
	   ?host_1 - Host
	   ?uid_1 ?uid_2 - Account)
    :precondition (and
		   (connected ?host_1 ?host_2)	
		   (not (= ?host_1 ?host_2))
		   (isAdminShare ?host_1 ?share)   
		   (hasPrivileges ?host_2 ?uid_2 ADMIN)
		   (shareEnabled ?share ?host_2) 
		   (hasShell ?usr ?host_1 ?uid_1)
		   (knowsPassword ?usr ?host_2 ?uid_2)
		   (hasFile ?host_1 ?dir_1 ?file))
    :effect (hasFile ?host_2 ?share ?file))

(define (problem "Drop File via Admin Share Test")
    (:domain attack)
  (:objects hack - Malware
	    initHost tgtHost - Host
	    initDir shareDir - Directory
	    apt - User
	    initUid tgtUid - Account)
  (:init
    (connected initHost tgtHost)
    (isAdminShare initHost shareDir)
    (hasPrivileges tgtHost tgtUid ADMIN)
    (shareEnabled shareDir tgtHost)
    (hasShell apt initHost initUid)
    (knowsPassword apt tgtHost tgtUid)
    (hasFile initHost initDir hack))
  (:goal 
   (hasFile tgtHost shareDir hack)))

;;;### Re-do for greater efficiency:  -dbs
(define (action "Deliver via Shared Folder")
    :documentation "If a hacker discovers a UID and password on the
			target Host, has a shell and an exploit file on
			an intermediate Host, and there's a share
			directory on the intermediate Host that's
			shareEnabled on the target Host, this
			intermediate-level action results in the exploit
			being delivered to the share folder on the
			target Host."
    :parameters (?exploit - Malware
		 ?tgtUid - Account
		 ?tgtHost - Host)
    :vars (?interHost - Host
	   ?interDir ?share - Directory
	   ?hacker - User
	   ?interUid - Account)
    :precondition (and
		   (connected ?interHost ?tgtHost)
		   (not (= ?interHost ?tgtHost))
		   (isShare ?interHost ?share)
		   (shareEnabled ?share ?tgtHost)
		   (hasShell ?hacker ?interHost ?interUid)		
		   (hasFile ?interHost ?interDir ?exploit)
		   (malwareCategory ?exploit SHARE_HACK))
    :expansion (series
		(knowsPassword ?hacker ?tgtHost ?tgtUid)
		(hasFile ?tgtHost ?share ?exploit))		
    :effect (exploitDelivered ?exploit ?tgtUid ?tgtHost))

(define (problem "Deliver via Shared Folder Test")
    (:domain attack)
  (:objects hack - Malware
	    bobsUid fredsUid - Account
	    MM123-computer MM125-computer - Host
	    initDir shareDir - Directory
	    apt - User)
  (:init
    (connected MM123-computer MM125-computer)
    (isShare MM123-computer shareDir)
    (shareEnabled shareDir MM125-computer)
    (hasShell apt MM123-computer bobsUid)
    (hasFile MM123-computer initDir hack)
    (malwareCategory hack SHARE_HACK)
    ;; This test is pretty trivial since the first subgoal in the
    ;; expansion is already given in the preconditions.  I haven't yet
    ;; implemented any actions that would result in achieving this
    ;; precondition starting with more basic conditions.
    (knowsPassword apt MM125-computer fredsUid))
  (:goal 
   (exploitDelivered hack fredsUid MM125-computer)))


;;; This is almost identical to "Deliver via Shared Folder".
(define (action "Deliver via Admin Share")
    :documentation "If a hacker discovers a UID and password on the
			target Host, has a shell and an exploit file on
			an intermediate Host, and there's an admin share
			directory on the intermediate Host that's
			shareEnabled on the target Host, this
			intermediate-level action results in the exploit
			being delivered to the share folder on the
			target Host."
    :parameters (?exploit - Malware
		 ?tgtUid - Account
		 ?tgtHost - Host)
    :vars (?interHost - Host
	   ?interDir ?share - Directory
	   ?hacker - User
	   ?interUid - Account)	    
    :precondition (and
		   (connected ?interHost ?tgtHost)
		   (not (= ?interHost ?tgtHost))
		   (isAdminShare ?interHost ?share)
		       ;; shouldn't need to represent HERE all the
		       ;; pre-conditions of the lower-level actions
		       ;; that will be used to accomplish the sequential
		       ;; goals below
		       ; (shareEnabled ?share ?tgtHost)
		   (hasShell ?hacker ?interHost ?interUid)
		   (hasFile ?interHost ?interDir ?exploit)
		   (malwareCategory ?exploit SHARE_HACK)
		       ;; must be admin share to use this action
		   )
    :expansion (series
		(hasPrivileges ?tgtHost ?tgtUid ADMIN)
		(knowsPassword ?hacker ?tgtHost ?tgtUid)
		(hasFile ?tgtHost ?share ?exploit))
    :effect (exploitDelivered ?exploit ?tgtUid ?tgtHost))

(define (problem "Deliver via Admin Share Test")
    (:domain attack)
  (:objects hack - Malware
	    bobsUid fredsUid - Account
	    MM123-computer MM125-computer - Host
	    initDir shareDir - Directory
	    apt - User)
  (:init
    (connected MM123-computer MM125-computer)
    (isAdminShare MM123-computer shareDir)
    (shareEnabled shareDir MM125-computer)
    (hasShell apt MM123-computer bobsUid)
    (hasFile MM123-computer initDir hack)
    (malwareCategory hack SHARE_HACK)
    ;; This test is pretty trivial since the first two subgoals in the
    ;; expansion is already given in the preconditions.  I haven't yet
    ;; implemented any actions that would result in achieving these
    ;; preconditions starting with more basic conditions.
    (hasPrivileges MM125-computer fredsUid ADMIN)
    (knowsPassword apt MM125-computer fredsUid))
  (:goal (exploitDelivered hack fredsUid MM125-computer)))


(define (action "Execute via Shared Webroot")
    :parameters (?exploit - Malware
		 ?webServerAdminUid - Account
		 ?webServer - Host
		 ?webrootDir - Directory)
    :vars (?interHost - Host
	   ?interUid - Account
	   ?interDir - Directory
	   ?hacker - User)
    :precondition (and
		   (hasAccount ?webServer
			       ?webServerAdminUid :ignore ?webrootDir)
		   (not (= ?interHost ?webServer))
		   (hasFile ?interHost ?interDir ?exploit)
			;;; there were several kinds of files in the
			;;; spreadsheet (ASP, ASPX, PHP, CFM, JSP) 
					;(or (malwareCategory EXECUTABLE_ASP ?exploit)
		   (malwareCategory ?exploit EXECUTABLE_ASPX)
			;    (malwareCategory EXECUTABLE_PHP ?exploit)
			;    (malwareCategory EXECUTABLE_CFM ?exploit)
			;    (malwareCategory EXECUTABLE_JSP ?exploit)
			;    ) 
		   (hasShell ?hacker ?interHost ?interUid)
		   (shareEnabled ?webrootDir ?webServer)
		   (isWebroot ?webrootDir ?webServer))
    :expansion (series
		(hasFile ?webServer ?webrootDir ?exploit)
		(visitsUrl ?hacker ?interHost ?webServer ?webrootDir ?exploit))
    :effect (executed ?exploit ?webServerAdminUid ?webServer ?webrootDir))


(define (problem "Execute via Shared Webroot Test")
    (:domain attack)
  (:objects exploit - Malware
	    webServerAdminUid - Account
	    webServer - Host
	    webrootDir - Directory
	    interHost - Host
	    interUid - Account
	    interDir - Directory
	    hacker web_server_admin - User
	    web_server_admin_gid - Group)
  (:init
  ;;  (hasAccount web_server_admin webServer
   ;;		webServerAdminUid web_server_admin_gid webrootDir)
   ;; guessing what above means in the next two props:
   (hasAccount webServer webServerAdminUid web_server_admin_gid webrootDir)
   (knowsPassword web_server_admin webServer webServerAdminUid)
    (hasFile interHost interDir exploit)
    (malwareCategory exploit EXECUTABLE_ASPX)
    (hasShell hacker interHost interUid)
    (shareEnabled webrootDir webServer)
    (isWebroot webrootDir webServer)
    ;; Explicitly including the sub-goals from the :expansion series
    ;; above so that the higher-level action being tested will execute
    ;; without AP needing to find actions to achieve the subgoals, and
    ;; without needing the preconditions for lower-level actions to be
    ;; represented here explicitly.  But if i understand correctly, the
    ;; lower-level actions would be something like "Drop file via Share
    ;; Directory" and "clickUrl".
    (hasFile webServer webrootDir exploit)
    (visitsUrl hacker interHost webServer webrootDir exploit))
  (:goal 
   (executed exploit webServerAdminUid webServer webrootDir)))
