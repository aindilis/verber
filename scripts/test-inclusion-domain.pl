#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

my $tempagent = UniLang::Util::TempAgent->new
  (
   RandName => "SPSE2-debug",
  );

my $res1 = $tempagent->MyAgent->QueryAgent
  (
   Receiver => "Notification-Manager",
   Receiver => "Verber",
   Contents => "echo hi",
  );
print Dumper($res1);

my $res2 = $tempagent->MyAgent->QueryAgent
  (
   Receiver => "Notification-Manager",
   Receiver => "Verber",
   Data => {
	    Command => "plan",
	    Name => "main",
	    IEM => 2,
	   },
  );
print Dumper($res2);
