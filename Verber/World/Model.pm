package Verber::World::Model;

use UniLang::Util::Message;

# this system keeps track of which facts of true of the world, it also
# sends reports to the event system as things change

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Facts / ];

sub init {
  my ($self,%args) = @_;
  $self->Facts($args{Facts});
}

sub SyncKnowledgeBases {
  my ($self,%args) = @_;
  # in case we ever get a knowledge base going, sync with it
  
}

sub Update {
  my ($self,%args) = @_;
  foreach my $step (@{$args{Steps}}) {
    my $um = UniLang::Util::Message->new
      (Sender => "Verber",
       Receiver => "Emacs-Client",
       Date => undef,
       Contents => "ps ".$step->Action);
    $UNIVERSAL::agent->Send
      (Handle => $UNIVERSAL::agent->Client,
       Message => $um);
  }
}

# @{$UNIVERSAL::verber->MyManager->Completed};

# for now simply send these off to the event system assuming it's active

# soon, send of any effects of plan steps

# we  can also  listen to  incoming  messages, parsing  these out  and
# replanning as necessary

# suppose <REDACTED>'s agent sends us  information saying he has moved
# away from where he was.  we  could evaluate whether this affects any
# plan steps, regenerate the plan files, and rebuild.  Note that if he
# leaves, maybe he's coming back?  We'd have to work that out.

# it's humorous how going to <REDACTED>'s  serve as the basis for this
# planning domain

1;
