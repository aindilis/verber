package Verber::Util::Requirements;

use Verber::Ext::PDDL::Domain;
use Verber::Ext::PDDL::Problem;

use Data::Dumper;
use IO::File;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / / ];

sub init {
  my ($self,%args) = @_;
}

sub MapRequirements {
  my ($self,%args) = @_;
  # first create all the test domains
  my $worlddir = $UNIVERSAL::systemdir."/data/worldmodel/test";
  system "rm $worlddir/*";
  my $extension = "pddl";

  my $requirements =
    {
     PDDL3 =>
     [qw(strips typing negative-preconditions disjunctive-preconditions
	 equality existential-preconditions universal-preconditions
	 quantified-preconditions conditional-effects fluents adl
	 durative-actions derived-predicates timed-initial-literals preferences
	 constraints)],
    };

  # foreach planner
  my $planners = {};

  my $dir = $UNIVERSAL::systemdir."/Verber/Planner";
  foreach my $plannername (@{$UNIVERSAL::verber->ListPlanners}) {
    require "$dir/$plannername.pm";
    my $planner = "Verber::Planner::$plannername"->new();
    $planners->{$plannername} = $planner;
  }

  my $supported = {};
  foreach my $lang (qw(PDDL3)) {
    foreach my $requirement (@{$requirements->{$lang}}) {
      my $domainname = "requirement-test-$requirement";
      my $domain = Verber::Ext::PDDL::Domain->new
	();
      my $problem = Verber::Ext::PDDL::Problem->new
	();
      # now go ahead and add the requirement, then generate the result
      $domain->Domain(uc($domainname));
      $domain->AddRequirement(Requirement => ":".$requirement);
      $problem->Problem(uc($domainname));
      $problem->Domain(uc($domainname));

      # add initial facts
      # domain

      $domain->AddType
	(
	 SubType => "type1",
	 SuperType => "object",
	);

      $domain->Predicates->{"pred1"} =
	["pred1", "?obj", "-", "type1"];

      my $action1 = <<EOF
(:action action1
:parameters
(?o1 ?o2 - object)
:precondition
(and
 (pred1 ?o1)
)
:effect
(and
 (pred1 ?o2)
))
EOF
	;
	$domain->AddGeneral
	  (Container => "Actions",
	   String => $action1);

      # problem

      $problem->AddObject
	(
	 Type => "type1",
	 Object => "obj1",
	);
      $problem->AddObject
	(
	 Type => "type1",
	 Object => "obj2",
	);

      $problem->AddInit
	(Structure => ["pred1", "obj1"]);

      $problem->AddGoal
	(Structure => ["pred1", "obj2"]);


      # now generate the domain, and then foreach planner, run the planner on it
      my $domainfile = $worlddir."/".$domainname.".d.".$extension;
      my $fh1 = IO::File->new;
      $fh1->open(">$domainfile") or die "Cannot open $domainfile for writing\n";
      print "DOMAINFILE: $domainfile\n";
      print $fh1 $domain->Generate;

      my $problemfile = $worlddir."/".$domainname.".p.".$extension;
      my $fh2 = IO::File->new;
      $fh2->open(">$problemfile") or die "Cannot open $problemfile for writing\n";
      print "PROBLEMFILE: $problemfile\n";
      print $fh2 $problem->Generate;

      my $world = Verber::World->new
	(
	 Name => $domainname,
	 WorldDir => $worlddir,
	 Extension => $extension,
	);

      foreach my $plannername (sort keys %$planners) {
	my $planner = $planners->{$plannername};
	print "PLANNER: $plannername\n";
	$planner->MyCapsule
	  ($world->MyCapsule);
	my $plan = $planner->DevelopPlan;
	if ($plan->TeeErrFile->Contents !~ /requirement .+ not supported by this IPP version/) {
	  $supported->{$plannername}->{$lang}->{$requirement} = 1;
	}
      }
    }
  }
  print Dumper($supported);
}

1;


#                            Description
#                            Basic STRIPS-style adds and deletes
#   :strips
#                            Allow type names in declarations of variables
#   :typing
#                            Allow not in goal descriptions
#   :negative-preconditions
#                            Allow or in goal descriptions
#   :disjunctive-preconditions
#                            Support = as built-in predicate
#   :equality
#                            Allow exists in goal descriptions
#   :existential-preconditions
#                            Allow forall in goal descriptions
#   :universal-preconditions
#   = :existential-preconditions
#   :quantified-preconditions
#   + :universal-preconditions
#                            Allow when in action effects
#   :conditional-effects
#                            Allow function definitions and use of effects using
#   :fluents
#                            assignment operators and arithmetic preconditions.
#   = :strips + :typing
#   :adl
#   + :negative-preconditions
#   + :disjunctive-preconditions
#   + :equality
#   + :quantified-preconditions
#   + :conditional-effects
#                            Allows durative actions.
#   :durative-actions
#                            Note that this does not imply :fluents.
#                            Allows predicates whose truth value is
#   :derived-predicates
#                            defined by a formula
#                            Allows the initial state to specify literals
#   :timed-initial-literals
#                            that will become true at a specified time point
#                            implies durative actions
#                            Allows use of preferences in action
#   :preferences
#                            preconditions and goals.
#                            Allows use of constraints fields in
#   :constraints
#                            domain and problem files. These may contain
#                            modal operators supporting trajectory
#                            constraints.
