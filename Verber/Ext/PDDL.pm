package Verber::Ext::PDDL;

use Data::Dumper;
use Lisp::Reader qw (lisp_read);
use Lisp::Printer qw (lisp_print);


use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / System Contents Types SuperTypes SubTypes Inits Goals Order
   HasObjects HasType Objects TimeUnits Parsed /

  ];

# learn system specific type mappings to Cyc for instance
# this is now obvious a problem description, we'll have to generalize it

sub init {
  my ($self,%args) = @_;
  $self->System($args{System});
  $self->Contents($args{Contents});
  $self->Types($args{Types} || {});
  $self->Objects($args{Objects} || {});
  $self->HasObjects($args{HasObjects} || {});
  $self->HasType($args{HasType} || {});
  $self->SuperTypes($args{SuperTypes} || {});
  $self->SubTypes($args{SubTypes} || {});
  $self->Inits($args{Inits} || {});
  $self->Goals($args{Goals} || {});
  $self->Order($args{Order} || 0);
  $self->TimeUnits($args{TimeUnits} || "minutes");
}

sub AddType {
  my ($self,$subt,$supt) = @_;
  # maybe even use math::partialorder here
  # do a check that it hasn't been asserted before
  # supertypes X Y means that X is a supertype of Y
  $self->SuperTypes->{$supt}->{$subt} = 1;
  $self->SubTypes->{$subt}->{$supt} = 1;
  $self->Types->{$subt} = 1;
  $self->Types->{$supt} = 1;
}

sub AddObject {
  my ($self,$o,$t) = @_;
  # maybe even use math::partialorder here
  # do a check that it hasn't been asserted before
  # supertypes X Y means that X is a supertype of Y
  $self->HasObjects->{$t}->{$o} = 1;
  $self->HasType->{$o}->{$t} = 1;
  $self->Objects->{$o} = 1;
  $self->Types->{$t} = 1;
}

sub AddInit {
  my ($self,$s) = @_;
  $s = $self->NormalizeToLispString($s);
  if (! exists $self->Inits->{$s}) {
    $self->Inits->{$s} = ++$self->Order->{Init};
  }
}

sub AddGoal {
  my ($self,$s) = @_;
  $s = $self->NormalizeToLispString($s);
  if (! exists $self->Goals->{$s}) {
    $self->Goals->{$s} = ++$self->Order->{Goal};
  }
}

sub SPrintTypes {
  my ($self,%args) = @_;
  my $retval = "";
  foreach my $supertype (keys %{$self->SuperTypes}) {
    $retval .= "\t".
      join(" ",keys %{$self->SuperTypes->{$supertype}})
	." - ".
	  $supertype."\n";
  }
  return $retval;
}

sub SPrintObjects {
  my ($self,%args) = @_;
  my $retval = "";
  foreach my $type (keys %{$self->HasObjects}) {
    $retval .= "\t".
      join(" ",keys %{$self->HasObjects->{$type}})
	." - ".
	  $type."\n";
  }
  return $retval;
}

sub SPrintInits {
  my ($self,%args) = @_;
  return join ("\n",
	       map "\t$_",
	       sort {$self->Inits->{$a} <=> $self->Inits->{$b}}
	       keys %{$self->Inits})."\n";
}

sub SPrintGoals {
  my ($self,%args) = @_;
  return join ("\n",
	       map "\t$_",
	       sort {$self->Goals->{$a} <=> $self->Goals->{$b}}
	       keys %{$self->Goals})."\n";
}

sub Clean {
  my ($self,$c) = @_;
  $c =~ s/\W/-/g;
  $c =~ s/-+/-/g;
  $c =~ s/^-//;
  $c =~ s/-$//;
  return $c;
}

sub Export {
  my ($self,%args) = @_;

  my $verberdir = "/var/lib/myfrdcsa/codebases/internal/verber";

  my $templatedomain = "$verberdir/worldmodel/templates/".$self->System.
    ".d.pddl";
  my $templateproblem = "$verberdir/worldmodel/templates/".$self->System.
    ".p.pddl";
  my $outputdomain = "$verberdir/worldmodel/worlds/".$self->System.
    ".d.pddl";
  my $outputproblem = "$verberdir/worldmodel/worlds/".$self->System.
    ".p.pddl";

  my $dpddl = `cat $templatedomain`;
  my $ppddl = `cat $templateproblem`;

  my ($objects, $init, $goal) =
    ($self->SPrintObjects, $self->SPrintInits, $self->SPrintGoals);

  $ppddl =~ s/\<OBJECTS\>/$objects/;
  $ppddl =~ s/\<INIT\>/$init/;
  $ppddl =~ s/\<GOAL\>/$goal/;

  my $OUT;
  open(OUT,">$outputdomain") or die "ouch";
  print OUT $dpddl;
  close(OUT);

  open(OUT,">$outputproblem") or die "ouch";
  print OUT $ppddl;
  close(OUT);
}

sub Merge {
  my ($self,%args) = @_;
  # merge with another PDDL object
}

sub Parse {
  my ($self,%args) = @_;
  $self->ParseStructure
    (LispStructure =>
     $self->LispStringToLispStructure
     (LispString => $self->Contents));
}

sub Generate {
  my ($self,%args) = @_;
  return $self->LispStructureToLispString
    (LispStructure =>
     $self->GenerateStructure);
}

sub ParseStructure {
  my ($self,%args) = @_;
  my $structure = $args{LispStructure};
  # now we simply process this  structure, turning it into strings and
  # adding them to the appropriate sections
  shift @$structure;		# get rid of that first define
  my $a = shift @$structure;
  $self->System($a->[1]);	# store that first problem

  # now use the first element to choose what to do
  while (@$structure) {
    $a = shift @$structure;
    my $enum = shift @$a;
    if ($enum eq ":domain") {

    } elsif ($enum eq ":objects") {
      # get objects
      my $typ;
      my @obj;
      while (@$a) {
	my $x = shift @$a;
	if ($x eq "-") {
	  my $typ = shift @$a;
	  while (@obj) {
	    my $obj = shift @obj;
	    $self->AddObject($obj,$typ);
	  }
	} else {
	  push @obj, $x;
	}
      }
    } elsif ($enum eq ":init") {
      while (@$a) {
	$self->AddInit(shift @$a);
      }
    } elsif ($enum eq ":goal") {
      my $a = $a->[0];
      shift @$a; # get rid of that first "and"
      while (@$a) {
	$self->AddGoal(shift @$a);
      }
    }
  }
}

sub GenerateStructure {
  my ($self,%args) = @_;
  # all we have to do is generate the structure
  my $structure = [];

  push @$structure, "define";	# add that first define
  my $a = ["problem",$self->System];
  push @$structure, $a;

  # now use the first element to choose what to do
  foreach my $enum (qw(:domain :objects :init :goal)) {
    my $a = [];
    if ($enum eq ":domain") {
      push @$a, $self->System;
    } elsif ($enum eq ":objects") {
      foreach my $type (keys %{$self->HasObjects}) {
	push @$a, $type;
	push @$a, "-";
	foreach my $obj (keys %{$self->HasObjects->{$type}}) {
	  push @$a, $obj;
	}
      }
      push @$a, ":objects";
      $a = [reverse @$a];
    } elsif ($enum eq ":init") {
      push @$a, ":init";
      foreach my $init (keys %{$self->Inits}) {
	# don't we have to convert this from structure to string for
	# now?
	push @$a, $self->LispStringToLispStructure
	  (LispString => $init);
      }
    } elsif ($enum eq ":goal") {
      push @$a, ":goal";
      foreach my $goal (keys %{$self->Goals}) {
	# don't we have to convert this from structure to string for
	# now?
	push @$a, $self->LispStringToLispStructure
	  (LispString => $goal);
      }
    }
    push @$structure, $a;
  }
  return $structure;
}

sub NormalizeToLispString {
  my ($self,$s) = @_;
  if (ref $s eq "ARRAY") {
    return $self->LispStructureToLispString
      (LispStructure => $s);
  } else {
    return $self->LispStringNormalize
      ($s);
  }
}

sub LispStringNormalize {
  my ($self,$s) = @_;
  return
    $self->LispStructureToLispString
      (LispStructure =>
       $self->LispStringToLispStructure
       (LispString => $s));
}

sub LispStringToLispStructure {
  my ($self,%args) = @_;
  my $c = $args{LispString};
  $c =~ s/;.*//mg;
  my $tokens = [split //,$c];
  my $cnt = 0;
  my $stack = [];
  my $symbol = "";
  do {
    $char = shift @$tokens;
    if ($char =~ /\(/) {
      ++$cnt;
      $stack->[$cnt] = [];
      $symbol = "";
    } elsif ($char =~ /[\s\n]/) {
      if (length $symbol) {
	push @{$stack->[$cnt]},$symbol;
	$symbol = "";
      }
    } elsif ($char =~ /\)/) {
      # now $stack->[$cnt] holds all of  our objects, and so just have
      # to move those into the right place
      if (length $symbol) {
	push @{$stack->[$cnt]},$symbol;
	$symbol = "";
      }
      my @a = @{$stack->[$cnt]};
      $stack->[$cnt] = undef;
      --$cnt;
      push @{$stack->[$cnt]}, \@a;
    } else {
      if ($char !~ /\s/) {
	$symbol .= $char;
      }
    }
  } while (@$tokens);
  $domain = $stack->[0]->[0];
  return $domain;
}

sub LispStructureToLispString {
  my ($self,%args) = @_;
  my $structure = $args{LispStructure};
  $args{Indent} = $args{Indent} || 0;
  my $indentation = (" " x $args{Indent});
  my $retval = "$indentation(";
  my $total = scalar @$structure;
  my $cnt = 0;
  my $l = 0;
  foreach my $x (@$structure) {
    ++$cnt;
    if (ref $x eq "ARRAY") {
      my $c = $self->LispStructureToLispString
	(LispStructure => $x,
	 Indent => $args{Indent} + 1);
      $retval .= "\n$c";
      $l = 1;
      # $retval .= "\n" unless $cnt == $total;
    } else {
      if ($l == 1) {
	$retval .= " ";
	$l = 0;
      }
      $retval .= "$x";
      $retval .= " " unless $cnt == $total;
    }
  }
  $retval .= ")";
  return $retval;
}

1;
