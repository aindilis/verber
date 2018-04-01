(in-package :ap)

#|
All commented-out classes have been moved to relevant .pddl domains.
Those should have the same prefix as this so no harm.

remove:
all predicates defined in physob: possesses, contains

eyeware is a property?

add Planner - Agent for counterplanning

added EquipmentRole - Equipment
Equipment - EquipmentRole
to make them equivalent classes

Took out these, all subPropertyOf event:TemporalRelations.
use OWl-time directly. No need for these

(before ?a ?b - Entity)
(hasEnd ?a ?b - Entity)
(hasDateTimeDescription ?a ?b - Entity)
(intervalOverlappedBy ?a ?b - Entity)
(intervalFinishedBy ?a ?b - Entity)
(intervalEquals ?a ?b - Entity)
(intervalDuring ?a ?b - Entity)
(intervalFinishes ?a ?b - Entity)
(intervalOverlaps ?a ?b - Entity)
(hasDurationDescription ?a ?b - Entity)
(intervalContains ?a ?b - Entity)
(intervalStarts ?a ?b - Entity)
(intervalAfter ?a ?b - Entity)
(intervalStartedBy ?a ?b - Entity)

|#

(define (domain event)
  (:prefix "event")
  (:uri "http://www.fsf.org/ontologies/2012/event#")
  (:extends foaf org wgs84_pos Geography) ; added, CE, 2016-02
  (:types
   Entity - object
   SpatioTemporalEntity - Entity
   Quality - SpatioTemporalEntity
   Length Weight - Quality
   Height Width - Length
   PhysicalEntity - SpatioTemporalEntity
   Environment BiologicalEntity - PhysicalEntity
   Soil Weather - Environment
   Disease ChemicalEntitiesOfBiologicalInterest - BiologicalEntity
   DiseaseByInfectiousAgent - Disease
   ChemicalRole ChemicalEntity - ChemicalEntitiesOfBiologicalInterest
   Explosive - ChemicalRole
   SocialEntity - PhysicalEntity
   ;;LegalPerson - Agent
   ;;Person - LegalPerson
   ArbitraryGroupOfPeople - SocialEntity
   EventAudience TourGroup TransportPassengerGroup - ArbitraryGroupOfPeople
   MilitaryOrganization ReligiousOrganization PoliceOrganization - FormalOrganization
  ;; ArbitraryGroupOfPeople MilitaryOrganization - Organization
   ;; moved to commerce.pddl 2016/06/24
;    CommercialOrganization - BusinessEntity ; added 2016-02, was direct before
; 					; extending org
;    FinancialOrganization TradeAssociation - CommercialOrganization
   SocialGroup LegalCorporation TerroristGroup NonGovernmentalOrganization 
   GovernmentOrganization InternationalOrganization PoliticalOrganization
   CriminalOrganization NotForProfitOrganization ;;BoardOfDirectors
   IntelligenceOrganization GeoPoliticalEntity EducationalOrganization - Organization
   AlumniOrganization FraternalOrganization - SocialGroup
   IntelligenceOrganization Government - GovernmentOrganization
   OrganizationOfCountries - InternationalOrganization
   PoliticalParty LobbyingOrganization - PoliticalOrganization
   
   NonAgentiveEntity - SocialEntity
   Law Language Religion - NonAgentiveEntity
   Artifact - PhysicalEntity
   Equipment - Artifact
   EquipmentRole - Equipment		; make them equlivelant classes
   Equipment - EquipmentRole		; see record-class
   ;;MachineSystem ManufacturedForm Machine ChemicalEqupment NuclearRadiologicalEquipment 
   ;;Supply MachineComponent BiologicalEquipment - Equipment
   InformationBearingEntity - Artifact
   Document - InformationBearingEntity
   Book OfficialDocument - Document  ;;FinancialDocument 
   ;; moved to commerce.pddl
;    RealEstateAgreement CreditCard SalesReceipt - FinancialDocument
;    Lease Mortgage RentalAgreement - RealEstateAgreement
;    BillOfSales Invoice - FinancialDocument
   PersonalIdentityDocument AlienRegistrationDocument BirthCertificate - OfficialDocument
   NationalIdentityDocument Passport MilitaryID - PersonalIdentityDocument
   CriminalRecord Deed OperatorsLicense - OfficialDocument ;TaxIDDocument
   PrisonRecord ArrestSheet - CriminalRecord
   DriversLicense - (and OperatorsLicense PersonalIdentityDocument)
   PilotsLicense - OperatorsLicense
   MarriageLicense VoterRegistrationCard - OfficialDocument ; CommercialLicense
   ;;VendorsLicense - CommercialLicense
   PropertyRegistration VehicleTitle - OfficialDocument
   VehicleRegistration GunRegistration - PropertyRegistration
   ProfessionalCertification - OfficialDocument
   UnionCard LawLicense MedicalLicense - ProfessionalCertification
   DeathCertificate WorkPermit Visa - OfficialDocument
   ;;FinancialStatement - (and OfficialDocument FinancialDocument)
   TravelDocument Letter - Document
   TravelTicket - (and TravelDocument OfficialDocument)
   Itinerary - TravelDocument
   DigitizedInformationBearingEntity - InformationBearingEntity
   Software Database EmailEntity Website ComputerFile - DigitizedInformationBearingEntity
   Service Program - Software
   Facility - Artifact
   CommercialFacility MilitaryFacility MunicipalFacility ResidentialFacility - Facility
   GroceryStore Bank DepartmentStore AgriculturalSupplyStore - CommercialFacility
   ConvenienceStore - GroceryStore
   HardwareStore - DepartmentStore
   Apartment House - ResidentialFacility
   IntelligenceFacility MilitaryBase - MilitaryFacility
   FireStation PoliceStation - MunicipalFacility
;;   TransportationFacility - Facility
;;   Airport BusStop PortFacility 
;;   MetroStation TrainStation - TransportationFacility
   HealthFacility ScientificFacility - Facility
   PhysicianOffice HealthClinic Hospital - HealthFacility
   Laboratory - ScientificFacility
   TransportationDevice Sensor Infrastructure MobileArtifact - Artifact ;;WeaponComponent
;;   Rocket Bullet - WeaponComponent
   ;;; commented-out moved to ground.pddl, transportation.pddl, water.pddl
;;   Vehicle - (and MobileArtifact TransportationDevice)
;;   LandVehicle 
;;   SpaceVehicle CommercialVehicle WaterVehicle - Vehicle
;;   WheeledVehicle - LandVehicle
;;   Bicycle Truck Bus
;;   Motorcycle Automobile - WheeledVehicle
;;   Train - LandVehicle
;;   MilitaryVehicle AmphibiousVehicle AutonomousVehicle - Vehicle
;;   ArmoredVehicle - MilitaryVehicle
;;   AirVehicle - Vehicle
;;   Helicopter Airplane - AirVehicle
   MobileStructure - MobileArtifact
;   Weapon - Artifact
;    ExplosiveWeapon - Weapon
;    Bomb Grenade IED - ExplosiveWeapon
;    Artillery - Weapon
;    RocketLauncher - Artillery
;    Firearm - Weapon
;    AutomaticWeapon Rifle Shotgun
;    Handgun - Firearm
   StationaryArtifact - Artifact
   StationaryConveyor - (and StationaryArtifact TransportationDevice)
   Pipeline Elevator Escalator - StationaryConveyor
   Bridge Building - StationaryArtifact
   CognitiveEntity - PhysicalEntity
   InformationContentEntity Account Analysis Formula - CognitiveEntity
   ;;EconomicEntity - InformationContentEntity
   ;;Money Cost Price - EconomicEntity
   WebAccount LibraryAccount UtilityAccount - Account ;;RetailStoreAccount CreditCardAccount
   ;;BrokerageAccount LibraryAccount - Account
   WebsiteRegistration EmailAccount - WebAccount
   UserGroupAccount - WebsiteRegistration
   TelephoneAccount - UtilityAccount
   UnconsciousContentEntity Plan Metadata - InformationContentEntity
   Dream Hallucination - UnconsciousContentEntity
   Recipe - Plan
   TaskSpecification Opinion Objective Identifier BeliefSystem FieldOfStudy Fiction - InformationContentEntity
   StateOfMatter OrganicEntity Substance - PhysicalEntity
   Solid Gas Liquid Plasma - StateOfMatter
   LivingEntity - OrganicEntity
   Animal - LivingEntity
   Human - (and Person Animal)
   ChemicalMaterial NuclearRadiologicalMaterial Water - Substance
   ChemicalCompound ChemicalElement - ChemicalMaterial
   Oxide Metal - ChemicalCompound
   MetalOxide - (and Oxide Metal)
   BiologicalMaterial - (and LivingEntity Substance)
   InfectiousOrganism MicroOrganism - BiologicalMaterial
   ControlledSubstance Fuel - Substance
   Contraband - ControlledSubstance
   Oil Gasoline - Fuel
   Emission - PhysicalEntity
   ;; these extend classes in Geography:
   Location - (and SpatialThing PhysicalEntity) ; SpatialThing added 2016-02
   RelativeLocation - Location
   Address GeographicArea GeoPhysicalEntity - SpatialRegion
   StreetAddress CoordinateDeterminedAddress - Address
   Continent LandArea Island WaterArea Hemisphere - GeographicRegion
   AutonomousArea DependentArea - GeopoliticalArea
   GeographicPolygon GeographicDonut GeographicSwath
   GeographicPoint GeographicLine GeographicEllipse GeographicCircle - GeographicArea
   Mountain River - GeoPhysicalEntity
   CommunicationNode CyberAddress NamedLocation PhysicalAddress - Location
   TelephoneNumber - CommunicationNode
   EmailAddress - (and CommunicationNode CyberAddress)
   
   Event - SpatioTemporalEntity
   Eventive - Event
   NonAgentiveEvent NaturalEvent ArtificialEvent - Eventive
   Occur - NonAgentiveEvent
   NaturalDisaster NaturalLivingEvent - NaturalEvent
   Flood Earthquake Tornado Hurricane VolcanicEruption - NaturalDisaster
   Tsunami - Flood
   Move - ArtificialEvent
   Accompany Combine Cover Pour - Move
   Amalgamate React Mix - Combine
   Walk Enter Leave Travel Return - Go
   Run - Walk
   Break_Into - Enter
   Evacuate - Leave
   Fly Embark Drive - Travel
   ;;Mill - Carve
   Filter - Wipe
   Lead Follow Escort - Accompany
   Guide - Lead
   Steer Shepherd - Guide
   Conduct - Escort

   PersonalEvent PersonnelAction Conflict BusinessEvent - ArtificialEvent
   Resigning RemovingFromOffice - PersonnelAction
   Damage - Conflict
   Harm Degrade - Damage
   PhysicalHarm CognitiveHarm - Harm
   Kill Destroy Injure Fight - PhysicalHarm
   Murder - Kill
   Stab Wound Shoot Hit - Injure
   Demean - CognitiveHarm
   Divorce Wedding - PersonalEvent
   Death - (and PersonalEvent NaturalLivingEvent)
   Birth - (and PersonalEvent NaturalLivingEvent)
   Hold Achieve Attempt - ArtificialEvent
   Keep Confine Grasp - Hold
   Finish Vote Elect Begin Accomplish ActFor - Achieve
   Arrive End Succeed - Finish
   Prevent Help MutuallyAct - ArtificialEvent
   Stop Avoid - Prevent
   Meet Cooperate Conspire Marry - MutuallyAct
   Confer - Meet
   CognitiveEvent - ArtificialEvent
   Communicate Study Calculate - CognitiveEvent
   Request - Communicate
   Ask Command Persuade - Request
   CommunicateElectronically Report Encode Tell Warn Validate Promise Approve - Communicate
   Fax InstantMessage Telegraph Text Telephone Radio
   Telecast Broadcast NewsPost Wire Signal Telex - CommunicateElectronically
   Characterize Classify - Report
   Judge - CognitiveEvent
   Assess Suspect - Judge
   Investigate Learn - Study
   Search - Investigate
   Discover - Learn
   Research - Study
   Perceive - CognitiveEvent
   Taste Touch Hear Smell See - Perceive
   Protect TransferEvent - ArtificialEvent
   Hide Secure Enforce - Protect
   Translocation TransferringControl TransferringPossession TransferringOwnership - TransferEvent
   TravelEvent TransportationEvent - Translocation
   TravelSegment - TravelEvent
   Transport - (and TransportationEvent Move)
   Disperse Transfer Place Give - Transport
   Spray Distribute Explode Expell Transmit Expose - Disperse
   Sell Send Throw - Give
   Bill - Sell
   Mail Carry Ship - Send
   Email - (and Mail CommunicateElectronically)
   MailingShipping - TransportationEvent
   Obtain Allow - ArtificialEvent
   Purchase - Obtain
   Hire Rent - Purchase
   Take Use Consume Steal Gather - Obtain
   Take_Over - Take
   Eat - Consume
   Cheat Smuggle - Steal
   SocialEvent - ArtificialEvent
   JoiningAnOrganization - (and SocialEvent TransferEvent)
   Hiring - (and PersonnelAction JoiningAnOrganization)
   ArmedConflict - SocialEvent
   LeavingAnOrganization - (and SocialEvent TransferEvent)
   QuittingAJob Firing - (and PersonnelAction LeavingAnOrganization)
   Make - ArtificialEvent
   Activate - (and Make Begin)
   Develop Perform Integrate Work Copy Grow Emit Modify Prepare Configure - Make
   ;;Build Design - Develop
   ;;Create Construct Manufacture - Build
   EmitSound EmitSmell EmitSubstance - Emit
   ChangeShape Paint Purify Weaponize Disassemble Dry Transform - Modify
   Enlarge Shorten - ChangeShape
   Concentrate - Purify

   Stative IntensionalEvent - Event
   DynamicState StaticState - Stative
   Become Change - DynamicState
   Appear - Become
   Moving ChangeBodilyState Sound - Change
   ContiguousLocation Employment CognitiveState - StaticState
   SymmetricContiguousLocation NonSymmetricContiguousLocation - ContiguousLocation
   EmotionalState Believe - CognitiveState
   Amuse - EmotionalState
   Intend Consider Think Desire Emotive Intuit Conceive Hypothesize Imagine - Believe
   PlanEvent - Intend
   Experience Feel - Emotive
   Know Care - CognitiveState
   Regret Deny Understand - Know
   Like - Care
   Love - Like
   Is BodyInternalState Possess - StaticState
   IsPredicative IsAttributive - Is
   Exist IsPresent IsMemberOf - IsPredicative
   IsAlive IsDead - Exist
   Ownership - Possess
   Role - StaticState
   BusinessRole - Role
   Customer - (and BusinessRole Agent)
   Vendor - (and BusinessRole CommercialOrganization)
   Retailer Distributor Supplier
   ServiceProvider Wholesaler Reseller Shipper CertifiedVendor - Vendor
   StreetVendor - Retailer
   AbstractEntity - Entity
   Time Number UnitOfMeasure LexicalEntity Predication Quantity Proposition - AbstractEntity
   ;; see time.pddl
 ;;  DayOfWeek DateTimeDescription TemporalUnit
  ;; TemporalEntity DurationDescription TimeZone - Time
   SpatialUnitOfMeasure FinancialUnitOfMeasure - UnitOfMeasure
   PhysicalQuantity - Quantity
   ;;Collection - AbstractEntity
   ;;PhysicalCollection - (and Collection PhysicalEntity)
   )
  (:predicates
    ;;(hasSymmetricAgentAERoles ?a ?b - Entity)
    ;;(accountHolder ?a ?b - Entity)
    ;;(agentOf ?a ?b - Entity)  moved to ap.pddl
    (allegiance ?a ?b - Entity)
    (registeredProperty ?a ?b - Entity)
    (inDateTime ?a ?b - Entity)
    (husband ?a ?b - Entity)
    (headquartersLocation ?a ?b - Entity)
    (hasHeight ?a ?b - Entity)
    (usedBy ?a ?b - Entity)
    (subsidiaryOf ?a ?b - Entity)
    (product ?a ?b - Entity)
    (owns ?a ?b - Entity)
    (cardOfAccount ?a ?b - Entity)
    (associatedEmailAddress ?a ?b - Entity)
    (geoPolygonLine ?a ?b - Entity)
    (eventContinuousCauses ?a ?b - Entity)
    (hasSense ?a ?b - Entity)
    (child ?a ?b - Entity)
    (nativeLanguage ?a ?b - Entity)
    (fromLocation ?a ?b - Entity)
    (uses ?a ?b - Entity)
    (hasDimensions ?a ?b - Entity)
    (usesGeoReferenceSystem ?a ?b - Entity)
    (sourceOf ?a ?b - Entity)
    (attendeeOfMeeting ?a ?b - Entity)
    (letterFrom ?a ?b - Entity)
    (loanHolder ?a ?b - Entity)
    (hasUnitOfMeasure ?a ?b - Entity)
    (startDate ?a ?b - Entity)
    (callToTelephoneNumber ?a ?b - Entity)
    (hasTelephoneNumber ?a ?b - Entity)
    (during ?a ?b - Entity)
    (geoLineStart ?a ?b - Entity)
    (descendent ?a ?b - Entity)
    (possessorOf ?a ?b - Entity)
    (overlapsSpatially ?a ?b - Entity)
    ;;(contains ?a ?b - Entity)
    (digitizedAs ?a ?b - Entity)
    (eventCauses ?a ?b - Entity)
    (socialParticipant ?a ?b - Entity)
    (emailAddressOf ?a ?b - Entity)
    (transporter ?a ?b - Entity)
    (capitalCityOf ?a ?b - Entity)
    (citizenshipCountry ?a ?b - Entity)
    ;;(possesses ?a - Agent ?b - PhysicalEntity) ;
    (customerTo ?a ?b - Entity)
    (vehicleTitled ?a ?b - Entity)
    (addressCountry ?a ?b - Entity)
    (home ?a ?b - Entity)
    (eventSucceeds ?a ?b - Entity)
    (vehicleUsed ?a ?b - Entity)
    (traveller ?a ?b - Entity)
    ;;(vendorFor ?a ?b - Entity)
    (eventOccursDuring ?a ?b - Entity)
    (ownedObject ?a ?b - Entity)
    ;;(doesBusinessWith ?a ?b - Entity)
    (hasEmailAddress ?a ?b - Entity)
    (spouse ?a ?b - Entity)    
    (adoptiveParent ?a ?b - Entity)
    (representedAs ?a ?b - Entity)
    (alumnusOf ?a ?b - Entity)
    (employerOf ?a ?b - Entity)
    ;;(transactionAmount ?a ?b - Entity)
    (dependent ?a ?b - Entity)
    (travelCarrier ?a ?b - Entity)
    (issuingAuthority ?a ?b - Entity)
    (goalOf ?a ?b - Entity)
    (owner ?a ?b - Entity)
    (registeredOwner ?a ?b - Entity)
    (brother ?a ?b - Entity)
    (militaryIDOf ?a ?b - Entity)
  ;;  (organizationMembers ?a ?b - Entity)
  ;;  (meetsSpatially ?a ?b - Entity)
    ;;(hasPriceOf ?a ?b - Entity)
    (eventPartiallyCauses ?a ?b - Entity)
    ;;(businessAssociate ?a ?b - Entity)
    (eventPrecedes ?a ?b - Entity)
    (hasLieutenant ?a ?b - Entity)
    (associate ?a ?b - Entity)
    (friend ?a ?b - Entity)
    (birthDate ?a ?b - Entity)
    (mother ?a ?b - Entity)
    (reasonFor ?a ?b - Entity)
    (inputs ?a ?b - Entity)
    (purposeOf ?a ?b - Entity)
    (dateOfExpiration ?a ?b - Entity)
    (bannedBy ?a ?b - Entity)
    ;;(madeBy ?a ?b - Entity)
    (affectedEntityOf ?a ?b - Entity)
    (eventEndsAtTime ?a ?b - Entity)
    (supports ?a ?b - Entity)
    (hasBeliefSystem ?a ?b - Entity)
    ;;(temporalRelations ?a ?b - Entity)
    (travelAreaRecorded ?a ?b - Entity)
    (outputsCreated ?a ?b - Entity)
    (isFinancerOf ?a ?b - Entity)
    (dayOfWeek ?a ?b - Entity)
    ;;(hasFinancer ?a ?b - Entity)
    (swathTopLeft ?a ?b - Entity)
    (eventOverlaps ?a ?b - Entity)
    (employer ?a ?b - Entity)
    (employee ?a ?b - Entity)
    (birthDateRecorded ?a ?b - Entity)
    (subEvents ?a ?b - Entity)
    (cohabitantPartner ?a ?b - Entity)
    (overlapsLocation ?a ?b - Entity)
    ;;(after ?a ?b - Entity)
    (bloodRelation ?a ?b - Entity)
    (employeeOf ?a ?b - Entity)
    (telephoneNumberOf ?a ?b - Entity)
    (near ?a ?b - Entity)
    (overlapsTemporally ?a ?b - Entity)
    (adoptedChild ?a ?b - Entity)
    (eventIsCausedBy ?a ?b - Entity)
    (hasReligion ?a ?b - Entity)
    (mainParticipant ?a ?b - Entity)
    (classmates ?a ?b - Entity)
    (height ?a ?b - Entity)
    (wife ?a ?b - Entity)
    (inhabits ?a ?b - Entity)
    (deathCertificateOf ?a ?b - Entity)
    ;;(hasBeginning ?a ?b - Entity)
    (graduateOf ?a ?b - Entity)
    (directingAgent ?a ?b - Entity)
    (actsFor ?a ?b - Entity)
    ;;(eventCoincidesWith ?a ?b - Entity)
    (publicationsInField ?a ?b - Entity)
    (guardian ?a ?b - Entity)
    ;;(hasVendorsLicense ?a ?b - Entity)
    (accountHolderAddress ?a ?b - Entity)
    (ownedBy ?a ?b - Entity)
    (lengthMeasure ?a ?b - Entity)
    (coAuthors ?a ?b - Entity)
    (hasTeacher ?a ?b - Entity)
    (ancestor ?a ?b - Entity)
    (authorOf ?a ?b - Entity)
    (employedBy ?a ?b - Entity)
    (isLeaderOf ?a ?b - Entity)
    (volumeMeasure ?a ?b - Entity)
    (registeredVehicle ?a ?b - Entity)
    (profession ?a ?b - Entity)
    (olderThan ?a ?b - Entity)
    (hasServiceProvider ?a ?b - Entity)
    (hasPhysicalPart ?a ?b - Entity)
    (daughter ?a ?b - Entity)
    (physicallyConnected ?a ?b - Entity)
    (serviceProviderOf ?a ?b - Entity)
    (travelCompanion ?a ?b - Entity)
    (hasShareholder ?a ?b - Entity)
    ;;(makes ?a ?b - Entity)
    (son ?a ?b - Entity)
    (parent ?a ?b - Entity)
    ;;(eventDisjointCauses ?a ?b - Entity)
    (toLocation ?a ?b - Entity)
    (participantOfEvent ?a ?b - Entity)
    (sibling ?a ?b - Entity)
    (researchSpecialty ?a ?b - Entity)
    (hasPhysicalAddress ?a ?b - Entity)
    (controlledBy ?a ?b - Entity)
    (licensedOperator ?a ?b - Entity)
    (timeZone ?a ?b - Entity)
    (birthCertificateOf ?a ?b - Entity)
    ;;(vendorTo ?a ?b - Entity)
    (businessRole ?a ?b - Entity)
    (hasSubLocation ?a ?b - Entity)
    (identificationOf ?a ?b - Entity)
    (hasSuperLocation ?a ?b - Entity)
    (sister ?a ?b - Entity)
    (transferredObject ?a ?b - Entity)
    (birthPlace ?a ?b - Entity)
    (father ?a ?b - Entity)
    (frontsFor ?a ?b - Entity)
    (objectActedOn ?a ?b - Entity)
    (inside ?a ?b - Entity)
    (actedBy ?a ?b - Entity)
    (nationalityCountry ?a ?b - Entity)
    (coParticipants ?a ?b - Entity)
    (hasNecessaryPart ?a ?b - Entity)
    (result ?a ?b - Entity)
    (swathBottomLeft ?a ?b - Entity)
    ;;(hasSymmetricThemeAERoles ?a ?b - Entity)
    (familyRelation ?a ?b - Entity)
    (locatedAt ?a ?b - Entity)
    (residesAt ?a ?b - Entity)
    (transportee ?a ?b - Entity)
    (coOwners ?a ?b - Entity)
    (cohabitantGeneric ?a ?b - Entity)
    (hasNationalIDFrom ?a ?b - Entity)
    (patientOf ?a ?b - Entity)
    (deedForProperty ?a ?b - Entity)
    (causes ?a ?b - Entity)
    (toGeneric ?a ?b - Entity)
    (personalEnemies ?a ?b - Entity)
    (length ?a ?b - Entity)
    (hasLeader ?a ?b - Entity)
    (dateIssued ?a ?b - Entity)
    (legalFamilyRelation ?a ?b - Entity)
    (locationOf ?a ?b - Entity)
    (isGovernmentOf ?a ?b - Entity)
    (presentAt ?a ?b - Entity)
    (residence ?a ?b - Entity)
    (age ?a ?b - Entity)
    (experiencerOf ?a ?b - Entity)
    (race ?a ?b - Entity)
    (instrumentOf ?a ?b - Entity)
    (hasNegative ?a ?b - Entity)
    (geopoliticalSubdivision ?a ?b - Entity)
    (unitType - fact ?a ?b - Entity)	;
    (hasPart - fact ?a ?b - Entity)	;
    ;;(agent ?a ?b - Entity)
    (swathTopRight ?a ?b - Entity)
    (actors ?a ?b - Entity)
    (diameter ?a ?b - Entity)
    (maritalRelative ?a ?b - Entity)
    (issuedTo ?a ?b - Entity)
    (weight ?a ?b - Entity)
    (meetingAttendees ?a ?b - Entity)
    (letterTo ?a ?b - Entity)
    (hasQuantity ?a ?b - Entity)
    (massMeasure ?a ?b - Entity)
    ;;(isSubOrganizationOf ?a ?b - Entity)
    (themeOf ?a ?b - Entity)
    (situationalRole ?a ?b - Entity)
    (hasResult ?a ?b - Entity)
    ;;(geographicSubregion ?a ?b - Entity)
    (instrument ?a ?b - Entity)
    (biologicalParentWith ?a ?b - Entity)
    (eventReportedAtTime ?a ?b - Entity)
    (callFromTelephoneNumber ?a ?b - Entity)
    ;;(precondition ?a ?b - Entity)
    (accountProvider ?a ?b - Entity)
    (deathDateRecorded ?a ?b - Entity)
    (measurementUnit ?a ?b - Entity)
    (hasPersonalMeasurement ?a ?b - Entity)
    (hasAddress ?a ?b - Entity)
    (containsInformation ?a ?b - Entity)
    (issuedByCountry ?a ?b - Entity)
    (hasOnlineAccount ?a ?b - Entity)
    (eventImmediatelySucceeds ?a ?b - Entity)
    (swathBottomRight ?a ?b - Entity)
    (hasWeight ?a ?b - Entity)
    (width ?a ?b - Entity)
    (partOf ?a ?b - Entity)
    (predicationOf ?a ?b - Entity)
    (experiencer ?a ?b - Entity)
    ;;(hasAccount ?a ?b - Entity)
    (fromGeneric ?a ?b - Entity)
    (endDate ?a ?b - Entity)
    (eventLocation ?a ?b - Entity)
    ;;(customerFor ?a ?b - Entity)
    (hasAccessTo ?a - Entity ?b - Thing)
    (dateOfTravel ?a ?b - Entity))
  (:functions
   ;;(alive ?a - Agent) - Boolean
   (facialHair - fact ?a - Entity)
    ;;(geoEllipseLongRadius - fact ?a - Entity)
    ;;(geoLineBearing - fact ?a - Entity)
    (bloodRhFactor - fact ?a - Entity)
    (swathViewAngle - fact ?a - Entity)
    ;;(geoLineDegree - fact ?a - Entity)
    ;;(geoEllipseShortRadius - fact ?a - Entity)
    (ethnicity - fact ?a - Entity)
    (alias - fact ?a - Entity)
    (eyeColor - fact ?a - Entity)
    (addressPostalCode - fact ?a - Entity)
    ;;(name - fact ?a - Entity)
    (physicalBuild - fact ?a - Entity)
    (accountNumber - fact ?a - Entity)
    (addressStreetNumber - fact ?a - Entity)
    (citizenshipStatus - fact ?a - Entity)
    (nameSuffix - fact ?a - Entity)
    (dead - fact ?a - Entity)
    (quantity - fact ?a - Entity)
    (addressStreet - fact ?a - Entity)
    (geoLineLength - fact ?a - Entity)
    (emailUserName - fact ?a - Entity)
    (dead? - fact ?a - Entity)
    (gender - fact ?a - Entity)
    ;;(geoEllipseShortDegree - fact ?a - Entity)
    (quantityNumber - fact ?a - Entity)
    ;;(geoEllipseLongBearing - fact ?a - Entity)
    (telephoneExtension - fact ?a - Entity)
    (makesProductType - fact ?a - Entity)
    (surname - fact ?a - Entity)
    (addressPlaceName - fact ?a - Entity)
    (hasIPAddress - fact ?a - Entity)
    (hasSkill - fact ?a - Entity)
    (telephoneNumberExchange - fact ?a - Entity)
    (militaryRank - fact ?a - Entity)
    (hasPastEmployer - fact ?a - Entity)
    (telephoneNumber_Main - fact ?a - Entity)
    (addressCity - fact ?a - Entity)
    (fullName - fact ?a - Entity)
    (eyeDescription - fact ?a - Entity)
    (skinTone - fact ?a - Entity)
    (title - fact ?a - Entity)
    (taxIDNumber - fact ?a - Entity)
    (emailDomain - fact ?a - Entity)
    (eventPurpose - fact ?a - Entity)
    (namePatronymic - fact ?a - Entity)
    (hasURL - fact ?a - Entity)
    (weightDescription - fact ?a - Entity)
    (employeeTitle - fact ?a - Entity)
    ;;(addressStateOrProvince - fact ?a - Entity)
    (alsoKnownAs ?a - Entity ?b - Entity) ;
    (employmentPositionType - fact ?a - Entity)
    (givenName - fact ?a - Entity)
    (organizationGoals - fact ?a - Entity)
    (geoEllipseShortBearing - fact ?a - Entity)
    (visibleMark - fact ?a - Entity)
    (complexion - fact ?a - Entity)
    (personName - fact ?a - Entity)
    (middleName - fact ?a - Entity)
    (publications - fact ?a - Entity)
    (geoCircleRadius - fact ?a - Entity)
    (birthNameRecorded - fact ?a - Entity)
    (sizeOfOrganization - fact ?a - Entity)
    (hairDescription - fact ?a - Entity)
    (deathNameRecorded - fact ?a - Entity)
    (geoDonutOuterRadius - fact ?a - Entity)
    (nickname - fact ?a - Entity)
    (eyewear - fact ?a - Entity)
    (maritalStatus - fact ?a - Entity)
    (positionInOrganization - fact ?a - Entity)
    (nameMatronymic - fact ?a - Entity)
    ;;(manufacturingSector - fact ?a - Entity)
    (nationality - fact ?a - Entity)
    (educationLevel - fact ?a - Entity)
    (stockTickerSymbol - fact ?a - Entity)
    (abaRoutingNumber - fact ?a - Entity)
    (namePrefix - fact ?a - Entity)
    (accountName - fact ?a - Entity)
    (hairColor - fact ?a - Entity)
    (annualizedSalary - fact ?a - Entity)
    (telephoneCountryPrefix - fact ?a - Entity)
    ;;(geoDonutInnerRadius - fact ?a - Entity)
    (maidenName - fact ?a - Entity)
    (registeredSerialNumber - fact ?a - Entity)
    (identificationNumber - fact ?a - Entity)
    (telephoneAreaCode - fact ?a - Entity)
    (physicalAbnormality - fact ?a - Entity)
    (militaryIDNumber - fact ?a - Entity)
    (bloodABOGroup - fact ?a - Entity)
    ;;(geoEllipseLongDegree - fact ?a - Entity)
    ;;(swathViewHeight - fact ?a - Entity)
    (emailAddressString - fact ?a - Entity)
    (telephoneNumberCity - fact ?a - Entity))
  )
  


