package Verber::Ext::PDDL::Problem;

use PerlLib::Lisp;
use PerlLib::SwissArmyKnife;
use Verber::Util::DateManip;
use Verber::Util::Light;

use Data::Dumper;
use Date::ICal;
use DateTime;
use DateTime::Format::ICal;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Contents Problem Domain Types SuperTypes SubTypes Inits Goals
 Constraints HasObjects HasType Objects MyLight Metric Includes
 IncludesOrder IncludesHierarchy StartDate Units InThePast MyDateManip
 /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Contents($args{Contents});
  $self->Problem($args{Problem});
  $self->Domain($args{Domain});

  $self->Types($args{Types} || {});
  $self->Objects($args{Objects} || {});
  $self->HasObjects($args{HasObjects} || {});
  $self->HasType($args{HasType} || {});
  $self->Inits($args{Inits} || {});
  $self->Goals($args{Goals} || {});
  $self->Metric($args{Metric} || {});
  $self->Constraints($args{Constraints} || {});

  $self->MyDateManip(Verber::Util::DateManip->new);
  $self->MyLight(Verber::Util::Light->new);
  $self->Includes($args{Includes} || {});
  $self->IncludesHierarchy($args{IncludesHierarchy} || {});
  $self->IncludesOrder($args{IncludesOrder} || []);
}

sub AddObject {
  my ($self,%args) = @_;
  $self->HasObjects->{$args{Type}}->{$args{Object}} = 1;
  $self->HasType->{$args{Object}}->{$args{Type}} = 1;
  $self->Objects->{$args{Object}} = 1;
  $self->Types->{$args{Type}} = 1;
}

sub AddInit {
  my ($self,%args) = @_;
  my $r = StringStructure(String => $args{String},
			  Structure => $args{Structure});
  if (! exists $self->Inits->{$r->{String}}) {
    $self->Inits->{$r->{String}} = $r->{Structure};
  }
}

sub AddGoal {
  my ($self,%args) = @_;
  print "A\n";
  my $r = StringStructure(String => $args{String},
			  Structure => $args{Structure});
  print "B\n";
  print Dumper($r);
  if (! exists $self->Goals->{$r->{String}}) {
    $self->Goals->{$r->{String}} = $r->{Structure};
  }
  print "C\n";
}

sub AddMetric {
  my ($self,%args) = @_;
  my $r = StringStructure(String => $args{String},
			  Structure => $args{Structure});
  if (! exists $self->Metric->{$r->{String}}) {
    $self->Metric->{$r->{String}} = $r->{Structure};
  }
}

sub AddConstraint {
  my ($self,%args) = @_;
  my $r = StringStructure(String => $args{String},
			  Structure => $args{Structure});
  if (! exists $self->Constraints->{$r->{String}}) {
    $self->Constraints->{$r->{String}} = $r->{Structure};
  }
}

sub Merge {
  my ($self,%args) = @_;
  $self->ParseStructure
    (LispStructure =>
     LispStringToLispStructure
     (LispString => $args{Contents}));
}

sub Parse {
  my ($self,%args) = @_;
  $self->ParseStructure
    (LispStructure =>
     LispStringToLispStructure
     (LispString => $self->Contents));
}

sub Generate {
  my ($self,%args) = @_;
  $self->MyLight->PrettyGenerate
    (Structure => $self->GenerateStructure
     (%args));
}

sub ParseStructure {
  my ($self,%args) = @_;
  my $structure = $args{LispStructure};
  # now we simply process this  structure, turning it into strings and
  # adding them to the appropriate sections
  shift @$structure;		# get rid of that first define
  my $aaaaa = shift @$structure;
  $self->Problem($aaaaa->[1]);	# store that first problem

  # now use the first element to choose what to do
  while (@$structure) {
    $aaaaa = shift @$structure;
    my $enum = shift @$aaaaa;
    if ($enum eq ":domain") {
      $self->Domain(shift @$aaaaa);
    } elsif ($enum eq ":objects") {
      # get objects
      my $typ;
      my @obj;
      while (@$aaaaa) {
	my $x = shift @$aaaaa;
	if ($x eq "-") {
	  my $typ = shift @$aaaaa;
	  while (@obj) {
	    my $obj = shift @obj;
	    $self->AddObject
	      (Object => $obj,
	       Type => $typ);
	  }
	} else {
	  push @obj, $x;
	}
      }
    } elsif ($enum eq ":init") {
      while (@$aaaaa) {
	$self->AddInit(Structure => shift @$aaaaa);
      }
    } elsif ($enum eq ":goal") {
      my $aaaaa = $aaaaa->[0];
      shift @$aaaaa; # get rid of that first "and"
      while (@$aaaaa) {
	$self->AddGoal(Structure => shift @$aaaaa);
      }
    } elsif ($enum eq ":metric") {
      $self->AddMetric(Structure => $aaaaa);
    } elsif ($enum eq ":constraints") {
      my $aaaaa = $aaaaa->[0];
      shift @$aaaaa; # get rid of that first "and"
      while (@$aaaaa) {
	$self->AddConstraint(Structure => shift @$aaaaa);
      }
    } elsif ($enum eq ":includes") {
      foreach my $include (@$aaaaa) {
	$self->AddInclude(Include => $include);
      }
    } elsif ($enum eq ":timing") {
      foreach my $include (@$aaaaa) {
	if ($include->[0] eq "start-date") {
	  $self->StartDate
	    ($self->MyDateManip->ICalDateStringToDateTime
	     (String => $include->[1]));
	} elsif ($include->[0] eq "units") {
	  $self->Units
	    ($self->MyDateManip->DurationStringToDateTimeDuration
	     (String => $include->[1]));
	}
      }
    }
  }
}

sub GenerateStructure {
  my ($self,%args) = @_;
  # all we have to do is generate the structure
  my $structure = [];

  push @$structure, "define";	# add that first define
  my $aaaaa = ["problem",$self->Problem];
  push @$structure, $aaaaa;

  # now use the first element to choose what to do
  foreach my $enum (qw(:domain :includes :timing :objects :init :goal :constraints :metric)) {
    my $aaaaa = [];
    if ($enum eq ":domain") {
      push @$aaaaa, ":domain";
      push @$aaaaa, $self->Domain;
    } elsif ($enum eq ":includes") {
      if (exists $args{Output} and $args{Output} eq "verb") {
	push @$aaaaa, ":includes";
	push @$aaaaa, @{$self->IncludesOrder}; # keys %{$self->Includes};
      }
    } elsif ($enum eq ":timing") {
      if (0 and exists $args{Output} and $args{Output} eq "verb") {
	push @$aaaaa, ":timing";
	push @$aaaaa, ["start-date", $self->MyDateManip->DateTimeToICalString
		       (DateTime => $self->StartDate)];
	my $string = $self->MyDateManip->DurationToString
	  (Duration => $self->Units);
	$string =~ s/\s/_/;
	push @$aaaaa, ["units", $string];
      }
    } elsif ($enum eq ":objects") {
      if (1) {
	foreach my $type (sort keys %{$self->HasObjects}) {
	  push @$aaaaa, $type;
	  push @$aaaaa, "-";
	  foreach my $obj (sort keys %{$self->HasObjects->{$type}}) {
	    push @$aaaaa, $obj;
	  }
	}
	push @$aaaaa, ":objects";
	$aaaaa = [reverse @$aaaaa];
      } else {
	push @$aaaaa, ":objects";
	foreach my $type (sort keys %{$self->HasObjects}) {
	  foreach my $obj (sort keys %{$self->HasObjects->{$type}}) {
	    push @$aaaaa, $obj;
	    push @$aaaaa, "-";
	    push @$aaaaa, $type;
	  }
	}
      }
    } elsif ($enum eq ":init") {
      push @$aaaaa, ":init";
      my $inthepast = {};
      # print Dumper({Inits => $self->Inits});
      foreach my $init (sort {Dumper($a) cmp Dumper($b)} values %{$self->Inits}) {
	# translate times as necessary
	my $res = $self->TranslateDatesAndTimes
	  (Thing => $init);
	print Dumper({DateAndTimes => $res});
	my $structure = $res->{Result};
	if (exists $res->{InThePast} and $res->{InThePast} and $structure->[0] eq "at") {
	  $time = $structure->[1];
	  if ($structure->[2]->[0] =~ /^not$/i) {
	    my $dumped = Dumper($structure->[2]->[1]);
	    if (exists $inthepast->{negative}->{$dumper}) {
	      if ($inthepast->{negative}->{$dumper}->{Time} < $time) {
		$inthepast->{negative}->{$dumper}->{Time} = $time;
	      }
	    } else {
	      $inthepast->{negative}->{$dumper} =
		{
		 Time => $time,
		 Structure => $structure->[2],
		};
	    }
	  } else {
	    my $dumped = Dumper($structure->[2]);
	    if (exists $inthepast->{positive}->{$dumped}) {
	      if ($inthepast->{positive}->{$dumped}->{Time} < $time) {
		$inthepast->{positive}->{$dumped}->{Time} = $time;
	      }
	    } else {
	      $inthepast->{positive}->{$dumped} =
		{
		 Time => $time,
		 Structure => $structure->[2],
		};
	    }
	  }
	} else {
	  push @$aaaaa, $res->{Result};
	}
      }
      $self->InThePast($inthepast);
      # # now add the negative times
      # # this is incorrect, for instance, it would contradict (at 0 X) or X, need to fix3C
      #       foreach my $key (keys %{$inthepast->{negative}}) {
      # 	if (exists $inthepast->{positive}->{$key}) {
      # 	  if ($inthepast->{positive}->{$key}->{Time} < $inthepast->{negative}->{$key}->{Time}) {
      # 	    push @$aaaaa, ["at", 0, $inthepast->{negative}->{$key}->{Structure}];
      # 	  } elsif ($inthepast->{positive}->{$key}->{Time} > $inthepast->{negative}->{$key}->{Time}) {
      # 	    push @$aaaaa, ["at", 0, $inthepast->{positive}->{$key}->{Structure}];
      # 	  } else {
      # 	    die "Error, conflict in at statement\n";
      # 	  }
      # 	}
      #       }
    } elsif ($enum eq ":goal") {
      push @$aaaaa, ":goal";
      my $b = ["and"];
      foreach my $goal (sort {Dumper($a) cmp Dumper($b)} values %{$self->Goals}) {
	push @$b, $goal;
      }
      push @$aaaaa, $b;
    } elsif ($enum eq ":metric") {
      if (defined $self->Metric and scalar keys %{$self->Metric}) {
	push @$aaaaa, ":metric";
	foreach my $key (sort keys %{$self->Metric}) {
	  push @$aaaaa, @{$self->Metric->{$key}};
	}
      }
    } elsif ($enum eq ":constraints") {
      if (scalar values %{$self->Constraints}) {
	push @$aaaaa, ":constraints";
	my $b = ["and"];
	foreach my $constraint (sort {Dumper($a) cmp Dumper($b)} values %{$self->Constraints}) {
	  push @$b, $constraint;
	}
	push @$aaaaa, $b;
      }
    }
    if (scalar @$aaaaa) {
      push @$structure, $aaaaa;
    }
  }
  return $structure;
}

sub AddProblem {
  my ($self,%args) = @_;
  # print Dumper({Problem => {Self => $self, Args => \%args}});

  # don't do any kind of checking for now
  my $subproblem = $args{Subproblem};
  if ($args{Current}) {
    $self->IncludesHierarchy($subproblem->IncludesHierarchy);
    $self->Problem($subproblem->Problem);
    $self->Domain($subproblem->Domain);
    $self->Units($subproblem->Units);
    $self->StartDate($subproblem->StartDate);
  } else {
    $self->IncludesHierarchy->{$self->Problem} = $subproblem->IncludesHierarchy;
  }

  # types
  foreach my $object (keys %{$subproblem->HasType}) {
    foreach my $type (keys %{$subproblem->HasType->{$object}}) {
      $self->HasType->{$object}{$type} = 1;
    }
  }
  foreach my $type (keys %{$subproblem->HasObjects}) {
    foreach my $object (keys %{$subproblem->HasObjects->{$type}}) {
      $self->HasObjects->{$type}{$object} = 1;
    }
  }

  # FIXME handle units and startdate here

  foreach my $hash (qw(Inits Objects Types Goals Metric)) {
    foreach my $item (keys %{$subproblem->$hash}) {
      $self->$hash->{$item} = $subproblem->$hash->{$item};
    }
  }

  # FIXME Constraints
  # foreach my $item (qw(Types SuperTypes SubTypes Inits Goals
  # 		       Constraints HasObjects HasType Objects Metric
  # 		       Includes StartDate Units)) {

  # }
}

sub GenerateDescriptiveComments {
  my ($self,%args) = @_;
  # generate comments for stuff that is in .verb but not in .pddl
  $self->Comment
    (Text => Dumper({
  		     Includes => $self->Includes,
  		     Units => $self->MyDateManip->DurationToString
  		     (Duration => $self->Units),
  		     StartDate => $self->MyDateManip->DateTimeToICalString
  		     (DateTime => $self->StartDate),
  		    })) if 0;
  return "";
}

sub Comment {
  my ($self,%args) = @_;
  return join("\n",map {";; ".$_} split /\n/, $args{Text});
}

sub TranslateDatesAndTimes {
  my ($self,%args) = @_;
  my $ref = ref $args{Thing};
  if ($ref eq "ARRAY") {
    my @list;
    my $inthepast = 0;
    foreach my $substructure (@{$args{Thing}}) {
      my $res = $self->TranslateDatesAndTimes
	(Thing => $substructure);
      push @list, $res->{Result};
      if (exists $res->{InThePast} and $res->{InThePast}) {
	$inthepast = 1;
      }
    }
    return {
	    Result => \@list,
	    InThePast => $inthepast,
	   };
  } else {
    if ($args{Thing} =~ /^(TZID=[^:]+:)?\d{8}T\d{6}Z?$/) {
      my $dt = $self->MyDateManip->ICalDateStringToDateTime
	(String => $args{Thing});
      if (defined $dt) {
	# convert it using the starttime
	my $duration = $dt - $self->StartDate;
	# now express this duration in terms of the other duration
	return {
		Result => $self->MyDateManip->DurationDivision
		(
		 Numerator => $duration,
		 Denominator => $self->Units,
		),
		InThePast => $duration->is_negative,
	       };
      }
    } elsif ($args{Thing} =~ /^(\d{4})-(\d{2})-(\d{2})_(\d{2}):(\d{2}):(\d{2})$/) {
      my $duration = DateTime::Duration->new
	(
	 years => $1,
	 months => $2,
	 days => $3,
	 hours => $4,
	 minutes => $5,
	 seconds => $6,
	);
      return {
	      Result => $self->MyDateManip->DurationDivision
	      (
	       Numerator => $duration,
	       Denominator => $self->Units,
	      ),
	     };
    } else {
      return {
	      Result => $args{Thing},
	     };
    }
  }
}

sub AddInclude {
  my ($self,%args) = @_;
  my $include = $args{Include};
  $self->Includes->{$include} = 1;
  push @{$self->IncludesOrder}, $include;
  $self->IncludesHierarchy->{$self->Domain}{$include} = 1;
}

1;

