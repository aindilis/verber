#!/usr/bin/perl -w

# This is  a script that  tries to match  concepts we have  defined in
# verber and elsewhere  to the appropriate concept in  Cyc, so that we
# have a strong foundation.

use OpenCyc::Client;

# I don't know  do we want to do  that, or do we want  to do something
# else?

sub MatchConcept {
  my $t = shift;
  my $concept = Format($t);
  my $res = CycQuery("(constant-apropos \"$concept\")");
}

sub Format {
  my $t = shift;
  return $t;
}
