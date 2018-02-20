package Verber::Planner::Maxplan;

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
  $self->Paths->{Exec} =
    ConcatDir($UNIVERSAL::plannerdir,"maxplan","maxplan");
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  my $command = join (" ",
		      ($self->Paths->{Exec},
		       "-o",
		       $self->MyCapsule->DomainFile,
		       "-f",
		       $self->MyCapsule->ProblemFile,
		       "-F",
		       $self->CWPlan->SolutionFile->Name,
		       $self->Options->{PlanType}));

  return $self->ExecuteCommandWithTee
    (
     Dir => $self->MyCapsule->Dir,
     Command => $command,
    );
}

1;
