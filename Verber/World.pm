package Verber::World;

use MyFRDCSA;
use Verber::World::Model;

use Verber::Capsule::PDDL22;

use Data::Dumper;
use File::Basename;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Name InputType MyCapsule OutputPlan MyModel Plans PlanCounter
   ValidSyntax StartDate Units /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Name($args{Name});
  $self->InputType($args{Type} || "PDDL2.2");
  $self->MyCapsule
    (
     Verber::Capsule::PDDL22->new
     (
      Name => $self->Name,
      WorldDir => $args{WorldDir},
      TemplateDir => $args{TemplateDir},
      PrototypeDir => $args{PrototypeDir},
      Extension => $args{Extension},
     )
    );

  #   $self->MyModel
  #     (Verber::World::Model->new
  #      (Facts => $args{Facts}));

  $self->Plans({});
  $self->PlanCounter(1);
  $self->SyntaxCheck;

  $self;
}

sub SyntaxCheck {
  my ($self,%args) = @_;
  my $command = $UNIVERSAL::systemdir."/data/support-tools/SyntaxCheckerPDDL3.0 -o ".
    $self->MyCapsule->DomainFileFull." -f ".$self->MyCapsule->ProblemFileFull;
  my $res = `$command`;
  if ($res =~ /According to the BNF grammar of PDDL3.0, the input problem and.*domain are correct./s) {
    print "Syntax is valid\n";
    $self->ValidSyntax(1);
  }
  # # To validate domains
  # /var/lib/myfrdcsa/sandbox/itsimple4.0-beta3/itsimple4.0-beta3/myValidators/validate -v /var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/date-20120826.d.pddl /var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/date-20120826.p.pddl 
  # /var/lib/myfrdcsa/sandbox/itsimple4.0-beta3/itsimple4.0-beta3/myPlanners/sgplan6 -o /var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/date-20120826.d.pddl -f /var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/worlds/date-20120826.p.pddl -out /tmp/tmp.txt
}

sub AddPlan {
  my ($self,%args) = @_;
  # maybe do a snapshot of the world as it was when this was generated
  $self->Plans->{$self->PlanCounter} = $args{Plan};
  $self->PlanCounter($self->PlanCounter + 1);
}

1;
