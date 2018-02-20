package CalendarTest;

# This is a test system to extract temporal factors from calendars,
# and add them and upload them.

# Should know which items are our own plans, and which are not.

use Corpus::Util::UniLang;
use Manager::Dialog qw(Approve ChooseByProcessor QueryUser);
use PerlLib::EasySayer;
use PerlLib::SwissArmyKnife;
use PerlLib::Util;
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
	EntryData MyGraph DependencyGraph MyEasySayer /

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
    (qw(calendar));
  $self->Entries({});
  $self->EntryData({});
  $self->Marks({});
  $self->Preferences({});
  $self->MyGraph
    (Verber::Util::Graph->new
     ());
  $self->Context
    ($args{Context} || "calendar");
  $self->MyDateManip
    ($args{DateManip} || Verber::Util::DateManip->new);
  $self->DependencyGraph
    (Graph::Directed->new);
  $self->MyEasySayer(PerlLib::EasySayer->new);
}

sub UploadPlanIntoCalendar {
  my ($self,%args) = @_;
  # have to know which items are ours, which are not, and only alter
  # and update the ones that are ours
  my $method = "Google";

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
      my $username = "adougher9"; # QueryUser("Username? ");
      my $password = "8Bluskye"; # QueryUser("Password? ");
      my $cal = Net::Google::Calendar->new;
      $cal->login($username,$password);
      my @list = $cal->get_calendars;
      my $hash = ChooseByProcessor
	(
	 Values => \@list,
	 Processor => sub {$_->title},
	);
      print Dumper({Hash => $hash});
      undef $cal;
      for my $calendar (@$hash) {
	my $cal2 = Net::Google::Calendar->new
	  (url => $calendar->id);
	$cal2->login($username,$password);
	$cal2->add_entry($entry);
      }
    } elsif ($method eq "CalDAV") {
      my $username = QueryUser("Username? ");
      my $password = QueryUser("Password? ");
      my $url = QueryUser("Url? ");
      my $cal = Cal::DAV->new
	(
	 user => $username,
	 pass => $password,
	 url => $url,
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

  my $method = "Google";
  my $timezone;
  my @assertions;
  my $formatter = DateTime::Format::Duration->new
    (
     pattern => '%Y years, %m months, %e days, %H hours, %M minutes, %S seconds',
    );

  if ($method eq "Google") {
    my $username = 'adougher9'; #"QueryUser("Username? ");
    my $password = '8Bluskye';	# QueryUser("Password? ");
    my $res = $self->GetEvents
      (
       Username => $username,
       Password => $password,
      );
    #     my $res = $self->MyEasySayer->Do
    #       (
    #        _Sub => sub {$self->GetEvents(@_)},
    #        _Overwrite => 1,
    #        Username => $username,
    #        Password => $password,
    #       );
    foreach my $gcalentry (@{$res->{Events}}) {
      # print Dumper([$gcalentry->when]);
      my $entry = $gcalentry->recurrence;
      my $ref = ref $entry;
      if ($ref eq "Data::ICal::Entry::Event") {
	my $p = $entry->{properties};
	# ("critic-unilang-classification" "109839" "goal")
	# ("start-date" "107408" "TZID=America/Chicago:20090404T100000")
	# ("event-duration" "107408" "1 hours")

	# print Dumper($p);
	# push @assertions,

	my $start = $p->{dtstart}->[0]->{value};
	my $starttzid = $p->{dtstart}->[0]->{_parameters}->{TZID};
	my $startstring = "TZID=$starttzid:$start";
	my $startdatetime;
	if ($start =~ /^(....)(..)(..)T(..)(..)(..)$/) {
	  $startdatetime = DateTime->new
	    (
	     year   => $1,
	     month  => $2,
	     day    => $3,
	     hour   => $4,
	     minute => $5,
	     second => $6,
	     time_zone => $starttzid,
	    );
	}

	my $end = $p->{dtend}->[0]->{value};
	my $endtzid = $p->{dtend}->[0]->{_parameters}->{TZID};
	my $endstring = "TZID=$endtzid:$end";
	my $enddatetime;
	if ($end =~ /^(....)(..)(..)T(..)(..)(..)$/) {
	  $enddatetime = DateTime->new
	    (
	     year   => $1,
	     month  => $2,
	     day    => $3,
	     hour   => $4,
	     minute => $5,
	     second => $6,
	     time_zone => $endtzid,
	    );
	}
	my $duration = $enddatetime->subtract_datetime($startdatetime);
	my $string = $formatter->format_duration($duration);
	my @items;
	foreach my $item (split /, /, $string) {
	  if ($item =~ /^(\d+) (\w+)$/) {
	    my $value = $1;
	    my $unit = $2;
	    if ($value !~ /^0+$/) {
	      push @items, "$value $unit";
	    }
	  }
	}
	# add a goal with the text
	my $entryrelation = ["entry-fn","pse",$pseentryid];
	my $entryrelation2 = ["entry-fn","google-calendar",$gcalentry->id];
	# ("asserter" ("entry-fn" "pse" "227") "unknown")
	# ("goal" ())
	push @assertions, ["goal", $entryrelation];
	push @assertions, ["has-source", $entryrelation, $entryrelation2];
	push @assertions, ["has-NL", $entryrelation, $gcalentry->title];
	push @assertions, ["start-date", $entryrelation, $startstring];
	push @assertions, ["event-duration", $entryrelation, join(", ",@items)];
      }
    }
    print Dumper(\@assertions);
  } elsif ($method eq "CalDAV") {
    foreach my $calendar ("Calendar", "Zlatan%20Klebic's%20Calendar") {
      # use a cache here for now, to avoid repeat calls over large data structures
      # need something like PerlLib::EasySayer, which is quick, etc
      my $username = 'adougherty@openinformatics.net'; #"QueryUser("Username? ");
      my $password = '4freefKetyoj'; # QueryUser("Password? ");

      my $res = $self->MyEasySayer->Do
	(
	 _Sub => sub {$self->GetCalendar(@_)},
	 # _Overwrite => 1,
	 Username => $username,
	 Password => $password,
	 Calendar => $calendar,
	);
      my $cal = $res->[0];
      # go ahead and get the events here, add them to the planning
      # domain or whatever is necessary
      foreach my $entry (@{$cal->{entries}}) {
	my $ref = ref $entry;
	if ($ref eq "Data::ICal::Entry::TimeZone") {
	  $timezone = $entry;
	}
	if ($ref eq "Data::ICal::Entry::Event") {
	  my $p = $entry->{properties};
	  # ("critic-unilang-classification" "109839" "goal")
	  # ("start-date" "107408" "TZID=America/Chicago:20090404T100000")
	  # ("event-duration" "107408" "1 hours")

	  # print Dumper($p);
	  # push @assertions,

	  my $start = $p->{dtstart}->[0]->{value};
	  my $starttzid = $p->{dtstart}->[0]->{_parameters}->{TZID};
	  my $startstring = "TZID=$starttzid:$start";
	  my $startdatetime;
	  if ($start =~ /^(....)(..)(..)T(..)(..)(..)$/) {
	    $startdatetime = DateTime->new
	      (
	       year   => $1,
	       month  => $2,
	       day    => $3,
	       hour   => $4,
	       minute => $5,
	       second => $6,
	       time_zone => $starttzid,
	      );
	  }

	  my $end = $p->{dtend}->[0]->{value};
	  my $endtzid = $p->{dtend}->[0]->{_parameters}->{TZID};
	  my $endstring = "TZID=$endtzid:$end";
	  my $enddatetime;
	  if ($end =~ /^(....)(..)(..)T(..)(..)(..)$/) {
	    $enddatetime = DateTime->new
	      (
	       year   => $1,
	       month  => $2,
	       day    => $3,
	       hour   => $4,
	       minute => $5,
	       second => $6,
	       time_zone => $endtzid,
	      );
	  }
	  my $duration = $enddatetime->subtract_datetime($startdatetime);
	  my $string = $formatter->format_duration($duration);
	  my @items;
	  foreach my $item (split /, /, $string) {
	    if ($item =~ /^(\d+) (\w+)$/) {
	      my $value = $1;
	      my $unit = $2;
	      if ($value !~ /^0+$/) {
		push @items, "$value $unit";
	      }
	    }
	  }
	  push @assertions, ["start-date", "107408", $startstring];
	  push @assertions, ["event-duration", "107408", join(", ",@items)];
	}
      }
      print Dumper(\@assertions);
    }
  }
  exit(0);
}

sub GetCalendar {
  my ($self,%args) = @_;
  return Cal::DAV->new
    (
     user => $args{Username},
     pass => $args{Password},
     url => "http://mail.oicom.net/home/adougherty\@openinformatics.net/".$args{Calendar},
    )->cal;
}

sub GetEvents {
  my ($self,%args) = @_;
  my $calendar = Net::Google::Calendar->new;
  $calendar->login($args{Username},$args{Password});
  my @events;
  foreach my $cal ($calendar->get_calendars) {
    if ($cal->title eq "Andrew Dougherty") {
      $calendar->set_calendar($cal);
      push @events, $calendar->get_events();
      last;
    }
  }
  return {
	  Success => 1,
	  Events => \@events,
	  Calendar => $calendar,
	 };
}

1;
