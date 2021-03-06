package Verber::Federated::Calendar;

# This is a test system to extract temporal factors from calendars,
# and add them and upload them.

# Should know which items are our own plans, and which are not.

use Corpus::Util::UniLang;
use Manager::Dialog qw(Approve ChooseByProcessor QueryUser);
use PerlLib::Util;
use SPSE2::Util;
use UniLang::Util::TempAgent;
use Verber::Ext::PDDL::Domain;
use Verber::Ext::PDDL::Problem;
use Verber::Util::DateManip;
use Verber::Util::Graph;
use Verber::Util::Light;

use Cal::DAV;
use Data::Dumper;
use Data::ICal;
use Data::ICal::Entry::Event;
use Date::ICal;
use Date::Parse;
use DateTime;
use DateTime::Duration;
use DateTime::Format::ICal;
use DateTime::Format::Strptime;
use Graph::Directed;
use IO::File;
use Net::Google::Calendar;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / RegisteredWorldNames MyTempAgent MyDomain MyProblem MyLight
	Entries Marks Preferences MyUniLang Context MyDateManip
	EntryData MyGraph DependencyGraph /

  ];

sub init {
  my ($self,%args) = @_;
  $self->MyUniLang(Corpus::Util::UniLang->new);
  $self->MyTempAgent
    (UniLang::Util::TempAgent->new);
  $self->MyDomain
    (Verber::Ext::PDDL::Domain->new());
  $self->MyProblem
    (Verber::Ext::PDDL::Problem->new());
  $self->MyLight
    (Verber::Util::Light->new);
  $self->RegisteredWorldNames
    (qw(psex));
  $self->Entries({});
  $self->EntryData({});
  $self->Marks({});
  $self->Preferences({});
  $self->MyGraph
    (Verber::Util::Graph->new
     ());
  $self->Context
    ($args{Context} || "work");
  $self->MyDateManip
    ($args{DateManip} || Verber::Util::DateManip->new);
  $self->DependencyGraph
    (Graph::Directed->new);
}

sub UploadPlanIntoCalendar {
  my ($self,%args) = @_;
  # have to know which items are ours, which are not, and only alter
  # and update the ones that are ours
  my $method = $args{Method} || "CalDAV";

  my $linearplan = $args{LinearPlan};

  my $item = {};
  $item->{Title} = $res->{Other} || $res->{Location};
  $item->{Content} = "Added by FRDCSA Event-System";
  $item->{Location} = $res->{Location};

  my $entry;
  if ($method eq "Google") {
    $entry = Net::Google::Calendar::Entry->new();
    $entry->title($item->{Title});
    $entry->content($item->{Content});
    $entry->location($item->{Location});
    # $entry->transparency('transparent');
    # $entry->status('confirmed');
  } elsif ($method eq "CalDAV") {
    $entry = {};
    $entry->{summary} = $item->{Title};
    $entry->{description} = $item->{Content};
    # $entry->location($item->{Location});

  }

  my $dt = DateTime->now;
  my $year = $dt->year;
  my $month = $dt->month;
  my $day = $dt->day;
  my $hour = 0;
  my $minute = 0;
  my $second = 0;

  my $start = DateTime->new
    ( year   => $year,
      month  => $month,
      day    => $day,
      hour   => $hour,
      minute => $minute,
      second => $second,
      time_zone => 'America/Chicago',
    );
  my $end = $start + DateTime::Duration->new( hours => 2 );

  $item->{StartDate} = $start->datetime;
  $item->{EndDate} = $end->datetime;

  if ($method eq "Google") {
    $entry->when($start, $end);
  } elsif ($method eq "CalDAV") {
    $entry->{dtstart} = DateTime::Format::ICal->format_datetime($start);
    $entry->{dtstart} =~ s/^.+://g;
    $entry->{dtend} = DateTime::Format::ICal->format_datetime($end);
    $entry->{dtend} =~ s/^.+://g;
  }

  print "(\n";
  foreach my $key (qw(Title Content Location StartDate EndDate)) {
    my $variable = lc($key);
    print "\t$key => ".$item->{$key}."\n";
  }
  print ")\n";

  if (Approve("Is this correct?")) {
    if ($method eq "Google") {
      my $username = 'andrew.j.dougherty'; #"QueryUser("Username? ");
      my $password = QueryUser("Password? ");
      my $cal = Net::Google::Calendar->new;
      $cal->login($username,$password);
      my @list = $cal->get_calendars;
      my $hash = ChooseByProcessor
	(
	 Values => \@list,
	 Processor => sub {$_->title},
	);
      undef $cal;
      for my $calendar (@$hash) {
	my $cal2 = Net::Google::Calendar->new
	  (url => $calendar->id);
	$cal2->login($username,$password);
	$cal2->add_entry($entry);
      }
    } elsif ($method eq "CalDAV") {
      my $username = 'adougherty@openinformatics.net'; #"QueryUser("Username? ");
      my $password = 'password'; #QueryUser("Password? ");
      my $cal = Cal::DAV->new
	(
	 user => $username,
	 pass => $password,
	 url => 'http://mail.oicom.net/home/adougherty@openinformatics.net/Calendar',
	);
      print Dumper($cal->cal);
      # go ahead and add an event to my calendar
      my $vevent = Data::ICal::Entry::Event->new();
      $vevent->add_properties(%$entry);
      print Dumper($entry);
      # $vevent->add_entry($alarm);
      $cal->add_entry($vevent);
      $cal->save;
    }
  }
}

sub Generate {
  my ($self,%args) = @_;
  # just use our own credentials for now

  # have to know which items are ours, which are not, and only alter
  # and update the ones that are ours

  my $method = $args{Method} || "CalDAV";
  if ($method eq "Google") {
    my $username = 'andrew.j.dougherty'; #"QueryUser("Username? ");
    my $password = QueryUser("Password? ");
    my $cal = Net::Google::Calendar->new;
    $cal->login($username,$password);
    my @list = $cal->get_calendars;
    my $hash = ChooseByProcessor
      (
       Values => \@list,
       Processor => sub {$_->title},
      );
    undef $cal;
    for my $calendar (@$hash) {
      my $cal2 = Net::Google::Calendar->new
	(url => $calendar->id);
      $cal2->login($username,$password);

      # go ahead and get the events here, add them to the planning
      # domain or whatever is necessary

    }
  } elsif ($method eq "CalDAV") {
    my $username = 'adougherty@openinformatics.net'; #"QueryUser("Username? ");
    my $password = 'password';	#QueryUser("Password? ");
    my $cal = Cal::DAV->new
      (
       user => $username,
       pass => $password,
       url => 'http://mail.oicom.net/home/adougherty@openinformatics.net/Calendar',
      );

    # go ahead and get the events here, add them to the planning
    # domain or whatever is necessary

    print Dumper($cal->cal);

  }

  $self->MyProblem->StartDate
    ($self->MyDateManip->GetPresent());

  $self->MyProblem->Units
    (DateTime::Duration->new(hours => 1));

  $self->MyProblem->AddInit
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

  my $context = $self->Context;
  my $message = $self->MyTempAgent->MyAgent->QueryAgent
    (
     Receiver => "KBS",
     Contents => "$context all-asserted-knowledge",
    );
  # print Dumper($message);
  if (defined $message) {
    my $assertions = DeDumper($message->Contents);
    foreach my $assertion (@$assertions) {
      my $pred = $assertion->[0];
      if ($pred eq "depends") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $entryname2 = $self->AddEntry($assertion->[2]);
	$self->MyProblem->AddInit
	  (
	   Structure =>
	   [
	    "depends",
	    $entryname1,
	    $entryname2,
	   ]
	  );
	$self->MyGraph->AddEdge
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
	$self->MyProblem->AddInit
	  (
	   Structure =>
	   [
	    "provides",
	    $entryname1,
	    $entryname2,
	   ]
	  );
	$self->MyGraph->AddEdge
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
	$self->MyProblem->AddInit
	  (
	   Structure =>
	   [
	    "eases",
	    $self->AddEntry($assertion->[1]),
	    $self->AddEntry($assertion->[2]),
	   ],
	  );
	$self->MyGraph->AddEdge
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
	$self->MyProblem->AddInit
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
	if ($tmp =~ /\$(\d+)/) {
	  $earnings = $1;
	}
	$self->Marks->{AltersBudget}->{$entryname1} = 1;
	$self->MyProblem->AddInit
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
	$self->MyProblem->AddInit
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
	  $self->MyProblem->AddGoal
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
	$self->Preferences->{"p-".$entryname1} = 1;
	# 	$self->MyProblem->AddGoal
	# 	  (
	# 	   Structure =>
	# 	   [
	# 	    "preference",
	# 	    "p-".$entryname1,
	# 	    [
	# 	     "completed",
	# 	     $entryname1,
	# 	    ],
	# 	   ]
	# 	  );
	# 	$self->MyProblem->AddGoal
	# 	  (
	# 	   Structure =>
	# 	   [
	# 	    "completed",
	# 	    $entryname1,
	# 	   ]
	# 	  );
      } elsif ($pred eq "due-date-for-entry") {
	my $entryname1 = $self->AddEntry($assertion->[1]);
	my $dateinformation = $assertion->[2];
	$self->MyProblem->AddInit
	  (
	   Structure =>
	   [
	    "at",
	    $self->MyDateManip->FormatDatetime
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
	$self->MyProblem->AddInit
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
	$self->MyProblem->AddInit
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
      $self->MyProblem->Metric
	(["minimize", ["total-time"]]);
    } elsif (0) {
      $self->MyProblem->Metric
	(["maximize", ["budget", "andy"]]);
    } else {
      $self->MyProblem->Metric
	(["minimize", ["-",["+", @metric], ["budget", "andy"]]]);
    }
    $self->MyProblem->AddObject
      (
       Type => "person",
       Object => "andy",
      );

    # $self->MyProblem->AddConstraint
    # (Structure => ["preference", "b1", ["always", [">=", ["budget", "andy"], "0"]]]);

    # $self->MyProblem->AddConstraint
    # (Structure => ["preference", "b1", ["always", ["=", ["budget", "andy"], "0"]]]);

    # $self->MyProblem->AddConstraint
    # (Structure => ["preference", "b1", ["always", ["=", ["budget", "andy"], "0"]]]);

    # $self->MyProblem->AddConstraint
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
	$self->MyProblem->AddInit
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
	$self->MyProblem->AddInit
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
	$self->MyProblem->AddInit
	  (
	   Structure =>
	   [
	    "=",
	    [
	     "duration",
	     $entry,
	    ],
	    $self->MyDateManip->DurationToString
	    (Duration => $dur),
	   ],
	  );
	$self->MyProblem->AddInit
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
    $self->MyProblem->Problem("PSEX");
    $self->MyProblem->Domain("PSEX");

    # generate graph display
    $self->MyGraph->Display if exists $UNIVERSAL::verber->Config->CLIConfig->{'--vw'};

    # print out to the problem file in the world section
    my $fh = IO::File->new;
    $fh->open(">/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/psex.p.pddl")
      or die "can't open\n";
    print $fh $self->MyProblem->Generate
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

sub AddEntry {
  my ($self,$entryid) = @_;
  my $entry = $self->MyUniLang->GetUniLangMessageContents
    (EntryID => $entryid);
  # print "$entry\n";
  my $name = ProcessName(Item => $entry);
  # my $name = "entry-".$entryid;
  if (! exists $self->Entries->{$name}) {
    $self->MyProblem->AddObject
      (
       Type => "unilang-entry",
       Object => $name,
      );
    $self->Entries->{$name} = 1;
    $self->MyGraph->AddNode
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
