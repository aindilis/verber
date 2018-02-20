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
	    'Goals' => [
			[
			 'entry-fn',
			 'pse',
			 91
			]
		       ],
	    'Context' => 'Org::FRDCSA::Verber::PSEx2::Do',
	    'Name' => 'psex3',
	    # 'TemplateFilename' => '/var/lib/myfrdcsa/codebases/internal/verber/data/worldmodel/templates/psex3.p.verb',
	    'NoPlan' => 1,
	    # 'Indent' => ''
	   },
  );

# Command => 'plan',
# Name => 'psex3',
# Context => '20140222',
# Goals => [
# 	     [
# 	      'entry-fn',
# 	      'pse',
# 	      5
# 	     ]
# 	    ],
# NoPlan => 1,

print Dumper($res2);
