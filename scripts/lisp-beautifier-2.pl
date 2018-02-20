#!/usr/bin/perl -w

use Data::Dumper;
use Lisp::Reader qw (lisp_read);
use Lisp::Printer qw (lisp_print);

use Manager::Misc::Light;
my $m = Manager::Misc::Light->new;

sub Beautify {
  foreach my $file (@_) {
    my $contents = `cat $file`;
    if (1) {
      my $domain = $m->Parse
	(Contents => $contents);
      print $m->PrettyGenerate
	(Structure => $domain)."\n";
    } else {
      $parse = Parse($contents);
      print Dumper($parse);
    }
  }
}

sub Parse {
  my $contents = shift;
  #   $contents =~ s/;.*$//mg;
  #   $contents =~ s/[\P{IsASCII}\r\t]//g;
  #   $contents =~ s/\n{2,}/\n/g;
  #   $contents =~ s/\n//;
  return lisp_read($contents);
}

Beautify(@ARGV);


