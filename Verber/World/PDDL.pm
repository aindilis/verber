package Verber::World::PDDL22;

# this takes care of PDDL specific worlds
# we need to load all pddl files for this
# can use any of these planners

use Verber::Ext::PDDL::Domain;
use Verber::Ext::PDDL::Problem;
use Verber::Planner::LPG;
use Verber::Planner::MBP;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / MyPlanners OutputDomainFile OutputProblemFile /

  ];

# WorldDir SolutionDir Domain DomainFile Problem ProblemFile SolFile
# SceneFile TimeUnits Extension MyWorldModel

sub init {
  my ($self,%args) = @_;
  $self->MyPlanners
    (PerlLib::Collection->new
     (Type => "Verber::Planner"));
  $self->MyPlanners->Contents({});
  $self->MyPlanners->Add("lpg" => Verber::Planner::LPG->new());
  $self->MyPlanners->Add("mbp" => Verber::Planner::MBP->new());

  # actually the  planners should be started up  independently, and be
  # passed an object, which they can "plan" "validate" "etc"
  # various planners should make known their capabilities
  # then this system will use those various capabilities for various things

  $self->Domain($args{Domain});
  $self->Problem($args{Problem});
  $self->WorldDir($args{WorldDir});
  $self->SolutionDir($self->WorldDir);
  $self->DomainFile
    ($args{DomainFile} || $self->Name.".d.".$self->Extension);
  $self->ProblemFile
    ($args{ProblemFile} || $self->Name.".p.".$self->Extension);
  $self->SolFile
    ($args{SolFile} ||
     "plan_".$self->ProblemFile.".SOL");
  $self->SceneFile
    ($args{SceneFile} ||
     "plan_".$self->ProblemFile.".SCENE");
  $self->Domain
    (Verber::Ext::PDDL::Domain->new
     ());
  $self->Problem
    (Verber::Ext::PDDL::Problem->new
     ());
}

sub GetIncludes {
  my $contents = shift;
  if ($contents =~ /;+\s*\(include ([^\)]+)\).*/sm) {
    return split /\s+/,$1;
  }
}


sub GetTimeUnits {
  my $self = shift;
  my $c1 = "cat ".ConcatDir($self->WorldDir,$self->ProblemFile);
  $contents = `$c1`;
  # print Dumper($contents);
  if ($contents =~ /;+\s*\(time-units ([^\)]+)\).*/sm) {
    $self->TimeUnits($1);
  }
}

sub Validate {
  my $self = (shift);
  my $command = join
    (" ",
     ("./bin/validate",
      $self->DomainFile,
      $self->ProblemFile));
  print $command."\n";
  system $command;
}

sub LoadPlan {
  chdir "/var/lib/myfrdcsa/codebases/internal/verber";
  my $c1 = "cat ".ConcatDir($self->World->SolutionDir,$self->World->SolFile);
  my $contents = `$c1`;

  $self->MyPlan
    (Verber::Manager::Plan->new
     (PlanContents => $contents,
      TimeUnits => $self->World->TimeUnits));
}

sub Generate {
  my ($self,%args) = (shift,@_);
  my $world = $self->CWW;
  # print Dumper($world);
  if (! exists $UNIVERSAL::verber->Config->CLIConfig->{'--check'}) {
    my $problem = $self->SynthesizeProblem;
    open(OUT,">".ConcatDir($world->WorldDir,$world->ProblemFile)) or die "ouch";
    print OUT $problem;
    close(OUT);
    open(OUT,">".ConcatDir($world->WorldDir,$world->DomainFile)) or die "ouch";
    print OUT $self->SynthesizeDomain;
    close(OUT);
  }
}

sub LoadDomain {
  my ($self,%args) = (shift,@_);
  my $name = lc($args{Name});
  # print "$name\n";
  my $filename = ConcatDir($self->TemplateDir,"/$name.d.".$self->Extension);
  if (! -e $filename or exists $UNIVERSAL::verber->Config->CLIConfig->{'--check'}) {
    $filename = ConcatDir($self->WorldDir,"/$name.d.".$self->Extension);
  }
  if (-e $filename) {
    my $contents = `cat $filename`;
    # add the contents here
    my $vd = Verber::Ext::PDDL::Domain->new();
    return $vd;
  }
}

sub LoadProblem {
  my ($self,%args) = (shift,@_);
  my $name = lc($args{Name});
  return unless $name;

  # if no world file exists, load the template, otherwise load the worldfile
  my $filename = ConcatDir($self->WorldDir,"/$name.p.".$self->Extension);
  if (! -f $filename) {
    $filename = ConcatDir($self->TemplateDir,"/$name.p.".$self->Extension);
    print "Compiling template for $filename\n";
  } else {
    print "Using world for $filename\n";
  }

  my $contents = `cat $filename`;
  $contents =~ s/\?/QQQMMM/g;
  my $l1 = Parse($contents);
  # foreach my $n2 (GetIncludes($contents)) {
}

1;

