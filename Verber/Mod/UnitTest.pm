package Verber::Modules::UnitTest;

#!/usr/bin/perl -w

# this is a  program that simulates events for  verber, and determines
# whether verber behaved correctly.

sub SimulateActivity {
  @tasks = ();

  # run simulation
  StartSimulation();

  foreach my $task (@tasks) {
    # did verber succeed
  }
}

sub PrintReport {

}

1;
