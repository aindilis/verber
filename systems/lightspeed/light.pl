#!/usr/bin/perl -w

# BE THE MASTER OF YOURSELF

# basically, the system accomplishes,  in whatever ways necessary what
# is  intended to  be  performed by  the "domain.lisp"  file.

use Data::Dumper;

my $debug = 0;

my $domain;
my $tasks = {};
my $actions = {};
my $task2action = {};
my $events = {};

$domainfile = "/home/mburch/lightspeed/domain.lisp";

sub SaveDomain {
  SaveDataToFile(File => $domainfile,
		 Data => $domain);
}

sub LoadDomain {
  LoadDataFromFile(File => $domainfile,
		   Data => $domain);
}

sub SaveDataToFile {
  my (%args) = (@_);
  my $OUT;
  open (OUT, ">$args{File}")  or die "ouch\n";
  print OUT Dumper($args{Data});
  close (OUT);
}

sub LoadDataFromFile {
  my (%args) = (@_);
  my $c = `cat "$args{File}"`;
  $args{Data} = eval $c;
}

sub PrintDomain {
  print Dumper($domain);
}

sub ProcessInput {

}

sub WalkThrough {
  # program to walk through constraints
}

sub ShowCurrentDomain {

}

sub ReportEvent {

}

sub InOrderTraverseDomain {
  my @q = ();
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
  my (%args) = (@_);
  my $domainfile = $args{DomainFile};
  my $c = `cat "$domainfile"`;
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
  my (%args) = (@_);
  my $structure = $args{Structure};
  my @res = ();
  foreach my $x (@$structure) {
    if (ref $x eq "ARRAY") {
      push @res, Generate(Structure => $x);
    } else {
      push @res, $x;
    }
  }
  return "(". join(" ",@res).")";
}

sub HasArray {
  my $s = shift;
  my $ha = 0;
  foreach my $x (@$s) {
    if (ref $x eq "ARRAY") {
      $ha = 1;
    }
  }
  return $ha;
}

sub PrettyGenerate {
  my (%args) = (@_);
  my $structure = $args{Structure};
  $args{Indent} = $args{Indent} || 0;
  my $indentation = (" " x $args{Indent});
  my $retval = "$indentation(";
  my $total = scalar @$structure;
  my $cnt = 0;
  foreach my $x (@$structure) {
    ++$cnt;
    if (ref $x eq "ARRAY") {
      my $c = PrettyGenerate(Structure => $x,
			     Indent => $args{Indent} + 1);
      $retval .= "\n$c";
      # $retval .= "\n" unless $cnt == $total;
    } else {
      $retval .= "$x";
      $retval .= " " unless $cnt == $total;
    }
  }
  $retval .= ")";
  return $retval;
}

sub ExportCurrentDomain {

}

sub ExportCurrentWorldModel {

}

sub LoadCurrentWorldModel {

}

sub SaveCurrentWorldModel {

}

sub DeclareTask {
  my (%args) = (@_);
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
    if (! exists $actions->{$action}) {
      print "Declaring action: $action\n" if $debug;
      $actions->{$action} = 1;
      $task2action->{$action} = {};
    }

    my $taskdescription = join(" ",@s);
    if (! exists $tasks->{$taskdescription}) {
      print "Declaring task: $taskdescription\n" if $debug;
      $tasks->{$taskdescription} = $task;
      $task2action->{$task->[1]}->{$taskdescription} = 1;
    }
  } else {
    print "Declaring complex task: ".$task->[1]."\n" if $debug;
  }
}

sub DeclareEvent {
  my (%args) = (@_);
  my $event = $args{Event};
  if (ref $event eq "ARRAY") {
    $name = Generate(Structure => $event->[1]);
  } else {
    $name = $event->[1];
  }
  print "Declaring event: $name\n" if $debug;
  $events->{$name} = $event;
}

sub Clean {
  my $t = shift;
  $t =~ s/\n//g;
  return $t;
}

sub Choose {
  my (%args) = (@_);
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
      $ret = Clean($ret);
    }
    # print Dumper($args{Options}->[$ret]);
    return $args{Options}->[$ret];
  }
}

sub PrepareForEvent {
  my @o = sort keys %$events;
  return Choose(Message => "Have any of these events occurred?",
		Options => \@o);
}

sub PrintEvent {
  my $event = shift;
  print PrettyGenerate
    (Structure => $events->{$event}).
      "\n";
}

sub PerformTaskList {
  my $event = shift;
  print Dumper($event);
  PrintEvent($event);
}

sub Loop {
  # have the user  select whether a given set  of events has occurred,
  # load the event processor
  while (1) {
    my $event = PrepareForEvent();
    print "<<<$event>>>\n";
    print Dumper($event);

    PerformTaskList($event);
  }
}

sub EvalDomain {
  my (%args) = (@_);
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
	DeclareTask(Task => $x);
	push @tasks, $x;
      }
      if ($x->[0] eq "event") {
	DeclareEvent(Event => $x);
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
  ParseDomainFile
    (DomainFile => $domainfile);
  # print PrettyGenerate(Structure => $domain)."\n";
  EvalDomain(Domain => $domain);
  Loop;
}

Light;
