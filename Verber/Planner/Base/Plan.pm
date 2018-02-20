package Verber::Planner::Base::Plan;

use KBS2::ImportExport;
use MyFRDCSA;
use PerlLib::SwissArmyKnife;
use PerlLib::Util::File;
use Verber::Ext::PDDL::Domain;
use Verber::Manager::Step;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Planner SolutionFile TeeOutFile TeeErrFile PlanContents
   Trimmed Steps StartDate Units Points Times Actions InitialFacts
   MyImportExport /

  ];

sub init {
  my ($self,%args) = @_;
  $self->MyImportExport(KBS2::ImportExport->new);
  $self->Planner($args{Planner});

  my $plannername = $self->Planner->PlannerName;
  $self->SolutionFile
    (PerlLib::Util::File->new
     (Name => ConcatDir($self->Planner->MyCapsule->Dir,$self->Planner->MyCapsule->ProblemFile.".$plannername.sol")));
  $self->TeeOutFile
    (PerlLib::Util::File->new
     (Name => ConcatDir($self->Planner->MyCapsule->Dir,$self->Planner->MyCapsule->ProblemFile.".$plannername.stdout")));
  $self->TeeErrFile
    (PerlLib::Util::File->new
     (Name => ConcatDir($self->Planner->MyCapsule->Dir,$self->Planner->MyCapsule->ProblemFile.".$plannername.stderr")));

  $self->PlanContents($args{PlanContents});
  $self->Steps($args{Steps} || []);

  $self->StartDate($args{StartDate});
  $self->Units($args{Units});
}

sub Clean {
  my ($self,%args) = @_;
  $self->SolutionFile->Remove;
  $self->TeeOutFile->Remove;
  $self->TeeErrFile->Remove;
}

sub LoadFiles {
  my ($self,%args) = @_;
  $self->ProcessContents
    (Contents => $self->SolutionFile->Contents);
}

sub ProcessContents {
  my ($self,%args) = @_;
  if (! $args{Contents}) {
    print "No contents\n";
    return;
  }
  $self->PlanContents($args{Contents});
  my $contents = $self->PlanContents;
  $contents =~ s/;.*$//mg;
  $contents =~ s/\n{2,}//sg;
  $contents =~ s/^\n//s;
  $self->Trimmed($contents);
  # $contents =~ s/.*Time: \(ACTION\) \[action Duration; action Cost\]//sm;
  my @steps;
  my @lines = split /\n/, $contents;
  foreach my $line (@lines) {
    push @{$self->Steps}, Verber::Manager::Step->new
      (
       Plan => $self,
       StepContents => $line,
      );
  }

  # now process these steps into points
  my $actions = $self->LoadDomain(DomainFileContents => $self->Planner->MyCapsule->{DomainFileContents});
  my $initialfacts = $self->LoadProblem(ProblemFileContents => $self->Planner->MyCapsule->{ProblemFileContents});
  my $times = {};
  foreach my $i (0 .. (scalar @{$self->Steps} - 1)) {
    my $step = $self->Steps->[$i];
    $times->{sprintf("%f",$self->Steps->[$i]->{Time})}->{start}->{$i} = $step;
    $times->{sprintf("%f",($self->Steps->[$i]->{Time} + $self->Steps->[$i]->{Duration}))}->{end}->{$i} = $step;
  }
  my @points;
  my $lasttime = 0;
  foreach my $time (sort {$a <=> $b} keys %$times) {
    print "TIME: ".$time."\n";
    if (exists $times->{$time}->{start}) {
      push @points, {
		     Time => $time,
		     Type => "start",
		     Steps => $times->{$time}->{start},
		    };
    }
    if (exists $times->{$time}->{end}) {
      push @points, {
		     Time => $time,
		     Type => "end",
		     Steps => $times->{$time}->{end},
		    };
    }
  }
  $self->Actions($actions);
  $self->InitialFacts($initialfacts);
  $self->Times($times);
  $self->Points(\@points);
}

sub GetPreconditionsAndEffects {
  my ($self,%args) = @_;
  # given a time point, and whether it is start or end, return a list
  # of preconditions or effects (for all items there)
  my $actions = $self->Actions;
  my $time = $args{Time};
  my $type = $args{Type};
  print "time: $time\n";
  my $preconditions = {};
  my $effects = {};
  if ($type eq "end") {
    if (exists $self->Times->{$time}->{end}) {
      print "\tend\n";
      foreach my $key (keys %{$self->Times->{$time}->{end}}) {
	my $step = $plan->{Steps}->[$key];
	# process the action
	my $action = $self->ParseAction(Action => lc($step->{Action}));
	print "Action: ".$action->[0]."\n";
	if (! exists $actions->{$action->[0]}) {
	  warn "No action for action ".Dumper($action)."\n\n";
	} else {
	  # verify that the end conditions and effects are true
	  # print Dumper($action);
	  my $mapping = {};
	  my $i = 1;
	  # FIXME add a check for the proper number of arguments here
	  foreach my $var (@{$actions->{$action->[0]}->{Parameters}->{Order}}) {
	    $mapping->{$var} = $action->[$i++];
	  }
	  # print Dumper($mapping);
	  # now iterate over the condition "at ends" and verify they are true

	  if (exists $actions->{$action->[0]}->{Condition}->{end}) {
	    foreach my $condition (@{$actions->{$action->[0]}->{Condition}->{end}}) {
	      # verify this condition
	      my $theorem = $self->SubstituteMappingInFormula
		(
		 Mapping => $mapping,
		 Formula => $condition,
		)->[0];
	      $preconditions->{Dumper($theorem)} = $theorem;
	      # now what to do about this, what do we do if an at end condition of an action failed to be true
	    }
	  }
	  if (exists $actions->{$action->[0]}->{Effect}->{end}) {
	    foreach my $effect (@{$actions->{$action->[0]}->{Effect}->{end}}) {
	      # install these effects
	      my $theorem = $self->SubstituteMappingInFormula
		(
		 Mapping => $mapping,
		 Formula => $effect,
		)->[0];
	      # propagate effects
	      $effects->{Dumper($theorem)} = $theorem;
	    }
	  }
	}
      }
    }
  }
  #   if (exists $self->Times->{$time}->{all}) {
  #     print "\tall\n";
  #     foreach my $key (keys %{$self->Times->{$time}->{all}}) {
  #       my $step = $plan->{Steps}->[$key];
  #       # process the action
  #       my $action = $self->ParseAction(Action => lc($step->{Action}));
  #       print "Action: ".$action->[0]."\n";
  #       if (! exists $actions->{$action->[0]}) {
  #   	warn "No action for action ".Dumper($action)."\n\n";
  #       } else {
  #   	# verify that the all conditions and effects are true
  #   	# print Dumper($action);
  #   	my $mapping = {};
  #   	my $i = 1;
  #   	# FIXME add a check for the proper number of arguments here
  #   	foreach my $var (@{$actions->{$action->[0]}->{Parameters}->{Order}}) {
  #   	  $mapping->{$var} = $action->[$i++];
  #   	}
  #   	# print Dumper($mapping);
  #   	# now iterate over the condition "at alls" and verify they are true
  #   	if (exists $actions->{$action->[0]}->{Condition}->{all}) {
  #   	  foreach my $condition (@{$actions->{$action->[0]}->{Condition}->{all}}) {
  #   	    # verify this condition
  #   	    my $theorem = $self->SubstituteMappingInFormula
  #   	      (
  #   	       Mapping => $mapping,
  #   	       Formula => $condition,
  #   	      )->[0];
  # 	    $preconditions->{Dumper($theorem)} = $theorem;
  #   	    # now what to do about this, what do we do if an at all condition of an action failed to be true
  #   	  }
  #   	}
  #   	if (exists $actions->{$action->[0]}->{Effect}->{all}) {
  #   	  foreach my $effect (@{$actions->{$action->[0]}->{Effect}->{all}}) {
  #   	    # install these effects
  #   	    my $theorem = $self->SubstituteMappingInFormula
  #   	      (
  #   	       Mapping => $mapping,
  #   	       Formula => $effect,
  #   	      )->[0];
  #   	    # propagate effects
  # 	    $effects->{Dumper($theorem)} = $theorem;
  #   	  }
  #   	}
  #       }
  #     }
  #   }
  if ($type eq "start") {
    if (exists $self->Times->{$time}->{start}) {
      print "\tstart\n";
      foreach my $key (keys %{$self->Times->{$time}->{start}}) {
	my $step = $plan->{Steps}->[$key];
	# process the action
	my $action = $self->ParseAction(Action => lc($step->{Action}));
	print "Action: ".$action->[0]."\n";
	if (! exists $actions->{$action->[0]}) {
	  warn "No action for action ".Dumper($action)."\n\n";
	} else {
	  # verify that the start conditions and effects are true
	  # print Dumper($action);
	  my $mapping = {};
	  my $i = 1;
	  # FIXME add a check for the proper number of arguments here
	  foreach my $var (@{$actions->{$action->[0]}->{Parameters}->{Order}}) {
	    $mapping->{$var} = $action->[$i++];
	  }
	  # print Dumper($mapping);
	  # now iterate over the condition "at starts" and verify they are true
	  if (exists $actions->{$action->[0]}->{Condition}->{start}) {
	    foreach my $condition (@{$actions->{$action->[0]}->{Condition}->{start}}) {
	      # verify this condition
	      my $theorem = $self->SubstituteMappingInFormula
		(
		 Mapping => $mapping,
		 Formula => $condition,
		)->[0];
	      $preconditions->{Dumper($theorem)} = $theorem;
	      # now what to do about this, what do we do if an at start condition of an action failed to be true
	    }
	  }
	  if (exists $actions->{$action->[0]}->{Effect}->{start}) {
	    foreach my $effect (@{$actions->{$action->[0]}->{Effect}->{start}}) {
	      # install these effects
	      my $theorem = $self->SubstituteMappingInFormula
		(
		 Mapping => $mapping,
		 Formula => $effect,
		)->[0];
	      # propagate effects
	      $effects->{Dumper($theorem)} = $theorem;
	    }
	  }
	}
      }
    }
  }
  return
    {
     Preconditions => $preconditions,
     Effects => $effects,
    };
}

sub SubstituteMappingInFormula {
  my ($self,%args) = @_;
  my @res;
  my $ref = ref $args{Formula};
  if ($ref eq "ARRAY") {
    my @sub;
    foreach my $subformula (@{$args{Formula}}) {
      push @sub, @{$self->SubstituteMappingInFormula
	(
	 Mapping => $args{Mapping},
	 Formula => $subformula,
	)};
    }
    push @res, \@sub;
  } else {
    if (exists $args{Mapping}->{$args{Formula}}) {
      push @res, $args{Mapping}->{$args{Formula}};
    } else {
      push @res, $args{Formula};
    }
  }
  return \@res;
}

sub ParseAction {
  my ($self,%args) = @_;
  my $res = $self->MyImportExport->Convert
    (
     Input => $args{Action},
     InputType => "KIF String",
     OutputType => "Interlingua",
    );
  if ($res->{Success}) {
    return $res->{Output}->[0];
  } else {
    return [];
  }
}

sub LoadDomain {
  my ($self,%args) = @_;
  my $contents = $args{DomainFileContents};
  my $domain = Verber::Ext::PDDL::Domain->new
    (
     Contents => $contents,
    );
  $domain->Parse;
  my $data = $self->ExtractDurativeActions(Domain => $domain);
  return $data;
}

sub LoadProblem {
  my ($self,%args) = @_;
  my $contents = $args{ProblemFileContents};
  my $problem = Verber::Ext::PDDL::Problem->new
    (
     Contents => $contents,
    );
  $problem->Parse;
  my $data = $self->ExtractInitialFacts(Problem => $problem);
  return $data;
}

sub ExtractInitialFacts {
  my ($self,%args) = @_;
  my $problem = $args{Problem};
  my @facts;
  foreach my $key (keys %{$problem->{Inits}}) {
    my $value = $problem->{Inits}->{$key};
    if ($value->[0] ne "=") {
      if ($value->[0] eq "at") {
	if ($value->[1] =~ /^\d+$/) {
	  # a timed initial literal
	  # skip for now
	} else {
	  push @facts, $value;
	}
      } else {
	push @facts, $value;
      }
    }
  }
  return \@facts;
}

sub ExtractDurativeActions {
  my ($self,%args) = @_;
  my $data = {};
  my $domain = $args{Domain};
  foreach my $key (keys %{$domain->{DurativeActions}}) {
    my $value = $domain->{DurativeActions}->{$key};
    my $name = $value->[1];
    my $parameters;
    my $condition;
    my $effect;
    foreach my $i (0 .. (scalar @$value - 1)) {
      if ($value->[$i] eq ":parameters") {
	$parameters = $self->ProcessParameters(Parameters => $value->[$i + 1]);
      }
      if ($value->[$i] eq ":condition") {
	$condition = $self->ProcessCondition(Condition => $value->[$i + 1]);
      }
      if ($value->[$i] eq ":effect") {
	$effect = $self->ProcessEffect(Effect => $value->[$i + 1]);
      }
    }
    $data->{$name}->{Parameters} = $parameters;
    $data->{$name}->{Condition} = $condition;
    $data->{$name}->{Effect} = $effect;
  }
  return $data;
}

sub ProcessParameters {
  my ($self,%args) = @_;
  my $parameters = $args{Parameters};
  my $types = {};
  my @order;
  my @cache;
  my $i = 0;
  while ($i < scalar @$parameters) {
    my $item = $parameters->[$i];
    if ($item eq "-") {
      # take the collected objects and give them the following type
      my $type = $parameters->[$i + 1];
      foreach my $obj (@cache) {
	$types->{$obj} = $type;
      }
      push @order, @cache;
      @cache = ();
      $i = $i + 2;
    } else {
      push @cache, $item;
      ++$i;
    }
  }
  return {
	  Types => $types,
	  Order => \@order,
	 };
}

sub ProcessCondition {
  my ($self,%args) = @_;
  my $condition = $args{Condition};
  my $conditions = {};
  foreach my $i (1 .. (scalar @$condition - 1)) {
    if ($condition->[$i]->[0] eq "at" or $condition->[$i]->[0] eq "over") {
      if (! exists $conditions->{$condition->[$i]->[1]}) {
	$conditions->{$condition->[$i]->[1]} = [];
      }
      push @{$conditions->{$condition->[$i]->[1]}}, $condition->[$i]->[2];
    } else {
      print Dumper($condition->[$i]);
    }
  }
  return $conditions;
}

sub ProcessEffect {
  my ($self,%args) = @_;
  my $effect = $args{Effect};
  my $effects = {};
  foreach my $i (1 .. (scalar @$effect - 1)) {
    if ($effect->[$i]->[0] eq "at" or $effect->[$i]->[0] eq "over") {
      if (! exists $effects->{$effect->[$i]->[1]}) {
	$effects->{$effect->[$i]->[1]} = [];
      }
      if ($effect->[$i]->[2]->[0] eq "assign") {
	# push @{$effects->{$effect->[$i]->[1]}}, $effect->[$i]->[2];
	# handle this specially
      } else {
	push @{$effects->{$effect->[$i]->[1]}}, $effect->[$i]->[2];
      }
    } else {
      print Dumper($effect->[$i]);
    }
  }
  return $effects;
}

1;
