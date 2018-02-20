package Verber::Federated::PSEx;

use Manager::Misc::Light;
use PerlLib::Util;
use UniLang::Util::TempAgent;
use Verber::Ext::PDDL::Problem;
use Verber::Ext::PDDL::Domain;

use Data::Dumper;
use IO::File;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / MyTempAgent MyDomain MyProblem MyLight / ];

sub init {
  my ($self,%args) = @_;
  $self->MyTempAgent
    (UniLang::Util::TempAgent->new);
  $self->MyDomain
    (Verber::Ext::PDDL::Domain->new());
  $self->MyProblem
    (Verber::Ext::PDDL::Problem->new());
  $self->MyLight
    (Manager::Misc::Light->new);
}

sub GenerateDomain {
  my ($self,%args) = @_;
  $self->MyProblem->AddInit
    (
     Structure =>
     [
      "=",
      [
       "budget",
      ],
      "100",
     ]
    );
  my $message = $self->MyTempAgent->MyAgent->QueryAgent
    (
     Receiver => "KBS",
     Contents => "pse-x all-asserted-knowledge",
     # Contents => "pse-x-test all-asserted-knowledge",
    );
  # print Dumper($message);
  if (defined $message) {
    my $assertions = DeDumper($message->Contents);
    foreach my $assertion (@$assertions) {
      my $pred = $assertion->[0];
      if ($pred eq "depends") {
	if (1) {
	  $self->MyProblem->AddConstraint
	    (
	     Structure =>
	     [
	      "sometime-before",
	      ["completed",$self->AddEntry($assertion->[1])],
	      ["completed",$self->AddEntry($assertion->[2])],
	     ]
	    );
	}
      } elsif ($pred eq "provides") {
	$self->MyProblem->AddInit
	  (
	   Structure =>
	   [
	    "provides",
	    $self->AddEntry($assertion->[1]),
	    $self->AddEntry($assertion->[2]),
	   ]
	  );
      } elsif ($pred eq "eases") {
	if (0) {
	  my $entryname1 = $self->AddEntry($assertion->[1]);
	  my $entryname2 = $self->AddEntry($assertion->[2]);
	  my $preferencename = "eases-$entryname1-$entryname2";
	  $self->AddPreference($preferencename);

	  $self->MyProblem->AddConstraint
	    (
	     Structure =>
	     [
	      "preference",
	      $preferencename,
	      [
	       "sometime-before",
	       ["completed",$entryname1],
	       ["completed",$entryname2],
	      ],
	     ]
	    );
	}
      } elsif ($pred eq "costs") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $cost = $assertion->[2];
	my $finalcost;
	if ($cost =~ /\$(\d+)/) {
	  $finalcost = $1;
	}
	$self->MyProblem->AddInit
	  (
	   Structure =>
	   [
	    "=",
	    [
	     "cost",
	     $entryname1,
	    ],
	    $finalcost,
	   ]
	  );
      } elsif ($pred eq "earns") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $tmp = $assertion->[2];
	my $finalcost;
	if ($tmp =~ /\$(\d+)/) {
	  $earnings = $1;
	}
	$self->MyProblem->AddInit
	  (
	   Structure =>
	   [
	    "=",
	    [
	     "cost",
	     $entryname1,
	    ],
	    "-".$earnings,
	   ]
	  );
      } elsif ($pred eq "goal") {
	$self->MyProblem->AddGoal
	  (
	   Structure =>
	   [
	    "completed",
	    $self->AddEntry($assertion->[1]),
	   ]
	  );
      } else {
	print "Unknown Predicate: $pred\n";
      }
    }
    # now print the problem file for now
    $self->MyProblem->Problem("PSEX");
    $self->MyProblem->Domain("PSEX");
    # print out to the problem file in the world section
    my $fh = IO::File->new;
    $fh->open(">/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/psex.p.pddl")
      or die "can't open\n";
    print $fh $self->MyProblem->Generate;
  }
}

sub RelToPDDL {
  my ($self,$rel) = @_;
  # now just pretty print this
  return $self->MyLight->PrettyGenerate
    (Structure => [$rel]);
}

sub AddEntry {
  my ($self,$entryid) = @_;
  my $name = "entry-".$entryid;
  $self->MyProblem->AddObject
    (
     Type => "unilang-entry",
     Object => $name,
    );
  return $name;
}

sub AddPreference {
  my ($self,$preference) = @_;
  print "Don't know what to do just yet here\n";
}

1;
