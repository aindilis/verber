#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use Verber::Util::DateManip;

my $datetime = "0000-00-00_03:00:00";

my $datemanip = Verber::Util::DateManip->new();

my $d = DateTime::Duration->new( days => 1, months => 3 );
my $res = $datemanip->DateTimeDurationToTimeSpecs
  (
   DateTimeDuration => $d,
  );
print Dumper($res);

my $res2 = $datemanip->TimeSpecsToDateTimeDuration
  (
   TimeSpecs => $res,
  );
print Dumper($res2);
