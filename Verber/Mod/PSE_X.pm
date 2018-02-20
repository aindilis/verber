package Verber::Mod::PSEx;

use UniLang::Util::TempAgent;
use Verber::Ext::PDDL::Problem;
use Verber::Ext::PDDL::Domain;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / MyTempAgent / ];

sub init {
  my ($self,%args) = @_;
  $self->MyTempAgent
    (UniLang::Util::TempAgent->new
     (Name => "PSE-X"));
}

sub GenerateDomain {
  my ($self,%args) = @_;
  Verber::Ext::PDDL->new
  my $message = $self->MyTempAgent->MyAgent->QueryAgent
    (Recipient => "KBS",
     Contents => "pse-x all-term-assertions");
  print Dumper($message);
}

1;
