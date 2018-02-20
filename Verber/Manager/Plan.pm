package Verber::Manager::Plan;

use Verber::Manager::Step;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / PlanContents Trimmed Steps TimeUnits / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->PlanContents($args{PlanContents} || "");
  $self->Steps($args{Steps} || []);
  $self->TimeUnits($args{TimeUnits} || "hour");
  $self->ProcessContents;
}

sub ProcessContents {
  my ($self,%args) = (shift,@_);
  my $contents = $self->PlanContents;
  $contents =~ s/;.*$//mg;
  $contents =~ s/\n{2,}//sg;
  $contents =~ s/^\n//s;
  $self->Trimmed($contents);
  # $contents =~ s/.*Time: \(ACTION\) \[action Duration; action Cost\]//sm;
  my @steps;
  my @lines = split /\n/, $contents;
  foreach my $line (@lines) {
    push @{$self->Steps}, Verber::Manager::Step->new(Plan => $self,
						     StepContents => $line);
  }
}

1;
