package Verber::Planner::LPG;

use MyFRDCSA;

use Data::Dumper;

# This is a  planning interface.  This basically starts  up SHOP2 with
# the correct domain  and generates the plans and  then uses dialog to
# display them.

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Capsule Paths Options / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->Capsule($args{Capsule});
  $self->Paths({});
  $self->Options({});
  $self->Options->{PlanType} = ($args{PlanType} || "-speed");

  $self->Paths->{LPGExec} =
    ConcatDir("/usr/bin/lpg-td-1.0");
}

sub Plan {
  my ($self) = (shift);
  my $pwd = 'pwd';
  chdir $self->Capsule->Dir;
  my $command = join (" ",
		      ($self->Paths->{LPGExec},
		       "-o",
		       $self->Capsule->DomainFile,
		       "-f",
		       $self->Capsule->ProblemFile,
		       $self->Options->{PlanType}));
  print $command . "\n";
  system $command;
  chdir $pwd;
}

1;
