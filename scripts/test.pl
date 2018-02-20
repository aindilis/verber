#!/usr/bin/perl -w

# use Verber::Ext::PDDL::Problem;
# my $p = Verber::Ext::PDDL::Problem->new
#   (FileName => $ARGV[0]);

use Verber::Ext::PDDL::Domain;
my $p = Verber::Ext::PDDL::Domain->new
  (FileName => $ARGV[0]);

$p->Parse;
print $p->Generate."\n";
