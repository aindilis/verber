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
  $self->Functions
    ([
      {Regex => qr/set-alarm/i,
       Handler => sub {$self->SetAlarm(@_)},
       Type => "nonblocking"},
      {Regex => qr/replan/,
       Handler => sub {$self->InitiateReplanning(@_)},
       Type => "nonblocking"},
      {Regex => qr/replan/,
       Handler => sub {$self->InitiateReplanning(@_)},
       Type => "nonblocking"},
      {Regex => qr/complete-task plan-cycle/i,
       Handler => sub {$self->TransitionCycle(@_)},
       Type => "blocking"},
     ]);
}

sub MatchFunctions {
  my ($self,%args) = @_;
  foreach my $i (@{$self->Functions}) {
    if ($i->{Type} eq $args{Type}) {
      if ($args{PlanStep}->Action =~ $i->{Regex}) {
	return 1;
      }
    }
  }
}

sub ExecuteFunctions {
  my ($self,%args) = @_;
  foreach my $i (@{$self->Functions}) {
    if ($i->{Type} eq $args{Type}) {
      if ($args{PlanStep}->Action =~ $i->{Regex}) {
	print "Executing handler for ".$args{PlanStep}->Action."\n";
	@list = ($1,$2,$3,$4,$5,$6,$7,$8,$9);
	while (@list and ! defined $list[-1]) {
	  pop @list;
	}
	&{$i->{Handler}}
	  (PlanStep => $args{PlanStep},
	   Function => $i);
      }
    }
  }
}

sub InitiateReplanning {
  my ($self,%args) = @_;
}

sub TransitionCycle {
  my ($self,%args) = @_;
  # plan out the next cycle

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

sub SetAlarm {
  my ($self,%args) = @_;
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


