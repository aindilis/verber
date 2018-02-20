package Verber::Planner::Crikey;

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
  $self->Paths->{Exec} =
    ConcatDir($UNIVERSAL::plannerdir,"crikey3.1","crikey3");
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  my $command = join (" ",
		      (
		       $self->Paths->{Exec},
		       $self->MyCapsule->DomainFile,
		       $self->MyCapsule->ProblemFile,
		      ));

  return $self->ExecuteCommandWithTee
    (
     Dir => $self->MyCapsule->Dir,
     Command => $command,
    );
}

1;
