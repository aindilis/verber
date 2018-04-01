;; Command and Control
(in-package :ap)
;;; CAPA domain definition

(define (domain command_and_control )
    (:extends hacker)
)

;; Row 2
;; CC_using_common_protocol_using_standards
(define (action CC_using_common_protocol_using_standards)
	:parameters (?command - software
		     ?toUid - account
		     ?destHost - host
		     ?working_dir - directory)
	:vars (?fromUid - account
	       ?srcHost - host
	       ?data - object
	       ?protocol - string
	       ?attacker - user
	       ?port - string)
	:precondition (and
		(transmitted ?fromUid ?srcHost ?toUid ?destHost ?data) ;; send command
		(connection_using_protocol_and_port ?data ?protocol ?port)
		(common_protocol_port ?protocol ?port)
		(follows_protocol_standards ?data ?protocol)
		(containsSubstring ?command ?data)) 
	:effect
		(and (hasShell ?destHost ?attacker ?toUid)
		     (executed ?command ?toUid ?destHost ?working_dir)))
			 
(define (action upload_malware)
        :parameters (?malware - malware
		     ?toUid - account
		     ?destHost - host)
	:vars (?attacker - user
	       ?command - software
	       ?working_dir - directory)       
	:expansion (series
		(hasShell ?destHost ?attacker ?toUid)
		(executed ?command ?toUid ?destHost ?working_dir)
		(softwareGeneratesData ?command ?malware))
	:effect
		(exploitDelivered ?malware ?toUid ?destHost))

;; Row 3
;; CC_using_common_protocol_not_using_standards
(define (action CC_using_common_protocol_not_using_standards)
	:parameters (?command - software
		     ?toUid - account
		     ?destHost - host
		     ?working_dir - directory)
	:vars (?fromUid - account
	       ?srcHost - host
	       ?data - object
	       ?protocol - string
	       ?attacker - user
	       ?port - string)
	:precondition (and
		(transmitted ?fromUid ?srcHost ?toUid ?destHost ?data) ;; send command
		(connection_using_protocol_and_port ?data ?protocol ?port)
		(common_protocol_port ?protocol ?port)
		(not (follows_protocol_standards ?data ?protocol))
		(containsSubstring ?command ?data))
	:effect
		(and (hasShell ?destHost ?attacker ?toUid)
		     (executed ?command ?toUid ?destHost ?working_dir)))

;; Row 4
;; CC_using_common_protocol_non_standard_port
(define (action CC_using_common_protocol_non_standard_port)
	:parameters (?command - software
		     ?toUid - account
		     ?destHost - host
		     ?working_dir - directory)
	:vars (?fromUid - account
	       ?srcHost - host
	       ?data - object
	       ?protocol - string
	       ?attacker - user
	       ?port - string)
	:precondition (and
		(transmitted ?fromUid ?srcHost ?toUid ?destHost ?data)  ;; send command
		(connection_using_protocol_and_port ?data ?protocol ?port)
		(not (common_protocol_port ?protocol ?port))
		(follows_protocol_standards ?data ?protocol)
		(containsSubstring ?command ?data))
	:effect
		(and (hasShell ?destHost ?attacker ?toUid)
		     (executed ?command ?toUid ?destHost ?working_dir)))

;; Row 5
(define (action CC_using_non_standard_encryption)
	:parameters (?command - software
		     ?toUid - account
		     ?destHost - host
		     ?working_dir - directory)
	:vars (?fromUid - account
	       ?srcHost - host
	       ?data - object
	       ?attacker - user
	       ?encryption_method - encryption-method)
	:precondition (and
		(transmitted ?fromUid ?srcHost ?toUid ?destHost ?data)  ;; send command
		(data_encypted ?data ?encryption_method)
		(not (standard_encryption ?encryption_method))
		(containsSubstring ?command ?data))
	:effect
		(and (hasShell ?destHost ?attacker ?toUid)
		     (executed ?command ?toUid ?destHost ?working_dir)))
			 
		
;; Row 6
;; Communications are obfuscated

(define (action CC_using_obfusction)
	:parameters (?command - software
		     ?toUid - account
		     ?destHost - host
		     ?working_dir - directory)
	:vars (?fromUid - account
	       ?srcHost - host
	       ?attacker - user
	       ?data - object)
	:precondition (and
		(transmitted ?fromUid ?srcHost ?toUid ?destHost ?data)   ;; send command
		(or (data_encypted ?data BASE64) (data_encypted ?data JPEG))   ;; and others....
		(containsSubstring ?command ?data))
	:effect
		(and (hasShell ?destHost ?attacker ?toUid)
		     (executed ?command ?toUid ?destHost ?working_dir)))
		
;; Row 7
;; Distributed communications

;; Row 8
;; Multiple protocols combined
