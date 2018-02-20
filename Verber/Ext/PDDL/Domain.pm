package Verber::Ext::PDDL::Domain;

use Verber::Util::Light;

use Data::Dumper;
use PerlLib::Lisp;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Contents Domain Requirements Types SuperTypes SubTypes
 Predicates Functions Deriveds DurativeActions Actions Parsed MyLight
 Includes IncludesOrder IncludesHierarchy Units /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Contents($args{Contents} || $c || "");
  $self->Domain($args{Domain});
  $self->Requirements($args{Requirements} || {});
  $self->Types($args{Types} || {});
  $self->SuperTypes($args{SuperTypes} || {});
  $self->SubTypes($args{SubTypes} || {});
  $self->Predicates($args{Predicates} || {});
  $self->Functions($args{Functions} || {});
  $self->Deriveds($args{Deriveds} || {});
  $self->Actions($args{Actions} || {});
  $self->DurativeActions($args{DurativeActions} || {});
  $self->MyLight(Verber::Util::Light->new);
  $self->Includes($args{Includes} || {});
  $self->IncludesHierarchy($args{IncludesHierarchy} || {});
  $self->IncludesOrder($args{IncludesOrder} || []);
  # $self->Units($args{Units} || "hours");
}

sub AddRequirement {
  my ($self,%args) = @_;
  $self->Requirements->{$args{Requirement}} = 1;
}

sub AddType {
  my ($self,%args) = @_;
  $self->SuperTypes->{$args{SuperType}}->{$args{SubType}} = 1;
  $self->SubTypes->{$args{SubType}}->{$args{SuperType}} = 1;
  $self->Types->{$args{SubType}} = 1;
  $self->Types->{$args{SuperType}} = 1;
}

sub AddGeneral {
  my ($self,%args) = @_;
  my $r = StringStructure(String => $args{String},
			  Structure => $args{Structure});
  if (eval "\$self->".$args{Container}."->{\$r->{String}} = \$r->{Structure}") {
    eval "\$self->".$args{Container}."->{\$r->{String}} = \$r->{Structure}";
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
    (
     Structure => $self->GenerateStructure
     (%args),
    );
}

sub ParseStructure {
  my ($self,%args) = @_;
  my $structure = $args{LispStructure};
  # now we simply process this  structure, turning it into strings and
  # adding them to the appropriate sections
  shift @$structure;		# get rid of that first define

  my $aaaaa = shift @$structure;
  $self->Domain($aaaaa->[1]);	# store that first domain

  # now use the first element to choose what to do
  while (@$structure) {
    $aaaaa = shift @$structure;
    my $enum = shift @$aaaaa;
    if ($enum eq ":requirements") {
      while (@$aaaaa) {
	$self->AddGeneral
	  (Container => "Requirements",
	   Structure => shift @$aaaaa);
      }
    } elsif ($enum eq ":types") {
      # get types
      my $supertype;
      my @subtypes;
      while (@$aaaaa) {
	my $x = shift @$aaaaa;
	if ($x eq "-") {
	  my $supertype = shift @$aaaaa;
	  while (@subtypes) {
	    my $subtype = shift @subtypes;
	    $self->AddType
	      (SubType => $subtype,
	       SuperType => $supertype);
	  }
	} else {
	  push @subtypes, $x;
	}
      }
    } elsif ($enum eq ":predicates") {
      while (@$aaaaa) {
	$self->AddGeneral
	  (Container => "Predicates",
	   Structure => shift @$aaaaa);
      }
    } elsif ($enum eq ":functions") {
      while (@$aaaaa) {
	$self->AddGeneral
	  (Container => "Functions",
	   Structure => shift @$aaaaa);
      }
    } elsif ($enum eq ":derived") {
      unshift @$aaaaa, $enum;
      $self->AddGeneral
	(Container => "Deriveds",
	 Structure => $aaaaa);
    } elsif ($enum eq ":action") {
      unshift @$aaaaa, $enum;
      $self->AddGeneral
	(Container => "Actions",
	 Structure => $aaaaa);
    } elsif ($enum eq ":durative-action") {
      unshift @$aaaaa, $enum;
      $self->AddGeneral
	(Container => "DurativeActions",
	 Structure => $aaaaa);
    } elsif ($enum eq ":includes") {
      $self->IncludesHierarchy->{$self->Domain} = {};
      foreach my $include (@$aaaaa) {
	$self->AddInclude(Include => $include);
      }
    } elsif ($enum eq ":timing") {
      foreach my $include (@$aaaaa) {
	if ($include->[0] eq "units") {
	  $self->Units($include->[1]);
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
  my $aaaaa = ["domain",$self->Domain];
  push @$structure, $aaaaa;

  # now use the first element to choose what to do
  foreach my $enum (qw(:requirements :includes :timing :types :predicates :functions :actions :durative-actions)) {
    my $aaaaa = [];
    if ($enum eq ":requirements") {
      $aaaaa = [$enum, keys %{$self->Requirements}];
    } elsif ($enum eq ":types") {
      foreach my $supertype (sort keys %{$self->SuperTypes}) {
	push @$aaaaa, $supertype;
	push @$aaaaa, "-";
	foreach my $subtype (sort keys %{$self->SuperTypes->{$supertype}}) {
	  push @$aaaaa, $subtype;
	}
      }
      push @$aaaaa, ":types";
      $aaaaa = [reverse @$aaaaa];
    } elsif ($enum eq ":includes") {
      if (exists $args{Output} and $args{Output} eq "verb") {
	push @$aaaaa, ":includes";
	push @$aaaaa, @{$self->IncludesOrder}; # keys %{$self->Includes};
      }
    } elsif ($enum eq ":timing") {
      if (0 and exists $args{Output} and $args{Output} eq "verb") {
	push @$aaaaa, ":timing";
	push @$aaaaa, ["units", $self->Units];
      }
    } elsif ($enum eq ":predicates") {
      if (scalar keys %{$self->Predicates}) {
	$aaaaa = [":predicates", sort {Dumper($a) cmp Dumper($b)} values %{$self->Predicates}];
      }
    } elsif ($enum eq ":functions") {
      if (scalar keys %{$self->Functions}) {
	$aaaaa = [":functions", sort {Dumper($a) cmp Dumper($b)} values %{$self->Functions}];
      }
      #     } elsif ($enum eq ":actions") {
      #       if (scalar keys %{$self->Actions}) {
      # 	push @$structure, values %{$self->Actions};
      #       }
      #     } elsif ($enum eq ":durative-actions") {
      #       if (scalar keys %{$self->DurativeActions}) {
      # 	push @$structure, values %{$self->DurativeActions};
      #       }
    }
    push @$structure, $aaaaa if scalar @$aaaaa;
  }

  # since its kind of wierd with each of these taking up its own
  # section, add them here
  foreach my $derived (sort {Dumper($a) cmp Dumper($b)} values %{$self->Deriveds}) {
    push @$structure, $derived;
  }
  foreach my $action (sort {Dumper($a) cmp Dumper($b)} values %{$self->Actions}) {
    push @$structure, $action;
  }
  foreach my $durativeaction (sort {Dumper($a) cmp Dumper($b)} values %{$self->DurativeActions}) {
    push @$structure, $durativeaction;
  }
  return $structure;
}

sub CalculateRequirements {
  my ($self,%args) = @_;
  # ignore the requirements as stated and just calculate, based on an
  # inspection of the domain, which requirements are, well, required
  my $requirements = {};

  # Durative actions
  if (scalar keys %{$self->DurativeActions}) {
    $requirements->{"durative-actions"} = 1;
  }
}

sub AddDomain {
  my ($self,%args) = @_;
  # print Dumper({Domain => {Self => $self, Args => \%args}});

  # don't do any kind of checking for now
  my $subdomain = $args{Subdomain};
  if ($args{Current}) {
    $self->IncludesHierarchy($subdomain->IncludesHierarchy);
    $self->Domain($subdomain->Domain);
  } else {
    $self->IncludesHierarchy->{$self->Domain} = $subdomain->IncludesHierarchy;
  }

  # types
  foreach my $type (keys %{$subdomain->SubTypes}) {
    foreach my $subtype (keys %{$subdomain->SubTypes->{$type}}) {
      $self->SubTypes->{$type}{$subtype} = 1;
    }
  }
  foreach my $type (keys %{$subdomain->SuperTypes}) {
    foreach my $supertype (keys %{$subdomain->SuperTypes->{$type}}) {
      $self->SuperTypes->{$type}{$supertype} = 1;
    }
  }

  # FIXME handle units translation here

  foreach my $hash (qw(Requirements Predicates Functions Deriveds Actions DurativeActions)) {
    foreach my $item (keys %{$subdomain->$hash}) {
      $self->$hash->{$item} = $subdomain->$hash->{$item};
    }
  }
}

sub GenerateDescriptiveComments {
  my ($self,%args) = @_;
  # generate comments for stuff that is in .verb but not in .pddl
  $self->Comment
    (Text => Dumper({
		     Includes => $self->IncludesHierarchy,
		     Units => $self->Units,
		    }));

}

sub Comment {
  my ($self,%args) = @_;
  return join("\n",map {";; ".$_} split /\n/, $args{Text});
}

sub AddInclude {
  my ($self,%args) = @_;
  my $include = $args{Include};
  $self->Includes->{$include} = 1;
  push @{$self->IncludesOrder}, $include;
  $self->IncludesHierarchy->{$self->Domain}{$include} = 1;
}

1;
