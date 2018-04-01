(in-package :ap)

;;; Things inherited by all CBRN domains

(define (domain AGENT)
  (:prefix "event")
  (:extends manufacturing capability Geography websearch)
  (:predicates 
   ;; production-routes. "fact" means monotonic property
   (hasRecipe - fact ?e - PhysicalEntity ?r - Recipe)
   (recipeFor - fact ?r - Recipe ?e - PhysicalEntity)
   ;;(madeFrom - fact ?pe1 ?pd2 - PhysicalEntity)
   ;;(requiredEquipment - fact ?pe1 ?pd2 - PhysicalEntity)
   (hasSideEffect - fact ?r - Recipe ?pe - PhysicalEntity)
   ;;
   (conductResearch ?c - Agent ?w - PhysicalEntity)
   (performR&D ?c - Agent ?w - PhysicalEntity)
   (obtainSourceMaterial ?a - Agent ?m - Thing)
   ;;(buildAndTest ?c - Agent ?c - PhysicalEntity)
   (prepareForDelivery ?a - Agent ?w - PhysicalEntity)
   ;; non-monotonic
   ;;(possessesEquipment ?a - Agent ?pr - Recipe)
   ;;(possessComponents ?a - Agent ?ca - Artifact)
   (purified ?a - Agent ?e - PhysicalEntity)
   (store ?a - Agent ?e - PhysicalEntity))
  )

(inverseOf 'hasRecipe 'recipeFor)

(remove-action 'Steal)
