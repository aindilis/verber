#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

use Verber::Util::DateManip;

$specification = q(
	-c <cycle>	Cycle to use
);

my $cycles =
  {
   Daily1 => 1,
   Weekly1 => 1,
   Weekly2 => 1,
   Monthly1 => 1,
   Years1_1 => 1,
   Years10_1 => 1,
   Years25_1 => 1,
   Life1 => 1,
  };

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;

my $tempagent = UniLang::Util::TempAgent->new
  (
   RandName => "Verber-debug",
  );

my $res;
my $cycle = 'Weekly2';
if (exists $conf->{'-c'} and exists $cycles->{$conf->{'-c'}}) {
  $cycle = $conf->{'-c'};
}

$res = $tempagent->MyAgent->QueryAgent
  (
   Receiver => "Verber",
   Data => {
	    'Command' => 'plan',
	    'Name' => 'CYCLE_'.uc($cycle),
	    'Timing' =>
	    {
	     StartDateString => '2012-08-21_00:00:00',
	     EndDateString => '2012-08-27_23:59:59',
	     Units => '0000-00-01_00:00:00',
	    },
	    'Verber::Federated::Util::Date1' =>
	    {
	     'Flags' => {
			 Date => 1,
			 DayOfWeek => 1,
			 Today => 1,
			},
	    },
	    IEM => 2,
	   },
  );

print Dumper($res);
