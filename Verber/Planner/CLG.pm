package Verber::Planner::CLG;

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
  $self->Paths->{Dir} = '/var/lib/myfrdcsa/sandbox/clg-run-20170927/clg-run-20170927';
  $self->Paths->{Exec} = './run-clg.sh';
  # ConcatDir($UNIVERSAL::plannerdir,"clg");
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  my $command =
    join (" ",
	  ('cd',
	   $self->Paths->{Dir},
	   '&&',
	   $self->Paths->{Exec},
	   '-1',
	   ConcatDir('/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/',$self->MyCapsule->DomainFile),
	   ConcatDir('/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/',$self->MyCapsule->ProblemFile),
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
