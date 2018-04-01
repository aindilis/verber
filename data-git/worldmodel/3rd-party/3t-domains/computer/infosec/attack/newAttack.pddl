(in-package :ap)
;;; CAPA domain definition

(define (domain new-attack)
    (:extends hacker)

  (:predicates

   ) ; end predicates
 ) ; end domain

(define (action "LateralMovement1")
	:parameters (?user - Agent
		     ?host1 ?host2 - host)
	:vars (?uid1 ?uid2 - account)
	:precondition (and 
		(hasShell ?user ?host1 ?uid1)
		(connected ?host1 ?host2))
	:expansion
		(series
			(knowsPassword ?user ?host2 ?uid2)
			(hasShell ?user ?host2 ?uid2))
	:effect
		(lateralMovement ?user ?host1 ?host2))

(define (action "LateralMovement2")
	:parameters (?user - Agent
		     ?host1 ?tgtHost - host)
	:vars (?uid1 ?tgtUid - account
	       ?exploit - malware)
	:precondition (and 
		(hasShell ?user ?host1 ?uid1)
		(connected ?host1 ?tgtHost))
	:expansion
		(series
			(malware-category BACKDOOR ?exploit)
			(exploitDelivered ?exploit ?tgtUid ?tgtHost))
	:effect
		(lateralMovement ?user ?host1 ?tgtHost))
		
;;; This is general enough to be moved to the computer file:
;;;
;;;### Not exactly a "general" remote service with *any* client-server
;;; pair; really applies specifically only to a remote login service
;;; (e.g. RLOGIN, TELNET, SSH, etc.).  Maybe should be used in
;;; conjunction with / re-implemented with software-cat constant values
;;; such as RLOGIN.
(define (action "Use Remote Service")
	;;; Connecting software:  TELNET, VNC
    :documentation "Given enabled client-server software that provides
		    remote login capability from the client to the
		    server, if a user has a shell on host_1, this action
		    results in him having a shell on host_2."
    :parameters (?usr - user
		 ?host_2 - host
		 ?uid_2 - account)
    :vars (?clientSoftware ?serverSoftware - software
	   ?uid_1 - account
	   ?host_1 - host)
    :precondition (and 
		    (client-server-pair ?clientSoftware ?serverSoftware)
		    ;; e.g. (client-server_pair SSH SSHD)
		    (installedOn ?clientSoftware ?host_1)
		    (enabled ?clientSoftware ?host_1)
		    (installedOn ?serverSoftware ?host_2)
		    (enabled ?serverSoftware ?host_2)
		    (connected ?host_1 ?host_2)
		    (not (equal ?host_1 ?host_2))
		    (hasShell ?usr ?host_1 ?uid_1)
		    (knowsPassword ?usr ?host_2 ?uid_2)
		    )
    	:effect 
		(hasShell ?usr ?host_2 ?uid_2))


(define (problem "Use Remote Service Test")
    (:domain attack)
  (:objects clientSW serverSW - software
	    clientHost serverHost - host
	    usr - user
	    clientUid serverUid - account
	    )
  (:init
    (client-server-pair clientSW serverSW)
    (installedOn clientSW clientHost)
    (enabled clientSW clientHost)
    (installedOn serverSW serverHost)
    (enabled serverSW serverHost)
    (connected clientHost serverHost)
    (hasShell usr clientHost clientUid)
    (knowsPassword usr serverHost serverUid)
   )
  (:goal (hasShell usr serverHost serverUid)))


;;; This is general enough to be moved to the computer file:
(define (action "Drop File via Share")
	:documentation "Given two connected hosts, with a share
			directory on host_1 that's shareEnabled on
			host_2, if a user knows a UID and password on
			host_2 and has a file on host_1, this action
			results in the file being placed in the share
			directory on host_2."
	:parameters (?file - file
		     ?host_2 - host
		     ?dir_2 - directory)
	:vars (?usr - user
	       ?dir_1 ?share - directory
	       ?host_1 - host
	       ?uid_1 ?uid_2 - account
	       ?priv - privilege
	       ?permission - permission)
	:precondition (and
		        (connected ?host_1 ?host_2)	
		        (not (equal ?host_1 ?host_2))
		        (hasShare ?host_1 ?share)   
		        (shareEnabled ?share ?host_1 ?dir_2 ?host_2) 
		        (hasShell ?usr ?host_1 ?uid_1)
			(hasPrivileges ?host_1 ?uid_1 ?priv)
			(hasPermissions ?host_1 ?priv ?share ?permission)
		        (knowsPassword ?usr ?host_2 ?uid_2)
		        (hasFile ?host_1 ?dir_1 ?file))
	:effect
		(hasFile ?host_2 ?dir_2 ?file))


(define (problem "Drop File via Share Test")
    (:domain attack)
  (:objects hack - malware
	    initHost tgtHost - host
	    initDir shareDir infectedDir  - directory
	    apt - user
	    initUid tgtUid - account
	    )
  (:init
    (connected initHost tgtHost)
    (hasShare initHost shareDir)
    (shareEnabled shareDir initHost infectedDir tgtHost)
    (hasShell apt initHost initUid)
    (knowsPassword apt tgtHost tgtUid)
    (hasFile initHost initDir hack)
    (hasPrivileges initHost initUid initUid)
    (hasPermissions initHost initUid shareDir WRITE)
    (malware-category SHARE_HACK hack)
   )
  (:goal (hasFile tgtHost infectedDir hack)))

(define (problem "Drop File via Admin Share Test")
    (:domain attack)
  (:objects hack - malware
	    initHost tgtHost - host
	    initDir shareDir infectedDir  - directory
	    apt - user
	    initUid tgtUid - account
	    )
  (:init
    (connected initHost tgtHost)
    (hasShare initHost shareDir)
    (shareEnabled shareDir initHost infectedDir tgtHost)
    (hasShell apt initHost initUid)
    (knowsPassword apt tgtHost tgtUid)
    (hasFile initHost initDir hack)
    (hasPrivileges initHost initUid ADMIN)
    (hasPermissions initHost ADMIN shareDir WRITE)
    (malware-category SHARE_HACK hack)
   )
  (:goal (hasFile tgtHost infectedDir hack)))


;;### Re-do for greater efficiency:  -dbs
(define (action "Deliver via Shared Folder")
	:documentation "If a hacker discovers a UID and password on the
			target host, has a shell and an exploit file on
			an intermediate host, and there's a share
			directory on the intermediate host that's
			shareEnabled on the target host, this
			intermediate-level action results in the exploit
			being delivered to the share folder on the
			target host."
	:parameters (?exploit - malware
		     ?tgtUid - account
		     ?tgtHost - host)
	:vars (?interHost - host
	       ?interDir ?share ?infectedDir - directory
	       ?hacker - user
	       ?interUid - account)
	:precondition (and
			(connected ?interHost ?tgtHost)
			(not (equal ?interHost ?tgtHost))
			(hasShare ?interHost ?share)
			(hasShell ?hacker ?interHost ?interUid)		
			(hasFile ?interHost ?interDir ?exploit)
			(malware-category :ignore ?exploit)
			)
	:expansion (series
		    (knowsPassword ?hacker ?tgtHost ?tgtUid)
		    (hasFile ?tgtHost ?infectedDir ?exploit))		
	:effect
		(exploitDelivered ?exploit ?tgtUid ?tgtHost))


(define (problem "Deliver via Shared Folder Test")
    (:domain attack)
  (:objects hack - malware
	    bobsUid fredsUid - account
	    MM123-computer MM125-computer - host
	    initDir shareDir infectedDir - directory
	    apt - user
	    )
  (:init
    (connected MM123-computer MM125-computer)
    (hasShare MM123-computer shareDir)
    (shareEnabled shareDir MM123-computer infectedDir  MM125-computer)
    (hasShell apt MM123-computer bobsUid)
    (hasFile MM123-computer initDir hack)
    (malware-category SHARE_HACK hack)
    (hasPrivileges MM123-computer bobsUid ADMIN)
    (hasPermissions MM123-computer ADMIN shareDir WRITE)
    ;; This test is pretty trivial since the first subgoal in the
    ;; expansion is already given in the preconditions.  I haven't yet
    ;; implemented any actions that would result in achieving this
    ;; precondition starting with more basic conditions.
    (knowsPassword apt MM125-computer fredsUid)
   )
  (:goal (exploitDelivered hack fredsUid MM125-computer)))

(define (action "Execute via Shared Webroot")
	:parameters (?exploit - malware
		     ?webServerAdminUid - account
		     ?webServer - host
		     ?webrootDir - directory)
	:vars (?interHost - host
	       ?interUid - account
               ?interDir - directory
               ?hacker - user)
	:precondition (and
			(hasAccount :ignore ?webServer
				    ?webServerAdminUid :ignore ?webrootDir)
			(not (equal ?interHost ?webServer))
			(hasFile ?interHost ?interDir ?exploit)
			;;; there were several kinds of files in the
			;;; spreadsheet (ASP, ASPX, PHP, CFM, JSP) 
			;(or (malware-category EXECUTABLE_ASP ?exploit)
			    (malware-category EXECUTABLE_ASPX ?exploit)
			;    (malware-category EXECUTABLE_PHP ?exploit)
			;    (malware-category EXECUTABLE_CFM ?exploit)
			;    (malware-category EXECUTABLE_JSP ?exploit)
			;    ) 
			(hasShell ?hacker ?interHost ?interUid)
			(shareEnabled ?webrootDir ?webServer ?interDir ?interHost)
			(isWebroot ?webrootDir ?webServer)
		       )
	:expansion (series
		    (hasFile ?webServer ?webrootDir ?exploit)
		    (visitsUrl ?hacker ?interHost
			       ?webServer ?webrootDir ?exploit))
	:effect
		(executed ?exploit ?webServerAdminUid
			  ?webServer ?webrootDir))


(define (problem "Execute via Shared Webroot Test")
    (:domain attack)
  (:objects exploit - malware
	    webServerAdminUid - account
	    webServer - host
	    webrootDir - directory

	    interHost - host
	    interUid - account
	    interDir - directory
	    hacker - user

	    web_server_admin - user
	    web_server_admin_gid - group
	    )
  (:init
    (hasAccount web_server_admin webServer
		webServerAdminUid web_server_admin_gid webrootDir)
    (hasFile interHost interDir exploit)
    (malware-category EXECUTABLE_ASPX exploit)
    (hasShell hacker interHost interUid)
    (shareEnabled webrootDir webServer)
    (isWebroot webrootDir webServer)
    ;; I'm explicitly including the sub-goals from the :expansion series
    ;; above so that the higher-level action being tested will execute
    ;; without AP needing to find actions to achieve the subgoals, and
    ;; without needing the preconditions for lower-level actions to be
    ;; represented here explicitly.  But if i understand correctly, the
    ;; lower-level actions would be something like "Drop file via Share
    ;; Directory" and "clickUrl".
    (hasFile webServer webrootDir exploit)
    (visitsUrl hacker interHost webServer webrootDir exploit)
   )
  (:goal (executed exploit webServerAdminUid webServer webrootDir)))
