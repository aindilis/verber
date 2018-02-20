package Verber::Planner::LPG;

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
  if (1) {
    $self->Options->{PlanType} = ($args{PlanType} || "-speed");
  } else {
    $self->Options->{PlanType} = ($args{PlanType} || "-quality");
  }
  $self->Paths->{Exec} =
    ConcatDir($UNIVERSAL::plannerdir,"lpg-td-1.0");
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  my $command = join (" ",
		      ($self->Paths->{Exec},
		       "-o",
		       $self->MyCapsule->DomainFile,
		       "-f",
		       $self->MyCapsule->ProblemFile,
		       "-out",
		       $self->CWPlan->SolutionFile->Name,
		       $self->Options->{PlanType},
		      ));

  my $response = $self->ExecuteCommandWithTee
    (
     Dir => $self->MyCapsule->Dir,
     Command => $command,
    );
  my $name2 = $self->CWPlan->SolutionFile->Name;
  my $name1 = $name2.".SOL";;
  my $command2 = "mv \"$name1\" \"$name2\"";
  print $command2."\n";
  system $command2;
  return $response;
}

1;
