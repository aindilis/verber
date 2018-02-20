package Verber::Manager;

use BOSS::Config;
use Manager::Dialog qw (Message QueryUser ApproveCommands Verify);
use Verber::Manager::Plan;
use Verber::Manager::SubProcess;
use MyFRDCSA;
use PerlLib::Collection;

use Data::Dumper;
use Event qw(loop unloop all_watchers);
use Math::Units::PhysicalValue qw(PV);
# use Speech::Synthesiser;
use Term::ReadKey;
use Time::Local;

# system responsible for walking user through plans

# should definitely read work on existing system that replan here

# eventually this whole  thing out to be turned  into a little wrapper
# over the plan  itself with executable actions, so  that it plans the
# plan interface!

# make that a future version

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / World MyPlan ConversionFactors Completed Input Synth MySubProcess /

  ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->World($args{World});
  $self->MySubProcess
    (Verber::Manager::SubProcess->new);
  $self->Completed([]);
}

sub MonitorPlan {
  my ($self,%args) = (shift,@_);
  $self->MyPlan($args{Plan});
  $self->StartExecutionMonitor;
}

sub StartExecutionMonitor {
  my ($self,%args) = (shift,@_);
  my $i = 0;
  my $abort = 0;
  while (! $abort and $i < scalar @{$self->MyPlan->Steps}) {
    $abort = 1 unless $self->GuideStep($i++);
  }
  # if plan succeeded or was intermittently aborted, now we must clean
  # up the world model
  if ($self->AskUser(Message => "Did all steps succeed?")) {
    # $self->Update;
  }
}

sub GuideStep {
  my ($self,$stepnum) = (shift,shift);
  # for now use a simple model of a plan

  # each plan step will simply be read to the user, to confirm that
  # she completes this plan, it will use duration as a rough estimate
  # it will also store the actual duration between events in order to
  # accurately model these transitions

  my $totalsteps = scalar @{$self->MyPlan->Steps};
  if ($stepnum >= 0 and $stepnum < $totalsteps) {
    print "<<$stepnum>>\n";
    my $planstep = $self->MyPlan->Steps->[$stepnum];

    # start nonblocking functions if any
    if ($self->MySubProcess->MatchFunctions
	(PlanStep => $planstep,
	 Type => "nonblocking")) {
      $self->MySubProcess->ExecuteFunctions
	(PlanStep => $planstep,
	 Type => "nonblocking");
    }

    # start blocking functions if any, otherwise must be user step
    if ($self->MySubProcess->MatchFunctions
	(Type => "blocking",
	 PlanStep => $planstep)) {
      $self->MySubProcess->ExecuteFunctions
	(Type => "blocking",
	 PlanStep => $planstep);
      # when done, push the planstep completed
      push @{$self->Completed}, $planstep;
      return 1;
    } else {
      # determine whether it is an automatic plan step or not
      if ($self->TellUser(Message => "Next plan step: ".$planstep->Action,
			  Confirm => 1,
			  TimeOut => PV "60s")) {
	# $self->MyWorldModel->Update
	# (Steps => [$planstep]);
	my $answer = $self->ConfirmStepSuccess
	  (Duration => $planstep->Duration);
	if (defined $answer and exists  $answer->{Status} and $answer->{Status} eq "success") {
	  if ($answer->{Reply} =~ /done|skipped/) {
	    # if the user reports the plan step has succeeded, push in onto
	    # the world model update stack, don't update the model until the
	    # user confirms that everything went according to plan.  In that
	    # case tell Cyc to update the model.
	    if ($answer->{Reply} eq "done") {
	      push @{$self->Completed}, $planstep;
	      # $self->MyWorldModel->Update
	      # (Steps => [$planstep]);
	    }
	    return 1;
	  } elsif ($answer->{Reply} =~ /aborted/) {
	    # if  the  user  aborts,  interactively determine  exactly  what
	    # changes were made to the environment, update these, then allow
	    # for new plans.  This is primitive replanning.
	  }
	} elsif ($answer->{Status} eq "timeout") {
	  Message(Message => "ConfirmActionSuccess timed out");
	}
      }
    }
  }
}

sub ConfirmStepSuccess {
  my ($self,%args) = (shift,@_);

  my $totaltimeelapsed = "0 s";
  my $timeremaining = $args{Duration};
  my $timeout = 1.5 * $timeremaining;
  my $fudgeduration;

  # now wait an appropriate ammount of time, listening in case the
  # user should report that the step has completed, or ask to
  # abandon the current plan, etc
  my $update = {};
  my $answer;
  do {
    $fudgeduration = $self->FudgeDuration(Duration => $timeremaining);
    # now we want to let the user

    $self->TellUser
      (Message => "Estimated Time Remaining: $timeremaining");
    $update = $self->GetUpdate
      (TimeOut => $fudgeduration);
    if ($update) {
      $answer->{Status} = "success";
      $answer->{Reply} = $update;
    } else {
      $answer = $self->AskUser(Message => "Has step completed?")
    }
    $timeremaining = $timeremaining - $fudgeduration unless
      ($timeremaining - $fudgeduration < (PV "60s"));
    # need to handle time universally from now on
    $totaltimeelapsed += $fudgeduration;
  } while (! ($update or $answer->{Status} eq "success") and
	   ($totaltimeelapsed < $timeout));
  if ($totaltimeelapsed > $timeout) {
    $answer->{Status} = "timeout";
  }
  return $answer;
}

sub FudgeDuration {
  my ($self,%args) = (shift,@_);
  return $args{Duration} * 0.9;
}

sub TellUser {
  my ($self,%args) = (shift,@_);
  my $feedback;
  # $self->Synth->speak($args{Message});
  Message(Message => $args{Message});
  system "echo \"(Parameter.set 'Duration_Stretch 0.5) ".
    "(SayText \\\"$args{Message}\\\")\" | festival --pipe /etc/clear/fest.conf";
  if ($args{Confirm}) {
    $feedback = $self->Confirm(TimeOut => $args{TimeOut} || (PV "10s"));
    return unless $feedback;
  }
  # check that feedback is not a request for a delay
  # now tell the user through the normal method, for now, just print it to the screen
  return $feedback || 1;
}

sub Confirm {
  my ($self,%args) = (shift,@_);
  my $repeatrate = $args{RepeatRate} || (PV "5s");

  $self->TellUser(Message => $args{Message} || "Do you confirm?");

  my $feedback;
  my $i = PV "0s";
  do {
    $feedback = $self->GetUpdate(TimeOut => $repeatrate);
    $i += $repeatrate;
    if ($feedback) {
      if ($feedback !~ /^((y(es)?)|(n)o?)$/i) {
	Message(Message => "Must reply with yes or no");
      }
    }
  } while (! defined $feedback or
	   $feedback !~ /^((y(es)?)|(n)o?)$/i and
	   ($i < ($args{TimeOut} || (PV "30s"))));
  return $feedback;
}

sub AskUser {
  my ($self,%args) = (shift,@_);
  my $update = {};
  if ($self->TellUser(Message => $args{Message},
	      Confirm => 1)) {
    $update->{Status} = "success";
    $update->{Reply} = "done";
  } else {
    $update->{Status} = "failure";
  }
  return $update;
}

sub GetUpdate {
  my ($self,%args) = (shift,@_);
  if (defined $args{TimeOut}) {
    my $message = "I'm listening.  Time out in $args{TimeOut}.";
    $self->TellUser(Message => $message);

    my $interval = ($args{TimeOut} + "0s")->deunit->bstr;

    my $date = `date -d"now + $interval sec"`;
    chomp $date;
    Message(Message => "which is $date");

    $self->Input(undef);
    ReadMode('cbreak');
    foreach my $w (all_watchers()) {
      # destroy it
      $w->cancel;
    }
    Event->timer(interval=>0.1, cb=> sub { $self->CheckForInput } );

    # print "Timer set to $args{TimeOut}, ($interval seconds)\n";
    Event->timer(interval => $interval,
		 repeat => 0,
		 cb => sub { print "[timeout]\n" ; unloop() });
    my $ret = loop();
    ReadMode('normal');
    return $self->Input;
  }
}

sub CheckForInput {
  my ($self,%args) = (shift,@_);
  if (defined ($line = ReadLine(-1)) ) {
    $self->Input($line);
    unloop();
  } else {
    # no input was waiting
  }
}

sub TimeAtStartOfToday {
  return int timelocal(0,0,0,(localtime)[3,4,5]);
}

1;
