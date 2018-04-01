;; exfiltration
(in-package :ap)
;;; CAPA domain definition

(define (domain exfiltration )
    (:extends hacker)
)

;; Row 2
;; Exfiltration of data over normal C&C channel

(define (action exfiltration_using_C2_channel)
	:parameters (?srcHost ?destHost - host
		     ?data - object
		     ?toUid ?fromUid - account)
	:vars (?command - software
	       ?working_dir - directory
	       ?attacker - user)
	:precondition (and
		(softwareGeneratesData ?command ?data)
		(connected ?destHost ?srcHost))
	:expansion (series 
		(hasShell ?destHost ?attacker ?toUid)
		(executed ?command ?toUid ?destHost ?working_dir))
	:effect
		(transmitted ?toUid ?destHost ?fromUid ?srcHost ?data))
		
;; Row 3
;; Exfiltration over alternate data channel on same network as C&C channel

;; don't know how to differentiate between channels, expect via c2 actions????

;; Row 4
;; Exfiltration over other network medium

;; don't know how to differentiate between channels, expect via c2 actions????

;; Row 5
;; Exfiltration over physical medium

(define (action exfiltration_using_physical_medium)
	:parameters (?device - device
		     ?dir - directory
		     ?file - file)
	:vars (?command - software
	       ?working_dir - directory
	       ?toUid - account
	       ?attacker - user
	       ?destHost - host)
	:precondition (and
		(softwareGeneratesData ?command ?file)
		(mounted ?device ?dir ?destHost))
	:expansion (series 
		(hasShell ?destHost ?attacker ?toUid)
		(executed ?command ?toUid ?destHost ?working_dir))
	:effect
		(hasFile ?device ?dir ?file))

;; Row 6
;; Data for exfiltration is encrypted (seperately from exfiltration channel)

(define (action exfiltration_encypted_not_using_C2_channel)
	:parameters (?srcHost ?destHost - host
		     ?data - object
		     ?toUid ?fromUid - account
		     ?encryption_method - object)
	:vars (?command - software
	       ?working_dir - directory
	       ?attacker - user)
	:precondition (and
		(softwareGeneratesData ?command ?data)
		(connected ?destHost ?srcHost))
	:expansion (series 
		(hasShell ?destHost ?attacker ?toUid)
		(executed ?command ?toUid ?destHost ?working_dir))   ;; executed cannot be satisfied using c2 pddl actions
	:effect
		(and (transmitted ?toUid ?destHost ?fromUid ?srcHost ?data)
			 (data_encypted ?data ?encryption_method)))

;; Row 7
;; Data for exfiltration is compressed (seperately from exfiltration channel)

;; why does compression matter??

;; Row 8
;; Data is staged for exfiltration at a later time or over a long period of time

(define (action collect_data_for_exfiltration)
	:parameters (?destHost - host
	             ?dir - directory
		     ?file - file)
	:vars (?command - software
	       ?data - string
	       ?working_dir - directory
	       ?attacker - user
	       ?toUid ?fromUid - account)
	:precondition (and
		(softwareGeneratesData ?command ?data))
	:expansion (series 
		(hasShell ?destHost ?attacker ?toUid)
		(executed ?command ?toUid ?destHost ?working_dir)   ;; executed may be satisfied using c2 pddl actions
		(appendToFile ?data ?file))
	:effect
		(hasFile ?destHost ?dir ?file))
		
;; Row 9
;; Automated or scripted data exfiltration

;; must a script be deployed??

(define (action deploy_script_and_exfiltrate)
	:parameters (?srcHost ?destHost - host
		     ?data - object
		     ?toUid ?fromUid - account)
	:vars (?malware - malware
	       ?attacker - user
	       ?working_dir - directory
	       ?some_uid - account)
	:precondition (and
		(softwareGeneratesData ?malware ?data)
		(connected ?destHost ?srcHost))
	:expansion (series 
		(exploitInstalled ?malware ?some_uid ?destHost)             ;; don't care who installed it....
		(hasShell ?destHost ?attacker ?toUid)
		(executed ?malware ?toUid ?destHost ?working_dir))
	:effect
		(transmitted ?toUid ?destHost ?fromUid ?srcHost ?data))

;; Row 10
;; Data being exfiltrated is sent in chunks instead of whole files at once.  
;; This approach may be used to avoid triggering network threshold alerts.
		
;; How do we indicate doing all of the chunks????
;; Maybe it is enough to notice a part of a file was exfiltrated??

(define (action chunk_data_for_exfiltration)
	:parameters (?destHost ?srcHost - host
	             ?toUid ?fromUid - account
		     ?data - string)
	:vars (?file - file 
	       ?dir ?working_dir - directory
	       ?attacker - user
	       ?toUid ?fromUid - account
	       ?command - software)
	:precondition (and
		(hasFile ?destHost ?dir ?file)
		(containsSubstring ?data ?file)
		(connected ?destHost ?srcHost))
	:expansion (series
		(hasShell ?destHost ?attacker ?toUid)
		(executed ?command ?toUid ?destHost ?working_dir))   ;; executed may be satisfied using c2 pddl actions)		
	:effect
		(transmitted ?toUid ?destHost ?fromUid ?srcHost ?data))
		
;; Row 11
;; Exfiltrated data follows a certain schedule
