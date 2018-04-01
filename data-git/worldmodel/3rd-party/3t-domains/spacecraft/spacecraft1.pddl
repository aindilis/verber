
 (in-package :ap)
(define (situation spacecraft1) 
  (:domain spacecraft-domain)
  (:objects
    galileo - (and unmanned-space-craft deep-space)
    dawn - (and unmanned-space-craft deep-space)
    cassini - (and unmanned-space-craft deep-space)
    cassini-visible&-infrared-mapping-spectrometer[-vims] - (and optical-imaging infra-red)
    mars-odyssey - (and unmanned-space-craft deep-space)
    voyager1 - (and unmanned-space-craft deep-space)
    voyager2 - (and unmanned-space-craft deep-space)
    cassini-radio&-plasma-wave-science[-rpws] cassini-plasma-spectrometer[-caps] cassini-magnetospheric-imaging-instrument[-mimi] cassini-ion&-neutral-mass-spectrometer[-inms] cassini-cosmic-dust-analyzer[-cda]  - fields&-particles
    TDRS2 TDRS1  - tracking&-data-relay-satellite
    student-nitrous-oxide-explorer sbirs-low sbirs-high iconos hubble-space-telescope global-star  - orbital
    optical-imaging6 optical-imaging5 optical-imaging4 optical-imaging3 optical-imaging1 optica-imaging2 cassini-imaging-science-subsystem[-iss]  - optical-imaging
    cassini-ultraviolet-imaging-spectrograph[-uvis]  - ultra-violet
    NOAA2 NOAA1  - noaa-weather-satellite
    cassini-boom-mag  - magnetometer
    cassini-radar  - radar
    infra-red4 infra-red3 infra-red2 infra-red1 cassini-composite-infrared-spectrometer[-cirs]  - infra-red
    mars-odyssey-thruster2 mars-odyssey-thruster1 dawn-thruster2 dawn-thruster1 cassini-thruster2 cassini-thruster1  - thrusters
    cassini-rtg3 cassini-rtg2 cassini-rtg1  - radioisotope-thermoelectric-generators
    mars-odyssey-sa dawn-sa  - solar-array
    cassini-radio-science[-rss] cassini-radio&-lasma-wave-science[-rpws]  - radio
    mars-odyssey-rcdr dawn-rcdr cassini-rcdr  - recorder

   )
   (:init
    (has-power-state cassini-rtg2 power_on)
    (has-orbit-type sbirs-low leo-polar)
    (has-network-membership sbirs-low space-network)
    (has-network-membership galileo space-network)
    (has-orbit-type NOAA1 geo-equatorial)
    (has-network-membership NOAA1 space-network)
    (has-orbit-type sbirs-high geo-equatorial)
    (has-network-membership sbirs-high space-network)
    (has-power-state cassini-rtg3 power_on)
    (has-thruster-state cassini-thruster2 thrusters-off)
    (has-orbit-type TDRS2 geo-equatorial)
    (has-network-membership TDRS2 space-network)
    (has-sensor dawn optical-imaging4)
    (has-power-source dawn dawn-sa)
    (current-target dawn saturn)
    (has-network-membership dawn space-network)
    (has-component dawn dawn-thruster2)
    (has-component dawn dawn-rcdr)
    (has-component dawn dawn-thruster1)
    (has-orbit-type NOAA2 geo-equatorial)
    (has-network-membership NOAA2 space-network)
    (has-orbit-type hubble-space-telescope leo-inclined)
    (has-network-membership hubble-space-telescope space-network)
    (has-sensor cassini cassini-cosmic-dust-analyzer[-cda])
    (has-sensor cassini cassini-magnetospheric-imaging-instrument[-mimi])
    (has-sensor cassini cassini-boom-mag)
    (has-sensor cassini cassini-visible&-infrared-mapping-spectrometer[-vims])
    (has-sensor cassini cassini-radar)
    (has-sensor cassini cassini-plasma-spectrometer[-caps])
    (has-sensor cassini cassini-radio&-plasma-wave-science[-rpws])
    (has-sensor cassini cassini-ultraviolet-imaging-spectrograph[-uvis])
    (has-sensor cassini cassini-composite-infrared-spectrometer[-cirs])
    (has-sensor cassini cassini-radio-science[-rss])
    (has-sensor cassini cassini-ion&-neutral-mass-spectrometer[-inms])
    (has-sensor cassini cassini-imaging-science-subsystem[-iss])
    (has-power-source cassini cassini-rtg2)
    (has-power-source cassini cassini-rtg3)
    (has-power-source cassini cassini-rtg1)
    (current-target cassini mars)
    (has-network-membership cassini deep-space-network)
    (has-component cassini cassini-thruster2)
    (has-component cassini cassini-rcdr)
    (has-component cassini cassini-thruster1)
    (has-orbit-type iconos leo-equatorial)
    (has-network-membership iconos space-network)
    (has-orbit-type student-nitrous-oxide-explorer leo-polar)
    (has-network-membership student-nitrous-oxide-explorer space-network)
    (has-power-state cassini-rtg1 power_on)
    (has-orbit-type TDRS1 geo-equatorial)
    (has-network-membership TDRS1 space-network)
    (has-power-source mars-odyssey mars-odyssey-sa)
    (has-network-membership mars-odyssey space-network)
    (has-component mars-odyssey mars-odyssey-thruster2)
    (has-component mars-odyssey mars-odyssey-rcdr)
    (has-component mars-odyssey mars-odyssey-thruster1)
    (has-orbit-type global-star meo-equatorial)
    (has-network-membership global-star space-network)
    (has-thruster-state cassini-thruster1 thrusters-off)
    (has-network-membership voyager1 space-network)
    (has-network-membership voyager2 space-network)
    (has-power-state dawn-sa power_on)
   )
)