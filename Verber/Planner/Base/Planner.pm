package Verber::Planner::Base::Planner;

use MyFRDCSA;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / PlannerName MyCapsule Paths Options World CWPlan /

  ];

sub init {
  my ($self,%args) = @_;
  if (exists $args{PlannerName}) {
    $self->PlannerName
      ($args{PlannerName});
  } else {
    my $it = ref $self;
    if ($it =~ /Verber::Planner::(.+)/) {
      $self->PlannerName($1);
    }
  }
  $self->MyCapsule($args{Capsule});
  $self->Paths({});
  $self->Options({});
  $self->Options->{PlanType} = ($args{PlanType});
}

sub DevelopPlan {
  my ($self,%args) = @_;
  my $plannername = $self->PlannerName;
  unless (defined $self->MyCapsule) {
    print "No capsule for $plannername\n";
    return;
  }

  require "$UNIVERSAL::systemdir/Verber/Planner/${plannername}/Plan.pm";
  $self->CWPlan
    ("Verber::Planner::${plannername}::Plan"->new
     (
      Planner => $self,
      StartDate => $args{StartDate},
      Units => $args{Units},
     ));

  $self->CWPlan->Clean;
  $self->ExecutePlanner
    (Plan => $self->CWPlan);
  return $self->CWPlan;
}

sub ExecuteCommandWithTee {
  my ($self,%args) = @_;
  my $plannername = $self->PlannerName;
  print "Executing $plannername\n";
  my $command = $args{Command};
  my $dir = $args{Dir};
  my $pwd = 'pwd';
  print "chdir to: <$dir>\n";
  my $teeoutfile = $self->CWPlan->TeeOutFile->Name;
  my $teeerrfile = $self->CWPlan->TeeErrFile->Name;

  my $fullcommand;
  if (exists $UNIVERSAL::verber->Config->CLIConfig->{'-t'}) {
    $fullcommand = "(($command 2>&1 1>&3 | tee $teeerrfile) 3>&1 1>&2 | tee $teeoutfile) 2>&1";
  } else {
    $fullcommand = "$command";
  }
  print "command: <$fullcommand>\n";

  chdir $dir;
  system $fullcommand;
  chdir $pwd;

  $self->CWPlan->LoadFiles;
}

1;
