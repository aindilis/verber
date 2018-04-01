(in-package :ap)

;;; from "AVOIDIT: A Cyber Attack Taxonomy", Simmmons, C. et al.

(define (domain AVOIDIT)
    (:extends malware)
  (:types
   AttackVector - Thing
   Misconfiguration KernelFlaw DesignFlaw InsufficientInputValidation
   SymbolicLink FileDescriptorAttack RaceCondition IncorrectPermission
   SocialEngineering BufferOverflow - AttackVector
   StackOverflow HeapOverflow - BufferOverflow
     
   OperationalImpact - Thing
   MisuseOfResources UserCompromise RootCompromise WebCombromise - OperationalImpact
   DenialOfService - OperationalImpact
   InstalledMalware - (and Malware OperationalImpact)
   Spyware ArbitraryCodeExecution - InstalledMalware
   SystemBootRecordInfector FileInfector Macro - Virus
   MassMailing NetworkAware - Worm
   HostBaseDOS NetworkBasedDOS DistributedDOS - DenialOfService
     
   Defense - Thing
   Mitigation Remediation - Defense
   RemoveFromNetwork Whitelisting ReferenceAdvisement - Mitigation
   PatchSystem CorrectCode - Remediation
     
   InformationalImpact - Thing
   Distort Disrupt Destruct Disclosure Discovery - InformationalImpact
     
   Target - Software
   Network Local User OperatingSystem Application - Target
   OSFamily - 	OperatingSystem		; seems like these should be properties
     ;;OSName - OSFamily
     ;;OSVersion - OSName
   ServerApplication ClientApplication - (and Application Program)
   DB Email Web - ServerApplication
   )
  )