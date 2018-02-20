Verber

(Please note the temporal planning domains are still undergoing data
 scrubbing/cleaning, they will be released asap)

Contingency planning, crisis management

Traditionally, planning systems are all about finding ways to solve
the combinatoric problem of satisfying a few goals.  Why these goals
are selected is not usually of any consequence.  What we really need
is a system that understands what happens if, for instance, you do not
pay your rent.  Another thing, is that it make sure that the daily
average of some required thing exceeds what it needs to be, hence
ensuring that you don't fall behind.  So, our system is for instance
able to reason as to what consequences will happen if certain actions
are taken or forsaken, and on the basis of this, determine what it
thinks are important goals.

Involve some kind of automatic relational multidimensional queue.
Ensure that it looks at everything (completeness).  A planner that
looks at all possible actions, and calculates what is most effective
for you to do.



<b>Overview:</b>

<p>According  to the  U.S. Army  Survival Manual,  it is  necessary to
develop a "pattern of survival".   People do this with various degrees
of  success.  Software  that  addresses these  issues  has real  world
applicability.</p>

<!--
	During times of extreme pressure, even the most prepared and composed
	professionals might not always remember to do everything at the right
	time. A checklist can prove invaluable in assisting supervisors to keep
	tense situations under control.
-->

<p>Advances in open source  temporal planning technology make possible
the  creation  of  many   useful  real  world  planning  domains.   We
demonstrate  one such domain  which necessarily  utilizes many  of the
features  present  in  PDDL2.2.   This  includes  numeric  quantities,
durative actions, and derived predicates.</p>

<p>By leveraging this planning software, and integrating this planning
domain with  a dialog  and execution manager  agent using  open source
speech  recognition  and  text  to  speech tools,  we  demonstrate  an
effective open source tool for time management and planning.</p>

<b>Example:</b>

<p>Here is the modest  first (anonymized) plan generated by Verber
for buying  groceries.  It was mainly  to serve two  needs, to get
integration with other modules smoothly, and to help me get to the
store.  It uses  actual bus data generated by  the BusRoute Verber
module.   I am working  on developing  query planning  domains, to
plan  the generation of  sub-domains from  modules as  needed. The
intention is  to increase  the coverage of  the domain to  such an
extent that virtually all tasks  in day to day life are completely
scheduled.</p>

<pre>
  Plan computed:
  Time: (ACTION) [action Duration; action Cost]
  19.2500: (RIDEBUS USER BUS-71D-51 CULMORE-AND-DERRY HELMSHIRE-AND-BROOKS) [D:0.0000; C:1.0000]
  19.2500: (BUYGROCERIES USER FORBES-AND-MURRAY) [D:1.0000; C:1.0000]
  20.2500: (RIDEBUS USER BUS-71D-52 HELMSHIRE-AND-BROOKS CULMORE-AND-DERRY) [D:0.0000; C:1.0000]
</pre>

<p>Here is an ancient plan.</p>

<pre>
  Plan computed:
  Time: (ACTION) [action Duration; action Cost]
  0.0000: (MOVE ANDY CS-LOUNGE DOHERTY-LOCKER-161) [D:0.1500; C:2.0000]
  0.1500: (PICK-UP ANDY LAUNDRY DOHERTY-LOCKER-161) [D:0.1000; C:1.0000]
  0.2500: (MOVE ANDY DOHERTY-LOCKER-161 FORBES-AND-CHESTERFIELD) [D:0.1500; C:2.0000]
  0.4000: (SET-DOWN ANDY LAUNDRY FORBES-AND-CHESTERFIELD) [D:0.1000; C:1.0000]
  0.5000: (WASH-LAUNDRY ANDY LAUNDRY FORBES-AVE-LAUNDROMAT FORBES-AND-CHESTERFIELD) [D:2.0000; C:1.0000]
  2.5000: (MOVE ANDY FORBES-AND-CHESTERFIELD BAKER-LOCKER-18) [D:0.1500; C:2.0000]
  2.6500: (PICK-UP ANDY ELECTRIC-RAZOR BAKER-LOCKER-18) [D:0.1000; C:1.0000]
  2.7500: (PICK-UP ANDY TOWEL BAKER-LOCKER-18) [D:0.1000; C:1.0000]
  7.0000: (MOVE ANDY BAKER-LOCKER-18 UC-GYM) [D:0.1500; C:2.0000]
  7.1500: (SHOWER ANDY TOWEL UC-MENS-LOCKER-ROOM-SHOWER UC-GYM) [D:1.0000; C:1.0000]
  8.1500: (MOVE ANDY UC-GYM BAKER-LOCKER-18) [D:0.1500; C:2.0000]
  8.3000: (MOVE ANDY BAKER-LOCKER-18 DOHERTY-4201) [D:0.1500; C:2.0000]
  8.4500: (SET-DOWN ANDY ELECTRIC-RAZOR DOHERTY-4201) [D:0.1000; C:1.0000]
  8.5500: (CHARGE ELECTRIC-RAZOR OUTLET0 ANDY DOHERTY-4201) [D:12.0000; C:1.0000]
  20.5500: (PICK-UP ANDY ELECTRIC-RAZOR DOHERTY-4201) [D:0.1000; C:1.0000]
  20.6500: (MOVE ANDY DOHERTY-4201 FLAGSTAFF-HILL) [D:0.1500; C:2.0000]
  24.0000: (SHAVE ELECTRIC-RAZOR ANDY FLAGSTAFF-HILL) [D:0.2500; C:1.0000]
</pre>

<p>This software aims to improve our ability to reason with the objective
consequeunces of our actions, which is of course necessary in order to
act morally and ethically.</p>

<p>So  the possiblity  of incorporating  plans which  are very  robust is
something we should certainly do  here since this improves the results
and utility  of any planning  process, and is  in a certain  sense the
entire reason we wish to do this.</p>

<p>The system is named after the late Senior Chess Master Richard Verber,
in the spirit illustrated by this quote:</p>

<p><em>"After losing  a game to  the master, Jermaine Bush  realized that
Verber had controlled  the outcome from the opening  move.  This was a
mastery that  the boy yearned for -  both in his chess  playing and in
his life. Yeah, he thought, control!"</em></p>

<p>Verber already incorporates many important features.  It has
support for plan cycles, launching code as a result of a planning
action, domain microtheories, visualization, and an interactive
execution monitor/dialog system.  It is easy to incorporate other
systems and considerations into verber, simply by specifying a
verber module consisting of a pddl file and programmable actions.
Ultimately, HTNs will be exported from PSE to Manager/Verber and
almost all activities will be guided using this combination, with
monitoring sending results to RSR to measure goal
accomplishment.</p>