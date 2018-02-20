#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use Net::Google::Calendar;

my $username = 'adougher9';
my $password = '8Bluskye';

my $cal = Net::Google::Calendar->new
  (
   url => "http://www.google.com/calendar/feeds/default/allcalendars/full/adougher9%40gmail.com",
  );
$cal->login($username,$password);
my @res = $cal->get_events();
my $size = scalar @res;
print Dumper($size);
