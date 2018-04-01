(in-package :ap)

(define (domain capability)
    (:comment "merged with competency 2016-11-06")
  (:prefix "event")
  (:extends event org)
  (:types
   Capability - Number
   Competency FieldOfStudy - InformationContentEntity
   ;;CompetencyScale - EnumeratedClass	; makes it an ordered list of objects
   )
  (:constants
   ;;none low medium high - CompetencyScale ; these will be listed in order
   physics nuclearTechnology biology microbiology
   improvisedExplosiveDevices chemistry - FieldOfStudy)
  (:predicates
   (competencyIn ?c - Competency ?f - FieldOfStudy)
   (hasCapability ?a - Agent ?o - Thing)
   (hasSomeKnowledgeOf ?a - Agent ?o - Thing))
  (:functions 
   ;;(hasCompetency ?a - Agent) -  CompetencyScale
   ;;(competencyLevel ?c - Competency) - CompetencyScale
   (hasKnowledgeAbout ?a - Agent ?e - Entity) - Capability
   (hasOrganizationalCapability ?a - Organization ?e - Entity) - Capability
   (hasFinancialCapability ?a - Agent ?e - Entity) - Capability
   (hasLogisticalCapability ?a - Agent ?e - Entity) - Capability
   ;; make this obsolete
   (hasKnowledge ?a - Agent) - Capability))
  
;; this will cause Capability to become an rdf:Collection
;;  That is, an ennumerated class where the values are in order.
;;  Hence, you can increase, decrease, increment, or decrement
;;    the function values where Capability is the rdfs:range.

(asv Capability 'owl:oneOf (list 0 1 2 3)) ; order important
