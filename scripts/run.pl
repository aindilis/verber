#!/usr/bin/perl -w

use Verber::Ext::PDDL::Domain;
use Verber::Ext::PDDL::Problem;

use Verber::Capsule::PDDL22;

# this is a little program to test the basic concept

my $dir = "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds";

my @input =
  (
   "groceries",
   "classes",
  );

my @inputdomains =
  (
#    "cycle.d.pddl",
#    "busroute.d.pddl",
#    "hygiene.d.pddl",
  );

my @inputproblems =
  (
#    "cycle.p.pddl",
#   "busroute.p.pddl",
#   "hygiene.p.pddl",
  );

my $domain = Verber::Ext::PDDL::Domain->new;
my $problem = Verber::Ext::PDDL::Problem->new;

foreach my $file (@input) {
  my $c = `cat "$dir/$file.d.pddl"`;
  $domain->Merge(Contents => $c);
  $c = `cat "$dir/$file.p.pddl"`;
  $problem->Merge(Contents => $c);
}

foreach my $file (@inputdomains) {
  my $c = `cat "$dir/$file"`;
  $domain->Merge(Contents => $c);
}

foreach my $file (@inputproblems) {
  my $c = `cat "$dir/$file"`;
  $problem->Merge(Contents => $c);
}

my $resultlocation = "/var/lib/myfrdcsa/codebases/internal/verber/data/results";
my $domainfile = "domain.d.pddl";
my $problemfile = "problem.p.pddl";

# now that we have these, generate two new ones in a tmp directory
open(OUT,">$resultlocation/$domainfile") or die "ouch";
print OUT $domain->Generate;
close(OUT);
open(OUT,">$resultlocation/$problemfile") or die "ouch";
print OUT $problem->Generate;
close(OUT);

# now, run a planner on these
# my $plannername = "SGPlan";
my $plannername = "LPG";
require "/var/lib/myfrdcsa/codebases/internal/verber/Verber/Planner/$plannername.pm";
my $planner = "Verber::Planner::$plannername"->new;

$planner->Capsule
  (Verber::Capsule::PDDL22->new
   (
    Dir => $resultlocation,
    DomainFile => $domainfile,
    ProblemFile => $problemfile,
   ));

$planner->Plan;
