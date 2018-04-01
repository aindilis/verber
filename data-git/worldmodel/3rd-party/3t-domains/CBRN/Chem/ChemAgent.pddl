(in-package :ap)

(define (domain ChemAgent)
  (:imports CBRNEMatEquip)
  (:prefix "ChemAgent")
  (:uri "http://agent.jhuapl.edu/2011/11/15/Chem/ChemAgent#")
  (:types
   CWARelatedChemical - ChemicalWeaponRole
   DecontaminationChemical - CWARelatedChemical
   DecontaminationSolution - DecontaminationChemical
   SodiumHydroxideSolution - DecontaminationSolution
   CWAControlledChemical - CWARelatedChemical
   CWCChemical - CWAControlledChemical
   UnscheduledDiscreteOrganicChemical CWCSchedule3Chemical - CWCChemical
   PSFChemical - UnscheduledDiscreteOrganicChemical
   CWCSchedule2Chemical - CWCChemical
   EthylMethylphosphonicAcid DipinacolylMethylphosphonate DiisopropylMethylphosphonate
   Diethyl-H-Phosphonate CyclohexylMethylphosphonicAcid DicyclohexylMethylphosphonate - CWCSchedule2Chemical
   CWCSchedule1Chemical - CWCChemical
   IsopropylEthylphosphonofluoridate - (and CWCSchedule1Chemical MolecularEntity)
   MustardTMixture - CWCSchedule1Chemical
   CFATSChemical AustraliaGroupChemical - CWAControlledChemical
   Tabun - (and CFATSChemical CWCSchedule1Chemical MolecularEntity)
   _246_Trinitrotoluene - (and CFATSChemical CastExplosive SecondaryExplosive)
   FluorineGas - CFATSChemical
   _135-Trinitrobenzene - (and CFATSChemical PrimaryExplosive)
   Methylthiol - CFATSChemical
   MercuryFulminate - (and CFATSChemical PrimaryExplosive)
   DimethylAmine - CFATSChemical
   _246-Trinitroresorcinol - (and ChemicalExplosive CFATSChemical)
   PotassiumNitrate - CFATSChemical
   Tritonal - (and CFATSChemical SecondaryExplosive)
   Ethylthiol Isopropylamine Nitroguanidine - CFATSChemical
   SodiumCyanide - (and CFATSChemical AustraliaGroupChemical)
   LeadAzide - (and CFATSChemical PrimaryExplosive)
   AmmoniumNitrate - (and CFATSChemical SecondaryExplosive)
   Octogen - (and CFATSChemical SecondaryExplosive)
   PentaerythritolTetranitrate - (and CFATSChemical DetonatorExplosive SecondaryExplosive)
   Nitroglycerin - (and CFATSChemical PrimaryExplosive)
   Hexanitrostilbene - (and CFATSChemical SecondaryExplosive)
   PotassiumCyanide - (and CFATSChemical AustraliaGroupChemical)
   _246-TrinitroMCresol - (and CFATSChemical SecondaryExplosive)
   Chloroform - CFATSChemical
   TriethylPhosphite - (and CFATSChemical CWCSchedule3Chemical)
   Cyclotrimethylenetrinitramine - (and CFATSChemical SecondaryExplosive)
   Trimethylamine - CFATSChemical
   LeadStyphnate - (and CFATSChemical PrimaryExplosive)
   Amiton - (and CFATSChemical MolecularEntity CWCSchedule2Chemical)
   Nitrocellulose - (and CFATSChemical Propellant)
   EthylPhosphonicDifluoride - (and CFATSChemical CWCSchedule1Chemical)
   Nitromethane - (and CFATSChemical Propellant)
   Chloroethane - (and CFATSChemical MolecularEntity)
   CWAPrecursor - CWARelatedChemical
   TearAgentPrecursor - CWAPrecursor
   CNBPrecursor CSPrecursor CNSPrecursor
   ChloropicrinPrecursor ChloroacetophenonePrecursor CRPrecursor
   CNCPrecursor BromobenzylcyanidePrecursor - TearAgentPrecursor
   VomitAgentPrecursor - CWAPrecursor
   AdamsitePrecursor DiphenylchloroarsinePrecursor DiphenylcyanoarsinePrecursor - VomitAgentPrecursor
   ChokingAgentPrecursor - CWAPrecursor
   NitricOxidePrecursor PerfluoroisobutylenePrecursor - ChokingAgentPrecursor
   BloodAgentPrecursor - CWAPrecursor
   HydrogenCyanidePrecursor ArsinePrecursor CyanogenChloridePrecursor - BloodAgentPrecursor
   Propane - (and HydrogenCyanidePrecursor CFATSChemical GasForFuelingGasFurnace)
   Formamide CyanogenHalide TrimethylsilylCyanide
   HalogenAcid MetalCyanide - HydrogenCyanidePrecursor
   Coke - (and HydrogenCyanidePrecursor MaterialForVitreousCarbonMoldFormation HydrocarbonFuel Catalyst MaterialForVitreousCarbonCrucibleFormation)
   OrganoNitrile Alcohol MercuryIICyanide - HydrogenCyanidePrecursor
   UrticantAgentPrecursor - CWAPrecursor
   PhosgeneOximePrecursor - UrticantAgentPrecursor
   BlisterAgentPrecursor ChlorinatingAgent FluorinatingAgent - CWAPrecursor
   ArsenicBlisterPrecursor - BlisterAgentPrecursor
   LewisitePrecursor PhenyldichloroarsinePrecursor EthyldichloroarsinePrecursor
   MethyldichloroarsinePrecursor - ArsenicBlisterPrecursor
   LewisiteL3Precursor LewisiteL1Precursor LewisiteL2Precursor - LewisitePrecursor
   MustardBlisterPrecursor - BlisterAgentPrecursor
   NitrogenMustardPrecursor - MustardBlisterPrecursor
   NitrogenMustardHN2Precursor NitrogenMustardHN1Precursor NitrogenMustardHN3Precursor - NitrogenMustardPrecursor
   SulfurMustardAgentPrecursor - MustardBlisterPrecursor
   DistilledSulfurMustardPrecursor MustardTMixturePrecursor SesquimustardPrecursor
   MustardTPrecursor - SulfurMustardAgentPrecursor
   SulfurMustardPrecursor - DistilledSulfurMustardPrecursor
   Thiodiglycol - (and CFATSChemical CWCSchedule2Chemical AustraliaGroupChemical SulfurMustardPrecursor)
   EpoxideCatalyst Tetrahydrofuran - SulfurMustardPrecursor
   AlkaliMetal - (and HydrogenCyanidePrecursor SulfurMustardPrecursor)
   AlkaliCarbonate Benzotrichloride EthyleneGlycol
   MetalThiocyanate - SulfurMustardPrecursor
   StrongAcid - (and HydrogenCyanidePrecursor SulfurMustardPrecursor)
   CalciumCarbide _2-Chloroethanethiol - SulfurMustardPrecursor
   VinylChloride - (and CFATSChemical ChlorinatingAgent SulfurMustardPrecursor)
   CarbonElementalEntity DimethylCarbonate - SulfurMustardPrecursor
   Water - (and HydrogenCyanidePrecursor SulfurMustardPrecursor)
   EthyleneSulfide DimethylSulfoxide - SulfurMustardPrecursor
   Acetylene - (and CFATSChemical SulfurMustardPrecursor)
   HypochlorousAcid - (and ChlorinatingAgent SulfurMustardPrecursor)
   SodiumSulfide - (and MolecularEntity AustraliaGroupChemical SulfurMustardPrecursor)
   MetalSulfide _2-Mercaptoethanol Thiourea
   AmmoniumThiocyanate - SulfurMustardPrecursor
   SulfurDichloride - (and ChlorinatingAgent CWCSchedule3Chemical AustraliaGroupChemical SulfurMustardPrecursor)
   Toluene Diphosgene - SulfurMustardPrecursor
   IronChloride - (and Catalyst SulfurMustardPrecursor)
   Naphthalene - (and Catalyst SulfurMustardPrecursor)
   NitrogenGas - (and AnaerobicGas SulfurMustardPrecursor ReducingGasForFiring)
   SodiumSulfate - SulfurMustardPrecursor
   DiphosgenePrecursor - (and ChokingAgentPrecursor SulfurMustardPrecursor)
   StrongBase - (and HydrogenCyanidePrecursor DiphosgenePrecursor)
   FormicAcid - (and HydrogenCyanidePrecursor DiphosgenePrecursor)
   MonomethylCarbonate - DiphosgenePrecursor
   MethylFormate - (and HydrogenCyanidePrecursor CFATSChemical DiphosgenePrecursor)
   MetalIHydrosulfide - SulfurMustardPrecursor
   _2-ChloroethanesulfenylChloride - (and ChlorinatingAgent SulfurMustardPrecursor)
   Sulfur - SulfurMustardPrecursor
   _2-Chloroethanol - (and MolecularEntity ChlorinatingAgent AustraliaGroupChemical SulfurMustardPrecursor)
   Triphosgene CalciumCyanamide - SulfurMustardPrecursor
   MustardLewisiteMixturePrecursor - BlisterAgentPrecursor
   NerveAgentPrecursor - CWAPrecursor
   VAgentPrecursor - NerveAgentPrecursor
   AmitonPrecursor VSPrecursor EdemoPrecursor
   VRPrecursor VEPrecursor VxPrecursor
   VXPrecursor - VAgentPrecursor
   GAgentPrecursor - NerveAgentPrecursor
   CyclosarinPrecursor - GAgentPrecursor
   PerchloricAcid - CyclosarinPrecursor
   CobaltII_IIIOxide - (and Catalyst CyclosarinPrecursor)
   Cyclohexanol SodiumPerchlorate - CyclosarinPrecursor
   AmmoniumPerchlorate - (and CFATSChemical CyclosarinPrecursor)
   CyclohexylMethylphosphonochloridate - (and CWCSchedule2Chemical CyclosarinPrecursor)
   Cobalt Cyclohexane MethylEthylKetone
   Air BariumPerchlorate - CyclosarinPrecursor
   SomanPrecursor - GAgentPrecursor
   PalladiumChloride - (and Catalyst SomanPrecursor)
   DiethylEther - (and CFATSChemical MolecularEntity SomanPrecursor)
   t-Butanol t-ButylMagnesiumChloride - SomanPrecursor
   t-ButylMethylKetone - (and SomanPrecursor AustraliaGroupChemical)
   Magnesium - (and CFATSChemical MolecularEntity MetallothermyReductionMetal SomanPrecursor)
   Ethylene - (and CFATSChemical MolecularEntity SomanPrecursor SulfurMustardPrecursor)
   MercuryIIChloride _23-dimethylbutane-23-diol t-ButylChloride - SomanPrecursor
   PinacolylMethylphosphonochloridate - (and CFATSChemical CWCSchedule1Chemical MolecularEntity SomanPrecursor)
   Ethanol - (and DispersingAgentForRefractoryCeramicConstruction SomanPrecursor SulfurMustardPrecursor)
   Oxygen - (and HydrogenCyanidePrecursor GasForFuelingGasFurnace SomanPrecursor SulfurMustardPrecursor)
   PinacolylAlcohol - (and CWCSchedule2Chemical SomanPrecursor AustraliaGroupChemical)
   CopperChloride - (and Catalyst SomanPrecursor SulfurMustardPrecursor)
   SarinPrecursor GVPrecursor TabunPrecursor - GAgentPrecursor
   Tributylamine - (and SarinPrecursor Catalyst Solvent SomanPrecursor CyclosarinPrecursor)
   AmmoniumFluoride - (and SarinPrecursor FluorinatingAgent SomanPrecursor CyclosarinPrecursor)
   TrimethylPhosphite - (and CFATSChemical SarinPrecursor CWCSchedule3Chemical SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   Acetonitrile - SarinPrecursor
   MethylIodide - (and SarinPrecursor MethylatingAgent SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   TrimethylsilylIodide - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   SilicaChloride - (and CFATSChemical SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   BenzoylFluoride - (and SarinPrecursor FluorinatingAgent SomanPrecursor CyclosarinPrecursor)
   OxalylChloride - (and SarinPrecursor ChlorinatingAgent SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   DiIodine - (and SarinPrecursor SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   Pyridine - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   PhosphorusTriiodide - (and SarinPrecursor SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   DibutylMethylphosphonate - (and CWCSchedule2Chemical SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   MetalFluoride - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   Isopropanol - SarinPrecursor
   MethylAcetate - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   MetalCatalyst - (and HydrogenCyanidePrecursor SarinPrecursor)
   Sodium - (and SarinPrecursor MetallothermyReductionMetal MetalCatalyst SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   Platinum - MetalCatalyst
   Copper - (and MetalMoldMaterial MetalCatalyst CrucibleMaterial)
   Silver - MetalCatalyst
   SiliconDioxide - (and SarinPrecursor FireRetardantForMetal SomanPrecursor CyclosarinPrecursor)
   AcetylFluoride - (and SarinPrecursor FluorinatingAgent SomanPrecursor CyclosarinPrecursor)
   Tetra-n-butylammoniumFluoride - (and SarinPrecursor FluorinatingAgent SomanPrecursor CyclosarinPrecursor)
   Acetone - (and SarinPrecursor SomanPrecursor PostProcessingChemicalForMoltenSaltElectrolysis CyclosarinPrecursor)
   SodiumMethylate - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   DimethylMethylPhosphonate - (and CWCSchedule2Chemical SarinPrecursor SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   TrimethylsilylChloride - (and CFATSChemical MolecularEntity SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   CalciumFluoride - (and SarinPrecursor CrucibleCoating SomanPrecursor MoldCoating CyclosarinPrecursor)
   Triethylamine - (and SarinPrecursor SulfurMustardPrecursor)
   AmineBase - (and SarinPrecursor Catalyst SomanPrecursor CyclosarinPrecursor)
   DimethylEther - (and CFATSChemical MolecularEntity SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   AluminumChloride - (and CFATSChemical MolecularEntity SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   PhosgenePrecursor - (and SarinPrecursor ChokingAgentPrecursor SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   ActivatedCarbon - (and MaterialForVitreousCarbonMoldFormation Catalyst PhosgenePrecursor Desiccant)
   ChlorinePrecursor - (and DiphosgenePrecursor PhosgenePrecursor)
   Bleach - (and ChlorinePrecursor DecontaminationSolution)
   PotassiumPermanganate - (and CFATSChemical MolecularEntity ChlorinePrecursor)
   Pyrolusite - ChlorinePrecursor
   CalciumHypochlorite - (and ChlorinePrecursor ChlorinatingAgent)
   PotassiumCarbonate - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   MethylChloride - (and CFATSChemical MolecularEntity SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   Propan-2-ylMethylphosphonochloridate - (and CFATSChemical CWCSchedule1Chemical MolecularEntity SarinPrecursor)
   MetalIodide - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   DimethylPhosphonate - (and SarinPrecursor CWCSchedule3Chemical SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   PotassiumFluoride - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   t-ButylHydroperoxide - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   MethylPhosphonicDifluoride - (and CFATSChemical CWCSchedule1Chemical SarinPrecursor SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   Methanol - (and HydrogenCyanidePrecursor DiphosgenePrecursor SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   Phosphorus - (and CFATSChemical SarinPrecursor SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   PotassiumIodide - (and SarinPrecursor SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   Aluminum - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   PhosphorusPentachloride - (and CFATSChemical SarinPrecursor ChlorinatingAgent CWCSchedule3Chemical SomanPrecursor AustraliaGroupChemical SulfurMustardPrecursor CyclosarinPrecursor)
   AntimonyPentafluoride - (and CFATSChemical SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   DimethylMethylPhosphonite - (and CWCSchedule2Chemical SarinPrecursor SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   MethylPhosphonicDichloride - (and CWCSchedule2Chemical SarinPrecursor SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   DehydrationCatalyst - (and HydrogenCyanidePrecursor DiphosgenePrecursor SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   SynDol - DehydrationCatalyst
   PotassiumHydroxide - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   MethylPhosphonicAcid - (and CWCSchedule2Chemical SarinPrecursor SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   PhosphorusTrifluoride - (and SarinPrecursor SomanPrecursor CyclosarinPrecursor)
   ThionylChloride - (and CFATSChemical DiphosgenePrecursor SarinPrecursor ChlorinatingAgent CWCSchedule3Chemical SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   OxalicAcid - (and SarinPrecursor SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   EthylSarinPrecursor - GAgentPrecursor
   IncapacitantAgentPrecursor - CWAPrecursor
   BZPrecursor - IncapacitantAgentPrecursor
   CWAProductionByproduct - CWARelatedChemical
   BloodAgentByproduct - CWAProductionByproduct
   HydrogenCyanideByproduct - BloodAgentByproduct
   OrganicLeavingGroup MercuricSulfide HydrogenHalide
   HalogenHalide TrimethylsilylHalide - HydrogenCyanideByproduct
   AluminumOxide - (and CrucibleMaterialForPyrochemicalReduction HydrogenCyanideByproduct Catalyst LinerMaterialForPyrochemicalReduction SaltBathAdditiveForPyrochemicalReduction)
   TrimethylsilylAlkylEther - HydrogenCyanideByproduct
   DiTrimethylsilylEther - (and HydrogenCyanideByproduct Solvent)
   MecuricDihalide Halogen MetalHydrogenSulfate - HydrogenCyanideByproduct
   CyanogenChlorideByproduct ArsineByproduct - BloodAgentByproduct
   IncapacitatingAgentByproduct - CWAProductionByproduct
   BZByproduct - IncapacitatingAgentByproduct
   TearAgentByproduct - CWAProductionByproduct
   ChloropicrinByproduct CRByproduct CSByproduct
   ChloroacetophenoneByproduct CNCByproduct BromobenzylcyanideByproduct
   CNSByproduct CNBByproduct - TearAgentByproduct
   UrticantByproduct - CWAProductionByproduct
   PhosgeneOximeByproduct - UrticantByproduct
   ChokingAgentByproduct - CWAProductionByproduct
   NitricOxideByproduct PerfluoroisobutyleneByproduct - ChokingAgentByproduct
   BlisterAgentByproduct - CWAProductionByproduct
   ArsenicBlisterByproduct MustardLewisiteMixtureByproduct - BlisterAgentByproduct
   LewisiteByproduct PhenyldichloroarsineByproduct MethyldichloroarsineByproduct
   EthyldichloroarsineByproduct - ArsenicBlisterByproduct
   LewisiteL3Byproduct LewisiteL2Byproduct LewisiteL1Byproduct - LewisiteByproduct
   MustardAgentByproduct - BlisterAgentByproduct
   NitrogenMustardByproduct - MustardAgentByproduct
   NitrogenMustardHN2Byproduct NitrogenMustardHN3Byproduct NitrogenMustardHN1Byproduct - NitrogenMustardByproduct
   SulfurMustardAgentByproduct - MustardAgentByproduct
   DistilledSulfurMustardByproduct - SulfurMustardAgentByproduct
   SulfurMustardByproduct - DistilledSulfurMustardByproduct
   _13-bis2-hydroxyethylthioproane IsocyanicAcid EthyleneSulfideOligomer
   Bis2-hydroxyethylthiomethane Thiobisethane-21-diylDibenzoate SodiumCarbonate - SulfurMustardByproduct
   PhosgeneByproduct - (and ChokingAgentByproduct SulfurMustardByproduct)
   CarbonDioxide - (and SarinPrecursor SomanPrecursor PhosgeneByproduct SulfurMustardPrecursor CyclosarinPrecursor)
   _2-2-chloroethylthioethanol - SulfurMustardByproduct
   DiphosgeneByproduct - (and ChokingAgentByproduct SulfurMustardByproduct)
   ChlorineByproduct - (and DiphosgeneByproduct PhosgeneByproduct)
   DisulfurDichloride - (and CWCSchedule3Chemical SulfurMustardByproduct AustraliaGroupChemical)
   CalciumChloride - (and ChemicalPrecipitant SulfurMustardByproduct Desiccant)
   MetalHydroxide PolysulfoMustards MetalCyanate
   Urea Trichloroethylene CalciumSulfide
   CalciumHydroxide Trichloroacetaldehyde Cyanamide - SulfurMustardByproduct
   Dichloromethane - (and SarinPrecursor SulfurMustardByproduct)
   _11-Dichloroethane _2-2-hydroxyethylthioethylBenzoate BenzoicAcid
   CalciumCarbonate _14-bis2-hydroxyethylthiobutane - SulfurMustardByproduct
   CarbonTetrachloride - (and DispersingAgentForRefractoryCeramicConstruction SulfurMustardByproduct)
   HydrogenGas - (and HydrogenCyanidePrecursor CFATSChemical SarinPrecursor SulfurMustardByproduct SomanPrecursor CyclosarinPrecursor)
   _12-bis2-hydroxyethylthioethane - SulfurMustardByproduct
   Acetaldehyde - (and CFATSChemical MolecularEntity SulfurMustardByproduct SomanPrecursor)
   _112-Trichloroethane - SulfurMustardByproduct
   MustardTMixtureByproduct MustardTByproduct SesquimustardByproduct - SulfurMustardAgentByproduct
   NerveAgentByproduct - CWAProductionByproduct
   VAgentByproduct - NerveAgentByproduct
   VEByproduct VxByproduct VSByproduct
   EdemoByproduct VRByproduct AmitonByproduct
   VXByproduct - VAgentByproduct
   GAgentByproduct - NerveAgentByproduct
   SomanByproduct - GAgentByproduct
   MethylMethacrylate MagnesiumHydroxide PinacolHydrate - SomanByproduct
   PinacolylMethylphosphonicAcid - (and CWCSchedule2Chemical SomanByproduct)
   CyclosarinByproduct - GAgentByproduct
   Benzene - CyclosarinByproduct
   SarinByproduct EthylSarinByproduct TabunByproduct
   GVByproduct - GAgentByproduct
   BariumSulfate - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   BenzoylChloride - (and SarinByproduct ChlorinatingAgent CyclosarinByproduct SomanByproduct SulfurMustardPrecursor)
   MethylFluoride - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   MetalIChloride - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   TriethylamineHydrochloride - (and SarinByproduct SomanByproduct)
   HydrogenTetrachloroaluminate - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   SodiumHydroxide - (and SarinByproduct CyclosarinByproduct SomanByproduct SulfurMustardPrecursor)
   IsopropylMethylphosphonicAcid - (and SarinByproduct CWCSchedule2Chemical)
   AntimonyTrifluoride - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   TriethylamineHydrofluoride - SarinByproduct
   CalciumSulfate - (and SarinByproduct CyclosarinByproduct SulfurMustardByproduct Desiccant SomanByproduct)
   Propylene - (and CFATSChemical MolecularEntity SarinByproduct CyclosarinByproduct SulfurMustardByproduct SomanByproduct)
   AcidicWater - (and SarinByproduct ChlorineByproduct CyclosarinByproduct Acid SomanByproduct)
   ManganeseHydroxide - (and SarinByproduct ChlorineByproduct CyclosarinByproduct SomanByproduct)
   PotassiumChloride - (and SarinByproduct ChlorineByproduct CyclosarinByproduct SomanByproduct AustraliaGroupChemical)
   AmmoniumChloride - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   HydrogenPeroxide - (and CFATSChemical MolecularEntity SarinByproduct SomanByproduct CyclosarinPrecursor)
   DiisopropylCarbodiimide - SarinByproduct
   PotassiumBicarbonate - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   ManganeseChloride - (and SarinByproduct ChlorineByproduct CyclosarinByproduct SomanByproduct)
   BaseHydrochlorideSalt - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   PhosphoricAcid - (and SarinByproduct CyclosarinByproduct SulfurMustardByproduct SomanByproduct)
   Ethane - (and CFATSChemical MolecularEntity SarinByproduct CyclosarinByproduct SulfurMustardByproduct SomanByproduct)
   AcetylChloride - (and CFATSChemical MolecularEntity SarinByproduct SomanPrecursor)
   PhosphorousAcid - (and SarinByproduct CyclosarinByproduct SulfurMustardByproduct SomanByproduct)
   BaseHydrofluorideSalt - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   PotassiumBisulfate - (and SarinByproduct CyclosarinByproduct SulfurMustardByproduct SomanByproduct)
   _12-Dichloroethane - (and SarinByproduct CyclosarinByproduct SomanByproduct SulfurMustardPrecursor)
   MagnesiumChlorideHexahydrate - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   EthylEthers - (and SarinByproduct CyclosarinByproduct SulfurMustardByproduct SomanByproduct)
   Tetra-n-butylammoniumChloride - (and SarinByproduct ChlorinatingAgent CyclosarinByproduct SomanByproduct)
   Methane - (and HydrogenCyanidePrecursor CFATSChemical MolecularEntity GasForFuelingGasFurnace SarinByproduct CyclosarinByproduct SulfurMustardByproduct SomanByproduct)
   AntimonyChlorideTetrafluoride - (and SarinByproduct CyclosarinByproduct SomanByproduct)
   Butylene - (and SarinByproduct CyclosarinByproduct SulfurMustardByproduct SomanByproduct)
   VomitAgentByproduct - CWAProductionByproduct
   DiphenylchloroarsineByproduct DiphenylcyanoarsineByproduct AdamsiteByproduct - VomitAgentByproduct
   ChemicalExposureTreatment - ChemicalWeaponRole
   CalciumGluconate - (and MolecularEntity ChemicalExposureTreatment)
   ChemicalAgentTreatment - ChemicalExposureTreatment
   BlisterAgentTreatment - ChemicalAgentTreatment
   BritishAntiLewisite - (and MolecularEntity BlisterAgentTreatment)
   NerveAgentTreatment - ChemicalAgentTreatment
   PyridostigmineBromide Diazepam Mark1Kit - NerveAgentTreatment
   Atropine - (and MolecularEntity NerveAgentTreatment)
   Pralidoxime - NerveAgentTreatment
   SodiumCarbonateSolution - ChemicalAgentTreatment
   ToxicIndustrialChemical - ChemicalWeaponRole
   MediumHazardIndexTIC - ToxicIndustrialChemical
   PhosphorusOxychloride - (and CFATSChemical SarinByproduct CWCSchedule3Chemical CyclosarinByproduct SulfurMustardByproduct SomanByproduct AustraliaGroupChemical MediumHazardIndexTIC)
   SulfurylChloride - (and CFATSChemical MolecularEntity ChlorinatingAgent MediumHazardIndexTIC SulfurMustardPrecursor)
   CarbonMonoxide - (and HydrogenCyanidePrecursor DiphosgenePrecursor PhosgenePrecursor SulfurMustardByproduct MediumHazardIndexTIC)
   MethylChloroformate - (and CFATSChemical DiphosgenePrecursor MediumHazardIndexTIC)
   Acrylonitrile - (and CFATSChemical MolecularEntity MediumHazardIndexTIC)
   HighHazardIndexTIC LowHazardIndexTIC - ToxicIndustrialChemical
   NitricAcid - (and CFATSChemical StrongMonoproticAcid HighHazardIndexTIC PostProcessingChemicalForMoltenSaltElectrolysis CyclosarinPrecursor)
   PhosphorusTrichloride - (and CFATSChemical HighHazardIndexTIC SarinPrecursor ChlorinatingAgent CWCSchedule3Chemical SomanPrecursor AustraliaGroupChemical SulfurMustardPrecursor CyclosarinPrecursor)
   HydrogenFluorideGas - (and CFATSChemical HighHazardIndexTIC SarinPrecursor SomanPrecursor AustraliaGroupChemical CyclosarinPrecursor)
   Ammonia - (and HydrogenCyanidePrecursor CFATSChemical MolecularEntity HighHazardIndexTIC SulfurMustardByproduct)
   HydrogenChlorideGas - (and CFATSChemical HighHazardIndexTIC SarinPrecursor SomanPrecursor AustraliaGroupChemical PhosgeneByproduct SulfurMustardPrecursor CyclosarinPrecursor)
   HydrogenSulfide - (and HydrogenCyanidePrecursor CFATSChemical HighHazardIndexTIC SulfurMustardPrecursor)
   SulfurDioxide - (and CFATSChemical SarinByproduct HighHazardIndexTIC CyclosarinByproduct SomanByproduct DiphosgeneByproduct)
   SulfuricAcid - (and HighHazardIndexTIC SarinPrecursor ToxinPrecipitant SomanPrecursor StrongAcid CyclosarinPrecursor)
   HydrofluoricAcid - (and CFATSChemical StrongMonoproticAcid HighHazardIndexTIC)
   EthyleneOxide - (and CFATSChemical MolecularEntity HighHazardIndexTIC SulfurMustardPrecursor)
   HydrochloricAcid - (and CFATSChemical StrongMonoproticAcid HighHazardIndexTIC SarinPrecursor ToxinPrecipitant ChlorinePrecursor ChlorinatingAgent SomanPrecursor PostProcessingChemicalForMoltenSaltElectrolysis CyclosarinPrecursor)
   CarbonDisulfide - (and CFATSChemical MolecularEntity HighHazardIndexTIC SarinPrecursor SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   Formaldehyde - (and CFATSChemical MolecularEntity HighHazardIndexTIC SulfurMustardByproduct)
   ChemicalAgentExposureIndicator - ChemicalWeaponRole
   OcularExposureIndicator SkinExposureIndicator RespiratoryExposureIndicator - ChemicalAgentExposureIndicator
   ChemicalAgent - ChemicalWeaponRole
   IncapacitatingAgent - ChemicalAgent
   BZ - (and MolecularEntity CWCSchedule2Chemical IncapacitatingAgent)
   UrticantAgent - ChemicalAgent
   PhosgeneOxime - UrticantAgent
   NerveAgent - ChemicalAgent
   VAgent - NerveAgent
   Edemo - (and CWCSchedule1Chemical VAgent)
   VX - (and CFATSChemical CWCSchedule1Chemical VAgent)
   VS - (and CWCSchedule1Chemical VAgent)
   VR - (and CWCSchedule1Chemical VAgent)
   VE - (and CWCSchedule1Chemical VAgent)
   Vx - (and CWCSchedule1Chemical VAgent)
   GAgent - NerveAgent
   Soman - (and CFATSChemical CWCSchedule1Chemical GAgent)
   Sarin - (and CFATSChemical CWCSchedule1Chemical MolecularEntity GAgent)
   Cyclosarin - (and CWCSchedule1Chemical GAgent)
   _2-dimethylamino-ethyl-dimethylphosphoramido-fluoridate - (and MolecularEntity GAgent)
   TearAgent - ChemicalAgent
   Chloroacetophenone - TearAgent
   Bromobenzylcyanide - (and MolecularEntity TearAgent)
   CNS CNB CNC
   CS - TearAgent
   Chloropicrin - (and CWCSchedule3Chemical TearAgent)
   CR - TearAgent
   BlisterAgent - ChemicalAgent
   MustardLewisiteMixture - (and CWCSchedule1Chemical BlisterAgent)
   MustardBlisterAgent - BlisterAgent
   SulfurMustardAgent - MustardBlisterAgent
   Bis2-chloroethylsulfide - (and CFATSChemical CWCSchedule1Chemical SulfurMustardAgent)
   Bis-2-ChloroethylthioEthylEther - (and CFATSChemical CWCSchedule1Chemical SulfurMustardAgent)
   _1_2-Bis-2-ChloroethylthioEthane - (and CFATSChemical CWCSchedule1Chemical SulfurMustardAgent)
   DistilledSulfurMustard - (and CFATSChemical CWCSchedule1Chemical SulfurMustardAgent)
   SulfurMustard - (and CFATSChemical CWCSchedule1Chemical SulfurMustardAgent)
   NitrogenMustardAgent - MustardBlisterAgent
   Bis-2-Chloroethyl-Ethylamine - (and CFATSChemical CWCSchedule1Chemical NitrogenMustardAgent)
   Tris-2-ChloroethylAmine - (and CFATSChemical CWCSchedule1Chemical NitrogenMustardAgent)
   DichloroethylMethylamine - (and CFATSChemical CWCSchedule1Chemical NitrogenMustardAgent)
   ArsenicBlisterAgent - BlisterAgent
   LewisiteAgent - ArsenicBlisterAgent
   Bis-2-chlorovinylchloroarsine - (and CFATSChemical CWCSchedule1Chemical LewisiteAgent)
   _2-Chlorovinyldichloroarsine - (and CFATSChemical CWCSchedule1Chemical LewisiteAgent)
   Tris-2-chloroethenylarsine - (and CFATSChemical CWCSchedule1Chemical LewisiteAgent)
   PhenylDichloroarsine - (and MolecularEntity ArsenicBlisterAgent)
   EthylDichloroarsine - (and MolecularEntity ArsenicBlisterAgent)
   MethylDichloroarsine - (and MolecularEntity ArsenicBlisterAgent)
   BloodAgent - ChemicalAgent
   Arsine - (and HighHazardIndexTIC BloodAgent)
   CyanogenChloride - (and CFATSChemical BloodAgent CWCSchedule3Chemical)
   HydrogenCyanide - (and CFATSChemical HighHazardIndexTIC BloodAgent CWCSchedule3Chemical)
   VomitAgent - ChemicalAgent
   Adamsite - (and MolecularEntity VomitAgent)
   Diphenylchloroarsine Diphenylcyanoarsine - VomitAgent
   ChokingAgent - ChemicalAgent
   Perfluoroisobutylene - (and ChokingAgent CWCSchedule2Chemical)
   NitricOxide - (and HydrogenCyanidePrecursor CFATSChemical ChokingAgent)
   Phosgene - (and CFATSChemical ChokingAgent HighHazardIndexTIC SarinPrecursor ChlorinatingAgent CWCSchedule3Chemical SomanPrecursor SulfurMustardPrecursor CyclosarinPrecursor)
   ChlorineGas - (and ChokingAgent DiphosgenePrecursor HighHazardIndexTIC PhosgenePrecursor ChlorinatingAgent)
   ChemicalWeaponRelatedMaterial ChemicalReferenceMaterial - InformationBearingEntity)
  )

