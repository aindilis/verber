#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use XML::Simple;
use Verber::Ext::PDDL::Domain;

my $plannersxml = "/var/lib/myfrdcsa/sandbox/itsimple4.0-beta3/itsimple4.0-beta3/resources/planners/itPlanners.xml";
my $c = read_file($plannersxml);

my $xml = XMLin($c);
# print Dumper($xml);

my $domain = "/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/date-20120908.d.pddl";
my $c2 = read_file($domain);

my $pddld = Verber::Ext::PDDL::Domain->new(Contents => $c2);
$pddld->Parse();
print Dumper($pddld->Requirements);

foreach my $planner (keys %{$xml->{planners}{planner}}) {
  print "$planner\n";
  my $plannerrequirements = $xml->{planners}{planner}{$planner}{requirements};
  my $meetsallrequirements = 1;
  foreach my $requirement (map {s/^:// && $_} keys %{$pddld->Requirements}) {
    if (! exists $plannerrequirements->{lc($requirement)}) {
      $meetsallrequirements = 0;
      print "\t\tMissing $requirement\n";
    }
  }
  if ($meetsallrequirements) {
    print "\tYes\n";
  } else {
    print "\tNo\n";
  }
}


