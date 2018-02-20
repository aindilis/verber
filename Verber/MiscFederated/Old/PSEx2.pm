package Verber::Federated::PSEx2;

# this is to be the version of PSEx that uses KBS2

use Moose;

use Corpus::Util::UniLang;
use KBS2::Client;
use PerlLib::SwissArmyKnife;
use PerlLib::Util;
use SPSE2::Util;
use UniLang::Util::TempAgent;
use Verber::Ext::PDDL::Problem;
use Verber::Ext::PDDL::Domain;
use Verber::Util::DateManip;
use Verber::Util::Graph;
use Verber::Util::Light;

use Data::Dumper;
use Date::ICal;
use Date::Parse;
use DateTime;
use DateTime::Duration;
use DateTime::Format::ICal;
use DateTime::Format::Strptime;
use Graph::Directed;
use IO::File;

extends 'Verber::Federated';

has 'RegisteredWorldNames' => (is => 'rw',isa => 'ArrayRef',default => sub {[qw(psex2)]});

has 'DomainIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {[]});
has 'ProblemIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {[]});

has 'DateManip' =>
  (
   is => 'rw',
   isa => 'Verber::Util::DateManip',
   default => sub { # $args{DateManip} ||
     Verber::Util::DateManip->new;
   },
  );

has 'StartDate' => (is  => 'rw',isa => 'DateTime');
has 'Units' => (is  => 'rw',isa => 'DateTime::Duration');

has 'UniLang' =>
  (
   is => 'rw',
   isa => 'Corpus::Util::UniLang',
   default => sub { Corpus::Util::UniLang->new },
  );

has 'TempAgent' =>
  (
   is  => 'rw',
   isa => 'UniLang::Util::TempAgent',
   default => sub {UniLang::Util::TempAgent->new},
  );

has 'Domain' =>
  (
   is  => 'rw',
   isa => 'Verber::Ext::PDDL::Domain',
   default => sub {Verber::Ext::PDDL::Domain->new},
  );

has 'Problem' =>
  (
   is  => 'rw',
   isa => 'Verber::Ext::PDDL::Problem',
   default => sub {Verber::Ext::PDDL::Problem->new},
  );

has 'Light' =>
  (
   is  => 'rw',
   isa => 'Verber::Util::Light',
   default => sub {Verber::Util::Light->new},
  );

has 'Client' =>
  (
   is  => 'rw',
   isa => 'KBS2::Client',
   default => sub {KBS2::Client->new},
  );

has 'Entries' => (is  => 'rw',isa => 'HashRef',default => sub {{}});
has 'EntryData' => (is  => 'rw',isa => 'HashRef',default => sub {{}});
has 'Marks' => (is  => 'rw',isa => 'HashRef',default => sub {{}});
has 'Preferences' => (is  => 'rw',isa => 'HashRef',default => sub {{}});
has 'Data' => (is  => 'rw',isa => 'HashRef',default => sub {{}});

has 'Context' =>
  (
   is  => 'rw',
   isa => 'Str',
   default => sub {
     # $args{Context} ||
     "Org::FRDCSA::Verber::PSEx2::Do" || "Org::FRDCSA::Verber::PSEx2::Verber";
   },
  );

has 'Graph' =>
  (
   is  => 'rw',
   isa => 'Verber::Util::Graph',
   default => sub {Verber::Util::Graph->new},
  );

has 'DependencyGraph' =>
  (
   is  => 'rw',
   isa => 'Graph::Directed',
   default => sub {Graph::Directed->new},
  );

override 'GenerateDomainPrototype' => sub {
  my ($self,%args) = @_;
  print Dumper({MySillyArgs => \%args});
  if ($args{Context}) {
    $self->Context($args{Context});
  }
  my $contents = read_file($args{TemplateFilename});
  my $domain = $self->SUPER::GenerateDomainPrototype
    (
     %args,
     Contents => $contents,
    );
  return $domain;
};

override 'GenerateProblemPrototype' => sub {
  my ($self,%args) = @_;
  my $contents = ""; # read_file($args{TemplateFilename});
  my $problem = $self->SUPER::GenerateProblemPrototype
    (
     %args,
     Contents => $contents,
    );
  $self->Generate();
  return $self->Problem;
};

sub Generate {
  my ($self,%args) = @_;
  print Dumper({OhNoYouDidnt => 1});
  $self->Marks->{AltersBudget} = {};
  $self->Marks->{Completed} = {};

  $self->Problem->StartDate
    ($self->DateManip->GetPresent());

  $self->Problem->Units
    (DateTime::Duration->new(hours => 1));

  $self->Problem->AddInit
    (
     Structure =>
     [
      "=",
      [
       "budget",
       "andy",
      ],
      "500",
     ]
    );

  my $message = $self->Client->Send
    (
     QueryAgent => 1,
     Command => "all-asserted-knowledge",
     Context => $self->Context,
    );

  # print Dumper($message);
  if (defined $message) {
    my $assertions = $message->{Data}->{Result};
    foreach my $assertion (@$assertions) {
      my $pred = $assertion->[0];
      if ($assertion->[0] eq "has-NL") {
	$self->Data->{NL}->{$assertion->[1]->[1]}->{$assertion->[1]->[2]} = $assertion->[2];
	$self->Data->{iNL}->{$assertion->[1]->[1]}->{$assertion->[2]} = $assertion->[1]->[2];
      }
    }

    foreach my $assertion (@$assertions) {
      my $pred = $assertion->[0];
      if ($pred eq "depends") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $entryname2 = $self->AddEntry($assertion->[2]);
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "depends",
	    $entryname1,
	    $entryname2,
	   ]
	  );
	$self->Graph->AddEdge
	  (
	   Self => $self,
	   EN1 => $entryname1,
	   EN2 => $entryname2,
	   Pred => "depends",
	  );
	$self->DependencyGraph->add_edge
	  ($entryname1,$entryname2);
      } elsif ($pred eq "provides") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $entryname2 = $self->AddEntry($assertion->[2]);
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "provides",
	    $entryname1,
	    $entryname2,
	   ]
	  );
	$self->Graph->AddEdge
	  (
	   Self => $self,
	   EN1 => $entryname1,
	   EN2 => $entryname2,
	   Pred => "provides",
	  );
      } elsif ($pred eq "eases") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $entryname2 = $self->AddEntry($assertion->[2]);
	my $preferencename = "eases-$entryname1-$entryname2";
	$self->AddPreference($preferencename);
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "eases",
	    $self->AddEntry($assertion->[1]),
	    $self->AddEntry($assertion->[2]),
	   ],
	  );
	$self->Graph->AddEdge
	  (
	   Self => $self,
	   EN1 => $entryname1,
	   EN2 => $entryname2,
	   Pred => "eases",
	  );

      } elsif ($pred eq "costs") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $costs = $assertion->[2];
	my $finalcosts;
	if ($costs =~ /\$(\d+)/) {
	  $finalcosts = $1;
	}
	$self->Marks->{AltersBudget}->{$entryname1} = 1;
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "=",
	    [
	     "costs",
	     $entryname1,
	    ],
	    $finalcosts,
	   ]
	  );
      } elsif ($pred eq "earns") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $tmp = $assertion->[2];
	my $finalcosts;
	my $earnings = 0;
	if ($tmp =~ /\$(\d+)/) {
	  $earnings = $1;
	}
	$self->Marks->{AltersBudget}->{$entryname1} = 1;
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "=",
	    [
	     "earns",
	     $entryname1,
	    ],
	    $earnings,
	   ]
	  );
      } elsif ($pred eq "completed") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "completed",
	    $entryname1,
	   ]
	  );
	$self->Marks->{Completed}->{$entryname1} = 1;
      } elsif ($pred eq "pse-has-property") {
	if ($assertion->[2] eq "very important" or $assertion->[2] eq "important") {
	  my $entryname1 = $self->AddEntry($assertion->[1]);
	  $self->Problem->AddGoal
	    (
	     Structure =>
	     [
	      "completed",
	      $entryname1,
	     ]
	    );
	}
      } elsif ($pred eq "goal") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	if (0) {
	  $self->Preferences->{"p-".$entryname1} = 1;
	  $self->Problem->AddGoal
	    (
	     Structure =>
	     [
	      "preference",
	      "p-".$entryname1,
	      [
	       "completed",
	       $entryname1,
	      ],
	     ]
	    );
	}
	$self->Problem->AddGoal
	  (
	   Structure =>
	   [
	    "completed",
	    $entryname1,
	   ]
	  );
      } elsif ($pred eq "due-date-for-entry") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $dateinformation = $assertion->[2];
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "at",
	    $self->DateManip->FormatDatetime
	    (Datetime => $dateinformation),
	    [
	     "overdue",
	     $entryname1,
	    ],
	   ]
	  );
      } elsif ($pred eq "start-date") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $dateinformation = $assertion->[2];
	$self->EntryData->{$entryname1}->{"begin-opportunity"} = $dateinformation;
      } elsif ($pred eq "event-duration") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $durationinformation = $assertion->[2];
	$self->EntryData->{$entryname1}->{"opportunity-duration"} = $durationinformation;
      } elsif ($pred eq "end-date") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $dateinformation = $assertion->[2];
	$self->EntryData->{$entryname1}->{"end-opportunity"} = $dateinformation;
      } else {
	print "Unknown Predicate: $pred\n";
      }
    }
    # now add costs definitions to all entries that haven't had it defined

    foreach my $name (keys %{$self->Entries}) {
      if (0 and ! exists $self->Marks->{AltersBudget}->{$name}) {
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "=",
	    [
	     "costs",
	     $name,
	    ],
	    "0",
	   ]
	  );
      }
      if (0 and ! exists $self->Marks->{Completed}->{$name}) {
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "not",
	    [
	     "completed",
	     $name,
	    ],
	   ]
	  );
      }
    }

    my @metric;
    # push @metric, ["*","10",["is-violated","b1"]];
    foreach my $pref (keys %{$self->Preferences}) {
      push @metric, ["*","10",["is-violated", $pref]];
    }

    if (1) {
      $self->Problem->AddMetric
	(Structure => ["minimize", ["total-time"]]);
    } elsif (0) {
      $self->Problem->AddMetric
	(Structure => ["maximize", ["budget", "andy"]]);
    } else {
      $self->Problem->AddMetric
	(Structure => ["minimize", ["-",["+", @metric], ["budget", "andy"]]]);
    }
    $self->Problem->AddObject
      (
       Type => "person",
       Object => "andy",
      );

    # $self->Problem->AddConstraint
    # (Structure => ["preference", "b1", ["always", [">=", ["budget", "andy"], "0"]]]);

    # $self->Problem->AddConstraint
    # (Structure => ["preference", "b1", ["always", ["=", ["budget", "andy"], "0"]]]);

    # $self->Problem->AddConstraint
    # (Structure => ["preference", "b1", ["always", ["=", ["budget", "andy"], "0"]]]);

    # $self->Problem->AddConstraint
    # (Structure => ["always", [">", ["budget", "andy"], "0"]]);


    # now update all opportunity windows
    foreach my $entry (keys %{$self->EntryData}) {
      my @missing;
      foreach my $item (qw(begin-opportunity end-opportunity opportunity-duration)) {
	if (! exists $self->EntryData->{$entry}->{$item}) {
	  push @missing, $item;
	}
      }
      if (scalar @missing <= 1) {
	my ($sdt,$edt,$dur);
	if (exists $self->EntryData->{$entry}->{"begin-opportunity"}) {
	  # print Dumper($self->EntryData->{$entry}->{"begin-opportunity"});
	  # my $startepoch = str2time($self->EntryData->{$entry}->{"begin-opportunity"});
	  my $startepoch = Date::ICal->new( ical => $self->EntryData->{$entry}->{"begin-opportunity"})->epoch;
	  $sdt = DateTime->from_epoch(epoch => $startepoch);
	}
	if (exists $self->EntryData->{$entry}->{"end-opportunity"}) {
	  # print Dumper($self->EntryData->{$entry}->{"end-opportunity"});
	  # my $endepoch = str2time($self->EntryData->{$entry}->{"end-opportunity"});
	  my $endepoch = Date::ICal->new( ical => $self->EntryData->{$entry}->{"end-opportunity"})->epoch;
	  $edt = DateTime->from_epoch(epoch => $endepoch);
	}
	if (exists $self->EntryData->{$entry}->{"opportunity-duration"}) {
	  my %hash = ();
	  foreach my $timespec (split /,\s*/, $self->EntryData->{$entry}->{"opportunity-duration"}) {
	    my ($qty,$unit) = split /\s+/, $timespec;
	    $hash{$unit} = $qty;
	  }
	  if (keys %hash) {
	    $dur = DateTime::Duration->new
	      (%hash);
	  } else {
	    print "ERROR parsing opportunity-duration\n";
	  }
	}
	if (scalar @missing == 1) {
	  # there will be no conflict, generate the begin and end
	  my $missingitem = shift @missing;
	  if ($missingitem eq "begin-opportunity") {
	    $sdt = $edt - $dur;
	  } elsif ($missingitem eq "end-opportunity") {
	    $edt = $sdt + $dur;
	  } elsif ($missingitem eq "opportunity-duration") {
	    $dur = $edt - $sdt;
	  }
	} elsif (scalar @missing == 0) {
	  print "Sanity Check needed here, not yet implemented!\n";
	  if (abs(DateTime::Duration->compare($sdt + $dur,$edt))) {
	    print "Dates do not align!\n";
	  }
	}
	# now that we have sdt and edt, generate statements
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "at",
	    DateTime::Format::ICal->format_datetime($sdt),
	    [
	     "possible",
	     $entry,
	    ],
	   ]
	  );
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "at",
	    DateTime::Format::ICal->format_datetime($edt),
	    [
	     "not",
	     [
	      "possible",
	      $entry,
	     ],
	    ],
	   ]
	  );
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "=",
	    [
	     "duration",
	     $entry,
	    ],
	    $self->DateManip->DurationToString
	    (Duration => $dur),
	   ],
	  );
	$self->Problem->AddInit
	  (
	   Structure =>
	   [
	    "has-time-constraints",
	    $entry,
	   ]
	  );
      } else {
	print "Underspecified event (not enough date information): <$entry>\n";
      }
    }

    # now print the problem file for now
    $self->Problem->Problem("PSEX2");
    $self->Problem->Domain("PSEX2");

    # generate graph display
    $self->Graph->Display if exists $UNIVERSAL::verber->Config->CLIConfig->{'--vw'};

    # print out to the problem file in the world section
    my $fh = IO::File->new;
    $fh->open(">/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/psex2.p.pddl")
      or die "can't open\n";
    print $fh $self->Problem->Generate
      (Output => "verb");

    my @cycle = $self->DependencyGraph->find_a_cycle;
    if (scalar @cycle) {
      print "Dependency cycle detected\n";
      print Dumper(\@cycle);
    } else {
      print "No dependency cycle found\n";
    }
  }
}

sub RelToPDDL {
  my ($self,$rel) = @_;
  # now just pretty print this
  return $self->Light->PrettyGenerate
    (Structure => [$rel]);
}

sub AddEntry {
  my ($self,$term) = @_;
  if (! defined $term or ! defined $term->[0]) {
    warn "Term is not defined\n";
    return;
  }
  if ($term->[0] ne "entry-fn") {
    die "ERROR <".$term->[0].">\n";
  }
  my $entrytype = $term->[1];
  my $entryid = $term->[2];
  my $entry;
  if ($entrytype eq "unilang") {
    $entry = $self->UniLang->GetUniLangMessageContents
      (EntryID => $entryid);
  } elsif ($entrytype eq "pse") {
    $entry = $self->Data->{NL}->{"pse"}->{$entryid};
  } elsif ($entrytype eq "sayer-index") {
    warn "Not yet implemented\n";
    # $entry = $self->UniLang->GetUniLangMessageContents
    # (EntryID => $entryid);
  }

  # print "$entry\n";
  my $name = ProcessName(Item => $entry);

  # my $name = "entry-".$entryid;
  if (! exists $self->Entries->{$name}) {
    $self->Problem->AddObject
      (
       Type => "$entrytype-entry",
       Object => $name,
      );
    $self->Entries->{$name} = 1;
    $self->Graph->AddNode
      (
       FullEntry => $entry,
       EN => $name,
      );
  }
  return $name;
}

sub AddPreference {
  my ($self,$preference) = @_;
  print "Don't know what to do just yet here\n";
}

1;
