package Verber::Capsule::PDDL22;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Dir DomainFile ProblemFile /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Dir($args{Dir});
  $self->DomainFile($args{DomainFile});
  $self->ProblemFile($args{ProblemFile});
}

1;
