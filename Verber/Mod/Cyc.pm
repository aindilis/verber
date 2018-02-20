package Verber::Modules::OpenCyc;

sub QueryOpenCyc {
  # this request must be in the form of a goal
  my $goal = $args{Goal};
  return unless $goal;
  return "invalid goal syntax" unless $self->CheckGoalSyntax(Goal => $goal);

  # with a valid goal, let us now query opencyc for the world state
  my $message = $UNIVERSAL->agent->Ask
    (Recipient => "OpenCyc",
     Contents => "(all-term-assertions #$CurrentWorldModel)");
  # now let us attempt to parse this information and feed it to a verber domain
  my $state = $self->CycLtoPDDL(CycL => $message->Contents) if $message->Sender eq "OpenCyc";
  my $problemfile = $self->ComposeProblemFile(Goal => $goal->Contents,
					      State => $state);
  # $self->Plan
  #   (Verber::Manager::Plan->new
  #    (Contents =>
  #     $UNIVERSAL->agent->Ask
  #     (Recipient => "Verber",
  #      Contents => $problemfile)));
}

sub CycLtoPDDL {
  my ($self,%args) = (shift,@_);
  return $args{CycL};
}

sub CheckGoalSyntax {
  my ($self,%args) = (shift,@_);
  return 1;
}

sub UpdateWorldModel {
  my ($self,%args) = (shift,@_);
  foreach my $step (@{$self->Completed}) {
    $self->SendMessage(Agent => "OpenCyc",
		       Contents => $self->ObtainEffects($step));
  }
}

sub ObtainEffects {
  my ($self,%args) = (shift,@_);
  # query the verber instance for the world model effects and return these as cyc assertions
  $self->SendMessage(Agent => "Verber",
		     Contents => $step->Contents);
}

1;
