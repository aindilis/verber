package Verber::Planner::MBP;

use MyFRDCSA;

use Data::Dumper;

# This is a planning interface.  This basically starts up MBP with the
# correct  domain and  generates the  plans  and then  uses dialog  to
# display them.

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / World Paths Options Version Extension / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->World($args{World});
  $self->Extension("npddl");
  $self->Paths({});
  $self->Options({});
  $self->Options->{PlanType} = ($args{PlanType} || "-speed");

  $self->Paths->{Verber} =
    ($args{Verber} ||
     ConcatDir(MyFRDCSA::Dir("internal codebases"),"verber"));

  $self->Paths->{DomainDir} =
    ($args{DomainDir} ||
     ConcatDir($self->Paths->{Verber},"worldmodel/worlds"));

  $self->Paths->{MBP} =
    ConcatDir("/usr/bin/MBP-solve");
}

sub Plan {
  my ($self) = (shift);
  my $pwd = 'pwd';
  chdir $self->Paths->{DomainDir};
  my $command = join (" ",
		      ($self->Paths->{MBP},
		       "-plan_output",
		       $self->World->SolFile,
		       $self->World->DomainFile,
		       $self->World->ProblemFile));
  print $command . "\n";
  system $command;
  chdir $pwd;
}

1;
