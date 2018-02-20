package Verber::Util::Light;

# BE THE MASTER OF YOURSELF
# basically, the system accomplishes,  in whatever ways necessary what
# is  intended to  be  performed by  the "domain.lisp"  file.

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Actions Debug Domainfile Events Task2Action Tasks /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Events({});
  $self->Actions({});
  $self->Task2Action({});
  $self->Domainfile
    ($args{DomainFile});
  $self->Tasks({});
  # $self->Debug($UNIVERSAL::verber->Debug || 0);
}

sub Execute {
  my ($self,%args) = @_;
  $self->Light;
}

sub SaveDomain {
  my ($self) = @_;
  $self->SaveDataToFile(File => $self->Domainfile,
			Data => $domain);
}

sub LoadDomain {
  my ($self) = @_;
  $self->LoadDataFromFile(File => $self->Domainfile,
			  Data => $domain);
}

sub LoadDataFromFile {
  my ($self,%args) = @_;
  my $c = `cat "$args{File}"`;
  $args{Data} = eval $c;
}

sub PrintDomain {
  my ($self) = @_;
  print Dumper($domain);
}

sub ProcessInput {
  my ($self) = @_;

}

sub WalkThrough {
  my ($self) = @_;
  # program to walk through constraints
}

sub ShowCurrentDomain {
  my ($self) = @_;

}

sub ReportEvent {
  my ($self) = @_;

}

sub InOrderTraverseDomain {
  my ($self,@q) = @_;
  my @l = ();
  my @tasks = ();
  push @q, @$domain;
  while (@q) {
    my $x = shift @q;
    if (ref $x eq "ARRAY") {
      if ($x->[0] eq "task") {
	push @tasks, $x;
      }
      unshift @q, @$x;
    } else {
      push @l, $x;
    }
  }
  print Dumper([@tasks]);
}

sub ParseDomainFile {
  my ($self,%args) = @_;
  $self->Domainfile($args{DomainFile});
  $f = $self->Domainfile;
  my $c = `cat "$f"`;
  $self->Parse
    (Contents => $c);
}

sub Parse {
  my ($self,%args) = @_;
  my $c = $args{Contents};
  $c =~ s/;.*//mg;
  my $tokens = [split //,$c];
  my $cnt = 0;
  my $stack = [];
  my $symbol = "";
  do {
    $char = shift @$tokens;
    if ($char =~ /\(/) {
      ++$cnt;
      $stack->[$cnt] = [];
      $symbol = "";
    } elsif ($char =~ /[\s\n]/) {
      if (length $symbol) {
	push @{$stack->[$cnt]},$symbol;
	$symbol = "";
      }
    } elsif ($char =~ /\)/) {
      # now $stack->[$cnt] holds all of  our objects, and so just have
      # to move those into the right place
      if (length $symbol) {
	push @{$stack->[$cnt]},$symbol;
	$symbol = "";
      }
      my @a = @{$stack->[$cnt]};
      $stack->[$cnt] = undef;
      --$cnt;
      push @{$stack->[$cnt]}, \@a;
    } else {
      if ($char !~ /\s/) {
	$symbol .= $char;
      }
    }
  } while (@$tokens);
  $domain = $stack->[0];
}

sub Generate {
  my ($self,%args) = @_;
  my $structure = $args{Structure};
  my @res = ();
  foreach my $x (@$structure) {
    if (ref $x eq "ARRAY") {
      push @res, $self->Generate(Structure => $x);
    } else {
      push @res, $x;
    }
  }
  return "(". join(" ",@res).")";
}

sub HasArray {
  my ($self,$s) = @_;
  my $ha = 0;
  foreach my $x (@$s) {
    if (ref $x eq "ARRAY") {
      $ha = 1;
    }
  }
  return $ha;
}

sub PrettyGenerate {
  my ($self,%args) = @_;
  my $structure = $args{Structure};
  $args{Indent} = $args{Indent} || 0;
  my $indentation = (" " x $args{Indent});
  my $retval = "$indentation(";
  my $total = scalar @$structure;
  my $cnt = 0;
  foreach my $x (@$structure) {
    ++$cnt;
    if (ref $x eq "ARRAY") {
      if ($args{NoNewLines} or $self->NoNewLines($structure->[0])) {
	my $c = $self->PrettyGenerate
	  (
	   Structure => $x,
	   Indent => 0,
	   NoNewLines => 1,
	  );
	$retval .= " $c";
      } else {
	my $c = $self->PrettyGenerate
	  (
	   Structure => $x,
	   Indent => $args{Indent} + 1,
	  );
	$retval .= "\n$c";
      }
      # $retval .= "\n" unless $cnt == $total;
    } else {
      $retval .= " " if $cnt > 1;
      $retval .= "$x";
      # $retval .= " " unless $cnt == $total;
    }
  }
  $retval .= ")";
  return $retval;
}

sub ExportCurrentDomain {
  my ($self) = @_;

}

sub ExportCurrentWorldModel {
  my ($self) = @_;

}

sub LoadCurrentWorldModel {
  my ($self) = @_;

}

sub SaveCurrentWorldModel {
  my ($self) = @_;

}

sub DeclareTask {
  my ($self,%args) = @_;
  my $task = $args{Task};
  # check that its not a complex task
  my $complex = 0;
  foreach my $e (@$task) {
    if (ref $e eq "ARRAY") {
      $complex = 1;
    }
  }

  if (! $complex) {
    my @s = @$task;
    shift @s;
    my $action = $task->[1];
    if (! exists $self->Actions->{$action}) {
      print "Declaring action: $action\n" if $self->Debug;
      $self->Actions->{$action} = 1;
      $self->Task2Action->{$action} = {};
    }

    my $taskdescription = join(" ",@s);
    if (! exists $self->Tasks->{$taskdescription}) {
      print "Declaring task: $taskdescription\n" if $self->Debug;
      $self->Tasks->{$taskdescription} = $task;
      $self->Task2Action->{$task->[1]}->{$taskdescription} = 1;
    }
  } else {
    print "Declaring complex task: ".$task->[1]."\n" if $self->Debug;
  }
}

sub DeclareEvent {
  my ($self,%args) = @_;
  my $event = $args{Event};
  if (ref $event eq "ARRAY") {
    $name = $self->Generate(Structure => $event->[1]);
  } else {
    $name = $event->[1];
  }
  print "Declaring event: $name\n" if $self->Debug;
  $self->Events->{$name} = $event;
}

sub Clean {
  my ($self,$t) = @_;
  $t =~ s/\n//g;
  return $t;
}

sub Choose {
  my ($self,%args) = @_;
  if ($args{Options}) {
    if ($args{Message}) {
      print $args{Message}."\n";
    }
    my $i = 0;
    foreach my $o (@{$args{Options}}) {
      print $i++.") $o\n";
    }
    my $ret = "";
    while ($ret !~ /^([0-9]+|q)$/) {
      $ret = <STDIN>;
      $ret = $self->Clean($ret);
    }
    # print Dumper($args{Options}->[$ret]);
    return $args{Options}->[$ret];
  }
}

sub PrepareForEvent {
  my ($self,@o) = @_;
  return $self->Choose(Message => "Have any of these events occurred?",
		       Options => \@o);
}

sub PrintEvent {
  my ($self,$event) = @_;
  print $self->PrettyGenerate
    (Structure => $self->Events->{$event}).
      "\n";
}

sub PerformTaskList {
  my ($self,$event) = @_;
  print Dumper($event);
  # at this point want to walk through
  $self->PrintEvent($event);
}

sub Loop {
  my ($self) = @_;
  # have the user  select whether a given set  of events has occurred,
  # load the event processor
  while (1) {
    my $event = $self->PrepareForEvent();
    $self->PerformTaskList($event);
  }
}

sub EvalDomain {
  my ($self,%args) = @_;
  my $dm = $args{Domain};
  my @q = ();
  my @l = ();
  my @tasks = ();
  my @events = ();
  push @q, @$dm;
  while (@q) {
    my $x = shift @q;
    if (ref $x eq "ARRAY" and scalar @$x) {
      if ($x->[0] eq "task") {
	$self->DeclareTask(Task => $x);
	push @tasks, $x;
      }
      if ($x->[0] eq "event") {
	$self->DeclareEvent(Event => $x);
	push @events, $x;
      }
      unshift @q, @$x;
    } else {
      push @l, $x;
    }
  }
  # print Dumper([@tasks]);
}

sub Light {
  my ($self) = @_;
  $self->ParseDomainFile
    (DomainFile => $self->Domainfile);
  # print $self->PrettyGenerate(Structure => $domain)."\n";
  $self->EvalDomain
    (Domain => $domain);
  $self->Loop;
}

sub NoNewLines {
  my ($self,$pred) = @_;
  if (ref $pred eq "") {
    return $pred =~ /^(at|=)$/;
  }
}

1;
