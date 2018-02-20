package Verber::Planner::SatPlanP;

use MyFRDCSA;
use Verber::Planner::Base::Planner;

our @ISA = qw(Verber::Planner::Base::Planner);

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / / ];

sub init {
  my ($self,%args) = @_;
  $self->Verber::Planner::Base::Planner::init(%args);
  $self->Options->{PlanType} = ($args{PlanType} || "-speed");
  $self->Paths->{SatPlanPDir} =
    ConcatDir($UNIVERSAL::plannerdir);
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  my $command = join (" ",
		      ("./satplanp",
		       "-domain",
		       ConcatDir($self->MyCapsule->Dir,$self->MyCapsule->DomainFile),
		       "-problem",
		       ConcatDir($self->MyCapsule->Dir,$self->MyCapsule->ProblemFile),
		       "-solution",
		       $self->CWPlan->SolutionFile->Name,
		       $self->Options->{PlanType}));

  return $self->ExecuteCommandWithTee
    (
     Dir => $self->Paths->{SatPlanPDir},
     Command => $command,
    );
}

1;
