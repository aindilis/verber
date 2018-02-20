#!/usr/bin/perl -w

use Data::Dumper;
use DateTime::Event::Holiday::US;

my @holidays = DateTime::Event::Holiday::US::known();
print Dumper(\@holidays);
