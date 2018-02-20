package Verber::Manager::SubProcess;

use Manager::Dialog qw (Message QueryUser ApproveCommands Verify);
use MyFRDCSA;
use UniLang::Util::Message;

use Data::Dumper;

# This system is responsible for executing programs or functions that
# are directly invoked by plan actions.

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Functions / ];

sub init {
  my ($self,%args) = @_;
  print "<<<TEST>>>\n";
  $self->Functions
    ([
      {Regex => qr//,
       Handler => sub {$self->InitiateReplanning(@_)},
       Type => "nonblocking"},
      {Regex => qr//,
       Handler => sub {$self->InitiateReplanning(@_)},
       Type => "nonblocking"},
      {Regex => qr/complete-task plan-cycle/i,
       Handler => sub {$self->TransitionCycle(@_)},
       Type => "blocking"},
     ]);
  print "<<<TEST>>>\n";
}

sub MatchFunctions {
  my ($self,%args) = @_;
  foreach my $i (@{$self->Functions}) {
    if ($args{PlanStep}->Action =~ $i->{Regex}) {
      if ($i->{Type} eq $args{Type}) {
	return 1;
      }
    }
  }
}

sub ExecuteFunctions {
  my ($self,%args) = @_;
  foreach my $i (@{$self->Functions}) {
    if ($args{PlanStep}->Action =~ $i->{Regex}) {
      if ($i->{Type} eq $args{Type}) {
	&{$i->{Handler}}($1,$2,$3,$4);
      }
    }
  }
}

sub InitiateReplanning {
  my ($self,%args) = @_;
}

sub TransitionCycle {
  my ($self,%args) = @_;
  # didn't really need all that fancy stuff, just reload the domains
  # and plan again
  print "HEAR YE, HEAR YE\n";
  sleep 1;
  print "BLAH BLAH BLAH\n";
  sleep 2;
  print "BLAH BLAH BLAH\n";
  sleep 2;
  print "BLAH BLAH BLAH\n";
  sleep 2;
  print "BLAH BLAH BLAH\n";
  sleep 2;
  print "Done\n";
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

1;


