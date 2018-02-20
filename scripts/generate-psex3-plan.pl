#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

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

my $res2 = $tempagent->MyAgent->QueryAgent
  (
   Receiver => "Verber",
   Data => {
	    Command => 'plan',
	    Name => 'psex3',
	    Context => '20140222',
	    Goals => [
		      [
		       'entry-fn',
		       'pse',
		       5
		      ]
                     ],
	    NoPlan => 1,
	   },
  );

print Dumper($res2);
