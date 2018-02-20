#!/usr/bin/perl -w

use DateTime::Duration;
use DateTime::Format::Duration;

my $formatter = DateTime::Format::Duration->new
  (
   pattern => '%s',
   normalize => 1,
  );

my $dt1 = DateTime::Duration->new(hours => 1);
my $dt2 = DateTime::Duration->new(minutes => 1);

my $a = DurationDivision($dt1, $dt2);
my $b = DurationDivision($dt2, $dt1);

print "<$a><$b>\n";

sub DurationDivision {
  my ($a,$b) = @_;
  return $formatter->format_duration($a) / $formatter->format_duration($b);
}
