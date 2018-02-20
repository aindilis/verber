#!/usr/bin/perl -w

use Data::Dumper;
use IO::File;

my $systemdir = "/var/lib/myfrdcsa/codebases/internal/verber";

# make the datadir

my $backupdir = "$systemdir/data/backup/psex";

my $lastnum = [split /\n/, `ls -1 $backupdir | sort -n`]->[-1];
++$lastnum;
my $dir = "$backupdir/$lastnum";
mkdir $dir;
print $lastnum."\n";

my @files = (
	     "data/worldmodel/templates/psex*",
	     "data/worldmodel/worlds/psex*",
	     "Verber/Federated/PSEx.pm",
	    );

foreach my $file (@files) {
  if ($file =~ /^(.*)\/(.+)$/) {
    print "<$1><$2>\n";
    system "mkdirhier $dir/$1";
    system "cp $systemdir/$file $dir/$1";
    my $fh = IO::File->new;
    $fh->open(">$dir/notes") or die "can't open $dir/$notes\n";
    print $fh Dumper(@ARGV);
    $fh->close();
  }
}
