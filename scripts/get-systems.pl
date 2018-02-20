#!/usr/bin/perl -w

use Data::Dumper;

my $planners = <<EOF
    * CPT2 (Vincent Vidal and Sebastien Tabary)
    * FDP (Cyril Pain-Barre and Stephane Grandcolas)
    * IPPLAN-1SC (Menkes van den Briel, Subbarao Kambhampati and Thomas Vossen)
    * Maxplan (Zhao Xing, Yixin Chen and Weixiong Zhang)
    * MIPS-BDD (Stefan Edelkamp)
    * SATPLAN06 (Joerg Hoffmann, Henry Kautz, Shane Neph and Bart Selman)
    * Fast Downward - sa (Malte Helmert)
    * HPlan-P (Jorge Baier, Fahiem Bacchus and Sheila McIlraith)
    * IPPLAN-G1SC (Menkes van den Briel, Subbarao Kambhampati and Thomas Vossen)
    * MIPS-XXL (Stefan Edelkamp, Shahid Jabbar and Mohammed Nazih)
    * SGPlan5 (Benjamin W. Wah, Chih-Wei Hsu, Yixin Chen and Ruoyun Huang)
    * YochanPS (J. Benton, Subbarao Kambhampati and Minh B. Do)
EOF
;

foreach my $line (split /\n/, $planners) {
  if ($line =~ /^\s*\*\s+(.+?)\s*\((.+)\)$/) {
    print Dumper({
		  Sys => $1,
		  People => $2,
		 });
    system "radar-web-search \"$1\" -a \"$2\"";
  }
}
