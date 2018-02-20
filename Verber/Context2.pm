package Verber::Context;

use MyFRDCSA;
use Verber::World;

use Data::Dumper;
use Lisp::Reader qw (lisp_read);
use Lisp::Printer qw (lisp_print);

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
    (
     Name => $args{Name},
     WorldDir => $self->WorldDir,
     Extension => $self->Extension,
    );
  $self->CWW($world);
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
  print Dumper($world->MyCapsule);
  exit(0);
  if (! exists $UNIVERSAL::verber->Config->CLIConfig->{'--check'}) {
    my $problem = $self->SynthesizeProblem;
    open(OUT,">".ConcatDir($world->MyCapsule->Dir,$world->MyCapsule->ProblemFile)) or die "ouch";
    print OUT $problem;
    close(OUT);
    open(OUT,">".ConcatDir($world->MyCapsule->Dir,$world->MyCapsule->DomainFile)) or die "ouch";
    print OUT $self->SynthesizeDomain;
    close(OUT);
  }
}

sub SynthesizeDomain {
  my ($self,%args) = (shift,@_);
  my $result = lisp_print
    (shift @{$self->LoadDomain
	       (Name => $self->CWW->Name)});
  $result =~ s/QQQMMM/\?/g;
  return $result;
}

sub SynthesizeProblem {
  my ($self,%args) = (shift,@_);
  my $result = lisp_print
    (shift @{$self->LoadProblem
	       (Name => $self->CWW->Name)});
  $result =~ s/QQQMMM/\?/g;
  return $result;
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
    $contents =~ s/\?/QQQMMM/g;
    my $l1 = Parse($contents);
    # print Dumper($l1);
    my @subdomains;

    foreach my $n2 (GetIncludes($contents)) {
      my $l2 = $self->LoadDomain(Name => $n2);
      # load all the standard stuff
      foreach my $i (qw(2 3 4 5)) {
	if (defined $l2->[0]->[$i]) {
	  push @{$l1->[0]->[$i]}, splice(@{$l2->[0]->[$i]}, 1);
	}
      }

      # load all the actions
      if (@{$l2->[0]} > 6) {
	push @{$l1->[0]}, splice(@{$l2->[0]}, 6);
      }
    }
    # integrate all the domains
    return $l1;
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
  foreach my $n2 (GetIncludes($contents)) {
    my $l2 = $self->LoadProblem(Name => $n2);
    $self->AddProblem(L1 => $l1,
		      L2 => $l2);
  }
  return $l1;
}

sub AddProblem {
  my ($self,%args) = (shift,@_);
  push @{$args{L1}->[0]->[2]},
    bless( {
	    'name' => uc($name)
	   }, 'Lisp::Symbol' );
  foreach my $i (qw(3 4 5)) {
    if (defined $args{L2}->[0]->[$i]) {
      push @{$args{L1}->[0]->[$i]}, splice(@{$args{L2}->[0]->[$i]}, 1);
    }
  }
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
