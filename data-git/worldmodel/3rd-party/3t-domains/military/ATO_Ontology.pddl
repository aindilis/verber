(in-package :ap)

;; replace Learning with Learn
;;         OrganizationalProcess with Project

(define (domain ATO_Ontology)
    (:comment "created 2016-05-13")
  (:imports event transportation weapon)
;; imports Transportation.owl nil Mid-level-ontology.owl Communications.owl not found
  (:prefix "SUMO.owl")
  (:uri "http://reliant.teknowledge.com/DAML/SUMO.owl#")
  (:types
   AirOperation MissionEssentialTask SupportingTask UtilityTask - MilitaryProcess
   ATOPackage - AirOperation
   TransportationRequest - Requesting
   Specification - Proposition
   SCLAttribute - RelationalAttribute
   PrimarySCLAttribute SecondarySCLAttribute - SCLAttribute
   MissionObjective MissionStatusAttribute - RelationalAttribute
   AirTankerMissionObjective AirliftMissionObjective CompositeAirOperationsMissionObjective ControlMissionObjective DirectAttackMissionObjective
   ElectronicCombatMissionObjective EscortMissionObjective NavyFlightOperationsMissionObjective ReconnaissanceMissionObjective RepositioningMissionObjective
   StandoffAttackMissionObjective StationMissionObjective SurfaceToSurfaceMissileMissionObjective - MissionObjective
   AreaOfResponsibility - GeographicArea
   AirspaceControlSystem RadarFacility - Organization
   ;;ProjectileWeapon - Weapon
   BallisticWeapon - ProjectileWeapon
   ArtilleryShell Bullet - BallisticWeapon
   ArtilleryRocket - (and ProjectileWeapon SelfPoweredVehicle)
   PrecisionGuidedMunition - Weapon
   FuelTransfer - Putting
   GroundFuelTransfer - FuelTransfer
   PrepositionedMaterielTask - (and SupportingTask Transportation Putting)
   GettingFuel - Transportation
   ModernMilitaryMissile - (and ProjectileWeapon Vehicle)
   Torpedo - (and ModernMilitaryMissile SelfPoweredVehicle)
   GuidedMissile - (and ModernMilitaryMissile SelfPoweredVehicle)
   CruiseMissile - GuidedMissile
   BallisticMissile - (and ModernMilitaryMissile BallisticWeapon)
   AirLaunchedMissile - ModernMilitaryMissile
   MilitaryOrder - ContentBearingObject
   AirTaskingOrder AirspaceControlOrder - MilitaryOrder
   IntelligenceProduct - ContentBearingObject
   PinpointScan RoadReconTracePlot - IntelligenceProduct
   PhotoScan - (and IntelligenceProduct Photograph)
   AreaCoverageScan - IntelligenceProduct
   ATOSpecialInstructions AirspaceControlPlanDocument IFFIdentifier IFFSIFIdentifier - ContentBearingObject
   ATOMissionPlan ATOPackagePlan AirBattlePlan AirspaceControlPlan LegSegmentOfATOMissionLeg - Plan
   ReconnaissanceMissionPlan SupportHelicopterMission SupportHelicopterMissionPlan - ATOMissionPlan
   StationCollectionReconnaissanceMissionPlan - ReconnaissanceMissionPlan
   ElectronicCombatMissionPlan EscortMissionPlan InterdictionMissionPlan OffensiveAirSupportMissionPlan OffensiveCounterAirMissionPlan - ATOMissionPlan
   ElectronicCollectionMissionPlan ElectronicJammingMissionPlan - ElectronicCombatMissionPlan
   AirTankerMissionPlan AirliftMissionPlan DirectAttackMissionPlan - ATOMissionPlan
   AirStationTankerMissionPlan AirTankerCellMissionPlan BuddyTankerMissionPlan - AirTankerMissionPlan
   ATOAircraftGroupPlan - Plan
   ATOMission - (and AirOperation OrganizationalProcess)
   ElectronicCombatMission EscortMission InterdictionMission OffensiveAirSupportMission OffensiveCounterAirMission - ATOMission
   ElectronicCollectionMission - ElectronicCombatMission
   AirliftMission DirectAttackMission - ATOMission
   AirMovementReSupplyMission AirdropMission GroundStationTankerMission - AirliftMission
   AirTankerMission - ATOMission
   IntelligenceAcquisition - Learn ;;(and Learn OrganizationalProcess)
   AirRefuelingControlPoint EndAirRefuelingPoint InitialPoint - TimePosition
   ICAOBaseCode - SymbolicString
   CombatantCommand FriendlyOrderOfBattle - MilitaryOrganization
   ForceLevelOperationalMissionModel - Class
   DeviceConnector - EngineeringComponent
   FuelingConnector - DeviceConnector
   FuelingBoom FuelingDrogue - FuelingConnector
   ConstraintChecking - (and Investigating Comparing)
   ElectronicDevice - ElectricDevice
   ComputerBasedInformationSystem - (and Artifact ElectronicDevice)
   TheaterAirControlSystem - (and ComputerBasedInformationSystem MilitaryUnit)
   CommandAndControlInformationProcessingSystem ModularControlEquipment - ComputerBasedInformationSystem
   CommandAndControlProcess - (and Managing MilitaryProcess)
   CombatAirPatrol - (and AirOperation DefensiveManeuver)
   ChaffReflector - Device
   AirspaceControlMeasure - Entity
   RouteTransitionLine - (and GeographicArea AirspaceControlMeasure)
   NamedAirspaceControlMeasure - (and AirspaceControlMeasure AtmosphericRegion)
   AirspaceDeconfliction - (and OrganizationalProcess AirspaceControlMeasure)
   AirspaceControlMeasureRelation - (and Relation AirspaceControlMeasure)
   AirStation - (and AirTransitway AirspaceControlMeasure)
   CollectionOrbit ElectronicCombatOrbit TankerOrbit - AirStation
   AircraftOrbit - (and AirStation AirspaceControlMeasure)
   AircraftManeuver - (and Translocation IntentionalProcess)
   PackageBreakUp PackageReForm PackageRendezvous PackageSpreadOut - AircraftManeuver
   AircraftTakeOff - (and AircraftManeuver TakingOff)
   AircraftLanding - (and AircraftManeuver Landing)
   AircraftEscortDetach AircraftEscortJoinUp AircraftEscorting - AircraftManeuver
   AerialRefueling - (and AircraftManeuver FuelTransfer))
  (:predicates
    (MilitaryTimeFn ?d - Thing ?r - Thing)
    (PrimarySCLFn ?d - Thing ?r - Thing)
    (SecondarySCLFn ?d - Thing ?r - Thing)
    (airLocationAssignedToATOMission ?d - Thing ?r - Thing)
    (aircraftAssignedToATOMission ?d - Thing ?r - Thing)
    (aircraftAssignedToGroupPlan ?d - Thing ?r - Thing)
    (aircraftFuelType ?d - Thing ?r - Thing)
    (aircraftGroupAssignedToATOMission ?d - Thing ?r - Thing)
    (aircraftMDSIdentifiedSCL ?d - Thing ?r - Thing)
    (aircraftMaximumFuelLoad ?d - Thing ?r - Thing)
    (aircraftOfMission ?d - Thing ?r - Thing)
    (aircraftRefuelingStat ?d - Thing ?r - Thing)
    (aircraftSCLComponentType ?d - Thing ?r - Thing)
    (aircraftSCLOption ?d - Thing ?r - Thing)
    (airspaceControlOrder ?d - Thing ?r - Thing)
    (associatedACMOfACO ?d - Thing ?r - Thing)
    (associatedACOForATO ?d - Thing ?r - Thing)
    (associatedACOForATOMissionPlan ?d - Thing ?r - Thing)
    (commandMissionInPackage ?d - Thing ?r - Thing)
    (contentEffectiveDuring ?d - Thing ?r - Thing)
    (controlMissionOfATOMissionPlan ?d - Thing ?r - Thing)
    (decrementFuelOffload ?d - Thing ?r - Thing)
    (earlierInPlan ?d - Thing ?r - Thing)
    (effectiveTime ?d - Thing ?r - Thing)
    (entryPointOfAirspace ?d - Thing ?r - Thing)
    (equipmentAssignedToATOMission ?d - Thing ?r - Thing)
    (equipmentOperationalStatus ?d - Thing ?r - Thing)
    (equipmentType ?d - Thing ?r - Thing)
    (escortMissionOfMission ?d - Thing ?r - Thing)
    (escortPlanOfMissionPlan ?d - Thing ?r - Thing)
    (exitPointOfAirspace ?d - Thing ?r - Thing)
    (fuelAboard ?d - Thing ?r - Thing)
    (fuelDecrementFromCapacity ?d - Thing ?r - Thing)
    (interdictionTargetOfATOMission ?d - Thing ?r - Thing)
    (locationAssignedToATOMission ?d - Thing ?r - Thing)
    (minimumTimeSpacingAtTRP ?d - Thing ?r - Thing)
    (missileRadiusOfAction ?d - Thing ?r - Thing)
    (missileTypeCruisingSpeed ?d - Thing ?r - Thing)
    (missionAircraftSpeedInPlan ?d - Thing ?r - Thing)
    (missionAssignedToATOPackage ?d - Thing ?r - Thing)
    (missionCallsignOfATOMission ?d - Thing ?r - Thing)
    (missionCommander ?d - Thing ?r - Thing)
    (missionIFFSIFOfATOMission ?d - Thing ?r - Thing)
    (missionInPackage ?d - Thing ?r - Thing)
    (missionNumberOfATOMission ?d - Thing ?r - Thing)
    (missionObjectiveDetailOfATOPlan ?d - Thing ?r - Thing)
    (missionObjectiveForOperationalModel ?d - Thing ?r - Thing)
    (missionObjectiveOfATOPlan ?d - Thing ?r - Thing)
    (missionObjectiveOfRECCEMission ?d - Thing ?r - Thing)
    (missionPlanSupportsRequest ?d - Thing ?r - Thing)
    (missionTypeOfATOPlan ?d - Thing ?r - Thing)
    (operationImplementsPlan ?d - Thing ?r - Thing)
    (packageCallsignOfATOPackage ?d - Thing ?r - Thing)
    (planCommandMissionInPackage ?d - Thing ?r - Thing)
    (planGoal ?d - Thing ?r - Thing)
    (planMissionCommander ?d - Thing ?r - Thing)
    (planTimeInterval ?d - Thing ?r - Thing)
    (primaryMissionObjective ?d - Thing ?r - Thing)
    (primaryTargetOfATOMission ?d - Thing ?r - Thing)
    (productOfRECCEMission ?d - Thing ?r - Thing)
    (receiverRefuelingAircraft ?d - Thing ?r - Thing)
    (refuelingAmount ?d - Thing ?r - Thing)
    (refuelingArrivalTimeOfPlan ?d - Thing ?r - Thing)
    (refuelingBeaconCode ?d - Thing ?r - Thing)
    (refuelingConnection ?d - Thing ?r - Thing)
    (refuelingFinishTimeOfPlan ?d - Thing ?r - Thing)
    (refuelingLocationOfPlan ?d - Thing ?r - Thing)
    (refuelingMissionOfMission ?d - Thing ?r - Thing)
    (refuelingPlanOfMissionPlan ?d - Thing ?r - Thing)
    (routeAssignedToATOMissionPlan ?d - Thing ?r - Thing)
    (secondaryMissionObjective ?d - Thing ?r - Thing)
    (subTaskTypeOfATOMission ?d - Thing ?r - Thing)
    (supportsMissionPlan ?d - Thing ?r - Thing)
    (targetForOASInATOMission ?d - Thing ?r - Thing)
    (targetForOCAInATOMission ?d - Thing ?r - Thing)
    (targetForWeaponType ?d - Thing ?r - Thing)
    (targetOfATOMission ?d - Thing ?r - Thing)
    (targetOptionOfSCL ?d - Thing ?r - Thing)
    (temporalSafetyZone ?d - Thing ?r - Thing)
    (timeOfATOMissionPlan ?d - Thing ?r - Thing)
    (uniqueIdentifier ?d - Thing ?r - Thing)
    (uniquelyRepresents ?d - Thing ?r - Thing)
    (unitAssignedToATOMission ?d - Thing ?r - Thing)
    (weaponRange ?d - Thing ?r - Thing)
    (numberOfAircraftInMissionPlan ?d - Thing ?r - Thing)
    (numberOfAircraftTypeInMissionPlan ?d - Thing ?r - Thing)))


(relabel-classes
 (list
   (cons 'RouteTransitionLine "Route Transition Line")
   (cons 'BallisticMissile "ballistic missile")))
