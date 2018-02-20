#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

use Verber::Util::DateManip;

$specification = q(
	-x <index>	Test index to perform (1, 2, 2a, etc)
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;

my $tempagent = UniLang::Util::TempAgent->new
  (
   RandName => "Verber-debug",
  );

# my $res1 = $tempagent->MyAgent->QueryAgent
#   (
#    Receiver => "Notification-Manager",
#    Receiver => "Verber",
#    Contents => "echo hi",
#   );
# print Dumper($res1);

my $res;
if ((! exists $conf->{'-x'}) or ($conf->{'-x'} eq '1')) {
  $res = $tempagent->MyAgent->QueryAgent
    (
     Receiver => "Verber",
     Data => {
	      'Command' => 'plan',
	      'Name' => 'TEST_TEST1',
	      'Verber::Federated::Test::Test1' =>
	      {
	       'Date' => '2012-09-08_12:04:31',
	      },
	      # 'NoPlan' => 1,
	     },
    );
} elsif ($conf->{'-x'} eq '2') {
  $res = $tempagent->MyAgent->QueryAgent
    (
     Receiver => "Verber",
     Data => {
	      'Command' => 'plan',
	      'Name' => 'TEST_TEST2',
	      'Verber::Federated::Util::Date1' =>
	      {
	       'Date' => '2012-09-08_12:04:31',
	       'DurationInfo' => {
				  Years => 0,
				  Months => 6,
				  Days => 0,
				 },
	       'Flags' => {
			   Date => 1,
			   DayOfWeek => 1,
			   Today => 1,
			  },
	      },
	      # 'NoPlan' => 1,
	     },
    );
} elsif ($conf->{'-x'} eq '3') {
  $res = $tempagent->MyAgent->QueryAgent
    (
     Receiver => "Verber",
     Data => {
	      'Command' => 'plan',
	      'Name' => 'TEST_TEST3',
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
	      # 'NoPlan' => 1,
	     },
    );
} elsif ($conf->{'-x'} eq '4') {
  $res = $tempagent->MyAgent->QueryAgent
    (
     Receiver => "Verber",
     Data => {
	      'Command' => 'plan',
	      'Name' => 'TEST_TEST4',
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
	      # 'NoPlan' => 1,
	     },
    );
}

print Dumper($res);
