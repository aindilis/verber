package Verber::Federated::Test::Test3;

use Moose;

use Data::Dumper;
use Date::Day;
use DateTime;
use DateTime::Duration;
use PerlLib::SwissArmyKnife;
use Verber::Util::DateManip;

use POSIX;

extends 'Verber::Federated';

has 'RegisteredWorldNames' => (is  => 'rw',isa => 'ArrayRef',default => sub {[qw(TEST_TEST3)]});
has 'DomainIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {['UTIL_DATE1','']});
has 'ProblemIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {['UTIL_DATE1','']});

override 'GenerateDomainPrototype' => sub {
  my ($self,%args) = @_;
  my $contents = "";
  if (-e $args{TemplateFilename}) {
    $contents = read_file($args{TemplateFilename});
  }
  my $domain = $self->SUPER::GenerateDomainPrototype
    (
     %args,
     Contents => $contents,
    );
  return $domain;
};

override 'GenerateProblemPrototype' => sub {
  my ($self,%args) = @_;
  my $problem = super();
  # print Dumper({Problem => $problem});
  return $problem;
};

sub GenerateDomain {
  my ($self,%args) = @_;
  # accept the existing domain in order to generate our changes
  # add them to the existing domain
}

sub GenerateProblem {
  my ($self,%args) = @_;
  # accept the existing problem in order to generate our changes
  # add them to the existing problem
  print Dumper({GenerateProblemArgs => \%args});
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
