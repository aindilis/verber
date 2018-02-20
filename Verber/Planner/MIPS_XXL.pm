package Verber::Planner::MIPS_XXL;

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
    ConcatDir($UNIVERSAL::plannerdir,"mips-xxl2008");
  $self->Paths->{Exec} =
    "/var/lib/myfrdcsas/versions/myfrdcsa-1.0/codebases/minor/numeric-metric-planning/systems/mips-xxl/systems/itsimple/myPlanners/mips-xxl2008";
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  my $postprocessed = $self->MyCapsule->DomainFile.'.mips_xxl.d.pddl';
  my $command1 = 'cat '.shell_quote($self->MyCapsule->DomainFile).' | sed -e \'s/:derived-predicates//\' > '.shell_quote($postprocessed);
  my $response1 = $self->ExecuteCommandWithTee
    (
     Dir => $self->MyCapsule->Dir,
     Command => $command1,
    );
  my $command =
    join (" ",
	  ($self->Paths->{Exec},
	   "-o",
	   $postprocessed,
	   "-f",
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
  my $name1 = $name2.".SOL";;
  my $command2 = "mv \"$name1\" \"$name2\"";
  print $command2."\n";
  system $command2;
  return $response;
}

1;
