;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
;;; Procedure text for each pddl leaf action

(defparameter *action-procs*
    '((egress-inside-agent 
       "Procedure 
        1)	Open airlock thermal-cover
        2)	Egress airlock
        3)	Attach ?safety-tether to D-ring extender
        4)      Verify ?safety-tether configuration")
      (egress-by-two
       "Procedure 
        1)	Hand-out a free waist-tether
        2)      Wait untill waist-tether is connected to ?safety-tether
        3)	Egress airlock
        4)	Close thermal cover")
      (safety-tether-for-egress
       "Procedure 
        1)	Receive a waist-tether and connect it to ?safety-tether")
      (ingress-by-two
       "Procedure 
        1)	Open thermal cover
        2)	Ingress airlock
        3)	Tether a waste tether to forward umbilical interface assembly (UIA) tether point; verify waist tether configuration
        4)	Detach ?safety-tether 
        5)	Hand ?safety-tether  outside"
       )
      (untether-for-ingress
       "Procedure 
        1)	Receive ?safety-tether
        2)	Stow ?safety-tether on ?hr 
        3)	Verify reel in UNLOCK")
      (ingress-outside-agent
       "Procedure 
        1)	Attach a waist tether to airlock internal D-ring extender
        2)	Stow ?safety-tether on its hand rail
        3)	Verify reel in UNLOCK
        4)	Ingress airlock
        5)	Close thermal cover, attach Velcro strap")
      (stow
       "Procedure 
        1)	Receive ?item
        2)	Stow ?item")
      (hand-over
       "Procedure 
        1)	Un-tether ?item 
        2)	Hand over ?item")
      (prepare-for-eva
       "Procedure 
        1)	Verify SAFER MAN ISOL valve is open (down)  
        2)	Verify SAFER hand controller mechanism (HCM) - closed (down)
        3)	Verify wireless video system (WVS) LED is ON  
        4)	Perform translation adaptation as required ")
      (pick_up
       "Procedure 
        1)	Tether ?item to suit 
        2)	Un-tether ?item from ?location")
      (pick-up
       "Procedure 
        1)	Tether ?item to suit 
        2)	Un-tether ?item from ?location")
      (Extract-item-to-fs
       "Procedure 
        1)	Tether ?item to ?fs
        2)	remove ?item from at ?location")
      (Extract_item_to_bag
       "Procedure 
        1)	Wait for GO-for-de-mate(?ceta-light) from MCC
        2)	De-mate ceta-connectors from the ?ceta-light stanchion panel 
        3)	Install dust covers on avionics tray
        4)	Release stanchion bolt using ?pgt socket, ~ 16.5 turns 
        5)	Stow ?ceta-light in ?bag")
      (Extract-item-to-bag
       "Procedure 
        1)	Wait for GO-for-de-mate(?ceta-light) from MCC
        2)	De-mate ceta-connectors from the ?ceta-light stanchion panel 
        3)	Install dust covers on avionics tray
        4)	Release stanchion bolt using ?pgt socket, ~ 16.5 turns 
        5)	Stow ?ceta-light in ?bag")
      #|"Procedure 
        1)	Tether ?item to ?fs
	2)	remove ?item from at ?location")
	|#
      (remove-light
       "Procedure 
        1)	Wait for GO-for-de-mate(?ceta-light) from MCC
        2)	De-mate ceta-connectors from the ?ceta-light stanchion panel 
        3)	Install dust covers on avionics tray
        4)	Release stanchion bolt using ?pgt socket, ~ 16.5 turns 
        5)	Stow ?ceta-light in ?bag")
      (vent-tool-assemble
       "Procedure 
        1)	Retrieve ?vent-tool and vent tool extension;
        2)	Verify vent tool extender is locked on to ?vent-tool and connect together if reqd
        3)	Attach vent tool extension to ?mut-ee 
	        Verify: Clock MUT EE such that nozzle points outboard perpendicular to Solar array
        4)	Retrieve ?vt-adapter, from ?vte-bag
        5)	Remove 1 cap from ?vt-adapter 
        6)	Remove cap from vent tool QD
        7)	Mate ?vt-adapter to vent tool QD, per BLOCK B
        8)	Open vent tool QD valve per BLOCK C
        9)	Attach adj tether to ?vt-adapter and temp stow on P6 HR 5309
       10)	Glove Check")
      (vent-tool-stow
       "Procedure 
       1.	Close ?vent-tool QD valve per BLOCK D  
       2.	Demate ?vent-tool from vent tool adapter per BLOCK A  
       3.	Reinstall cap on ?vent-tool-adapter and stow in VTEB
       4.	Reinstall plug on ?vent-tool QD
       5.	Coil?vent-tool and ?vent-tool extension combination and stow in VTEB
       6.	Stow MUT EE in VTEB
       7.	Perform bag inventory
       8.	Stow VTEB on BRT
       9.	Glove and Gauntlet check")
      (jumper-or-line-vent
       "Procedure
       For p1-p5 lines
      1.	Remove cap from vent tool adapter
      2.	Close and demate P6 QD F14 at M14 per BLOCK D and per BLOCK A
      3.	Mate QD F14 to vent tool adapter per BLOCK B, adjust Adj Equip tether as reqd 
      4.	On IV GO, open valve on QD F14 per BLOCK C 

	Wait while jumper line vents (~17min)
      5.	Go to SARJ Cover Removal, P3 (face 4) 7-24

      6.	On IV GO; close QD F14 per BLOCK D 
      7.	Demate QD F14 from vent tool adapter per BLOCK A  
      8.	Mate QD F14 to dummy panel M14 on P5 per BLOCK B 

      NOTE
      Do not open valve on QD F14 after mating
      9.	Reinstall cap on P6 QD male M14

      For eas-jumpers
      1.	Close  and demate QD-02F at M10 per BLOCK D and per BLOCK A
      2.	Mate QD-02F to vent tool adapter per BLOCK B, adjust adj tether as reqd 
      3.	On IV GO, open valve on QD-02F per BLOCK C

	Wait while jumper line vents (~10 min) 

      4.	On IV GO; close QD-02F per BLOCK D  
      5.	Demate QD-02F from vent tool adapter per BLOCK A
      6.	Remove cap from M11
      7.	Mate QD-02F to M11 per BLOCK B

      NOTE
      Do not open valve on QD-02F after mating
      8.	Install cap on M10
      9.	Demate QD Extender at M2 per BLOCK A
      10.	Remove cap from M3
      11.	Mate QD Extender to M3 per BLOCK B 
      12.	Close thermal bootie on QD Extender
      13.	Install cap on M2")
      (fill-p6-radiator
       "Procedure
        1.	On IV GO; open QD-02F at M10 per BLOCK C
        2.	Open QD Extender at M2 per BLOCK C

       ATA fills P6 Radiator (~10min)")
      (install-item	;;;mut-ee
       "Procedure 
        1.	Attach ?mut-ee to P6 HR 5318
	        Verify Locked")
      (install-gas-jumper
       "Procedure 
        1)	Translate to P4 inboard bulkhead M2 dummy male
        2)	Demate QD F2 on M2 per BLOCK A  
        3)	RET QD F2 bale to MWS
        4)	Translate to P3 outboard panel A502 with QD F2
        5)	Route jumper as required
        6)	Attach RET to HR3860
        7)	RET, remove cap from male QD M2
        8)	Mate and open QD F2 to M2 on panel A502 per BLOCK B and BLOCK C
        9)	 Visually inspect jumper connections
        10)	Glove  and Gauntlet Check")
      (open-qd
       "Procedure 
        For QD15
        1)	Translate to P4 HR 5123 (IEA Radiator sidewall)
        2)	Remove wire ties from P3/P4 jumper line and stow in trash bag

        3)	Translate to P4 male QD M15 mated to QD F15
        4)	On IV GO: Open QD F15 per BLOCK C
        5)	Visually inspect jumper connections
        6)	Glove  and Gauntlet Check
        For qd185
        1.      Demate QD F185 from M3 per BLOCK A  
        2.	Mate and open QD F185 to M1 per BLOCK B and BLOCK C 
        3.	Open QD F184 per on M2 BLOCK C
        4.	Install cap on M3
        5.	Notify IV, when valve is open
        For qd14
        1.	Mate  and open QD F14 to P6 M14 per BLOCK B and BLOCK C
        2.	Notify IV, when valve is open
        ")
      (tether-swap
       "Procedure
        1.	Perform safety tether swap from ?st1 to ?st2
                Verify tether config")
      (tether-swap-back
       "Procedure
        1.	Perform safety tether swap from ?st2 to ?st1
                Verify tether config")
      (tether-swap&pickup
       "Procedure
        1.	Perform safety tether swap from ?st2 to ?st1
		Verify tether config
        2.      Detach extender hook from HR
        3.      Stow ?st2 in ?stp")
      (install-tether&swap
       "Procedure
        1.	Attach extender hook to HR
                Verify: Gate closed, hook locked, reel unlocked
        2.      Perform safety tether swap; verify tether config")
      (Install-fqd-in-place
       "Procedure 
        1)    Peal back P1 utility tray shroud; utilize a RET to restrain it open
        2)    Open TA clamp
        3)    Check F186 button installed and tightened
        4)    Demate F186 from M2
        5)    Tether to ?jumper
        6)    Check F187 button installed and tightened
        7)    Demate F187 from M1
        8)    Close TA clamp
        9)    Remove FQD cap from panel P1-A503-M3
       10)    Install FDQ cap from M3 to P1-A503-M2
       11)    Inspect F186 and P1-A503-M3 for debris or damage
       12)    Release F186 ring retracted (forward white band not visible)
       13)    Mate F186 to P1-A503-M3
       14)    Fwd white band visible; perform snapback, pull and FID checks
       15)    Remove FQD cap from panel P3-A501-M1
       16)    Inspect F187 and P1-A501-M1 for debris or damage
       17)    Release F187 ring retracted (forward white band not visible)
       18)    Mate F187 to P3-A501-M1
       19)    Fwd white band visible; perform snapback, pull and FID checks
       20)    Rotate locking collar on F187 to unlock
       21)    Open valve on F187 (push bail fwd)
       22)    Aft white band visible and detent button up
       23)    Install ?spd1 (Push down on latch tabs, 4 capture points, pull test)
       24)    Check button depressed by moving bail aft, then fwd
       25)    Rotate locking collar on F186 to unlock
       26)    Open valve on F186 (push bail fwd)
       27)    Aft white band visible and detent button up
       28)    Install ?spd2 (Push down on latch tabs, 4 capture points, pull test)
       29)    Check button depressed by moving bail aft, then fwd
       30)    Install FQD cap from P3-A501-M1 to P1-A504-M1
       31)    Close P1 utility tray shroud")
      (Install-item-from-container
       "Procedure
        1)	Ingress ?l
        2)	Open MLI door
        3)	Attach fairlead to S0 HR 3495
        4)	Ingress truss
        5)	Check connectors for damage, FOD, bent pins, cable bend radii, and EMI band
        6)	Release S0 P333 (W4145) TA clamp
        7)	Remove cap from S0 CH 1/4 ?jumper J333A, stow on MWS
        8)	Wait-for MCC GO
        9)	De-mate S0 P333 (W4145) from S0 J333; mate to S0 CH 1/4 ?jumper J333A
       10)	Remove cap from S0 CH 1/4 ?jumper P333A, stow on MWS
       11)	Mate S0 CH 1/4 ?jumper P333A to S0 J333
       12)	Insert ?jumper into TA clamp, close clamp
       13)	If necessary, wire tie cable bundle to HR
       14)	Egress truss, remove fairlead
       15)	Close MLI door ")
      (translate_by_handrail
       "Procedure  
         1)	Travel on ?path using hand-rails to ?end-loc
         2)	Tether to ?end-loc")
      (translate-by-handrail
       "Procedure  
         1)	Travel on ?path using hand-rails to ?end-loc
         2)	Tether to ?end-loc")
      (prepare-for-repress
       "Procedure 
        1)	Remove service and cooling umbilical (SCU) from stowage pouch
        2)	Remove displays and controls module (DCM) cover; Velcro to DCM
        3)	Connect SCU to DCM; check SCU Locked
        4)	WATER - OFF (fwd)
        5)	Wait two minutes")
      (close-hatch
       "Procedure 
                            CAUTION
         Do not close hatch until EMU WATER - OFF for 2 minutes

         1)	Verify outer hatch clear of hardware
         2)	Close and lock EV hatch 
         3)	Go to PRE-REPRESS(DEPRESS/REPRESS Cue Card)")
      (deactivate-rga
       "RGA SHUTDOWN
 (MCS/X2R4 - ALL/FIN 2 )  26 NOV 04
 2.606_M_12361.xml
 OBJECTIVE:
 Operational sequence used to ensure the RGA is powered off and shut down
 properly.

1. GNC COMMAND RESPONSE COUNTERS RESET
   PCS MCG : GNC Command Response Counters
   GNC Command Response Counters
   sel Reset
   Verify the Since Reset column values are all blank.
      Do not close this window until the procedure is complete.
      If the Command Accept Counter on a display does not increment
      Reselect GNC Command Response Counters to determine if
      that command was rejected.
     check MCC-H

2. DETERMINING PRIORITIES FOR SHUTDOWN
               NOTE
   It is not necessary to change priority or authorization of an RGA to be
   powered off, and nominally they should not be changed.

3. UPDATING NAVIGATION AUTHORITIES AND PRIORITIES
To change authorizations and update priorities to match those
recorded in step 2, for RGA(s) to be deactivated, perform {6.229
NAVIGATION CONFIGURATION PARAMETERS UPDATE }, steps 6
to all (SODF: GND AVIONICS: MCS: NOMINAL ), then:

4. VERIFYING RPC CONFIGURATION

   MCG : Nav Configuration :?rpc
   RPCM ?rpc
   Verify Integration Counter – incrementing
   Verify Open Cmd – Ena

5. COMMANDING RGA OFF
   PCS MCG : Nav Configuration : Sensor Power
  Navigation Sensor Power
  '?rpc '
  cmd Off
  Verify RPC Position – Op
  Verify Tripped – blank

6. RGA AUTO RECOVERY
  MCG : Nav Configuration : Navigation FDIR
  Navigation FDIR
  'RGA '
  Verify Auto Recovery – as recorded in step 2

7. INHIBITING RT COMMUNICATIONS AND RT FDIR
    NOTE
   1. Any commanding required in this step should be coordinated with
and performed by the ODIN position.
   2. When Russian rate data is available and an RGA fails, the GNC
software will switch to using the Russian data and will not recover
the other RGA.
   3. Inhibiting RT comm to an RGA will not allow the software to
recognize that the RGA is available for auto recovery. Therefore,
performing this step will also functionally disable RGA recovery.

  MCG : Primary GNC MDM : ?rt : RT Status
  ?rt Status
  '23 ?rga '
  Verify RT FDIR Status – Inh
  cmd Inhibit Execute
  Verify RT Status – Inh")
      
      (Reconfig-gps-power
       "RECONFIGURING GPS ANTENNA ASSEMBLY POWER
6.1 Verifying GPS AA Power Source
MCG: Nav Configuration: Sensor Power
Navigation Sensor Power
‘S01A E’
If RPCs 04, 05, 06, or 07 Power – Cl

6.2 Opening ?old-rpc-string GPS Antenna RPCs
PCS S0: EPS: RPCM S01A E
RPCM S01A E
sel RPC [X] where [X] = 4 5 6 7
RPCM S01A E RPC 0X
Verify Tripped – blank
Verify Open Cmd – Ena
cmd RPC Position − Open (Verify − Op)
Repeat

6.3 Closing ?new-rpc-string GPS Antenna RPCS
S0: EPS: RPCM S02B E
RPCM S02B E
sel RPC [X] where [X] = 5 6 7 8
RPCM S02B E RPC 0X
Verify Tripped – blank
Verify Close Cmd – Ena
cmd RPC Position − Close (Verify − Cl)
Repeat
")
      (Shutdown-cmg
       "2.202 CMG SHUTDOWN
(MCS/X2R4 - ALL/FIN 9/SPN ) Page 1 of 8 pages
19 JAN 06
2.202_M_12993.xml
OBJECTIVE:
Spin down and shut down one or more CMGs. Once below a predefined
threshold, the CMG is taken out of the control loop; then, power supplies are
commanded off and priorities are configured such that the CMG cannot be
incorporated back into the control loops.
NOTE
This procedure is valid for the ISS configuration after the patch panel
reconfiguration for CMG 2 on flight LF1. This procedure assumes that
CMG 2 is powered by RPCM Z13B B RPC 18.

1. RESETTING GNC COMMAND RESPONSE COUNTERS
PCS MCG : GNC Command Response Counters
GNC Command Response Counters
sel Reset
Verify the Since Reset column values are all blank.
Do not close this window until the procedure is complete.
If the Command Accept Counter on a display does not increment while
executing a command
Reselect GNC Command Response Counters to determine if
that command was rejected.
Check MCC-H

2. VERIFYING US GNC MODE
MCG
MCG Summary
'MCG Status '
Verify US GNC Mode – CMG TA(CMG Only,Drift,UDG,Standby)

3. DETERMINING CMGs TO BE SHUT DOWN AND VERIFYING
CONFIGURATION FOR REMAINING CMGs
CAUTION
If US GNC Mode is CMG Only, CMG TA, or Drift, the number of
CMGs to be shut down must not result in fewer than two CMGs
online. If US GNC Mode is UDG or Standby, any number of CMGs
may be shut down.
Determine which CMGs are to be shut down via ground call or OSTP.
If it is not recorded elsewhere, record the information below.
Record CMGs to be shut down with braking
Using the Shutdown command: ___________ ___________
___________ ___________
Using the EA Off command: ___________ ___________
___________ ___________

Record CMGs to be shut down without braking: ___________
___________ ___________ ___________
~
Are CMGs required to be powered off upon shutdown
(yes/no)? ___________
Determine desired momentum bias configuration via ground
call or OSTP.
Record Drift Reference Frame : ________________
Record Drift Momentum Vector X : ________________
Record Drift Momentum Vector Y : ________________
Record Drift Momentum Vector Z : ________________
MCG : CMG Configuration
CMG Configuration
Record Current Authorization/Priority for all CMGs.
CMG 1: ___________/ ___________
CMG 2: ___________/ ___________
CMG 3: ___________/ ___________
CMG 4: ___________/ ___________

4. ENABLING RPC OPEN COMMANDS
NOTE
Enabling the RPC Open Commands allows the GNC MDM CMG
FDIR to operate properly in response to the shutdown command.

MCG : ?cmg Configuration : S0 1A ?rpc
RPCM S01A ?rpc
Verify Integration Counter – Incrementing
Check Open Cmd – Ena

5. INITIATING CMG SHUTDOWN WITH BRAKING
MCG : CMG Configuration
CMG Configuration
For each CMG[X] to be shut down with braking (from step 3)
NOTE
1. CMG shutdown with braking in this step will cause the CMG to spin
down. This will take ~10 to 16 hours to spin down completely.
2. Ignore 'CMG[X] Failed ' and 'CMG [X] Wheel Over/Under Speed '
advisories. These messages will be intermittent when wheel speed
is less than 3000 rpm and continuous when wheel speed is less
than 600 rpm.
5.1. Using Shutdown Command
For each CMG[X] to be shut down with Shutdown command
(nominal method) from step 3
sel Spin Motor
CMG Spin Motor
'Spin Motor Power '
cmd Shut Down
Verify Current Wheel Speed, rpm – decreasing
sel CMG[X]
CMG[X]
'Control Authority '
Verify On Line – No
'Spin Motor '
Verify Current CMD, amp : -0.7 ±0.1
~

If CMGs are required to be powered off (from step 3),
go to step 9 .
~
If not,
go to step 7 .
5.2. Using EA Off Command
For each CMG[X] to be shut down with the EA Off command
(not the nominal Shutdown method)
NOTE
The EA Off command is not the nominal method to
shut down a CMG. This command would be performed
if communications had been lost with the CMG and the
nominal Shutdown method was not available.
sel EA Power
CMG EA Power
For CMG 1(3,4)
cmd EA Power –Off
Verify RPC Status – Op
MCG : CMG Overview
CMG Overview
'CMG[X] '
Verify Ready – No
Verify Available – No
Verify On Line – No
For CMG 2
cmd EA Power –Off
Z1 : EPS : RPCM Z13B B : RPC 18
RPCM Z13B B RPC 18
Verify RPC Position – Op
MCG : CMG Overview
CMG Overview
'CMG[X] '
Verify Ready – No
Verify Available – No
Verify On Line – No
~ ~
Go to step 9 .

6. INITIATING CMG SHUTDOWN WITHOUT BRAKING
NOTE
1. It may take several minutes before a decrease in wheel speed is
observed.
2. Beginning at 6598 RPM, the 'CMG[X] Wheel Over/Under Speed '
Advisory will annunciate intermittently.
For each CMG to be shut down without braking (from step 3)
MCG : CMG Configuration
CMG Configuration
sel CMG Authorization & Priority
CMG Authorization & Priority
'Pending Priority '
cmd Non Acitve
Verify Pending Priority – Non Active
For the remaining CMGs
ÖPending Priority is the same as recorded Current
Priority (from step 3)
cmd Incorporate CMG Authorizations and Priorities
Verify CMG 1,2,3,4 Current Authorization matches Pending
Authorization.
Verify CMG 1,2,3,4 Current Priority matches Pending Priority.
CMG Configuration
sel Spin Motor
CMG Spin Motor
'Spin Motor Relay '
cmd Disconnect
Verify Spin Motor Relay – Disconnect
Verify Current Wheel Speed, rpm – decreasing
If the CMG(s) that were shut down without braking are to
remain powered (from step 3)

When ready to reconnect spin motor, go to {2.203
CMG SPIN UP }, step 11 to end (SODF: MCS:
NOMINAL: CMGs ).
~ ~
If not,
go to step 11 .

7. VERIFYING WHEEL SPEED BELOW STEERING LAW THRESHOLD
MCG : CMG Overview
CMG Overview
'MA[X] '
When Whl Speed is less than 6260 rpm, proceed.
'CMG[X] '
Verify Ready – No
Verify Available – No
Verify On Line – No

8. MONITORING END OF SHUTDOWN
CMG Overview
'MA[X] '
When Whl Speed is less than 10 rpm, proceed.
'EA[X] '
Verify Pwr Supplies – light gray with black corners
Verify IG Trqr – light gray with black corners
Verify OG Trqr – light gray with black corners
Verify Spin Motor – light gray with black corners

9. RECONFIGURING CMG PENDING AUTHORIZATIONS AND
PRIORITIES
MCG : CMG Configuration
CMG Configuration
NOTE
All four CMG Pending Authorizations and Priorities will be
incorporated at the same time; therefore, they all must be verified
prior to incorporation.
sel CMG Authorization & Priority
CMG Authorization & Priority
'Pending Authorization '

For all CMGs that were shut down
cmd Unauthorize
Verify Pending Authorization – Unauth
For the remaining CMGs
ÖPending Authorization is the same as recorded Current
Authorization (from step 3)
'Pending Priority '
For all CMGs that were shut down
cmd Non Active
Verify Pending Priority – Non Active
For the remaining CMGs
ÖPending Priority is the same as recorded Current Priority (from
step 3)

10. INCORPORATING CMG AUTHORIZATIONS AND PRIORITIES
CMG Authorization & Priority
cmd Incorporate CMG Authorizations and Priorities
Verify CMG 1,2,3,4 Current Authorization matches Pending
Authorization.
Verify CMG 1,2,3,4 Current Priority matches Pending Priority.

11. POWERING OFF CMGs
For CMGs not previously powered off from step 5.2
CMG Configuration
sel EA Power
CMG EA Power
For CMGs 1(3,4) that were shut down and were required to be
powered off (from step 3)
cmd EA Power Off
Verify RPC Status – Op
For CMG 2 that was shut down and was required to be
powered off (from step 3)
cmd EA Power –Off

Z1 : EPS : RPCM Z13B B : RPC 18
RPCM Z13B B RPC 18
~
Verify RPC Position – Op
~

12. UPDATING US MOMENTUM SERVO REFERENCE FRAME AND
MOMENTUM VECTOR
If a momentum bias is required (from step 3)
MCG : MCS Configuration : Drift
Drift
'Momentum Servo '
input Drift Reference Frame – ___________(from step 3)
input Drift Momentum Vector X – ___________(from step 3)
input Drift Momentum Vector Y – ___________(from step 3)
input Drift Momentum Vector Z – ___________(from step 3)
cmd Set
Verify Commanded Drift Reference Frame – (as commanded)
Verify Commanded Drift Momentum Vector X – (as
commanded)
Verify Commanded Drift Momentum Vector Y – (as
commanded)
Verify Commanded Drift Momentum Vector Z – (as
commanded)

13. INHIBITING I/O TO CMGS POWERED OFF
NOTE
1. Any MCC-H commanding required in this step should be
coordinated with and performed by the ODIN position.
2. This step is only required if the CMG will remain powered off for an
extended period of time.
For CMG[X] that was powered off where [X] = 1(2,3,4)
MCC-H MCG : Primary GNC MDM : LB GNC [X] : RT Status
LB GNC [X] RT Status
'21 CMG [X] '
Verify RT FDIR Status – Inh
cmd RT Status –Inhibit Execute
Verify RT Status – Inh
")
      (Configure-sarj-monitor
 "9. CONFIGURING ?SARJ
PCS P3: EPS: ?Sarj
?Sarj
Record SARJ Mode: ___________________ (From top center of ring)
If SARJ Mode not Autotrack, Blind, or Directed Position
END

9.5 Swapping Joint Resolver
?Sarj
sel Operation
?Sarj Operation
If ?alt-rpc-string Joint Resolver Status – On
Go to step 10.
If ?rpc-string Joint Resolver Status – On
cmd ?rpc-string Joint Resolver Status – Off (Verify – Off)
cmd ?alt-rpc-string Joint Resolver Status – On (Verify – O)"
 )
      (Configure-sarj-commanded
  "9. CONFIGURING ?SARJ
PCS P3: EPS: ?Sarj
?Sarj
Record SARJ Mode: ___________________ (From top center of ring)
If SARJ Mode not Autotrack, Blind, or Directed Position
END

9.1 Commanding SARJ to Checkout
?Sarj
sel Operation
?Sarj Operation
NOTE
1. Sending the Check Out command will cause the SARJ to
stop rotating. If possible, wait for eclipse.
2. It may take several minutes for the SARJ to stop rotation
and for the SARJ Busy flag to clear. Commands will be
rejected by the SARJ until the SARJ Busy flag clears.
‘SARJ Mode’
cmd Check Out
Verify SARJ Mode – Checkout
Verify SARJ Busy – blank
‘?rpc-string’
‘Motor’
cmd Select – None (Verify – None)
cmd String Mode – Monitor (Verify – Monitor)

9.2 Swapping Joint Resolver
If ?rpc-string Joint Resolver Status – On
?Sarj Operation
cmd ?rpc-string Joint Resolver Status – Off (Verify – Off)
cmd ?alt-rpc-string Joint Resolver Status – On (Verify – On)

9.3 Recovering SARJ to Autotrack
If SARJ Mode was Autotrack or Blind (as recorded in step 9)
Perform {4.142 SARJ RECOVERY TO ?ALT-RPC-STRING
AUTOTRACK}, all (SODF: EPS: CORRECTIVE: PRIMARY
POWER SYSTEM), then go to step 10.

9.4 Recovering SARJ to Directed Position

If SARJ Mode was SARJ Directed Position (as recorded in
step 9)
?Sarj Operation
Record SARJ Position: ______________
Perform {4.142 SARJ RECOVERY TO ?ALT-RPC-STRING
AUTOTRACK}, steps 1 to 9 (SODF: EPS: CORRECTIVE:
PRIMARY POWER SYSTEM), then:
‘SARJ Mode’
input Directed Position Angle (as recorded above): ______ º
pick Directed Position Direction – 0 CW (decreasing)
cmd Set
END")
      (Transition-S0-mdm
 "4.511 S0 MDM TRANSITION C: TRANSITIONING S0 MDM FROM
NORMAL/WAIT TO WAIT/DIAGNOSTIC/OFF
(C&DH/12A.1 - ALL/FIN 6) Page 1 of 7 pages
OBJECTIVE:
To transition S0 MDM from Normal/Wait to Wait/Diagnostic/Off.
NOTE
If transitioning to Diagnostic/Off, there will be a loss of insight and control into lower-tiered systems. This mainly affects TCS and EPS. Refer to {3.708 C&DH SSR-8: S0 1 MDM FAILURE} (SODF: C&DH: MALFUNCTION: SSR) and {3.709 C&DH SSR-9: S0 2 MDM FAILURE} (SODF: C&DH: MALFUNCTION: SSR) for a list of the functions and equipment lost.

1. VERIFYING S0 MDM STATUS
PCS CDH: S0 ?mdm-p (?mdm-r) MDM
S0 ?mdm-p (?mdm-r) MDM
Verify Frame Count – incrementing
Verify Processing State – Normal or Wait
If current state is Wait, go to step 4.

2. DISABLING AND ENABLING SPECIFIED APPLICATIONS
NOTE
1. For transitioning S0 1 MDM from Normal to any other state with the intention of using SEPS redundancy in the S0 2 MDM
Disable S0_PTCS LT in S0 1 MDM
Disable EATCS_HAC in S0 1 MDM
Disable S0_SEPS_14 LT in S0 1 MDM
Enable S0_SEPS_14 LT in S0 2 MDM
Otherwise, do not disable any applications in the S0 1 MDM.
2. For transitioning S0 2 MDM from Normal to any other state with the intention of using SEPS redundancy in the S0 1 MDM
Disable S0_PTCS LT in S0 2 MDM
Disable EATCS_HAC in S0 2 MDM
Disable S0_SEPS_23 LT in S0 2 MDM
Enable S0_SEPS_23 LT in S0 1 MDM
Otherwise, do not disable any applications in the S0 2 MDM.
These steps are detailed in steps 2.1, 2.2, 2.3, and 2.4.
07 NOV 06

2.1 Disabling S0 PTCS LT in S0 ?mdm-p (?mdm-r) MDM
CDH: S0 ?mdm-p (?mdm-r) MDM
S0 ?mdm-p (?mdm-r) MDM
‘Software Control’
sel Applications
S0 ?mdm-p (?mdm-r) Applications
cmd PTCS – Inh Execute (Verify – Inh)
NOTE
If a quick power cycle of the MDM is performed, omit steps 2.2 and 2.3.
CAUTION
When the HAC Logical Thread is Inhibited, the Loop A(B) IFHX valves will not be able to be moved until the corresponding ?mdm-p (?mdm-r) is recovered and HAC and the SEPS 14(23) Logical Threads are enabled in that box. If the EATCS Loop A(B) is shutdown due to a transient failure, the Loop cannot be restarted with the IFHX integrated.
2.2 Disabling EATCS HAC Application in S0 ?mdm-p (?mdm-r) MDM
CDH: S0 ?mdm-p (?mdm-r) MDM
‘Software Control’
sel Applications
S0 ?mdm-p (?mdm-r) Applications
cmd EATCS_HAC – Inh Execute (Verify – Inh)
2.3 Disabling S0 SEPS 14(23) LT in S0 ?mdm-p (?mdm-r) MDM
CDH: S0 ?mdm-p (?mdm-r) MDM
S0 ?mdm-p (?mdm-r) MDM
‘Software Control’
sel Applications
S0 ?mdm-p (?mdm-r) Applications
cmd UB_SEPS_S0_14(23) – Inh (Verify – Inh)

2.4 Enabling S0 SEPS 14(23) LT in S0 2(1) MDM
CDH: S0 2(1) MDM
S0 2(1) MDM
‘Software Control’
sel Applications
S0 2(1) Applications
cmd UB_SEPS_S0_14(23) – Ena (Verify – Ena)
3. TRANSITIONING S0 MDM TO WAIT
CDH: S0 ?mdm-p (?mdm-r) MDM
S0 ?mdm-p (?mdm-r) MDM
sel Processing State
S0 ?mdm-p (?mdm-r) Processing State Transitions
‘Current State’
cmd Transition to Wait State Execute
√Current State – Wait
If transitioning to Wait >>
4. INHIBITING S0 MDM RT FDIR
CDH: Primary Ext MDM
Primary Ext MDM
Verify Frame Count – incrementing
Verify Processing State – Normal
If S0 1 MDM
sel LB SYS S 1
sel RT Status
LB SYS S1 RT Status
√27 S0 1 MDM RT FDIR Status – Inh
If S0 2 MDM
sel LB SYS P 2
sel RT Status
LB SYS P2 RT Status
√27 S0 2 MDM RT FDIR Status – Inh

If transitioning to Diagnostic, go to step 5.
If transitioning to Off, go to step 8.
5. SUPPRESSING NUISANCE CAUTION EVENTS (AS DESIRED)
NOTE
The Caution message ‘Prime EXT Detected S0 ?mdm-p (?mdm-r) MDM Fail - S0’ [Event Codes 10405(10406)] may go into alarm if the MDM RT I/O is enabled while transitioning MDM to diagnostics. Suppressing the Caution will prevent annunciation of a tone.
C&W Summ
Caution & Warning Summary
‘Event Code Tools’
sel Suppress
Suppress Annunciation of an Event
input Event Code – 1 0 4 0 5(10406) (‘Prime EXT Detected S0 ?mdm-p (?mdm-r) MDM Fail - S0’)
cmd Arm
cmd Execute
6. TRANSITIONING S0 MDM TO DIAGNOSTIC
NOTE
S0 MDM SDO card channels will remain in the last commanded position when the MDM is transitioned to Diagnostic.
CDH: S0 ?mdm-p (?mdm-r) MDM
S0 ?mdm-p (?mdm-r) MDM
sel Processing State
S0 ?mdm-p (?mdm-r) Processing State Transitions
‘Manual Transition to Diag State’
cmd Arm Execute
√Manual Transition to Diag State – Arm
cmd Transition Execute
S0 ?mdm-p (?mdm-r) MDM
Verify Frame Count – not incrementing

7. VERIFYING S0 MDM IN DIAGNOSTIC
CDH: Primary Ext MDM
Primary Ext MDM
NOTE
A Mode Code command is used to verify that an MDM is in Diagnostic.
‘Software Control’
sel Transmit Mode Code
Primary Ext Transmit Mode Code
Verify RT Address ≠ 27
If RT Address = 27
Clear Mode Code
‘Transmit Mode Code Commands’
input RT Address – 2 3
input Bus ID – 9
input Mode Code – 2
cmd Set Execute
Verify Subsystem Flag – No
Verify RT Address: 23
‘Transmit Mode Code Commands’
NOTE
Bus ID for S0 1 MDM on LB SYS S 1 is 5.
Bus ID for S0 2 MDM on LB SYS P 2 is 4.
input RT Address – 2 7 (for both S0 MDMs)
input Bus ID – 5(4)
input Mode Code – 2
cmd Set Execute
Verify Subsystem Flag – Yes
√RT Address: 27 (for both S0 MDMs)
If keeping S0 MDM in Diagnostic >>

8. INHIBITING S0 MDM RT I/O ON PRIMARY EXT MDM
CDH: Primary Ext MDM
Primary Ext MDM
If S0 1 MDM
sel LB SYS S1
sel RT Status
LB SYS S1 RT Status
cmd 27 S0 1 MDM RT Status – Inhibit Execute
√27 S0 1 MDM RT Status – Inh
If S0 2 MDM
sel LB SYS P 2
sel RT Status
LB SYS P2 RT Status
cmd 27 S0 2 MDM RT Status – Inhibit Execute
√27 S0 2 MDM RT Status – Inh
Verify C&W message ‘Prime EXT Detected S0 ?mdm-p (?mdm-r) MDM Fail - S0 – RTN’ [Event Codes 10405(10406)] return to normal.
9. POWERING OFF S0 MDMs
NOTE
1. S0 MDM SDO card channels will reset to the open position when the MDM is power cycled.
2. The above RPC powers the MDM. The remaining RPCs power SDO cards. The SDO card RPCs will be open and would not require additional commanding until 12A at the earliest.
3. The following can be performed at this point in the procedure only if the S0 2 MDM has been configured as bus controller of UB SEPS-S0-14. Step 2.4 had to be performed.

If Powering Off S0 1 MDM
S0: EPS: RPCM S01A C
RPCM_S01A_C
sel RPC 16
RPCM S01A C RPC 16
cmd RPC Position – Open (Verify – Op)
S0: EPS: RPCM S01A D
RPCM_S01A_D
sel RPC [X] where [X] = 5432
cmd RPC Position – Open (Verify – Op)
Repeat
If Powering Off S0 2 MDM
S0: EPS: RPCM S02B C
RPCM_S02B_C
sel RPC 16
RPCM S02B C RPC 16
cmd RPC Position – Open (Verify – Op)
S0: EPS: RPCM S02B D
RPCM S02B D
sel RPC [X] where [X] = 5432
cmd RPC Position – Open (Verify – Op)
Repeat
")
      (Transition-mdm
 "4.619 STR MDM TRANSITION C: TRANSITIONING STR MDM FROM
NORMAL/WAIT TO WAIT/DIAGNOSTIC/OFF
(C&DH/X2R4A - ALL/FIN 5) Page 1 of 3 pages
30 NOV 04
5299.doc
OBJECTIVE:
Transitions STR MDM from Normal/Wait to Wait/Diagnostic/Off.
NOTE
When transitioning to Diagnostic/Off, there is a loss of
insight and control into lower tiered systems. This mainly
affects TCS. Refer to {3.713 C&DH SSR-13: STR MDM
FAILURE} (SODF: C&DH: MALFUNCTION: SSR) for a list
of the functions and equipment lost.

1. VERIFYING STR MDM STATUS
PCS CDH: STR
STR MDM
Verify Frame Count – incrementing
Verify Processing State – Normal or Wait
If Processing State – Wait, go to step 4.

2. DISABLING/ENABLING SPECIFIED APPLICATIONS
Disabling RDR/RC Control Application in STR MDM
CDH: STR: Applications
STR Applications
Verify RDR Control – Inh
Verify RC Control – Inh

3. TRANSITIONING STR MDM TO WAIT
CDH: STR: Processing State
STR Processing State Transitions
‘Current State’
cmd Transition to Wait State Execute
Verify Current State – WAIT
If transitioning to Wait >>

4. INHIBITING STR MDM RT FDIR
CDH: Primary EXT
Primary Ext MDM
Verify Frame Count – incrementing
Verify Processing State – Normal
sel LB SYS S 1
sel RT Status
LB SYS S 1 RT Status
cmd 21 STR MDM RT FDIR Status – Inhibit FDIR Execute (√ – Inh)

If transitioning to Diagnostic, go to step 5.
If transitioning to Off, go to step 7.

5. TRANSITIONING STR MDM TO DIAGNOSTIC
NOTE
Expect Advisory message ‘Prime Ext MDM Detected
STR MDM Failed’. No action required.
CDH: STR: Processing State
STR Processing State Transitions
‘Manual Transition to Diag State’
cmd Arm Execute
√Manual Transition to Diag State – Arm
cmd Transition Execute
STR MDM
Verify Frame Count – not incrementing

6. VERIFYING STR MDM IN DIAGNOSTIC
NOTE
A Mode Code command is used to verify that an MDM is
in Diagnostic.
CDH: Primary EXT: Transmit Mode Code
Primary Ext Transmit Mode Code
Verify RT Address ≠ 21
If RT Address = 21, Clear Mode Code
‘Transmit Mode Code Commands’
input RT Address – 2 5
input Bus ID – 5
input Mode Code – 2
cmd Set Execute
Verify Subsystem Flag – No
Verify RT Address: 25

‘Transmit Mode Code Commands’
NOTE
Bus ID for STR MDM on LB SYS S 1 is 5.
input RT Address – 2 1
input Bus ID – 5
input Mode Code – 2
cmd Set Execute
Verify Subsystem Flag – Yes
Verify RT Address: 21
If keeping STR MDM in Diagnostic >>

7. INHIBITING STR MDM RT I/O ON PRIMARY EXT MDM
CDH: Primary EXT: LB SYS S 1: RT Status
LB SYS S1 RT Status
cmd 21 STR MDM RT Status – Inhibit Execute (Verify – Inh)
MCC-H Verify Advisory message ‘Prime Ext MDM Detected STR MDM Failed -
Return to Normal’.
8. POWERING OFF STR MDM
NOTE
1. All STR MDM SDO card channels will open when the MDM
is transitioned to Off.
2. Only RPC 3 should be opened. RPCs 4, 5, and 6 need to
remain closed to ensure that survival heaters remain
powered.
S1: EPS: RPCM S11A C: RPC 3
RPCM S11A C RPC 03
cmd RPC Position – Open (Verify – Op)
")
      (Deactivate-ddcu
 "23. DEACTIVATING S0 DDCU S01A CONVERTER
NOTE
Performing this step will result in powering down power
buses P11A, P31A, S01A, and S11A.
S0: EPS: DDCU S01A
DDCU S01A
1.252 S0 DDCU S01A POWERDOWN
(EPS/13A - ALL/FIN 2/SPN) Page 10 of 12 pages
07 MAR 07
15786.doc
sel Converter
DDCU S01A Converter
cmd Converter Off − Off (single-step cmd − Arm not required)
Verify Output Voltage <12.8
Record Converter Off GMT: _____/____:____
Notify MCC-H of recorded GMT and procedure completion.
")
      (Powerdown-ddcu
 "24. POWERING DOWN S0 DDCU S01A
If required
24.1 Inhibiting RT FDIR
CDH: Primary PMCU: LB PMCU 1: RT Status
LB PMCU 1 RT Status
‘20 DDCU S0 1A’
cmd Inhibit FDIR Execute
Verify FDIR Status – Inh
24.2 Opening RBI
S0: EPS: DDCU S01A
DDCU S01A
sel MBSU1 RBI 4
MBSU 1 RBI 4
‘Cmded Position’
‘Open’
cmd Open
Verify Cmded Position – Op
Verify Voltage < 4.2
Record RBI Open GMT: _____/____:____
Notify MCC-H of recorded GMT and procedure completion.
")
      (sband-swap
 "2.402 S-BAND STRING SWAP
(WARN/13A.1 POST EVA3 - ALL/FIN 1/Paper on ISS) Page 31 of 31 pages
20 JUL 07
2.402_M_5960.xml
3. EXPEDITED S-BAND STRING SWAP USING FDIR
3.1 Verifying S-Band FDIR is Enable
PCS C&T: S-Band FDIR: S Band FDIR
'S-Band FDIR'
ÖS-Band FDIR – Enable
If S-Band FDIR – Inhibit
'Enable'
cmd Enable
Verify S-Band FDIR – Enable
'GNC FDIR'
ÖGNC FDIR – Enable
If GNC FDIR – Inhibit
'Enable'
cmd Enable
~
Verify GNC FDIR – Enable
~
3.2 Verifying the Prime String Transponder
C&T: S-Band 1(2): S-Band 1(2) Overview
'Active String'
Record Active String: ________________ (1 or 2)
NOTE
Perform the next step on the active string recorded from step
3.2
3.3 Deactivating the Prime String Transponder
C&T: S-Band 1(2): RPCM S11A B RPC 10 (S-Band 2 P6: Ops
Power - RPCM Z13B B RPC 3)
RPCM S11A B RPC 10(RPCM Z13B RPC 03)
cmd RPC Position – Open (Verify – Op)")
      (shutdown-etcs-loop
 "2.510 ETCS LOOP A(B) PUMP MODULE SHUTDOWN
(TCS/12A.1 STAGE EVA 7 - ALL/FIN 3/SPN)
20 MAR 07
17348.doc

OBJECTIVE:
This procedure gracefully powers down an ETCS Pump Module and the corresponding
external cooling loop.

1. TRANSITIONING FROM DUAL LOOP TO SINGLE LOOP MODE
PCS US Lab: TCS
Lab: IATCS Overview
‘Status’
If IATCS MODE = DUAL
For ETCS Loop A shutdown, perform {2.205 LAB IATCS
TRANSITION TO SINGLE MT (AUTO)} (SODF: TCS: NOMINAL:
IATCS), then:
For ETCS Loop B shutdown, perform {2.204 LAB IATCS
TRANSITION TO SINGLE LT (AUTO)} (SODF: TCS: NOMINAL:
IATCS), then:

2. COMMANDING LTL(MTL) IFHX VALVES TO BYP/CLOSE
If any of the following Caution messages are received, no action required.
‘Thermal Safing Partial LTL Load Shed Timer Started’
‘Thermal Safing Partial MTL Load Shed Timer Started’
‘Thermal Safing LTL Partial Load Shed Initiated’
‘Thermal Safing MTL Partial Load Shed Initiated’
CAUTION
If the valve position is indeterminate, driving the valve in the
direction opposite its last direction of motion can potentially
result in damage to the valve seal.
* *******************************************************************
***
*
If the valve position is indeterminate, driving the valve in
the direction opposite its last direction of motion can
potentially result in damage to the valve seal.
If the valve position is indeterminate, notify MCC-H.
* *******************************************************************
NOTE
Once commanded, if the valve does not reach the
commanded position, the operator is allowed to issue the
same position command up to ten additional times. If the
desired position is still not reached, notify MCC-H. ITCS
heat reduction may be required.
S0: TCS: Loop A(B) IFHX: LAB LTL(MTL) IFHX Commands
LAB LTL(MTL) IFHX Commands
‘Commands’
‘LAB LTL(MTL) IFHX NH3’
‘Byp Vlv’
cmd Bypass – Ena (√Cntl Avail – Ena)
cmd Position – Byp (Verify – Bypass)
‘Isol Vlv’
cmd Close – Ena (√Cntl Avail – Ena)
cmd Position – Close (Verify – Closed)
NOTE
According to SCR 26929/SPN 3017, the Line Htr Inhibit Arm command
is sufficient to inhibit PM Line Heaters. However the Inhibit command
should also be sent because the telemetry feedback will continue to
read Inhibit Arm until the Inhibit command is sent.

3. CONFIGURING LINE HEATER CONTROL ALGORITHM IN
PRIMARY EXT
S1(P1): TCS: PM: ?loop PM Htrs
?loop PM Htrs
‘Commands’
‘In-Line Htrs’
‘Availability’
cmd Inhibit – Arm (√ – √)
cmd Inhibit – Inh
√Availability – Inh
CAUTION
RPCs associated with ?loop Line Heaters must be opened
prior to pump shutdown on the affected loop. Deactivating the
Line Heaters eliminates the risk of plumbing insulation
overheating, breakdown, or localized NH3 boiling in the
affected loops with stagnant conditions.
‘Telemetry’
‘In-Line Htrs’
√Htr 1 RPC Position – Op
√Htr 2 RPC Position – Op

4. INHIBITING RT FDIR
CDH: S1-1 (P1-2)
S1 1 (P1 2) MDM
sel UB SEPS S1 14 (P1 23)
sel RT Status
S1 1 (P1 2) UB SEPS S1 14 (P1 23) RT Status
cmd 28_ETCS_PPA_A(B) RT FDIR Status – Inhibit FDIR Execute
(√ – Inh)

5. POWERING OFF LOOP A(B) PUMPS
S1(P1): TCS: PM: ?loop PCVP Commands
?loop PCVP Commands
‘Commands’
NOTE
All ETCS ?loop data (except the ETCS Loop
A(B) PCVP Out Line HAC Temp) are invalid after
powering off the PCVP.
cmd Pump State Shutdown – Shutdown
√Pump State – Off
‘Telemetry’
‘PCVP’
Verify ?pump Speed: 0 ± 975 rpm
Record ?pump Off: ____ /____:____:_____ GMT

6. VERIFYING LOOP MODE
S1(P1): TCS: ?loop Software: ?loop Manual Startup
?loop Manual Startup
‘Commands’
Verify ETCS Mode – Standby
If the ETCS ?loop is known to be leaking >>

7. RECONFIGURING PM OUT ISOL VALVE
CAUTION
If the PM Out Isol Valve position is indeterminate, driving the
valve in the direction opposite its last direction of motion can
potentially damage the valve seal. If any valve position is
indeterminate, notify MCC-H.
NOTE
Once commanded, if PM valve does not reach the commanded
position, the operator is allowed to issue the same position
command up to 10 additional times.
S1(P1): TCS: PM: ?loop PM Valves
?loop PM Valves
‘Commands’
Verify Out Isol Valve Position – Closed
‘Out Isol Valve’
cmd Open – Arm (√ – √)
cmd Open – Open
√Out Isol Valve Position – Open
")

(Lock-sarj-with-shutdown
 "1.	VERIFYING INITIAL CONDITIONS
P3(S3): EPS: Port(Starboard)SARJ
Port(Starboard)SARJ
sel Operation
Port(Starboard) SARJ Operation
Verify SARJ Mode - Autotrack(Blind,Directed Position)

2.	TRANSITIONING TO SHUTDOWN
 �MCC-H  for Shutdown Angle: _____________________ 
SARJ Mode
input Shutdown Angle - ?angle deg
cmd Set 
Verify Shutdown Angle - Shutdown Angle
cmd SARJ Mode � Shutdown 

Verify SARJ Mode - Shutdown
Verify SARJ Position - Shutdown Angle

NOTE: It may take up to 30 minutes for the SARJ to reach the Shutdown Angle depending upon the initial position.

If String 1 String Mode  -  Commanded
Verify String 1,2 DLA 2 Position - Locked

If String 2 String Mode  -  Commanded
Verify String 1,2 DLA 1 Position - Locked"
 )
      ))

