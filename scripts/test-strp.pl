#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use Verber::Util::DateManip;

use DateTime::Format::Strptime;

my %args;

my $strp = DateTime::Format::Strptime->new
  (
   pattern => '%D_%T',
   locale => 'en_US',
   time_zone => $args{Timezone} || 'America/Chicago',
  );

# print SeeDumper($strp);

my $datemanip = Verber::Util::DateManip->new();

print SeeDumper
  ($datemanip->GetDateTimeFromString
   (
    String => '2012-08-27_23:59:59',
   ));


print SeeDumper
  ($datemanip->GetDateTimeDurationFromString
   (
    String => '0000-00-00 01:00:00',
   ));
