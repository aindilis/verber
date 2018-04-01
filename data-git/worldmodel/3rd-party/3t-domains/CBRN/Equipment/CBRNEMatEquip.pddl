(in-package :ap)


(define (domain CBRNEMatEquip)
  (:imports AGENT CBRNEChemical)
  (:prefix "CBRNEMatEquip")
  (:uri "http://agent.jhuapl.edu/2010/07/02/equipment/CBRNEMatEquip#")
  (:types
   Radiation - MaterialEntity
   ElectromagneticRadiation - Radiation
   VacuumUltraviolet Ultraviolet - ElectromagneticRadiation
   ExtremeUltraviolet FarUltraviolet - VacuumUltraviolet
   Infrared - ElectromagneticRadiation
   MidWaveInfrared NearInfrared LongWaveInfrared
   FarInfrared ShortWaveInfrared - Infrared
   RadioWave - ElectromagneticRadiation
   MicrowaveWave MillimeterWave - RadioWave
   Visible XRay - ElectromagneticRadiation
   NuclearRadiation - Radiation
   BetaParticle - NuclearRadiation
   Positron Electron - BetaParticle
   AlphaParticle - NuclearRadiation
   GammaRay - (and NuclearRadiation ElectromagneticRadiation)
   CosmicRay NeutronRadiation - NuclearRadiation
   Mixing - Equipment
   HighViscosityMixer - Mixing
   TwinScrewMixer TaffyPuller GridlapMixer - HighViscosityMixer
   Textile - Equipment
   Towel - Textile
   StainedTowel - Towel
   Electronic - Equipment
   HighImpedanceMeter - Electronic
   Safety - Equipment
   PersonalProtectiveEquipment - Safety
   Clothing - PersonalProtectiveEquipment
   Gloves - Clothing
   RespiratoryProtection - PersonalProtectiveEquipment
   Respirator - RespiratoryProtection
   FaceProtection - PersonalProtectiveEquipment
   FaceShield - FaceProtection
   Mark1Kit - Safety
   HeatShield - (and Safety Electronic)
   Sink PrepEquipment SolidAddition - Equipment
   StainedSink - Sink
   AnalyticalDevice - Equipment
   PhotonDetector - AnalyticalDevice
   PhotomultiplierTube - PhotonDetector
   TemperatureController - AnalyticalDevice
   Heater - TemperatureController
   NonIndustrialHeater - Heater
   HotAirOven MicrowaveOven - NonIndustrialHeater
   HouseholdOven - HotAirOven
   Flame - NonIndustrialHeater
   GasFlame - Flame
   Torch - GasFlame
   ButaneTorch AcetyleneTorch PropaneTorch - Torch
   Burner - GasFlame
   CannedHeat MekerFisherBurner BunsenBurner - Burner
   FirePit Candle - Flame
   NonIndustrialHeaterReceptacle - NonIndustrialHeater
   IndustrialHeater - Heater
   IndustrialHeaterReceptacle - IndustrialHeater
   ElectronicTemperatureController - TemperatureController
   ExplosiveDiagnostic - AnalyticalDevice
   WitnessPlate - ExplosiveDiagnostic
   OpticalScope CoordinateMeasuringDevice - AnalyticalDevice
   Borescope - OpticalScope
   Component - Equipment
   GelBox - Component
   GelBoxPowerSupply - GelBox
   ElectronicComponent - Component
   Capacitor - ElectronicComponent
   PulseCapacitor - Capacitor
   HighVoltageCeramicDielectricCapacitor HighVoltageDielectricFilmCapacitor HighVoltageMicaPaperCapacitor - PulseCapacitor
   HighVoltageBariumTitanateCapacitor - HighVoltageCeramicDielectricCapacitor
   MetalizedFilmCapacitor - PulseCapacitor
   Switch PulseTransformer - ElectronicComponent
   FastClosingSwitch MechanicalSwitch - Switch
   HighVoltageGasSwitch HighVoltageRelay Thyristor - FastClosingSwitch
   Thyratron - HighVoltageGasSwitch
   SparkGap HighVoltageMechanicalSwitch - FastClosingSwitch
   Trigatron - SparkGap
   HighVoltagePulseTransformer GP-32B GXT-150 - Trigatron
   LowEnergySwitch LowVoltageSwitch - Switch
   ElectronicConnector - ElectronicComponent
   Plug - ElectronicConnector
   CoaxialConnector - Plug
   Cable - ElectronicConnector
   ExtensionCord CoaxialCable - Cable
   MarxGenerator - ElectronicComponent
   FermenterAccessory - Component
   FermentationVessel ImpellorDriveMotor FermentationController - FermenterAccessory
   PCRAccessory - Component
   SmartcyclerTube PCRCapillaries - PCRAccessory
   FurnaceComponent - Component
   ArcFurnaceElectrode FurnaceViewport ArcFurnaceInitiator
   HighVoltageArcFurnaceInitiator - FurnaceComponent
   GraphiteElectrode - ArcFurnaceElectrode
   ElectrorefiningComponent - Component
   TungstenElectrode - (and ArcFurnaceElectrode ElectrorefiningComponent)
   TantalumElectrode - (and ArcFurnaceElectrode ElectrorefiningComponent)
   Photodiode - Component
   Comminuter AtmosphericIsolation - Equipment
   NuclearProcessingComminuter Homogenizer - Comminuter
   Milling - (and Comminuter NuclearProcessingComminuter)
   WileyMill - Milling
   Grinder - Comminuter
   MilitaryEquipment - Equipment
   EODEquipment - MilitaryEquipment
   EODAccessTools - EODEquipment
   LargeCaliberGuns - MilitaryEquipment
   Howitzer HeavyMortar ArtilleryGun TankMainGun - LargeCaliberGuns
   Container - Equipment
   HermeticContainer ReactionVessel - Container
   Cryovial - HermeticContainer
   PlasticContainer - Container
   Mechanical Irradiator Purification - Equipment
   Joiner - Mechanical
   ArcWelder - Joiner
   Actuator - Mechanical
   FluidHandling - Equipment
   Pump LiquidHandling - FluidHandling
   PositivePressurePump WaterPump - Pump
   GasHandling - FluidHandling
   VacuumEquipment GasFlowChamber GasSyringe - GasHandling
   VacuumFlange VacuumFitting VacuumFeedthrough - VacuumEquipment
   VacuumPump - (and VacuumEquipment Pump)
   VacuumValve - VacuumEquipment
   PaperTowel - Equipment
   ChemRelatedEquipment - (and Role Equipment)
   HeatingMantle - (and ChemRelatedEquipment NonIndustrialHeater)
   ColumnFiltration - (and Purification ChemRelatedEquipment)
   GelFiltrationColumn - ColumnFiltration
   ChromatographicEquipment - (and ChemRelatedEquipment AnalyticalDevice)
   GasChromatograph - ChromatographicEquipment
   Colorimeter - (and ChemRelatedEquipment AnalyticalDevice)
   TubeRack - (and PCRAccessory ChemRelatedEquipment)
   ChemicalPurification - (and Purification ChemRelatedEquipment)
   Evaporator DistillationApparatus - ChemicalPurification
   VacuumEvaporator Rotovap - Evaporator
   Condenser - ChemicalPurification
   Spectrometer - (and ChemRelatedEquipment AnalyticalDevice)
   Spectrophotometer MassSpectrometer NuclearMagneticResonanceSpectrometer - Spectrometer
   InfraredSpectrophotometer - Spectrophotometer
   RubberGasket - (and ChemRelatedEquipment Component)
   GasMask - (and RespiratoryProtection ChemRelatedEquipment)
   GasGeneration - (and ChemRelatedEquipment Equipment)
   NitrogenGenerator LassieurGenerator - GasGeneration
   MeltingPointApparatus - (and ChemRelatedEquipment AnalyticalDevice)
   RadicalInitiator - (and ChemRelatedEquipment Equipment)
   HeatingBath - (and NonIndustrialHeaterReceptacle ChemRelatedEquipment)
   SteamBath SandBath OilBath - HeatingBath
   InfraredLamp - (and Irradiator ChemRelatedEquipment)
   GrindingMedium - (and Role PhysicalEntity)
   CeramicGrindingMedium - GrindingMedium
   MilitaryEquipmentInformation - InformationBearingEntity
   LargeCaliberGunInformation - MilitaryEquipmentInformation
   ArtillerySystemInformation - LargeCaliberGunInformation
   ArtillerySystemOperatingProcedure - ArtillerySystemInformation
   ConventionalMunitionsTechnicalData MunitionPropellantInformation EODTrainingMaterials - MilitaryEquipmentInformation
   AirDeliveredBombDesignInformation ArtilleryRoundDesignInformation IEDFabricationInformation
   PrimerInformation - ConventionalMunitionsTechnicalData
   ManufacturedForm - Quality
   RectangularForm - ManufacturedForm
   RectangularSolid RectangularTube - RectangularForm
   ProcessedForm - ManufacturedForm
   ShavingForm SolidForm CastForm
   PowderForm WireForm RolledForm
   ChipForm - ProcessedForm
   SphericalForm - ManufacturedForm
   SphericalSolid SphericalShell - SphericalForm
   CylindricalForm - ManufacturedForm
   CylindricalSolid CylindricalTube - CylindricalForm
   SheetForm - ManufacturedForm
   Hospital Slaughterhouse AcademicInstitution
   Laboratory Farm Woolmill
   BiologicalResourceCenter VeterinaryFacility Tannery - Facility
   BioRelatedEquipment - (and Role Equipment)
   UltravioletLamp - (and Irradiator BioRelatedEquipment ChemRelatedEquipment)
   SpiceGrinder - (and Grinder BioRelatedEquipment ChemRelatedEquipment)
   Refractometer - (and BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   GrowthPlate - (and BioRelatedEquipment Equipment)
   AgarPlate - GrowthPlate
   ContactPlate - AgarPlate
   StreakPlate SettlePlate SpreadPlate - GrowthPlate
   BiologicalPurification - (and Purification BioRelatedEquipment)
   Washer - (and ChemicalPurification BiologicalPurification)
   ChromatographySystem - (and ChromatographicEquipment ColumnFiltration BiologicalPurification)
   DialysisDevice Dialysis - (and ChemicalPurification BiologicalPurification)
   TyvekBooties - (and BioRelatedEquipment Clothing)
   Hemocytometer - (and BioRelatedEquipment Equipment)
   BallMill - (and BioRelatedEquipment ChemRelatedEquipment Milling)
   JarMill - BallMill
   Thermocycler - (and BioRelatedEquipment AnalyticalDevice)
   Real-timePolymeraseChainReactionInstrument - Thermocycler
   EggIncubator - (and BioRelatedEquipment Equipment)
   Sonicator - (and BioRelatedEquipment ChemRelatedEquipment Homogenizer)
   Stirrer - (and BioRelatedEquipment ChemRelatedEquipment Mixing)
   MagneticStirrer - (and BioRelatedEquipment ChemRelatedEquipment Stirrer)
   RefractoryStirrer - Stirrer
   TantalumStirrer - RefractoryStirrer
   AnaerobicGrowthEquipment - (and BioRelatedEquipment Component)
   AnaerobicJar - (and AtmosphericIsolation AnaerobicGrowthEquipment)
   GasPakAnaerobicJar - AnaerobicJar
   AnaerobicChamber - (and AtmosphericIsolation AnaerobicGrowthEquipment)
   AnaerobicIncubator - (and AtmosphericIsolation AnaerobicGrowthEquipment)
   DryBag - (and BioRelatedEquipment AtmosphericIsolation ChemRelatedEquipment)
   IonSelectiveElectrode - (and BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   HighPressureHomogenizer - (and BioRelatedEquipment ChemRelatedEquipment Homogenizer)
   FrenchPress - HighPressureHomogenizer
   AnimalTestingEquipment - BioRelatedEquipment
   Scalpel - (and Equipment AnimalTestingEquipment)
   AnimalFeed - (and Equipment AnimalTestingEquipment)
   AnimalBedding - (and Equipment AnimalTestingEquipment)
   AnimalCage - (and Equipment AnimalTestingEquipment)
   WashBottle - (and Container BioRelatedEquipment ChemRelatedEquipment)
   FoodProcessor - (and Grinder BioRelatedEquipment ChemRelatedEquipment Homogenizer)
   RollerBottleApparatus - (and BioRelatedEquipment Stirrer)
   LaboratoryGlassware - (and BioRelatedEquipment ChemRelatedEquipment Equipment)
   SoxhletExtractor - (and LaboratoryGlassware ChemicalPurification)
   NMRTube - (and Container LaboratoryGlassware)
   KippGenerator - (and LaboratoryGlassware GasGeneration)
   ThieleTube - (and Container LaboratoryGlassware)
   LiquidAddition - (and LaboratoryGlassware LiquidHandling)
   Funnel - (and LiquidAddition SolidAddition)
   SeparatoryFunnel DroppingFunnel BuchnerFunnel
   PowderFunnel - Funnel
   MeteredLiquidAddition Siphon PipetTips
   ThistleTube - LiquidAddition
   Pipette - MeteredLiquidAddition
   Eyedropper GraduatedPipette SerologicalPipet
   VolumetricPipette PasteurPipette - Pipette
   MeasuringCup - MeteredLiquidAddition
   Syringe - (and MeteredLiquidAddition AnimalTestingEquipment)
   HypodermicNeedle - (and LiquidAddition AnimalTestingEquipment)
   Flask - (and Container LaboratoryGlassware)
   ErlenmeyerFlask SchlenkFlask VolumetricFlask
   BuchnerFlask FlorenceFlask - Flask
   RoundBottomFlask - (and ChemRelatedEquipment Flask ReactionVessel)
   GroundGlassFitting - LaboratoryGlassware
   Stopcock - (and GasHandling GroundGlassFitting LiquidAddition)
   GroundGlassStopper - GroundGlassFitting
   Burette - (and Container LaboratoryGlassware ChemRelatedEquipment)
   PCRTubes - (and PCRAccessory LaboratoryGlassware)
   TubeStrips - PCRTubes
   LaboratoryCondenser - (and Condenser LaboratoryGlassware)
   Retort - (and Container LaboratoryCondenser)
   FractionatingColumn CoilCondenser ColdFinger
   GrahamRefluxCondenser LiebigCondenser FreidrichsCondenser
   AllihnCondenser - LaboratoryCondenser
   PackedColumn VigreuxColumn SnyderColumn - FractionatingColumn
   GlassContainer - (and Container LaboratoryGlassware)
   GlassBottle - GlassContainer
   GlassReactor - (and GlassContainer ChemRelatedEquipment ReactionVessel)
   TestTube - (and Container LaboratoryGlassware)
   ReactionTube - (and TestTube ChemRelatedEquipment ReactionVessel)
   DilutionTube - TestTube
   Column - (and LaboratoryGlassware ChemRelatedEquipment Component BiologicalPurification)
   ChromatographyColumn CationIonExchangeColumn AffinityColumn
   DEAESephadexColumn - Column
   Pycnometer - (and Container LaboratoryGlassware)
   WatchGlass - (and Evaporator LaboratoryGlassware)
   GraduatedVessel - (and Container LaboratoryGlassware)
   GraduatedCylinder - GraduatedVessel
   SchlenkLine - (and AtmosphericIsolation LaboratoryGlassware ChemRelatedEquipment)
   LyophilizationContainer - (and Container LaboratoryGlassware)
   LyophilizationFlask LyophilizationVial - LyophilizationContainer
   Eudiometer - (and GasHandling LaboratoryGlassware ChemRelatedEquipment)
   pHPaperStrip - (and BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   VacuumFilterAid - (and BioRelatedEquipment Component)
   Cover - (and BioRelatedEquipment ChemRelatedEquipment Equipment)
   TubeCaps Parafilm AluminumFoil
   Cork - Cover
   Incubator - (and BioRelatedEquipment NonIndustrialHeaterReceptacle)
   CO2Incubator - Incubator
   LightBox - (and BioRelatedEquipment AnalyticalDevice)
   LatexGloves - (and Gloves BioRelatedEquipment ChemRelatedEquipment)
   WasteCollectionReservoir - (and Container BioRelatedEquipment ChemRelatedEquipment)
   VortexMixer - (and BioRelatedEquipment ChemRelatedEquipment Stirrer)
   Spreader - (and BioRelatedEquipment Equipment)
   LazySpreader - Spreader
   Spatula - (and Spreader ChemRelatedEquipment)
   InoculatingLoop - (and Spreader SolidAddition)
   Turntable - Spreader
   Ventilation - (and BioRelatedEquipment ChemRelatedEquipment Safety)
   ExhaustFan - Ventilation
   NitrileGloves - (and Gloves BioRelatedEquipment ChemRelatedEquipment)
   Hotplate - (and BioRelatedEquipment ChemRelatedEquipment NonIndustrialHeater)
   HotplateStirrer - (and BioRelatedEquipment Hotplate ChemRelatedEquipment Stirrer)
   Carboy - (and Container BioRelatedEquipment ChemRelatedEquipment)
   FractionCollector - (and BioRelatedEquipment ChromatographicEquipment)
   AerosolGeneration - (and BioRelatedEquipment ChemRelatedEquipment Equipment)
   DryAerosolGeneration - AerosolGeneration
   DustDispenser - DryAerosolGeneration
   LiquidAerosolGeneration - AerosolGeneration
   Sprayer - LiquidAerosolGeneration
   PaintSprayer UltrasonicAtomizer ElectrosprayAtomization
   Nebulizer - Sprayer
   Fogger - LiquidAerosolGeneration
   Drying - (and BioRelatedEquipment ChemRelatedEquipment Equipment)
   SolidsDrying - Drying
   Desiccator - (and LaboratoryGlassware SolidsDrying)
   VacuumOven VacuumDesiccator - Desiccator
   Fluidizer Lyophilizer FluidizedBedDryer
   FoodDehydrator - SolidsDrying
   GasDrying Dehumidifier SolventDryingEquipment - Drying
   DryingTube - (and Drying LaboratoryGlassware)
   SprayDryer - Drying
   SporeStainingKit - (and BioRelatedEquipment Equipment)
   LiquidNitrogenContainer - (and Container BioRelatedEquipment ChemRelatedEquipment)
   LiquidNitrogenTank LiquidNitrogenDewar - LiquidNitrogenContainer
   ZiplocBag - (and Container BioRelatedEquipment ChemRelatedEquipment)
   MicroscopeAccessory - (and BioRelatedEquipment ChemRelatedEquipment Component)
   Coverslip - (and MicroscopeAccessory Cover)
   AdhesiveCoverslip - (and MicroscopeAccessory Cover)
   MicroscopeSlide LensPaper - MicroscopeAccessory
   HeatFixedSlide StainedMicroscopeSlide - MicroscopeSlide
   ImmersionOil - MicroscopeAccessory
   FreezerGloves - (and Gloves BioRelatedEquipment)
   SelfContainedBreathingApparatus - (and BioRelatedEquipment Respirator)
   HumidityMeasurement - (and BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   Hygrometer - HumidityMeasurement
   Shaker - (and BioRelatedEquipment Mixing)
   IncubatorShaker - (and Shaker Incubator)
   VibrationTable - Shaker
   OpenAirShaker - (and Shaker ChemRelatedEquipment)
   WaterBathShaker - (and Shaker ChemRelatedEquipment)
   DOprobe - (and BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   SterilizationAccessory - (and BioRelatedEquipment Component)
   AutoclaveWasteBag - (and SterilizationAccessory WasteCollectionReservoir)
   AutoclaveIndicatorTape - SterilizationAccessory
   Blender - (and Grinder BioRelatedEquipment ChemRelatedEquipment Homogenizer)
   BeadMill - (and BioRelatedEquipment ChemRelatedEquipment Milling)
   Aspirator - (and VacuumPump BioRelatedEquipment ChemRelatedEquipment)
   SampleCollectionEquipment - (and BioRelatedEquipment ChemRelatedEquipment Equipment)
   SoilSampler SlitToAgarBiologicalAirSampler BloodTube
   Swab Wipe - SampleCollectionEquipment
   Rocker - (and BioRelatedEquipment Mixing)
   CellCultureContainer - (and Container BioRelatedEquipment)
   MultiwellPlate - CellCultureContainer
   PetriDish - (and CellCultureContainer LaboratoryGlassware)
   SpinnerFlask - (and CellCultureContainer Flask)
   TFlask - (and CellCultureContainer Flask)
   RollerBottle - (and CellCultureContainer LaboratoryGlassware)
   WAVEBioreactorBag - CellCultureContainer
   HarvestingTool - (and BioRelatedEquipment Equipment)
   CellScraper - HarvestingTool
   JetMill - (and BioRelatedEquipment ChemRelatedEquipment Milling)
   ResistiveHeater - (and Heater BioRelatedEquipment ChemRelatedEquipment)
   ResistanceHeatingWire - ResistiveHeater
   CentrifugeComponent - (and BioRelatedEquipment Component)
   CentrifugeContainer - (and CentrifugeComponent Container LaboratoryGlassware)
   CentrifugeTube - CentrifugeContainer
   MicrocentrifugeTube - CentrifugeTube
   CentrifugeBottle - CentrifugeContainer
   CentrifugeAdapter CentrifugeRotor - CentrifugeComponent
   pHMeter - (and BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   Tray - (and BioRelatedEquipment Equipment)
   TestTubePlate StainedTray CookieSheet - Tray
   MicrotiterPlate PicotiterPlate - TestTubePlate
   PorcelainPlate - Tray
   Stove - (and BioRelatedEquipment ChemRelatedEquipment NonIndustrialHeater)
   ElectricStove GasStove - Stove
   StirrerAccessory - (and BioRelatedEquipment ChemRelatedEquipment Component)
   StirBar - StirrerAccessory
   AnaerobicEquipmentAccessory - (and BioRelatedEquipment Component)
   AnaerobicGas - AnaerobicEquipmentAccessory
   AnaerobicMixedGas - AnaerobicGas
   CatalystCartridge SilicaCartridge - AnaerobicEquipmentAccessory
   Bioreactor - (and BioRelatedEquipment Equipment)
   WAVEMixer - (and Bioreactor Rocker)
   Fermentor WAVEBioreactor - Bioreactor
   BubbleFermentor - Fermentor
   ElectrophoresisSystem - (and BioRelatedEquipment Equipment)
   HeatBlock - (and BioRelatedEquipment NonIndustrialHeaterReceptacle)
   Cuvette - (and Container BioRelatedEquipment ChemRelatedEquipment)
   ImmunoassayEquipment - (and BioRelatedEquipment AnalyticalDevice)
   ImmunoassayReader ImmunoassayWasher - ImmunoassayEquipment
   Counter - (and BioRelatedEquipment AnalyticalDevice)
   ColonyCounter - Counter
   AirGrinder - (and Grinder BioRelatedEquipment ChemRelatedEquipment)
   CoffeeGrinder - (and Grinder BioRelatedEquipment ChemRelatedEquipment)
   ButylRubberGloves - (and Gloves BioRelatedEquipment ChemRelatedEquipment)
   MortarAndPestle - (and Grinder BioRelatedEquipment LaboratoryGlassware ChemRelatedEquipment NuclearProcessingComminuter)
   Sterilizer - (and BioRelatedEquipment Equipment)
   Steamer Microcinerator Autoclave - Sterilizer
   PressureCooker - (and Sterilizer ChemRelatedEquipment)
   TissueGrinder - (and Grinder BioRelatedEquipment Homogenizer)
   PoweredAirPurifyingRespirator - (and BioRelatedEquipment Respirator ChemRelatedEquipment)
   NucRelatedEquipment - (and Role Equipment)
   LinearActuator - (and Actuator NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   LaboratorySupportStructure - (and Mechanical NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   Tape ClayTriangle RackClamp
   RetortStand FramingRod SupportRack
   RingStand BossHead BuretteClamp - LaboratorySupportStructure
   HeatingElement - (and NucRelatedEquipment Heater BioRelatedEquipment ChemRelatedEquipment)
   HighTemperatureHeatingElement - HeatingElement
   TungstenHeatingElement TantalumHeatingElement MolybdenumDisilicideHeatingElement
   SiliconCarbideHeatingElement - HighTemperatureHeatingElement
   Crusher - (and Grinder NucRelatedEquipment)
   ImpactCrusher - Crusher
   EntrapmentPump - (and VacuumPump NucRelatedEquipment ChemRelatedEquipment)
   IonPump CryoTrapPump SorptionPump - EntrapmentPump
   ElectricalPowerSource - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Equipment)
   ElectricalOutlet HighPowerElectricalSource HighPowerDCPowerSupply
   Battery Solar_Panel - ElectricalPowerSource
   SinglePhaseOutlet ThreePhaseOutlet - ElectricalOutlet
   HighVoltagePowerSupply - ElectricalPowerSource
   AnalogHighVoltagePowerSupply SwitchingHighVoltagePowerSupply - HighVoltagePowerSupply
   Generator - ElectricalPowerSource
   WireMeshFaceShield - (and FaceProtection NucRelatedEquipment)
   ResistiveComponent - (and NucRelatedEquipment ElectronicComponent)
   Rheostat - ResistiveComponent
   MomentumPump - (and VacuumPump NucRelatedEquipment ChemRelatedEquipment)
   TurboPump DiffusionPump - MomentumPump
   VacuumChamber - (and NucRelatedEquipment AtmosphericIsolation ChemRelatedEquipment)
   CalibrationReference - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   AirCompressor - (and NucRelatedEquipment BioRelatedEquipment GasHandling ChemRelatedEquipment)
   LabCoat - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Clothing)
   SafetyGlasses - (and FaceProtection NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   HighPressureHighTempVessel - (and NucRelatedEquipment ChemRelatedEquipment ReactionVessel)
   Furnace - (and NucRelatedEquipment IndustrialHeaterReceptacle ChemRelatedEquipment)
   FurnaceForSpecificPurpose UnsealedFurnace ModifiedResistanceFurnaceEnclosingFluidizedBedReactor
   Kiln FurnaceEnclosingFixedOrFluidizedBedReactor InductionOrResistanceFurnace - Furnace
   BombReductionFurnace CeramicCrucibleFabricationFurnace VacuumRefiningFurnance - FurnaceForSpecificPurpose
   MuffleFurnace - BombReductionFurnace
   HeatTreatFurnace FurnaceForVitreousCarbonMoldFormation - FurnaceForSpecificPurpose
   Oil-FiredFurnace - (and HeatTreatFurnace BombReductionFurnace)
   CeramicMoldFabricationFurnace HotMetalPressingFurnace - FurnaceForSpecificPurpose
   InductionFurnace - (and CeramicMoldFabricationFurnace HeatTreatFurnace BombReductionFurnace CeramicCrucibleFabricationFurnace InductionOrResistanceFurnace)
   FurnaceForVitreousCarbonCrucibleFormation HotDippingFurnace - FurnaceForSpecificPurpose
   ResistanceFurnace - (and FurnaceForVitreousCarbonCrucibleFormation CeramicMoldFabricationFurnace HeatTreatFurnace FurnaceForVitreousCarbonMoldFormation BombReductionFurnace CeramicCrucibleFabricationFurnace InductionOrResistanceFurnace)
   ModifiedResistanceFurnace UnsealedResistanceFurnace - ResistanceFurnace
   Gas-FiredFurnace - (and FurnaceForVitreousCarbonCrucibleFormation CeramicMoldFabricationFurnace HeatTreatFurnace FurnaceForVitreousCarbonMoldFormation BombReductionFurnace CeramicCrucibleFabricationFurnace)
   AlloyingFurnace - FurnaceForSpecificPurpose
   InertGasFurnace - (and AlloyingFurnace Furnace)
   InertGasInductionFurnace - (and InductionFurnace InertGasFurnace)
   InertResistanceFurnace - (and InertGasFurnace ResistanceFurnace)
   InertGasResistanceFurnace - InertResistanceFurnace
   ElectrorefiningFurnace - FurnaceForSpecificPurpose
   VacuumFurnace - (and ElectrorefiningFurnace AlloyingFurnace)
   VacuumResistanceFurnace - (and VacuumFurnace VacuumRefiningFurnance)
   VacuumInductionFurnace - (and ElectrorefiningFurnace InductionFurnace VacuumFurnace VacuumRefiningFurnance)
   ArcFurnace - Furnace
   InertGasArcFurnace - (and ArcFurnace InertGasFurnace)
   VacuumArcFurnace - (and ArcFurnace VacuumFurnace)
   UnsealedArcFurnace - ArcFurnace
   RadiationMeasuringDevice - (and NucRelatedEquipment AnalyticalDevice)
   NuclearSpectroscopyInstrumentation - RadiationMeasuringDevice
   HighPurityGermaniumDetector LanthanumBromideDetector CesiumIodideDetector
   SodiumIodideDetector - NuclearSpectroscopyInstrumentation
   CriticalityMonitoringDetector - RadiationMeasuringDevice
   NeutronDetector - CriticalityMonitoringDetector
   ProtonRecoilScintillatorNeutronDetector - NeutronDetector
   CrystalScintillatorNeutronDetector LiquidScintillator PlasticScintillator - ProtonRecoilScintillatorNeutronDetector
   StilbeneScintillator - CrystalScintillatorNeutronDetector
   CompositeStilbeneScintillator - StilbeneScintillator
   AnthraceneScintillator - CrystalScintillatorNeutronDetector
   ProportionalNeutronCounter - NeutronDetector
   BoronTrifluorideProportionalCounter Helium3ProportionalCounter BoronLinedProportionalCounter - ProportionalNeutronCounter
   DopedScintillator - NeutronDetector
   LithiumIodideScintillator LithiumDopedGlassScintillator LithiumDopedGlassFiberScintillator - DopedScintillator
   FissionCounter - NeutronDetector
   GammaDetector - CriticalityMonitoringDetector
   XRayEquipment - (and NucRelatedEquipment AnalyticalDevice)
   DigitalXRayPanel XRayUnit XRayFilm - XRayEquipment
   HeatProtectiveGloves - (and NucRelatedEquipment Gloves ChemRelatedEquipment)
   OvenMitt - HeatProtectiveGloves
   XRayFluorescenceSpectrometer - (and NucRelatedEquipment Spectrophotometer)
   Glasses - (and FaceProtection NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   GasFlowIndicator - (and NucRelatedEquipment BioRelatedEquipment GasHandling ChemRelatedEquipment)
   Press - (and Mechanical NucRelatedEquipment ChemRelatedEquipment)
   HighExplosivePress PelletPress DropPress - Press
   HighExplosivePressingBag IsostaticPress HydrostaticPress - HighExplosivePress
   HeavyDutyPress - (and Press Crusher)
   HydraulicPress - HeavyDutyPress
   ArborPress - (and Press Crusher)
   WeighingTray - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment SolidAddition)
   WeighingBoat WeighingPaper - WeighingTray
   Computer - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Electronic)
   TemperatureControlVessel - (and NucRelatedEquipment ChemRelatedEquipment ReactionVessel)
   HighTempVessel - TemperatureControlVessel
   DistanceMeasuringDevice - (and NucRelatedEquipment AnalyticalDevice)
   HeightGauge ThreadGauge ThicknessGauge
   Micrometer PrecisionRuler Caliper - DistanceMeasuringDevice
   PersonalProtectiveEquipmentforFoundry - (and NucRelatedEquipment PersonalProtectiveEquipment)
   ParticulateRespirator - (and NucRelatedEquipment BioRelatedEquipment PersonalProtectiveEquipmentforFoundry)
   N95Respirator - ParticulateRespirator
   AluminizedGlassFabricClothing - PersonalProtectiveEquipmentforFoundry
   GasFlowMeter - (and NucRelatedEquipment BioRelatedEquipment GasHandling ChemRelatedEquipment)
   MilitaryEquipmentComponents - (and NucRelatedEquipment MilitaryEquipment)
   LargeCaliberGunComponents WarheadComponent - MilitaryEquipmentComponents
   LargeCaliberGunBarrel - LargeCaliberGunComponents
   Separator - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Equipment)
   Centrifuge GelFiltrationMedium FoamSeparationApparatus - Separator
   ContinuousFlowCentrifuge GradientCentrifuge HighSpeedCentrifuge
   RefrigeratedCentrifuge MicroCentrifuge Ultracentrifuge - Centrifuge
   Filter - Separator
   SilicaFiberFilter CoffeeFilter UltrafiltrationSystem
   GlassWool - Filter
   AirFilter - (and Filter Safety)
   HEPAFilter InLineAirFilter - AirFilter
   TangentialFlowFiltrationApparatus FilterPaper FilterUnit - Filter
   GlassFrit - (and Filter LaboratoryGlassware)
   MolecularSieve - Filter
   ArcEmissionSpectrometer - (and NucRelatedEquipment Spectrophotometer)
   VelocityMeasuringDevice - (and NucRelatedEquipment AnalyticalDevice)
   Tachometer PinDome - VelocityMeasuringDevice
   OpticalTachometer - Tachometer
   ShootingChronograph - VelocityMeasuringDevice
   Camera - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Equipment)
   HighSpeedCamera - Camera
   StreakCamera FramingCamera - HighSpeedCamera
   GatedImageIntensifier - (and Electronic HighSpeedCamera)
   FiberOpticCamera - Camera
   MechanicalPump - (and VacuumPump NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   ScrollPump RootsPump LiquidRingPump
   ScrewPump RotaryVanePump PistonPump
   DiaphramPump - MechanicalPump
   StaticMixer - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Stirrer)
   TransferUtensil - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment SolidAddition)
   Shovel - (and SampleCollectionEquipment TransferUtensil)
   GardenTrowel - Shovel
   Tweezer Scoopula Forcep - TransferUtensil
   Apron - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Clothing)
   Tubing - (and NucRelatedEquipment BioRelatedEquipment GasHandling ChemRelatedEquipment LiquidHandling)
   CopperTubing - Tubing
   QuartzTubing - (and Tubing LaboratoryGlassware)
   PyrexTubing - (and Tubing LaboratoryGlassware)
   SteelTubing DialysisTubing - Tubing
   HighNickleTubing - SteelTubing
   MonelTubing SuperNickelTubing - HighNickleTubing
   StainlessSteelTubing - SteelTubing
   PolymerTubing - Tubing
   TygonTubing NylonTubing PolyethyleneTubing
   PolypropyleneTubing SiliconeTubing NeopreneTubing
   TeflonTubing PVCTubing - PolymerTubing
   GasFlowControl - (and NucRelatedEquipment BioRelatedEquipment GasHandling ChemRelatedEquipment)
   GasValve Regulator - GasFlowControl
   MovingEquipment - (and NucRelatedEquipment Equipment)
   GasPurifier - (and NucRelatedEquipment BioRelatedEquipment GasHandling ChemRelatedEquipment)
   GasFilter GasPurifyingCatalyst - GasPurifier
   InertGasFilter - GasFilter
   Scrubber - (and NucRelatedEquipment ChemicalPurification)
   CatalyticOxygenScrubber - Scrubber
   Chiller - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment TemperatureController)
   ChillerReceptacle - Chiller
   CoolingBath - ChillerReceptacle
   DryIceOrganicSolventBath IceBath LiquidNitrogenOrganicSolventBath - CoolingBath
   DryIceAcetoneBath - DryIceOrganicSolventBath
   Freezer Refrigerator - ChillerReceptacle
   UltraLowFreezer - Freezer
   Cooler - ChillerReceptacle
   CryoSafeColdBox - Cooler
   BlockCooler IceMachine - ChillerReceptacle
   ChemicalReactor - (and NucRelatedEquipment ChemRelatedEquipment Equipment)
   ElectrolyticCell - (and ChemicalReactor AnalyticalDevice)
   MoltenSaltElectrolyticCell - ElectrolyticCell
   BedReactor MetallothermyReactionChamber - ChemicalReactor
   CorrosionResistantBedReactor FluidizedBedReactor - BedReactor
   BombReactor Precipitator ElectroplatingApparatus
   TrayBatchReactor - ChemicalReactor
   IndustrialBombReactor - BombReactor
   GasTank - (and NucRelatedEquipment BioRelatedEquipment GasHandling ChemRelatedEquipment)
   GlassBulb - (and GasTank LaboratoryGlassware ChemRelatedEquipment)
   FireExtinguisher - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Safety)
   ClassDFireExtinguisher - FireExtinguisher
   SafetyContainment - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Safety)
   AerosolTestingChamber BiosafetyCabinet LaminarFlowCabinet
   FumeHood - SafetyContainment
   Lift - (and NucRelatedEquipment Equipment)
   VacuumGage - (and VacuumEquipment NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   WeighingDevice - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   Scale - WeighingDevice
   FoodScale PostalScale - Scale
   TopLoadingBalance AnalyticalBalance TripleBeamBalance - WeighingDevice
   LightSource - (and Irradiator NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   TriggeringScreen - (and NucRelatedEquipment Electronic)
   Microscope - (and OpticalScope NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   OpticalMicroscope - Microscope
   InvertedMicroscope - OpticalMicroscope
   ElectronMicroscope FluorescentMicroscope - Microscope
   ThreeDPrinter - (and NucRelatedEquipment Equipment)
   PaintCanShaker - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Stirrer)
   Lithotripter - (and NucRelatedEquipment AnalyticalDevice)
   Clamp - (and Mechanical NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   HighPressureVessel - (and NucRelatedEquipment ChemRelatedEquipment ReactionVessel)
   Coveralls - (and NucRelatedEquipment ChemRelatedEquipment Clothing)
   TyvekSuit - (and Coveralls BioRelatedEquipment)
   PressureMeasurement - (and FluidHandling NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   PressureGauge - PressureMeasurement
   HeatExchanger - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment TemperatureController)
   MovingFluidChiller - (and HeatExchanger Chiller)
   ColdLiquidCirculatingSystem - MovingFluidChiller
   WortChiller WaterChiller - ColdLiquidCirculatingSystem
   ForcedAirCooler - MovingFluidChiller
   Fan AirConditioner - ForcedAirCooler
   RecirculatingBath - HeatExchanger
   MovingFluidHeater - (and HeatExchanger NonIndustrialHeater)
   ForcedAirHeater - MovingFluidHeater
   HeatGun - ForcedAirHeater
   HotLiquidCirculatingSystem - MovingFluidHeater
   WaterBath WaterJacket - HeatExchanger
   GloveBox - (and NucRelatedEquipment BioRelatedEquipment AtmosphericIsolation ChemRelatedEquipment)
   LiquidFlowIndicator - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment LiquidHandling)
   PlumbingMaterial - (and FluidHandling NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   GasFitting - (and PlumbingMaterial GasHandling)
   PipeFitting - PlumbingMaterial
   PeristalticPump - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment PositivePressurePump)
   Goggles - (and FaceProtection NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   FiringTrainTestEquipment - (and NucRelatedEquipment AnalyticalDevice)
   SparkGapTester ExplosiveTestChamber StrayVoltageDetector
   GridDipMeter ElectricallySimulatedExplodingBridgewire - FiringTrainTestEquipment
   Phototransistor - (and NucRelatedEquipment Electronic)
   ConstructionMaterial - (and Mechanical NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   Pipe - ConstructionMaterial
   MetalPipe PlasticPipe - Pipe
   SteelPipe - MetalPipe
   StainlessSteelPipe - SteelPipe
   CeramicPipe - Pipe
   Hardware - ConstructionMaterial
   SteelHardware Fastener - Hardware
   StainlessSteelHardware - SteelHardware
   HighSpeedEquipment - (and NucRelatedEquipment AnalyticalDevice)
   HighSpeedSignalGenerator - HighSpeedEquipment
   PulsePatternGenerator - (and Electronic HighSpeedSignalGenerator)
   PulseGenerator - (and Electronic HighSpeedSignalGenerator)
   DelayGenerator - (and Electronic HighSpeedSignalGenerator)
   HighSpeedSignalMeasuringDevice - HighSpeedEquipment
   DigitalTransientRecorder - (and Electronic HighSpeedSignalMeasuringDevice)
   FrequencyCounter - (and Electronic HighSpeedSignalMeasuringDevice)
   Oscilloscope - (and Electronic HighSpeedSignalMeasuringDevice HighSpeedSignalGenerator)
   HighAccuracyTimingSource - HighSpeedSignalMeasuringDevice
   Digitizer - (and Electronic HighSpeedSignalMeasuringDevice)
   TemperatureMeasurement - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment AnalyticalDevice)
   ElecticalTemperatureMeasurement HighTemperatureMeasurement - TemperatureMeasurement
   Thermocouple - (and ElecticalTemperatureMeasurement HighTemperatureMeasurement)
   Pyrometer - (and ElecticalTemperatureMeasurement HighTemperatureMeasurement)
   Thermistor - ElecticalTemperatureMeasurement
   MechanicalTempratureMeasurement - TemperatureMeasurement
   Thermometer - MechanicalTempratureMeasurement
   SpringThermometer LiquidThermometer - Thermometer
   MiningEquipment - (and NucRelatedEquipment Equipment)
   OreCrusher - (and MiningEquipment Crusher)
   BenchtopOreCrusher - OreCrusher
   DustMask - (and NucRelatedEquipment BioRelatedEquipment RespiratoryProtection ChemRelatedEquipment)
   Mold - (and Container NucRelatedEquipment ChemRelatedEquipment)
   MoldForMetalCasting - Mold
   MetalMold GraphiteMold - MoldForMetalCasting
   SteelMold TungstenMold TantalumMold
   CopperMold - MetalMold
   CoatedMoldForMetalCasting - MoldForMetalCasting
   HighExplosiveMold - Mold
   MachineTool - (and Mechanical NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment)
   Die - MachineTool
   HotPressMetalDie HighExplosivePressDie - Die
   HighStrengthMachineTool - MachineTool
   CarboloyTippedTool CarbideCuttingTool - HighStrengthMachineTool
   HighVoltageElectronic - (and NucRelatedEquipment Electronic)
   HighVoltageSwitch - (and HighVoltageElectronic Switch)
   HighVoltageDiagnostic - HighVoltageElectronic
   HighVoltageMeter HighVoltageProbe - HighVoltageDiagnostic
   LiquidFlowMeter - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment LiquidHandling)
   MillingAccessory - (and NucRelatedEquipment BioRelatedEquipment ChemRelatedEquipment Component)
   LeadBall CeramicBall - MillingAccessory
   CorrosionResistantVessel - (and NucRelatedEquipment ChemRelatedEquipment ReactionVessel)
   Beaker - (and Container NucRelatedEquipment BioRelatedEquipment LaboratoryGlassware ChemRelatedEquipment)
   CBRNEMaterial - MaterialEntity
   BulkMaterial - CBRNEMaterial
   CarbonMaterial - BulkMaterial
   SolidGraphite - CarbonMaterial
   MetalMaterial - BulkMaterial
   UnrefinedMetal - MetalMaterial
   UnrefinedReducingMetal - UnrefinedMetal
   UnrefinedMagnesium UnrefinedCalcium - UnrefinedReducingMetal
   UnrefinedUraniumMetal - UnrefinedMetal
   PlutoniumStock - MetalMaterial
   UnrefinedPlutoniumMetal - (and PlutoniumStock UnrefinedMetal)
   HighlyEnrichedUraniumStock - MetalMaterial
   UnrefinedHighlyEnrichedUraniumMetal - (and HighlyEnrichedUraniumStock UnrefinedMetal)
   RefinedMetal - MetalMaterial
   HighlyEnrichedUraniumMetal - (and RefinedMetal HighlyEnrichedUraniumStock)
   PlatinumMetal - RefinedMetal
   PlatinumWire - PlatinumMetal
   TitaniumMetal - RefinedMetal
   PowderedTitanium - TitaniumMetal
   CopperMetal - (and NucRelatedEquipment RefinedMetal ChemRelatedEquipment)
   CopperFoil CopperTape - CopperMetal
   TantalumMetal - RefinedMetal
   AluminumMetal - (and RefinedMetal ChemRelatedEquipment)
   CastAluminumMetal AluminumShavings HighPurityAluminumMetal - AluminumMetal
   LithiumMetal PlatingMaterial - RefinedMetal
   LithiumMetalChips - LithiumMetal
   MaterialForChemicalProcessing - (and Role PhysicalEntity)
   ReducingGasForFiring ElectroplatingMaterial - MaterialForChemicalProcessing
   NitrogenGas - ReducingGasForFiring
   CastingEquipment DeflocculationAgentForRefractoryCeramicConstruction HotDippingMaterial - MaterialForChemicalProcessing
   HighTemperatureCastingEquipment - CastingEquipment
   RefractoryMold - (and HighTemperatureCastingEquipment MoldForMetalCasting)
   CeramicRefractoryMold - RefractoryMold
   BerylliumOxideMold CalciumZirconateMold ZirconiumOxideMold - CeramicRefractoryMold
   ClayBondedCastingMold - RefractoryMold
   Crucible - (and Container HighTemperatureCastingEquipment)
   MetalCrucible - Crucible
   SteelCrucible CopperCrucible - MetalCrucible
   MetalCastingCrucible - Crucible
   MetalCastingCoatedCrucible - MetalCastingCrucible
   LaboratoryCrucible - (and Crucible LaboratoryGlassware)
   PyrochemicalReductionCrucible HotDippingCrucible - Crucible
   PyrochemicalReductionCeramicCrucible - PyrochemicalReductionCrucible
   RefractoryCrucible - Crucible
   RefractoryMetalCrucible - (and RefractoryCrucible MetalCrucible)
   RefractoryMetalBombReductionCrucible NitratedNiobium-TitaniumAlloyCrucible NiobiumTitaniumTungstenAlloyCrucible - RefractoryMetalCrucible
   TantalumCrucible - (and MetalCastingCrucible RefractoryMetalCrucible)
   TungstenCrucible TantalumAlloyCrucible - RefractoryMetalCrucible
   LinedMetalCrucible CalciumFluorideCrucible - RefractoryCrucible
   PyrochemicalReductionLinedMetalCrucible - (and PyrochemicalReductionCrucible LinedMetalCrucible)
   CeramicRefractoryCrucible - RefractoryCrucible
   CalciumOxideCrucible BerylliumOxideCrucible MagnesiumOxideCrucible
   ThoriumDioxideCrucible UraniumDioxideCrucible - CeramicRefractoryCrucible
   GraphiteCrucible - (and RefractoryCrucible MetalCastingCrucible)
   BombReductionCrucible - (and RefractoryCrucible Crucible)
   BombReductionCeramicCrucible - (and BombReductionCrucible CeramicRefractoryCrucible)
   MetazirconateCrucible ZirconiumOxideCrucible YttriumOxideCrucible
   HafniumOxideCrucible CeriumSulfideCrucible ErbiumOxideCrucible
   CalciumZirconateCrucible - BombReductionCeramicCrucible
   BombReductionLinedCrucible - BombReductionCrucible
   ClayBondedCastingCrucible MoltenSaltBathReactorCrucible ElectrolyticCellCrucible - Crucible
   LowTemperatureCastingEquipment - CastingEquipment
   PostProcessingChemicalForMoltenSaltElectrolysis - MaterialForChemicalProcessing
   NitricAcid - (and StrongMonoproticAcid PostProcessingChemicalForMoltenSaltElectrolysis)
   AceticAcid - (and WeakAcid ToxinPrecipitant PostProcessingChemicalForMoltenSaltElectrolysis)
   Acetone - PostProcessingChemicalForMoltenSaltElectrolysis
   HydrochloricAcid - (and StrongMonoproticAcid ToxinPrecipitant PostProcessingChemicalForMoltenSaltElectrolysis)
   SaltBathAdditiveForPyrochemicalReduction DielectricCoolant PlatingSolution
   MoltenSaltElectrolysisElectrodeMaterial - MaterialForChemicalProcessing
   Cadmium BariumChloride MagnesiumCadmiumAlloy
   LanthanumChloride - SaltBathAdditiveForPyrochemicalReduction
   SaltForPyrochemicalReduction GasForMetallothermy Lacquer
   PostProcessingBombReductionChemical - MaterialForChemicalProcessing
   BariumBromide CeriumBromide LanthanumBromide - SaltForPyrochemicalReduction
   DispersingAgent NickelCarbonCompositeScreen - MaterialForChemicalProcessing
   LiquidDispersingAgent - (and NucRelatedEquipment DispersingAgent)
   DispersingAgentForRefractoryCeramicConstruction - LiquidDispersingAgent
   Ethanol - DispersingAgentForRefractoryCeramicConstruction
   Kerosene - (and HydrocarbonFuel DispersingAgentForRefractoryCeramicConstruction)
   CarbonTetrachloride - DispersingAgentForRefractoryCeramicConstruction
   SolidDispersingAgent - (and BioRelatedEquipment DispersingAgent)
   TemperatureResistantMaterial - MaterialForChemicalProcessing
   CrucibleMaterial - TemperatureResistantMaterial
   RefractoryCrucibleMaterial - CrucibleMaterial
   Tungsten - RefractoryCrucibleMaterial
   CrucibleMaterialForPyrochemicalReduction MaterialForVitreousCarbonCrucibleFormation CeramicRefractoryCrucibleMaterial - CrucibleMaterial
   MoldMaterial - TemperatureResistantMaterial
   MaterialForVitreousCarbonMoldFormation - MoldMaterial
   BindingAgentForClayBondedGraphiteMold - (and MaterialForVitreousCarbonMoldFormation MaterialForVitreousCarbonCrucibleFormation)
   SiliconCarbide Feldspar Tragacanth
   Silicon - BindingAgentForClayBondedGraphiteMold
   ActivatedCarbon - (and MaterialForVitreousCarbonMoldFormation Catalyst Desiccant)
   CoalTarPitch - (and MaterialForVitreousCarbonMoldFormation MaterialForVitreousCarbonCrucibleFormation CarbonMaterial)
   CarbonBlack - (and MaterialForVitreousCarbonMoldFormation MaterialForVitreousCarbonCrucibleFormation CarbonMaterial)
   Characoal - (and MaterialForVitreousCarbonMoldFormation MaterialForVitreousCarbonCrucibleFormation CarbonMaterial)
   PowderedGraphite - (and MaterialForVitreousCarbonMoldFormation MaterialForVitreousCarbonCrucibleFormation CarbonMaterial)
   FlakedGraphite - (and MaterialForVitreousCarbonMoldFormation MaterialForVitreousCarbonCrucibleFormation CarbonMaterial)
   Coke - (and MaterialForVitreousCarbonMoldFormation HydrocarbonFuel Catalyst MaterialForVitreousCarbonCrucibleFormation CarbonMaterial)
   MetalMoldMaterial - MoldMaterial
   Nickel - (and MetalMoldMaterial CrucibleMaterial)
   Steel - (and MetalMoldMaterial RefinedMetal CrucibleMaterial)
   LowCarbonSteel - Steel
   _1112_Steel _1019_Steel _1020_Steel
   _1022_Steel _1010_Steel - LowCarbonSteel
   StainlessSteel HighDensitySteel - Steel
   LowCarbonStainlessSteel - StainlessSteel
   _309S_StainlessSteel _316L_StainlessSteel _310S_StainlessSteel
   _304L_StainlessSteel _304_StainlessSteel - LowCarbonStainlessSteel
   Tantalum - (and MetalMoldMaterial CrucibleMaterial)
   Copper - (and MetalMoldMaterial MetalCatalyst CrucibleMaterial)
   CrucibleCoating MetalCrucibleOrMoldMaterial MetalCrucibleMaterial
   MoldCoating - TemperatureResistantMaterial
   CesiumSulfide - (and CrucibleCoating MoldCoating)
   MetalCarbide - (and CrucibleCoating MoldCoating)
   CalciumFluoride - (and CrucibleCoating MoldCoating)
   MagnesiumSilicate - (and CrucibleCoating MoldCoating)
   RefractoryOxide - (and CrucibleCoating MoldCoating)
   ZirconiumOrthosilicate - (and CrucibleCoating MoldCoating)
   LinerMaterialForPyrochemicalReduction - TemperatureResistantMaterial
   MagnesiumOxide - (and CrucibleMaterialForPyrochemicalReduction LinerMaterialForPyrochemicalReduction SaltBathAdditiveForPyrochemicalReduction)
   BerylliumOxide - (and CrucibleMaterialForPyrochemicalReduction LinerMaterialForPyrochemicalReduction CeramicRefractoryCrucibleMaterial SaltBathAdditiveForPyrochemicalReduction)
   AluminumOxide - (and CrucibleMaterialForPyrochemicalReduction Catalyst LinerMaterialForPyrochemicalReduction SaltBathAdditiveForPyrochemicalReduction)
   CrucibleOrMoldCoating - TemperatureResistantMaterial
   InsulatingRefractoryMaterial - MaterialForChemicalProcessing
   CeramicPaste - (and FurnaceComponent InsulatingRefractoryMaterial)
   CeramicFiberBlanket - (and InsulatingRefractoryMaterial Safety)
   RefractoryPowder - (and InsulatingRefractoryMaterial Equipment)
   RefractoryFiber - (and InsulatingRefractoryMaterial Equipment)
   RefractoryInsulatingBoard - (and InsulatingRefractoryMaterial Equipment)
   FireBrick - (and FurnaceComponent InsulatingRefractoryMaterial)
   CorrosionResistantMaterial - MaterialForChemicalProcessing
   CorrosionResistantMetalReactorMaterial - CorrosionResistantMaterial
   NickelSuperAlloy - CorrosionResistantMetalReactorMaterial
   ReducingMetal - MaterialForChemicalProcessing
   MetallothermyReductionMetal - ReducingMetal
   Sodium - (and MetallothermyReductionMetal MetalCatalyst)
   Calcium Potassium Magnesium - MetallothermyReductionMetal
   Lithium - ReducingMetal
   FireRetardantForMetal - MaterialForChemicalProcessing
   SodiumBicarbonate SiliconDioxide - FireRetardantForMetal
   PowderedCopper - (and FireRetardantForMetal CopperMetal)
   SodiumChloride - FireRetardantForMetal
   RustInhibitor - (and MaterialForChemicalProcessing Equipment)
   DegreasingTools - (and MaterialForChemicalProcessing Hardware)
   NonOxidizingGas PurgeGasForMoltenSaltBathReduction - MaterialForChemicalProcessing
   InertGas - NonOxidizingGas
   GasForFuelingGasFurnace - MaterialForChemicalProcessing
   Propane - GasForFuelingGasFurnace
   NaturalGas - (and GasForFuelingGasFurnace HydrocarbonFuel)
   Methane Oxygen - GasForFuelingGasFurnace
   ArcFurnaceElectrodeMaterial - MaterialForChemicalProcessing
   Graphite - (and ArcFurnaceElectrodeMaterial FireRetardantForMetal CeramicRefractoryCrucibleMaterial RefractoryCrucibleMaterial)
   TungstenMetal - (and ArcFurnaceElectrodeMaterial RefinedMetal)
   PlutoniumMetal - (and ArcFurnaceElectrodeMaterial CBRNEMaterial)
   UraniumMetal - (and ArcFurnaceElectrodeMaterial RefinedMetal)
   UraniumShavings PowderedUranium - UraniumMetal
   DisplacementFluid PhotoEtchingMaterial - MaterialForChemicalProcessing
   Bromobenzene DistilledWater Freon - DisplacementFluid
   MachiningFluid - (and DisplacementFluid Mechanical)
   InertGasForPyrochemicalReduction FixedBedReactorMixingComponents - MaterialForChemicalProcessing
   NobleGas - (and InertGasForPyrochemicalReduction PurgeGasForMoltenSaltBathReduction))
  (:predicates
    (hasForm ?a ?b - Thing)
    (hasComponent ?a ?b - Thing)
    (hasMaxCapacity - fact ?a - Thing ?b - number)
    (hasProductOrCatalogID - fact ?a - Thing ?b - number)
    (hasModelNumber - fact ?a - Thing ?b - number)
    (hasSpeed - fact ?a - Thing ?b - number)
    (hasTemperatureSensorType - fact ?a - Thing ?b - number)
    (hasManufacturer - fact ?a - Thing ?b - number)
    (hasInteriorVolume - fact ?a - Thing ?b - number)
    (hasPrice - fact ?a - Thing ?b - number)
    (hasElectricalRequirements - fact ?a - Thing ?b - number)
    (hasMountingType - fact ?a - Thing ?b - number)))
