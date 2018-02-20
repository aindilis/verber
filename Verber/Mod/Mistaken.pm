sub TransitionCycle {
  my ($self,%args) = @_;
  # when the planning cycle is planned to terminate, this function is
  # called by the execution monitor

  if ($UNIVERSAL::verber->Config->CLIConfig->{'-u'}) {
    # broadcast start of transitioncycle, waiting for any other
    # systems to file last minute requests
    $self->Shout
      (Contents => "(beginning verber transitioncycle in 5 seconds)");

    sleep 5;		# obvious in reality this is much more complex

    # Change our UniLang agents name before restarting
    $UNIVERSAL::agent->ChangeName(Name => "Dummy");

    $self->LaunchNextPlanningCycle;

    # send and receive a message to "Verber" asking whether it is running
    if ($UNIVERSAL::agent->Ping(Agent => "Verber")) {
      # guess its perfectly okay to shutdown now
      $self->Shout
	(Contents => "(verber shutting down)");
      exit(0);
    } else {
      # apparently its not running, so change our name back
      $UNIVERSAL::agent->ChangeName(Name => "Verber");
      $self->Shout
	(Contents => "(verber transition aborted, initiating replanning)");
      $self->InitiateReplanning;
    }
  } else {
    sleep 5;
    $self->LaunchNextPlanningCycle;
  }
}

sub LaunchNextPlanningCycle {
  my ($self,%args) = @_;
  # launch the next plan cycle
  system "verber -w cycle -m -u &";
}

sub Shout {
  my ($self,%args) = @_;
  my $message = UniLang::Util::Message->new
    (Sender => $self->Name,
     Receiver => "Emacs-Agent",
     Contents => $args{Contents});
  $UNIVERSAL::agent->Send
    (Handle => $UNIVERSAL::agent->Client,
     Message => $message);
}
