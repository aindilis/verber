package Verber::Ext::PDDL;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [ qw / System Types SuperTypes SubTypes Inits Goals Order TimeUnits / ];

# learn system specific type mappings to Cyc for instance

sub init {
  my ($self,%args) = (shift,@_);
  $self->System($args{System});
  $self->Types($args{Types} || {});
  $self->SuperTypes($args{SuperTypes} || {});
  $self->SubTypes($args{SubTypes} || {});
  $self->Inits($args{Inits} || {});
  $self->Goals($args{Goals} || {});
  $self->Order($args{Order} || 0);
  $self->TimeUnits($args{TimeUnits} || "minutes");
}

sub AddType {
  my ($self,$o,$c) = (shift,shift,shift);
  # maybe even use math::partialorder here
  # do a check that it hasn't been asserted before
  $self->SuperTypes->{$c}->{$o} = 1;
  $self->SubTypes->{$o}->{$c} = 1;
  $self->Types->{$o} = 1;
  $self->Types->{$c} = 1;
}

sub AddInit {
  my ($self,$s) = (shift,shift);
  $self->Inits->{$s} = ++$self->Order->{Init};
}

sub AddGoal {
  my ($self,$s) = (shift,shift);
  $self->Goals->{$s} = ++$self->Order->{Goal};
}

sub SPrintTypes {
  my ($self,%args) = (shift,@_);
  my $retval = "";
  foreach my $supertype (keys %{$self->SuperTypes}) {
    $retval .= "\t".
      join(" ",keys %{$self->SuperTypes->{$supertype}})
	." - ".
	  $supertype."\n";
  }
  return $retval;
}

sub SPrintInits {
  my ($self,%args) = (shift,@_);
  return join ("\n",
	       map "\t$_",
	       sort {$self->Inits->{$a} <=> $self->Inits->{$b}}
	       keys %{$self->Inits})."\n";
}

sub SPrintGoals {
  my ($self,%args) = (shift,@_);
  return join ("\n",
	       map "\t$_",
	       sort {$self->Goals->{$a} <=> $self->Goals->{$b}}
	       keys %{$self->Goals})."\n";
}

sub Clean {
  my ($self,$c) = (shift,shift);
  $c =~ s/\W/-/g;
  $c =~ s/-+/-/g;
  $c =~ s/^-//;
  $c =~ s/-$//;
  return $c;
}

sub Export {
  my ($self,%args) = (shift,@_);

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
    ($self->SPrintTypes, $self->SPrintInits, $self->SPrintGoals);

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

1;
