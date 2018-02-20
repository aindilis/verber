package Verber::Planner::IPC2011;

use MyFRDCSA;
use PerlLib::SwissArmyKnife;
use Verber::Planner::Base::Planner;

our @ISA = qw(Verber::Planner::Base::Planner);

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Category Program ProgramDir IPC2011PlannersDir RunDir /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Verber::Planner::Base::Planner::init(%args);
  if (1) {
    $self->Options->{PlanType} = ($args{PlanType} || "-speed");
  } else {
    $self->Options->{PlanType} = ($args{PlanType} || "-quality");
  }

  $self->IPC2011PlannersDir
    ($args{IPC2011PlannersDir} ||
     "/var/lib/myfrdcsa/collections/ipc2011/data-old/planners");
  $self->Category($args{Category} || "tempo-sat");
  $self->Program($args{Program} || "yahsp2-mt");
  $self->ProgramDir($args{ProgramDir} || $self->Category.'-'.$self->Program);

  $self->RunDir(ConcatDir($self->IPC2011PlannersDir,$self->Category,$self->ProgramDir));
  $self->Paths->{Exec} = "plan";
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  my $command = join (" ",
		      ("plan",
		       ConcatDir($self->MyCapsule->Dir,$self->MyCapsule->DomainFile),
		       ConcatDir($self->MyCapsule->Dir,$self->MyCapsule->ProblemFile),
		       # ConcatDir($self->MyCapsule->Dir,$self->CWPlan->SolutionFile->Name),
		       "/tmp/plan-output",
		      ));

  my $response = $self->ExecuteCommandWithTee
    (
     Dir => $self->RunDir,
     Command => $command,
    );
  my $name2 = $self->CWPlan->SolutionFile->Name;
  my $name1 = $name2.".SOL";;
  my $command2 = "mv \"$name1\" \"$name2\"";
  print $command2."\n";
  # system $command2;
  return $response;
}

1;
