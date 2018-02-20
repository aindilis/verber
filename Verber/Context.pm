package Verber::Context;

use MyFRDCSA;
use PerlLib::SwissArmyKnife;
use Verber::Ext::PDDL::Domain;
use Verber::Ext::PDDL::Problem;
use Verber::FedManager;
use Verber::World;
use Verber::Util::Beautifier;

use Data::Dumper;
use Lisp::Printer qw (lisp_print);
use Lisp::Reader qw (lisp_read);
use Lisp::Symbol;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Worlds ContextDir WorldDir TemplateDir PrototypeDir Templates CWW Extension
	TemplateExtension MyBeautifier MyFedManager /

  ];

sub init {
  my ($self,%args) = @_;
  print "Initializing Context" if $UNIVERSAL::verber->Debug;
  $self->Extension($args{Extension} || "pddl");
  $self->TemplateExtension($args{Extension} || "verb");
  $self->Worlds($args{Worlds} || {});
  $self->ContextDir($args{ContextDir} || $UNIVERSAL::systemdir."/data/worldmodel");
  $self->WorldDir
    ($args{WorldDir} ||
     ConcatDir($self->ContextDir,"worlds"));
  $self->TemplateDir
    ($args{TemplateDir} ||
     ConcatDir($self->ContextDir,"templates"));
  $self->PrototypeDir
    ($args{PrototypeDir} ||
     ConcatDir($self->ContextDir,"prototypes"));
  $self->MyBeautifier
    (Verber::Util::Beautifier->new);
  print "Fed Manager started.\n" if $UNIVERSAL::verber->Debug;
  $self->MyFedManager
    (Verber::FedManager->new);
  print "Fed Manager completed.\n" if $UNIVERSAL::verber->Debug >= 2;
}

sub LoadTemplates {
  my ($self,%args) = @_;
  my $c1 = "ls ".$self->TemplateDir;
  my $templates = {};
  my $extension = $self->TemplateExtension;
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
     ContextDir => $self->ContextDir,
     WorldDir => $self->WorldDir,
     TemplateDir => $self->TemplateDir,
     PrototypeDir => $self->PrototypeDir,
     Extension => $self->Extension,
     TemplateExtension => $self->TemplateExtension,
    );
  $self->CWW($world);
  $self->Worlds->{$world->Name} = $world;
  $self->LoadTemplates;
  $self->Generate(%args);
}

sub Generate {
  my ($self,%args) = @_;
  print "Generating Context\n" if $UNIVERSAL::verber->Debug;
  if (! exists $args{SkipTemplates}) {
    if (exists $args{Timing}) {
      if (exists $args{Timing}{StartDateString}) {
	$args{Timing}{StartDate} = $UNIVERSAL::verber->MyResources->DateManip->GetDateTimeFromString
	  (
	   String => $args{Timing}{StartDateString},
	  );
      }
      if (exists $args{Timing}{EndDateString}) {
	$args{Timing}{EndDate} = $UNIVERSAL::verber->MyResources->DateManip->GetDateTimeFromString
	  (
	   String => $args{Timing}{EndDateString},
	  );
	$args{Timing}{Duration} = $args{Timing}{EndDate} - $args{Timing}{StartDate};
      } elsif (exists $args{Timing}{DurationHash}) {
	my $durhash = $args{Timing}{DurationHash};
	$args{Timing}{Duration} = DateTime::Duration ->new
	  (
	   years => exists $durhash->{Years} ? $durhash->{Years} : 1,
	   months => exists $durhash->{Months} ? $durhash->{Months} : 0,
	   days => exists $durhash->{Days} ? $durhash->{Days} : 0,
	   hours => exists $durhash->{Hours} ? $durhash->{Hours} : 0,
	   minutes => exists $durhash->{Minutes} ? $durhash->{Minutes} : 0,
	   seconds => exists $durhash->{Seconds} ? $durhash->{Seconds} : 0,
	  );
	$args{Timing}{EndDate} = $args{Timing}{StartDate} + $args{Timing}{Duration};
      }
    }
    print SeeDumper(\%args) if $UNIVERSAL::verber->Debug >= 3;
    $self->LoadDomain
      (
       %args,
      );
    $self->LoadProblem
      (
       %args,
      );
  }
  # FIXME: add an elsif to handle if the world domain/problem files don't exist
}

sub LoadDomain {
  my ($self,%args) = @_;
  my $name = lc($args{Name});
  return unless $name;
  print $args{Indent}."Loading included domain: ".$name."\n";
  my $nametr = $name;
  $nametr =~ tr/_/\//;
  $args{TemplateFilename} = ConcatDir($self->TemplateDir,"/$nametr.d.".$self->TemplateExtension);;
  $args{TemplateFilenamePDDL} = ConcatDir($self->TemplateDir,"/$nametr.d.".$self->Extension);;

  print "1\n";
  # FIXME: handle conversion of units at some point in time
  my $filename;
  print "2\n";
  if (! exists $args{SkipFederated}) {
    print "2a\n";
    if (exists $self->MyFedManager->Name2Fed->{$name}) {
      print "2aA\n";
      print SeeDumper(\%args) if $UNIVERSAL::verber->Debug >= 3;
      print SeeDumper({Andy => $self->MyFedManager->Name2Fed->{$name}})
	if $UNIVERSAL::verber->Debug >= 3;
      my $domain = $self->MyFedManager->Name2Fed->{$name}->GenerateDomainPrototype(%args);
      print "2aB\n";
      print SeeDumper({Andywhey => $domain}) if $UNIVERSAL::verber->Debug >= 3;

      $filename = $self->Write
	(
	 Name => $args{Name},
	 Domain => $domain,
	 Type => 'Prototype',
	 Indent => $args{Indent}."\t",
	);
      print "2aC\n";
    }
    print "2b\n";
  }
  print "3\n";
  if (! defined $filename) {
    print "Filename not defined, using TemplateFilename\n" if $UNIVERSAL::verber->Debug;
    $filename = -f $args{TemplateFilename} ? $args{TemplateFilename} : $args{TemplateFilenamePDDL};
  }
  print "4\n";
  print "FilenameDomain: $filename\n";
  my $contents = "";
  if (-e $filename) {
    $contents = read_file($filename);
  }

  my $domain = Verber::Ext::PDDL::Domain->new
    (
     Contents => "",
    );
  my $currentdomain = Verber::Ext::PDDL::Domain->new
    (
     Contents => $contents,
    );
  print "4a\n";
  $currentdomain->Parse();
  # note that the order of inclusion is important
  foreach my $n2 (@{$currentdomain->IncludesOrder}) {
    my %args2 = %args;
    delete $args2{Name};
    delete $args2{Indent};
    my $subdomain = $self->LoadDomain
      (
       Name => $n2,
       Indent => $args{Indent}."\t",
       %args2,
      );
    if (defined $subdomain) {
      $subdomain->Parse;
      $domain->AddDomain
	(
	 Subdomain => $subdomain,
	 %args,
	);
    }
  }
  print "4b\n";
  $domain->AddDomain
    (
     Subdomain => $currentdomain,
     Current => 1,
     %args,
    );
  if (! exists $args{SkipFederated}) {
    if (exists $self->MyFedManager->Name2Fed->{$name}) {
      my $ref = ref($self->MyFedManager->Name2Fed->{$name});
      print $args{Indent}."Performing Federated Planning on <$name> of <$ref>\n";
      $self->MyFedManager->Name2Fed->{$name}->GenerateDomain
	(
	 Domain => $domain,
	 %args,
	);
    }
  }
  print "4c\n";
  $self->Write
    (
     Name => $args{Name},
     Domain => $domain,
     Type => 'World',
     Indent => $args{Indent}."\t",
    );
  print "4d\n";
  return $domain;
}

sub LoadProblem {
  my ($self,%args) = @_;
  my $name = lc($args{Name});
  return unless $name;
  print $args{Indent}."Loading included problem: ".$name."\n";
  my $nametr = $name;
  $nametr =~ tr/_/\//;
  print "1\n";

  $args{TemplateFilename} = ConcatDir($self->TemplateDir,"/$nametr.p.".$self->TemplateExtension);;
  $args{TemplateFilenamePDDL} = ConcatDir($self->TemplateDir,"/$nametr.p.".$self->Extension);;

  # FIXME: handle conversion of startdate and units at some point in time

  my $filename;
  print "2\n";
  if (! exists $args{SkipFederated}) {
    print SeeDumper([keys %{$self->MyFedManager->Name2Fed}]) if $UNIVERSAL::verber->Debug >= 2;
    if (exists $self->MyFedManager->Name2Fed->{$name}) {
      print "3\n";
      $filename = $self->Write
	(
	 Name => $args{Name},
	 Problem => $self->MyFedManager->Name2Fed->{$name}->GenerateProblemPrototype(%args),
	 Type => 'Prototype',
	 Indent => $args{Indent}."\t",
	);
    }
  }
  print "4\n";
  if (! defined $filename) {
    $filename = -f $args{TemplateFilename} ? $args{TemplateFilename} : $args{TemplateFilenamePDDL};
  }
  print "FilenameProblem: $filename\n";
  my $contents = "";
  if (-e $filename) {
    $contents = read_file($filename);
  }

  my $problem = Verber::Ext::PDDL::Problem->new
    (
     Contents => "",
    );
  print "6\n";
  my $currentproblem = Verber::Ext::PDDL::Problem->new
    (
     Contents => $contents,
    );
  print "7\n";
  $currentproblem->Parse();
  print "8\n";
  # note that the order of inclusion is important
  foreach my $n2 (@{$currentproblem->IncludesOrder}) {
    my %args2 = %args;
    delete $args2{Name};
    delete $args2{Indent};
    my $subproblem = $self->LoadProblem
      (
       Name => $n2,
       Indent => $args{Indent}."\t",
       %args2,
      );
    if (defined $subproblem) {
      $subproblem->Parse;
      $problem->AddProblem
	(
	 Subproblem => $subproblem,
	 %args,
	);
    }
  }
  print "9\n";
  $problem->AddProblem
    (
     Subproblem => $currentproblem,
     Current => 1,
     %args,
    );
  $self->CWW->StartDate($currentproblem->StartDate);
  $self->CWW->Units($currentproblem->Units);

  print "10\n";
  if (! exists $args{SkipFederated}) {
    if (exists $self->MyFedManager->Name2Fed->{$name}) {
      my $ref = ref($self->MyFedManager->Name2Fed->{$name});
      print $args{Indent}."Performing Federated Planning on <$name> of <$ref>\n";
      $self->MyFedManager->Name2Fed->{$name}->GenerateProblem
	(
	 Problem => $problem,
	 %args,
	);
    }
  }
  $self->Write
    (
     Name => $args{Name},
     Problem => $problem,
     Type => 'World',
     Indent => $args{Indent}."\t",
    );
  return $problem;
}

sub Write {
  my ($self,%args) = @_;
  my ($item,$type,$initial,$extension);
  print "1\n";
  if ($args{Domain}) {
    $item = $args{Domain};
    $type = 'Domain';
    $initial = 'd';
  } elsif ($args{Problem}) {
    $item = $args{Problem};
    $type = 'Problem';
    $initial = 'p';
  } else {
    die "no domain or problem specified";
  }
  print "2\n";
  my $dir;
  if ($args{Type} eq 'World') {
    $dir = $self->CWW->MyCapsule->Dir;
    $extension = "pddl";
  } elsif ($args{Type} eq 'Prototype') {
    $dir = $self->CWW->MyCapsule->PrototypeDir;
    $extension = "verb";
  } else {
    die "Error 1\n";
  }
  print "3\n";
  my $lisppretty = $item->Generate(Output => $extension);
  my $text = $item->GenerateDescriptiveComments."\n\n".$lisppretty;
  my $nametr = lc($args{Name});
  print "4\n";
  $nametr =~ tr/_/\//;
  print "5\n";
  my $outfile = ConcatDir($dir,$nametr.'.'.$initial.'.'.$extension);
  print "$outfile\n";
  system 'mkdir -p '.shell_quote(dirname($outfile));
  print "Writing $outfile\n" if $UNIVERSAL::verber->Debug;
  open(OUT,">".$outfile) or die "ouch: $outfile";
  print OUT $text;
  close(OUT);
  print $args{Indent}."$type printed to <$outfile>\n";
  return $outfile;
}

# need to fix this to handle pddl3 and generalized pddlX

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
