#!/usr/bin/perl -w

use Data::Dumper;
use Date::Day;
use DateTime::Duration;
use POSIX;
use Verber::Util::DateManip;
# use Verber::Util::ForwardWindow;

my $datemanip = Verber::Util::DateManip->new();
my $dt1 = $datemanip->GetCurrentDateTime;
my $dur = DateTime::Duration->new
  (
   years => 100,
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
  $ispayday->{$date} = 0;
  if ($day == 1 or $day == 15) {
    if ($dow eq 'SUN') {	# consider other bank holidays
      my $ref = $history[-1];	# figure out if it should be -2
      $ispayday->{$ref->{date}} = 1;
    } else {
      $ispayday->{$date} = 1;
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

foreach my $ref (@history) {
  if ($ispayday->{$ref->{date}}) {
    print "(pay-day date-".$ref->{date}.")\n";
    
  }
}
