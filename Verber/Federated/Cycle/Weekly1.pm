package Verber::Federated::Cycle::Weekly1;

use Moose;

use Data::Dumper;
use Date::Day;
use DateTime;
use DateTime::Duration;
use PerlLib::SwissArmyKnife;
use Verber::Util::DateManip;

use POSIX;

extends 'Verber::Federated';

has 'RegisteredWorldNames' => (is  => 'rw',isa => 'ArrayRef',default => sub {[qw(CYCLE_WEEKLY1)]});
has 'DomainIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {['UTIL_DATE1']});
has 'ProblemIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {['UTIL_DATE1']});

sub BUILD {
  my ($self,$args) = @_;
  my %args = %$args;
  $self->StartDate
    ($UNIVERSAL::verber->MyResources->DateManip->GetDateTimeFromString
     (
      String => '2014-03-04_00:00:00',
     ));
  $self->EndDate
    ($UNIVERSAL::verber->MyResources->DateManip->GetDateTimeFromString
     (
      String => '2014-03-04_00:00:00',
     ));
  $self->Duration($self->EndDate - $self->StartDate);
  $self->Units
    ($UNIVERSAL::verber->MyResources->DateManip->GetDateTimeDurationFromString
     (
      String => '0000-00-00_01:00:00',
     ));
}

override 'GenerateDomainPrototype' => sub {
  my ($self,%args) = @_;
  $args{DoTemplateFilename} = $args{TemplateFilename};
  my $domain = $self->SUPER::GenerateDomainPrototype(%args);
  return $domain;
};

override 'GenerateProblemPrototype' => sub {
  my ($self,%args) = @_;
  $args{DoTemplateFilename} = $args{TemplateFilename};
  my $problem = $self->SUPER::GenerateProblemPrototype(%args);
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
