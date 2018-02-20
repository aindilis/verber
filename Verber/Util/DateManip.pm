package Verber::Util::DateManip;

use Data::Dumper;
use Date::ICal;
use Date::Parse;
use DateTime;
use DateTime::Duration;
use DateTime::Format::Duration;
use DateTime::Format::ICal;
use DateTime::Format::Strptime;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / FormatterSeconds Formatter FormatterWithoutSpace FormatterTimeSpecs TimePeriods
   DOWHash Strp /

  ];

sub init {
  my ($self,%args) = @_;
  $self->FormatterSeconds
    (DateTime::Format::Duration->new
     (
      pattern => '%s',
      normalize => 1,
     ));
  $self->Formatter
    (DateTime::Format::Duration->new
     (
      pattern => '%F %T',
      normalize => 1,
     ));
  $self->FormatterWithoutSpace
    (DateTime::Format::Duration->new
     (
      pattern => '%F_%T',
      normalize => 1,
     ));
  $self->FormatterTimeSpecs
    (DateTime::Format::Duration->new
     (
      pattern => '%Y years, %m months, %e days, %H hours, %M minutes, %S seconds',
      normalize => 1,
     ));
  $self->TimePeriods
    ({
      "noon" => ["12:00:00"],
      "midnight" => ["00:00:00"],

      "early morning" => ["05:00:00","07:59:59"],
      "morning proper" => ["08:00:00","11:59:59"],

      "morning" => ["05:00:00","11:59:59"],

      "early afternoon" => ["12:00:00","13:59:59"],
      "afternoon proper"  => ["14:00:00","15:59:59"],
      "late afternoon" => ["16:00:00","17:59:59"],

      "afternoon" => ["12:00:00","17:59:59"],

      "early evening" => ["18:00:00","18:59:59"],
      "evening proper" => ["19:00:00","20:59:59"],

      "evening" => ["18:00:00","20:59:59"],

      "night proper" => ["21:00:00","23:59:59"],
      "late night" => ["00:00:00", "01:59:59"],
      "late night/very early morning" => ["02:00:00","04:59:59"],

      "night" => ["21:00:00","04:59:59"],

      "all day" => ["00:00:00","23:59:59"],
     });
  $self->Strp
    (DateTime::Format::Strptime->new
     (
      pattern => '%F_%T',
      locale => 'en_US',
      time_zone => $args{Timezone} || 'America/Chicago',
     ));
  $self->DOWHash
    ({
      "jan" => 1,
      "feb" => 2,
      "mar" => 3,
      "apr" => 4,
      "may" => 5,
      "jun" => 6,
      "jul" => 7,
      "aug" => 8,
      "sep" => 9,
      "oct" => 10,
      "nov" => 11,
      "dec" => 12,
     });
}

sub GetPresent {
  my ($self,%args) = @_;
  my $date = `date`;
  chomp $date;
  my $epoch = str2time($date);
  my $dt = DateTime->from_epoch(epoch => $epoch, time_zone => "America/Chicago");
  # my $present = DateTime::Format::ICal->format_datetime($dt);
  return $dt;
}

sub FormatDatetime {
  my ($self,%args) = @_;
  return $args{Datetime};
}

sub ICalDateStringToDateTime {
  my ($self,%args) = @_;
  my $ical = Date::ICal->new
    (ical => $args{String});
  if (defined $ical) {
    # print Dumper([$args{String}, $ical]);
    return DateTime->from_epoch
      (epoch => $ical->epoch);
  }
}

sub DurationStringToDateTimeDuration {
  my ($self,%args) = @_;
  # print Dumper(\%args);
  if ($args{String} =~ /^(\d{4})-(\d{2})-(\d{2})_(\d{2}):(\d{2}):(\d{2})$/) {
    # 0000-01-18 22:46:13
    return DateTime::Duration->new
	(
	 years => $1,
	 months => $2,
	 days => $3,
	 hours => $4,
	 minutes => $5,
	 seconds => $6,
	);
  } else {
    my %hash = ();
    foreach my $entry (split /,\s*/, $args{String}) {
      my ($qty,$unit) = split /\s+/, $entry;
      $hash{$unit} = $qty;
    }
    if (keys %hash) {
      return DateTime::Duration->new
	(%hash);
    }
  }
}

sub DurationDivision {
  my ($self, %args) = @_;
  return $self->FormatterSeconds->format_duration
    ($args{Numerator})
      /
	$self->FormatterSeconds->format_duration
	  ($args{Denominator});
}

sub DateTimeToICalString {
  my ($self, %args) = @_;
  return DateTime::Format::ICal->format_datetime
      ($args{DateTime});
}

sub DurationToString {
  my ($self, %args) = @_;
  my $string = $self->FormatterWithoutSpace->format_duration
    ($args{Duration});
  $string =~ s/\s/_/;
  return $string;
}

sub TimeSpecsToDateTimeDuration {
  my ($self, %args) = @_;
  foreach my $timespec (split /,\s*/, $args{TimeSpecs}) {
    my ($qty,$unit) = split /\s+/, $timespec;
    $hash{$unit} = $qty;
  }
  if (keys %hash) {
    # print Dumper({Hash => \%hash});
    $dur = DateTime::Duration->new
      (%hash);
    return {
	    Success => 1,
	    Result => $dur,
	   };
  } else {
    return {
	    Success => 0,
	   };
  }
}

sub DateTimeDurationToTimeSpecs {
  my ($self, %args) = @_;
  my $res = $self->FormatterTimeSpecs->format_duration
    ($args{DateTimeDuration});
  my %hash;
  my @string;
  foreach my $timespec (split /,\s*/, $res) {
    my ($qty,$unit) = split /\s+/, $timespec;
    $hash{$unit} = int($qty);
    if ($hash{$unit} != 0) {
      push @string, $hash{$unit}." ".$unit;
    }
  }
  return join(", ",@string);
}

sub GetCurrentDateTime {
  my ($self, %args) = @_;
  my $dt = DateTime->now();
}

sub GetDateTimeFromString {
  my ($self, %args) = @_;
  return $self->Strp->parse_datetime($args{String});
}

sub GetDateTimeDurationFromString {
  my ($self, %args) = @_;
  my $tmp = $self->FormatterWithoutSpace->parse_duration($args{String});
  unless ($tmp) {
    $tmp = $self->Formatter->parse_duration($args{String});
  }
  return $tmp;
}

1;
