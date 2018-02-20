package Verber::Manager::Step;

use Math::Units::PhysicalValue qw(PV);

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Plan StepContents Time Action Duration Cost TimeUnits Units
   StartDate /

  ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->TimeUnits($args{TimeUnits});
  $self->Units($args{Units});
  $self->StartDate($args{StartDate});

  $self->StepContents($args{StepContents} || "");
  $self->ProcessContents;
}

sub ProcessContents {
  my ($self,%args) = (shift,@_);
  my $contents = $self->StepContents;
  # if ($contents =~ /\s*([0-9.]+):\s+(\([^\)]+\))\s+\[D:([0-9.]+);\s+C:([0-9.]+)\]/) {
  if ($contents =~ /\s*([0-9.]+):\s+(\([^\)]+\))\s+\[(D:)?([0-9.]+)(;\s+C:([0-9.]+))?\]/) {
    # $self->Time(PV "$1".$self->TimeUnits);
    $self->Time($1);
    $self->Action($2);
    # $self->Duration(PV "$4".$self->TimeUnits);
    $self->Duration($4);
    $self->Cost($6) if $6;
  }
}

sub GetStepStartDateTime {
  my ($self,%args) = (shift,@_);
  my $dt = $self->StartDate + ($self->Time * $self->Units);
  return $dt;
}

sub GetStepEndDateTime {
  my ($self,%args) = (shift,@_);
  my $dt = $self->StartDate + (($self->Time + $self->Duration) * $self->Units);
  return $dt;
}

1;
