#!/usr/bin/perl -w

use Data::Dumper;
use Lisp::Reader qw (lisp_read);
use Lisp::Printer qw (lisp_print);

sub Beautify {
  foreach my $file (@_) {
    my $contents = `cat $file`;
    $parse = Parse($contents);
    print Dumper($parse);
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
