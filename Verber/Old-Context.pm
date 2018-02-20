package Verber::Context;

use MyFRDCSA;
use Verber::World;

use Verber::Ext::PDDL::Problem;
use Verber::Ext::PDDL::Domain;
use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Worlds ContextDir WorldDir TemplateDir Templates
                          CWW Extension / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->Extension($args{Extension} || "pddl");
  $self->Worlds($args{Worlds} || {});
  $self->ContextDir($args{ContextDir} || "worldmodel");
  $self->WorldDir
    ($args{WorldDir} ||
     ConcatDir($self->ContextDir,"worlds"));
  $self->TemplateDir
    ($args{TemplateDir} ||
     ConcatDir($self->ContextDir,"templates"));
  $self->LoadTemplates;
}

sub LoadTemplates {
  my ($self,%args) = (shift,@_);
  my $c1 = "ls ".$self->TemplateDir;
  my $templates = {};
  my $extension = $self->Extension;
  foreach my $file (split /\n/,`$c1`) {
    $file =~ s/\.[pd]\.$extension//;
    $templates->{$file} = 1;
  }
  $self->Templates($templates);
}

sub AddWorld {
  my ($self,%args) = (shift,@_);
  # check whether the world is a template world, if so, generate it
  my $world = Verber::World->new
    (Name => $args{Name},
     WorldDir => $self->WorldDir,
     Extension => $self->Extension);
  $self->CWW($world);

  # here begins the tricky issue of how to deal with subworlds

  # there are many cases, for instance, say we don't want to bother
  # regenerating them

  # sometimes they have to be generated, and cannot be parsed until then

  # for now, let's not regenerate them, leaving that to the planning
  # domain itself to regenerate them

  if (exists $self->Templates->{$world->Name}) {
    $self->Generate;
  }
  $self->CWW->GetTimeUnits;
  $self->Worlds->{$world->Name} = $world;
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

sub SynthesizeDomain {
  my ($self,%args) = (shift,@_);
  $self->CWW->Domain
    (Verber::Ext::PDDL::Domain->new
     (FileName => ""));
  return $self->CWW->Domain->Generate;
}

sub SynthesizeProblem {
  my ($self,%args) = (shift,@_);
  $self->CWW->Problem
    (Verber::Ext::PDDL::Problem->new
     (FileName => ""));
  $self->LoadProblem;
  return $self->CWW->Problem->Generate;
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

sub GetIncludes {
  my $contents = shift;
  if ($contents =~ /;+\s*\(include ([^\)]+)\).*/sm) {
    return split /\s+/,$1;
  }
}

sub Parse {
  my $contents = shift;
  #   $contents =~ s/;.*$//mg;
  #   $contents =~ s/[\P{IsASCII}\r\t]//g;
  #   $contents =~ s/\n{2,}/\n/g;
  #   $contents =~ s/\n//;
  return lisp_read($contents);
}

sub Update {
  my ($self,%args) = (shift,@_);
  # need to account for any changes to the current world model
}

sub Operations {
  # operations to be performed on the verber template domains:
  # new, fork, new-version, etc
  # in other words need to keep accurate meta-data
}

1;
