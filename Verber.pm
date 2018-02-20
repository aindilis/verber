package Verber;

use BOSS::Config;
use MyFRDCSA;
use PerlLib::SwissArmyKnife;
use Verber::Context;
use Verber::Manager;
use Verber::Resources;
use Verber::Visualizer;
use Verber::Util::Requirements;

# use Verber::Context;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Config CWP MyPlanners MyContext MyVisualizer MyManager Debug
   MyResources /

  ];

sub init {
  my ($self,%args) = @_;
  $PerlLib::Util::SortKeys =
    sub {
      my ($hash) = @_; 
      # print join(" JOEY BUTAFUKO ",keys %{$hash}); 
      my @list;
      foreach my $key (keys %$hash) {
	my $ref = ref($hash->{$key});
	next if $ref =~ /^DateTime::TimeZone\b/;
	push @list, $key;
      }
      return \@list;
    };
  $specification = "
	-l				List available worlds
	-w <name>			World name

	-p <planner>...			Name of planner
	-a				Use all planners

	-c				Continuous planning
	--response <agent>		Send a response back to agent about the status of the plan

	--iem <version>			Use the Interactive Execution Monitor

	-m				Manage

	-t				Tee STDERR/OUT to files (messes up order of output)

	--print				Print solution
	-u [<host> <port>]		Run as a UniLang agent

	--vw				Visualize world
	--vp				Visualize plan

	--skip-templates		Don't generate from templates
	--skip-federated		Don't generate from federated

	--no-plan			Do everything but don't actually plan

	-e				Edit domains using GIPO

	--val				Process outputted plan with VAL-4.2.09

	--map-requirements		Figure out which planners support which requirements
";
  $self->Config(BOSS::Config->new
		(Spec => $specification,
		 ConfFile => ""));
  my $conf = $self->Config->CLIConfig;
  $self->Debug(1);
  $self->MyResources(Verber::Resources->new);
  $UNIVERSAL::systemdir = ConcatDir(Dir("internal codebases"),"verber");
  $UNIVERSAL::plannerdir = ConcatDir($UNIVERSAL::systemdir,"data","planner-library");
  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->DoNotDaemonize(1);
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  my $h = {};
  my $plan = 0;
  if (exists $conf->{'--map-requirements'}) {
    $h->{MapRequirements} = 1;
  }
  if ($conf->{'-a'}) {
    $h->{AllPlanners} = 1;
  } elsif ($conf->{'-p'}) {
    $h->{Planners} = $conf->{'-p'};
  }
  if (exists $conf->{'-w'}) {
    $h->{Name} = $conf->{'-w'};
    $plan = 1;
  }
  if ($conf->{'--no-plan'}) {
    $h->{NoPlan} = 1;
  }
  if ($plan) {
    $self->GeneratePlan(%$h);
  } else {
    $UNIVERSAL::agent->Listen();
  }
}

sub ListPlanners {
  my ($self,%args) = @_;
  my $list = [];
  my $dir = $UNIVERSAL::systemdir."/Verber/Planner";
  my $stuff = `ls $dir/*.pm`;
  foreach my $file (split /\n/, $stuff) {
    if ($file =~ /^.*\/(.+?)\.pm$/) {
      my $plannername = $1;
      push @$list, $plannername;
    }
  }
  return $list;
}

sub MapRequirements {
  my $requirements = Verber::Util::Requirements->new;
  $requirements->MapRequirements;
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  print SeeDumper($m) if $UNIVERSAL::verber->Debug >= 3;

  # look at the data segment and send
  my $it = $m->Contents;
  if ($it =~ /^echo\s*(.*)/) {
    $UNIVERSAL::agent->SendContents
      (Contents => $1,
       Requirementsceiver => $m->{Sender});
  } elsif ($it =~ /^(quit|exit)$/i) {
    $UNIVERSAL::agent->Deregister;
    exit(0);
  }
  my $d = $m->Data;
  if ($d->{Command} eq "plan") {
    # send the result back to the agent, possibly SPSE2, and have them
    # send it on to IEM
    delete $d->{Command};
    $self->GeneratePlan(%$d);
    $UNIVERSAL::agent->SendContents
      (
       Receiver => $m->Sender,
       Data => {
		World => $self->MyContext->CWW,
	       },
      );
  }
}

sub GeneratePlan {
  my ($self,%args) = @_;
  print SeeDumper(\%args) if $UNIVERSAL::verber->Debug >= 3;
  my $conf = $self->Config->CLIConfig;

  if ($args{MapRequirements}) {
    $self->MapRequirements;
    return;
  }

  # what verber wants to do is just take the current model
  # and get it going

  # the model generates a plan for verbers continued execution

  my $list;
  if (exists $args{Planners}) {
    $list = $args{Planners};
  } else {
    if (exists $args{AllPlanners}) {
      $list = $self->ListPlanners;
    } else {
      $list = [
	       "LPG",
	       # "SGPlan6",
	      ];
    }
  }

  print "Loading planners\n" if $UNIVERSAL::verber->Debug;
  $self->MyPlanners
    (PerlLib::Collection->new
     (Type => "Verber::Planner"));
  $self->MyPlanners->Contents({});

  my $dir = $UNIVERSAL::systemdir;
  foreach my $plannername (@$list) {
    require "$dir/Verber/Planner/$plannername.pm";
    my $planner = "Verber::Planner::$plannername"->new();
    $self->MyPlanners->Add
      ($plannername => $planner);
  }

  print "Initializing context\n" if $UNIVERSAL::verber->Debug;
  $self->MyContext
    (Verber::Context->new
     ());

  $args{Name} ||= "integrate";
  print SeeDumper({Name => $name}) if $UNIVERSAL::verber->Debug;
  if ($conf->{'--skip-federated'}) {
    $args{SkipFederated} = 1;
  }
  if ($conf->{'--skip-templates'}) {
    $args{SkipTemplates} = 1;
  }
  print "Adding world\n" if $UNIVERSAL::verber->Debug;
  $self->MyContext->AddWorld(%args);

  # choose a planner that can plan in that world, for now just choose
  # the first one

  foreach my $planner ($self->MyPlanners->Values) {
    $self->CWP($planner);
    $self->CWP->MyCapsule
      ($self->MyContext->CWW->MyCapsule);

    if (! $args{NoPlan}) {
      print "Generating plan with ".$planner->PlannerName."\n" if $UNIVERSAL::verber->Debug;
      my $plan = $self->CWP->DevelopPlan
	 (
	  StartDate => $self->MyContext->CWW->StartDate,
	  Units => $self->MyContext->CWW->Units,
	 );
      # print Dumper({Plan => $plan});
      $self->MyContext->CWW->AddPlan
	(Plan => $plan);
      print ClearDumper({CWW => $self->MyContext->CWW});
    }
  }
  if (! $args{NoPlan}) {
    $self->MyContext->CWW->Plans->{1}->LoadFiles();
    if (exists $args{IEM} or $conf->{'--iem'}) {
      my $version = $args{IEM} || $conf->{'--iem'};
      $UNIVERSAL::agent->SendContents
	(
	 Receiver => "IEM$version",
	 Data => {
		  World => $self->MyContext->CWW,
		 },
	);
    }
  }
}

1;
