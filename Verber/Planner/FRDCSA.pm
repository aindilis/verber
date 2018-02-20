package Verber::Planner::FRDCSA;

use MyFRDCSA;
use PerlLib::SwissArmyKnife;
use SPSE2::Util;
use Verber::Planner::Base::Planner;
# use Verber::Planner::FRDCSA::Attempt1;

use Verber::Ext::PDDL::Domain;
use Verber::Ext::PDDL::Problem;

our @ISA = qw(Verber::Planner::Base::Planner);

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Seen Functions Predicates /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Verber::Planner::Base::Planner::init(%args);
  $self->Seen({});
  $self->Predicates({});
  $self->Functions({});
}

sub ExecutePlanner {
  my ($self,%args) = @_;
  # print Dumper($self->MyCapsule);
  my $domaincontents = read_file($self->MyCapsule->DomainFileFull);
  my $problemcontents = read_file($self->MyCapsule->ProblemFileFull);
  print Dumper({ProblemContents => $problemcontents});
  my $currentdomain = Verber::Ext::PDDL::Domain->new(Contents => $domaincontents);
  $currentdomain->Parse;
  my $currentproblem = Verber::Ext::PDDL::Problem->new(Contents => $problemcontents);
  $currentproblem->Parse;

  # what is the DOMAIN

  # TRANSLATE PDDL2.2 to FLORA-2

  # REQUIREMENTS
  my @requirements = ();
  foreach my $requirement (keys %{$currentdomain->Requirements}) {
    $requirement =~ s/^://sg;
    push @requirements, $self->Clean(Term => $requirement);
  }
  $self->FloraAssert(Assertion => $self->Clean(Term => $currentdomain->Domain).'[requirements -> {'.join(',',@requirements).'}]');

  # TYPES
  foreach my $subtype (keys %{$currentdomain->SubTypes}) {
    foreach my $supertype (keys %{$currentdomain->SubTypes->{$subtype}}) {
      $self->FloraAssert
	(Assertion => $self->Clean(Term => $subtype).'::'.$self->Clean(Term => $supertype). '.');
    }
  }

  # PREDICATES
  foreach my $predicatestring (keys %{$currentdomain->Predicates}) {
    my $list = $currentdomain->Predicates->{$predicatestring};
    my $res = $self->ProcessFunctionOrPredicate(List => $list);
    if ($res->{Success}) {
      $self->Predicates->{$res->{Result}{FunctionOrPredicate}} = $res->{Result};
      $self->FloraAssert
	(Assertion => $res->{Result}{Def}.":PredicatePrototype.");
    }
  }

  # FUNCTIONS
  foreach my $functionstring (keys %{$currentdomain->Functions}) {
    my $list = $currentdomain->Functions->{$functionstring};
    my $res = $self->ProcessFunctionOrPredicate(List => $list);
    if ($res->{Success}) {
      $self->Functions->{$res->{Result}{FunctionOrPredicate}} = $res->{Result};
      $self->FloraAssert
	(Assertion => $res->{Result}{Def}.":FunctionPrototype.");
    }
  }

  # DERIVED PREDICATES
  # FIXME: finish this

  # write_file_dumper
  #   (
  #    File => '/tmp/domain.txt',
  #    Data => $currentdomain,
  #   );

  # ACTIONS
  # FIXME: finish this

  # foreach my $action ($currentdomain->Actions) {
  # }

  # DURATIVEACTIONS
  # FIXME: finish this

  foreach my $durativeactionstring (keys %{$currentdomain->DurativeActions}) {
    my $da = {};
    my @list = @{$currentdomain->DurativeActions->{$durativeactionstring}};
    shift @list;
    $da->{DurativeAction} = shift @list;
    shift @list;
    my $res = $self->ProcessDeclarations(List => shift @list);
    if ($res->{Success}) {
      $da->{Data} = $res->{Result};
    } else {
      return $res;
    }
    shift @list;
    $da->{Durations} = shift @list;
    shift @list;
    $da->{Condition} = shift @list;
    shift @list;
    $da->{Effect} = shift @list;
    $self->ParseDurativeAction(DurativeAction => $da);
  }


  my $output = "";
  my $outputfilename = $self->CWPlan->SolutionFile->Name;
  print "<$outputfilename>\n";
  # write_file($outputfilename,$output);
  return "";
}

sub FloraAssert {
  my ($self, %args) = @_;
  print "Assertion: ".$args{Assertion}."\n";
}

sub ProcessFunctionOrPredicate {
  my ($self, %args) = @_;
  my @list = @{$args{List}};
  my $tmp = shift @list;
  my $functionorpredicate = $self->Clean(Term => $tmp);
  my $res = $self->ProcessDeclarations(List => \@list);
  if ($res->{Success}) {
    my @args = @{$res->{Result}{Args}};
    return
      {
       Success => 1,
       Result => {
		  Hash => $res->{Result}{Hash},
		  Def => $functionorpredicate.'('.join(',',@args).')',
		  FunctionOrPredicate => $functionorpredicate,
		  Order => $res->{Result}{Order},
		 },
      };
  } else {
    return $res;
  }
}

sub ProcessDeclarations {
  my ($self, %args) = @_;
  my @list = @{$args{List}};
  my @stash = ();
  my @args = ();
  my @order;
  my $s = {};
  while (@list) {
    if ($list[0] =~ /^\?/) {
      push @stash, shift @list;
    } elsif ($list[0] eq '-') {
      shift @list;
    } else {
      my $type = shift @list;
      foreach my $variable (@stash) {
	my $var = uc($self->Clean(Term => $variable));
	if (exists $s->{$var}) {
	  return
	    {
	     Success => 0,
	     Error => "Variable already exists: $var",
	    };
	}
	$s->{$var} = $self->Clean(Term => $type);
	push @order, $var;
	push @args, $var.':'.$s->{$var};
      }
      @stash = ();
    }
  }
  return
    {
     Success => 1,
     Result => {
		Args => \@args,
		Hash => $s,
		Order => \@order,
	       },
    };
}

sub Clean {
  my ($self, %args) = @_;
  my $item = ProcessName(Item => $args{Term});
  $item =~ s/-/_/sg;
  $self->Seen->{$args{Term}} = $item;
  return $item;
}

sub ParseDurativeAction {
  my ($self, %args) = @_;
  my $da = $args{DurativeAction};
  print Dumper($da);
  $self->ParseCondition(Condition => $da->{Condition});
}

# for some ideas on parsing the domain

# /var/lib/myfrdcsa/repositories/git/Prolog-Planning-Library

# /var/lib/myfrdcsas/versions/myfrdcsa-1.0/repositories/git/logtalk2/contributions/pddl_parser

# /var/lib/myfrdcsa/sandbox/prolog-pddl-3-0-parser-20140825

sub ParseCondition {
  my ($self, %args) = @_;
  my $condition = $args{Condition};
  if (! scalar @$condition) {
  } else {
    my $lead = shift @$condition;
    if ($lead =~ /^and$/i) {

    }
  }
}

1;


