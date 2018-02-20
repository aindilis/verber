package Verber::Context;

use MyFRDCSA;
use Verber::FedManager;
use Verber::World;
use Verber::Util::Beautifier;

use Data::Dumper;
use Lisp::Printer qw (lisp_print);
use Lisp::Reader qw (lisp_read);
use Lisp::Symbol;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Worlds ContextDir WorldDir TemplateDir Templates
                          CWW Extension MyBeautifier MyFedManager / ];

sub init {
  my ($self,%args) = @_;
  $self->Extension($args{Extension} || "pddl");
  $self->Worlds($args{Worlds} || {});
  $self->ContextDir($args{ContextDir} || $UNIVERSAL::systemdir."/data/worldmodel");
  $self->WorldDir
    ($args{WorldDir} ||
     ConcatDir($self->ContextDir,"worlds"));
  $self->TemplateDir
    ($args{TemplateDir} ||
     ConcatDir($self->ContextDir,"templates"));
  $self->MyBeautifier
    (Verber::Util::Beautifier->new);
  $self->MyFedManager
    (Verber::FedManager->new);
}

sub LoadTemplates {
  my ($self,%args) = @_;
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
  my ($self,%args) = @_;
  my $conf = $UNIVERSAL::verber->Config->CLIConfig;
  # check whether the world is a template world, if so, generate it
  my $world = Verber::World->new
    (
     Name => $args{Name},
     Domain => $args{Domain},
     Problem => $args{Problem},
     WorldDir => $self->WorldDir,
     Extension => $self->Extension,
    );
  $self->CWW($world);
  # check whether there is a federated search that provides this, if
  if (exists $conf->{'-f'}) {
    if (exists $self->MyFedManager->Name2Fed->{$world->Name}) {
      print "Performing Federated Search\n";
      $self->MyFedManager->Name2Fed->{$world->Name}->Generate
	(%args);
    }
  }
  $self->LoadTemplates;
  if (exists $self->Templates->{$world->Name}) {
    # so run it
    $self->Generate;
  }
  # $self->CWW->GetTimeUnits;
  $self->Worlds->{$world->Name} = $world;
}

sub Generate {
  my ($self,%args) = @_;
  my $world = $self->CWW;
  # print Dumper($world);
  if (! exists $UNIVERSAL::verber->Config->CLIConfig->{'--check'}) {
    open(OUT,">".ConcatDir($world->MyCapsule->DomainFileFull)) or die "ouch";
    print OUT $self->SynthesizeDomain2;
    close(OUT);
    print "Domain printed to ".$world->MyCapsule->DomainFileFull."\n";

    open(OUT,">".ConcatDir($world->MyCapsule->ProblemFileFull)) or die "ouch";
    print OUT $self->SynthesizeProblem2;
    close(OUT);
    print "Problem printed to ".$world->MyCapsule->ProblemFileFull."\n";
  }
}

sub SynthesizeDomain {
  my ($self,%args) = @_;
  my $result = lisp_print
    (shift @{$self->LoadDomain2
	       (Name => $self->CWW->Name)});
  # $result =~ s/QQQMMM/\?/g;
  return $self->MyBeautifier->Beautify
    (Lisp => $result);
}

sub SynthesizeProblem {
  my ($self,%args) = @_;
  my $result = lisp_print
    (shift @{$self->LoadProblem2
	       (Name => $self->CWW->Name)});
  # $result =~ s/QQQMMM/\?/g;
  return $self->MyBeautifier->Beautify
    (Lisp => $result);
}

sub SynthesizeDomain2 {
  my ($self,%args) = @_;
  my $domain = $self->LoadDomain2
     (Name => $self->CWW->Name);
  my $lisppretty = $domain->Generate;
  return $domain->GenerateDescriptiveComments."\n\n".$lisppretty;
}

sub SynthesizeProblem2 {
  my ($self,%args) = @_;
  my $problem = $self->LoadProblem2
     (Name => $self->CWW->Name);
  my $lisppretty = $problem->Generate;
  return $problem->GenerateDescriptiveComments."\n\n".$lisppretty;
}

sub LoadDomain {
  my ($self,%args) = @_;
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
  my ($self,%args) = @_;
  my $name = lc($args{Name});
  return unless $name;

  my $filename = ConcatDir($self->TemplateDir,"/$name.p.".$self->Extension);
  if (! -e $filename or exists $UNIVERSAL::verber->Config->CLIConfig->{'--check'}) {
    $filename = ConcatDir($self->WorldDir,"/$name.p.".$self->Extension);
  }
  if (-e $filename) {
    my $contents = `cat $filename`;
    $contents =~ s/\?/QQQMMM/g;
    my $l1 = Parse($contents);
    foreach my $n2 (GetIncludes($contents)) {
      my $l2 = $self->LoadProblem(Name => $n2);
      $self->AddProblem(L1 => $l1,
			L2 => $l2);
    }
    if (! scalar @{$l1->[0]->[2]}) {
      push @{$l1->[0]->[2]}, Lisp::Symbol->new(uc($args{Name}));
    }
    return $l1;
  }
}

sub LoadDomain2 {
  my ($self,%args) = @_;
  my $name = lc($args{Name});
  return unless $name;
  my $filename = ConcatDir($self->TemplateDir,"/$name.d.".$self->Extension);
  if (! -e $filename or exists $UNIVERSAL::verber->Config->CLIConfig->{'--check'}) {
    $filename = ConcatDir($self->WorldDir,"/$name.d.".$self->Extension);
  }
  if (-e $filename) {
    my $contents = `cat "$filename"`;
    # $contents =~ s/\?/QQQMMM/g;
    my $domain1 = Verber::Ext::PDDL::Domain->new
      (
       Contents => $contents,
      );
    $domain1->Parse;
    foreach my $n2 (keys %{$domain1->Includes}) {
      my $domain2 = $self->LoadDomain2
	(Name => $n2);
      $domain2->Parse;
      $domain1->AddDomain
	(Domain => $domain2);
    }
    return $domain1;
  }
}

sub LoadProblem2 {
  my ($self,%args) = @_;
  my $name = lc($args{Name});
  return unless $name;
  my $filename = ConcatDir($self->TemplateDir,"/$name.p.".$self->Extension);
  if (! -e $filename or exists $UNIVERSAL::verber->Config->CLIConfig->{'--check'}) {
    $filename = ConcatDir($self->WorldDir,"/$name.p.".$self->Extension);
  }
  if (-e $filename) {
    my $contents = `cat "$filename"`;
    # $contents =~ s/\?/QQQMMM/g;
    my $problem1 = Verber::Ext::PDDL::Problem->new
      (
       Contents => $contents,
      );
    $problem1->Parse;
    foreach my $n2 (keys %{$problem1->Includes}) {
      my $problem2 = $self->LoadProblem2
	(Name => $n2);
      $problem2->Parse;
      $problem1->AddProblem
	(Problem => $problem2);
    }
    return $problem1;
  }
}

# need to fix this to handle pddl3 and generalized pddlX

sub AddProblem {
  my ($self,%args) = @_;
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
  my ($self,%args) = @_;
  # need to account for any changes to the current world model
}

sub Operations {
  # operations to be performed on the verber template domains:
  # new, fork, new-version, etc
  # in other words need to keep accurate meta-data
}

1;
