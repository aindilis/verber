package Verber::Federated::WorldStateMonitor;

use Moose;

# track and report on the status of items

extends 'Verber::Federated';

has 'RegisteredWorldNames' => (is  => 'rw',isa => 'ArrayRef',default => sub {[qw(WORLDSTATEMONITOR)]});
has 'DomainIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {[]});
has 'ProblemIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {[]});

__PACKAGE__->meta->make_immutable;
no Moose;
1;


# need to load the current planned events

# NOTE What if the layer depends on things in lower layers?

# need to load currently believed future and past events






# package Verber::Federated::Util::Date1;

# use Moose;

# use Data::Dumper;
# use Date::Day;
# use DateTime;
# use DateTime::Duration;
# use PerlLib::SwissArmyKnife;

# use POSIX;

# extends 'Verber::Federated';

# has 'RegisteredWorldNames' => (is  => 'rw',isa => 'ArrayRef',default => sub {[qw(UTIL_DATE1)]});
# has 'DomainIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {[]});
# has 'ProblemIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {[]});

# override 'GenerateDomainPrototype' => sub {
#   my ($self,%args) = @_;
#   $args{DoTemplateFilename} = $args{TemplateFilename};
#   my $domain = $self->SUPER::GenerateDomainPrototype(%args);
#   return $domain;
# };

# override 'GenerateProblemPrototype' => sub {
#   my ($self,%args) = @_;
#   $args{DoTemplateFilename} = $args{TemplateFilename};
#   my $problem = $self->SUPER::GenerateProblemPrototype(%args);
#   return $problem;
# };

# sub GenerateDomain {
#   my ($self,%args) = @_;
#   # accept the existing domain in order to generate our changes
#   # add them to the existing domain
# }

# sub GenerateProblem {
#   my ($self,%args) = @_;
#   # accept the existing problem in order to generate our changes
#   # add them to the existing problem

#   print SeeDumper({GenerateProblemArgs => \%args}) if $UNIVERSAL::verber->Debug >= 3;

#   my $data = $args{'Verber::Federated::Util::Date1'};
#   my $flags = $data->{Flags};

#   my $sdt;
#   my $edt;
#   my $dur;
#   if (exists $args{Timing}) {
#     $sdt = $args{Timing}{StartDate};

#     if (exists $args{Timing}{EndDate}) {
#       $edt = $args{Timing}{EndDate};
#       $dur = $args{Timing}{Duration};
#     }
#   }

#   return unless $edt;

#   my $seconds = $edt->epoch - $sdt->epoch;
#   my $days = $seconds / (24 * 60 * 60);
#   my $day = DateTime::Duration->new
#     (
#      days => 1,
#     );

#   my $debug = 0;
#   my @history;
#   foreach my $i (0 .. ceil($days)) {
#     my $dt = $sdt + ($i * $day);
#     my ($year,$month,$day) = ($dt->year(), $dt->month(), $dt->day());
#     my $dow = &day($month,$day,$year);
#     my $date = sprintf("%04i%02i%02i", $year, $month, $day);
#     push @history, {
# 		    date => $date,
# 		    dow => $dow,
# 		   };
#   }

#   my $dowhash =
#     {
#      'SUN' => 'Sunday',
#      'MON' => 'Monday',
#      'TUE' => 'Tuesday',
#      'WED' => 'Wednesday',
#      'THU' => 'Thursday',
#      'FRI' => 'Friday',
#      'SAT' => 'Saturday',
#     };

#   if ($flags->{Date} and $flags->{DayOfWeek}) {
#     foreach my $value (values %$dowhash) {
#       $args{Problem}->AddObject
# 	(
# 	 Type => "day-of-week",
# 	 Object => $value,
# 	);
#     }
#   }
#   my $i = 0;
#   foreach my $ref (@history) {
#     my $date = 'date-'.$ref->{date};
#     if ($flags->{Date}) {
#       $args{Problem}->AddObject
# 	(
# 	 Type => "date",
# 	 Object => $date,
# 	);
#       my $time1 = $i*24;
#       my $time2 = ($i*24) + 24;
#       if ($flags->{Today}) {
# 	$args{Problem}->AddInit
# 	  (
# 	   Structure => ['at',$time1,['today', $date]],
# 	  );
# 	$args{Problem}->AddInit
# 	  (
# 	   Structure => ['at',$time2,['not', ['today', $date]]],
# 	  );
#       }
#       if ($flags->{DayOfWeek}) {
# 	$args{Problem}->AddInit
# 	  (
# 	   Structure => ['day-of-week',$date, $dowhash->{$ref->{dow}}],
# 	  );
#       }
#     }
#     ++$i;
#   }
# }

# __PACKAGE__->meta->make_immutable;
# no Moose;
# 1;
