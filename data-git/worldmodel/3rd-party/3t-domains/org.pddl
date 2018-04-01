(in-package :AP)

(define (domain org)
    (:extends foaf)
  (:prefix "org")
  (:uri "http://www.w3.org/ns/org#")
  (:types
   FormalOrganization OrganizationalUnit OrganizationalCollaboration - Organization
   BusinessEntity - FormalOrganization
   Membership Post Site - Thing
   OrganizationalProcess - Project	; added 8/2016
   )
  (:predicates 
   (purpose ?o - Organization ?s - Thing)
   (classification ?o - Organization ?s - Thing)
   (memberOf ?a - Agent ?o - Organization)
   (hasMember ?o - Organization ?a - Agent)
   (subOrganizationOf - fact ?sub ?super - Organization)
   (hasSubOrganization - fact ?super ?sub - Organization)
   (hasUnit - hasSubOrganization ?super - FormalOrganization ?sub - OrganizationalUnit)
   (unitOf - subOrganizationOf ?sub - OrganizationalUnit ?super - FormalOrganization)
   (linkedTo ?o1 ?o2 - Organization)
   (reportsTo ?a1 ?a2 - Agent)
   (hasMembership ?a - Agent ?m - Membership)
   (headOf - memberOf ?p - Person ?o - Organization)
   (hasSite ?o - Organization ?s - Site)
   (siteOf ?s - Site ?o - Organization)
   (hasPrimarySite - siteOf ?s - Site ?o - Organization)
   (basedAt ?p - Person ?s - Site)
   (occupiesPosition ?p - Person ?r - Thing ?o - Organization))
  (:functions
   (member ?m - Membership) - Agent
   (organization ?m - Membership) - Organization)
  )

(inverseOf memberOf hasMember)
(inverseOf hasSite siteOf)
(inverseOf subOrganizationOf hasSubOrganization)
