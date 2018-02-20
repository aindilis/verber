package Verber::Federated::Cycle::Monthly1;

use Moose;

use Data::Dumper;
use Date::Day;
use DateTime;
use DateTime::Duration;
use PerlLib::SwissArmyKnife;
use Verber::Util::DateManip;

use POSIX;

extends 'Verber::Federated';

has 'RegisteredWorldNames' => (is  => 'rw',isa => 'ArrayRef',default => sub {[qw(CYCLE_MONTHLY1)]});
has 'DomainIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {['groceries']});
has 'ProblemIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {['groceries']});
has 'DateManip' => (
		    is  => 'rw',
		    isa => 'Verber::Util::DateManip',
		    default => sub { Verber::Util::DateManip->new() },
		   );
has 'StartDate' => (is  => 'rw',isa => 'DateTime');
has 'Units' => (is  => 'rw',isa => 'DateTime::Duration');

has 'IsPayDay' => (is  => 'rw',isa => 'HashRef',default => sub {{}});

override 'GenerateDomainPrototype' => sub {
  my ($self,%args) = @_;
  my $contents = read_file($args{TemplateFilename});
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

  print Dumper({GenerateProblemArgs => \%args});

  # accept the existing problem in order to generate our changes
  # add them to the existing problem

  my $dt1;
  if ($args{'Verber::Federated::Cycle::Monthly1'}{Date} =~
      /^(\d{4})-(\d{2})-(\d{2})_(\d{2}):(\d{2}):(\d{2})$/) {
    $dt1 = DateTime->new
      (
       year       => $1,
       month      => $2,
       day        => $3,
       hour       => $4,
       minute     => $5,
       second     => $6,
       time_zone  => 'America/Chicago',
      );
  } else {
    $dt1 = $self->DateManip->GetCurrentDateTime;
  }

  my $dur = DateTime::Duration->new
    (
     years => 5,
     months => 0,
     days => 0,
    );
  my $dt2 = $dt1 + $dur;
  my $seconds = $dt2->epoch - $dt1->epoch;
  my $days = $seconds / (24 * 60 * 60);
  my $day = DateTime::Duration->new
    (
     days => 1,
    );
  my $debug = 0;
  my @history;
  foreach my $i (0 .. ceil($days)) {
    my $dt = $dt1 + ($i * $day);
    my ($year,$month,$day) = ($dt->year(), $dt->month(), $dt->day());
    my $dow = &day($month,$day,$year);
    my $date = sprintf("%04i%02i%02i", $year, $month, $day);
    print Dumper($date,$dow) if $debug;
    $self->IsPayDay->{$date} = 0;
    if ($day == 1 or $day == 15) {
      if ($dow eq 'SUN') {	# consider other bank holidays
	my $ref = $history[-1];	# figure out if it should be -2
	$self->IsPayDay->{$ref->{date}} = 1;
      } else {
	$self->IsPayDay->{$date} = 1;
      }
    }
    push @history, {
		    date => $date,
		    dow => $dow,
		   };
  }

  # my $employer = {
  # 		"Ionzero" => 1,
  # 	       };
  # if (abs(DateTime::Duration->compare($sdt + $dur,$edt))) {

  my $dowhash =
    {
     'SUN' => 'Sunday',
     'MON' => 'Monday',
     'TUE' => 'Tuesday',
     'WED' => 'Wednesday',
     'THU' => 'Thursday',
     'FRI' => 'Friday',
     'SAT' => 'Saturday',
    };

  foreach my $value (values %$dowhash) {
    $args{Problem}->AddObject
      (
       Type => "day-of-week",
       Object => $value,
      );
  }

  foreach my $ref (@history) {
    my $date = 'date-'.$ref->{date};
    $args{Problem}->AddObject
      (
       Type => "date",
       Object => $date,
      );
    $args{Problem}->AddInit
      (
       Structure => ['day-of-week',$date, $dowhash->{$ref->{dow}}],
      );
    if ($self->IsPayDay->{$ref->{date}}) {
      $args{Problem}->AddInit
	(
	 Structure => ['pay-day',$date],
	);
    }
  }
}

  __PACKAGE__->meta->make_immutable;
no Moose;
1;
