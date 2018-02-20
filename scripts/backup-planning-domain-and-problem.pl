#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;

$specification = q(
	-d <dir>	Directory
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

if (! exists $conf->{'-d'}) {
  die "-d required\n";
}

my $dir = $conf->{'-d'};
my $i = 1;
my $j = 1;
while (-e "$dir/$i") {
  $j = $i;
  ++$i;
}
print "$i\n";

my $commands =
  [
   "cp -ar $dir/$j $dir/$i",
   "rm $dir/current",
   "ln -s $dir/$i $dir/current",
  ];

ApproveCommands
  (
   Commands => $commands,
   Method => 'serial',
  );

print Dumper($commands);

print "Kill your emacs files\n";
