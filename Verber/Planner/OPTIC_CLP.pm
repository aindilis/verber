package Verber::Planner::OPTIC_CLP;

use MyFRDCSA;
use PerlLib::SwissArmyKnife;
use Verber::Planner::Base::Planner;

our @ISA = qw(Verber::Planner::Base::Planner);

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / MyCapsule / ];

sub init {
  my ($self,%args) = @_;
  $self->Verber::Planner::Base::Planner::init(%args);
  $self->Paths->{Exec} = 
    ConcatDir($UNIVERSAL::plannerdir,"optic-clp");
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  my $command =
    join (" ",
	  ($self->Paths->{Exec},
	   '-N',
	   $self->MyCapsule->DomainFile,
	   $self->MyCapsule->ProblemFile,
	   ">",
	   $self->CWPlan->SolutionFile->Name,
	  ));
  my $response = $self->ExecuteCommandWithTee
    (
     Dir => $self->MyCapsule->Dir,
     Command => $command,
    );
  my $name2 = $self->CWPlan->SolutionFile->Name;
  # my $name1 = $name2.".SOL";;
  # my $command2 = "mv \"$name1\" \"$name2\"";
  # print $command2."\n";
  # system $command2;
  print $name2."\n";
  return $response;
}

1;
