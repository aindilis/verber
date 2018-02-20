(the first goal set should obviously be the requirements of being
 productive)

(set up software tests of the planning domains and their results.
 validate plan correctness using a tool.
 (then we can add new things to the planning domains without
  breaking everything, simply by running the regression tests to
  check for regressions)
 )








(some temporal units, aren't in a constant ratio, like seconds and years)

(figure out if PDDL2.2 or later allow predicates to have
 real-valued functions as arguments)
(figure out if derived predicates allow the use of metric functions like > i.e. gt)
(durative actions
 (time-unit :duration)
 (:conditions can have metric functions like >)


 (looks like I need a full blown unit system to add units to
  predicates and such in PDDL.  probably have to convert between
  different values, also incompatible)

 (look up papers on PDDL units management, also, remember that
  Math::Units or whatever)
 )

(Or could just write everything in hours, but then, what about
 monetary conversions, etc.  Could just specify everything in
 dollars.  Could have a default unit for all items.  What about
 monetary conversion.  Maybe this is not convertible because of
 non fixed conversion rates.  SO for instance, you could have
 different predicates for different currencies.  Getting a bit
 complicated.  For currencies could always load in dynamically
 different current values, through Federated planning.  A
 predicate could have a universally applied standard unit, stored
 in the verb format.  Or perhaps just per file.  Then, would need
 a translator module.

 Also note that with times, because of the resolution of time
 values we will want different time interfvals, and to be able to
 plan at different intervals, for instance with the different
 cycles.)

(could combine the specification of predicate units with
 the (unit dollars 0.75) type specification to enable dynamic
 translation.  Would need to elementarily parse, and also be able
 to calculate conversions as needed.  For monetary conversions,
 becomes uncertain as time goes on.  New source of branching
 factor.)

(Concern, not everything will be in .verb format, so going to
 have issues when processing subdomains and such, can't specify
 units)

(I don't think you can simply use Template Toolkit because the
 functions won't be correct)


(
 dpkg --add-architecture i386

 sudo apt-get install libc6-dev-i386 javacc build-essential execstack libc6-i686:i386 openjdk-7-jdk:i386

 sudo update-alternatives --config java
 sudo update-alternatives --config javac
)

(use flora-2 to represent the object type and property
 hierarchies, encode knowledge about which facts belong in which
 domains in flora2 itself.  possibly generate the domains from
 flora-2.)

(
  # my $employer = {
  # 		"Ionzero" => 1,
  # 	       };
  # if (abs(DateTime::Duration->compare($sdt + $dur,$edt))) {
)

(write documentation about the inclusion system and federated
 planning system)

(make a knowledge base about the feature sets of programs)

(crikey does not support derived predicates)

(get a planner with more types available)

(we can use logic forms to represent in closed-world domains)
(we can load preconditions and effects for a special action which
 describes the accomplishment of a goal in psex)

(add the state of the doors from the house manager to the
 planning domain)

(you can use timed initial literals to place the effects of
 certain plans into the planning domain for planning a new one)

(add the ability to have subdirectories of the worlds and
 templates dirs)

(Next thing to do is to add SGPLAN6 or 5 checking of the syntax
 of domains, so that we can know if it's an issue with our domain
 or with the LPG-td planner, when it segfaults)

(figure out how that file (worlds/busroute.p.pddl) got
overwritten and what to do about it (probably when it was called
with verber -w busroute))

(have it call the user if it can't get a hold of the user by
voice query)

(make it so that it includes the subdomains)

(make everything executable from Perl)
(set up unit tests for different planning domains)

(add a goal severity level and plan to accomplish the most
 important goals)

(develop the ability to break down a set of goals that is not
 accomplisable into a small set of goals that is, dropping the
 least valuable goals, and also doing so efficiently, keeping in
 mind that if a goal can not be accomplished, then no set of goals
 containing that goal can be accomplished)

(develop the ability to determine when a plan has failed)
(develop the ability to integrate differing planning domains into one)

(translate everything, including RT tickets, into temporal logics
 and agent logics, etc, in a central planning system.  Be able to
 plan by dropping certain goals as necessary)



(add stuff for eating individual meals)
(add inventory manager for items
 (have ontologies of items, track their locations))
(have the ability for things like fingernails to grow back and
 after a certain amount of time, require clipping again)
(model fatigue)
(model paydays)
(model accurate times)
(model cash, have app that tracks it)




(if LPG-td-1.0 is saying there are actions but is not displaying the plan, try planning with -speed instead of -quality)


(the following setup does not work usually, because the problem
is 'negation by failure' and it would only work if for every
object you specified whether it was clean or dirty
 
  ;; (:derived (clean ?o - object)
  ;;  (not (dirty ?o)))

  ;; (:derived (dirty ?o - object)
  ;;  (not (clean ?o)))

 (or maybe you can if you do something like effects: 
  (dirty ?o) (not (clean ?o)), so it updates both at the same time
  (however this may fail if the effects are applied atomically)))

 (:durative-action clean-object
  :parameters (?o - object)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (clean ?o)))
	      )
  :effect (and 
	   (at end (clean ?o))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )

 (:durative-action clean-building
  :parameters (?b - building ?p - person ?l - location)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (clean ?b)))
	      (at start (at-location ?p ?l))
	      (at start (not (exists (?s - space)
			      (and (at-location ?s ?b) (not (clean ?s))))))
	      )
  :effect (and 
	   (at end (clean ?b))
	   (at end (assign (actions) (+ (actions) 1)))
	   )
  )
