package Verber::Ext::PDDL::Domain::Predicate;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / String Structure Predicate Arguments /

  ];

sub init {
  my ($self,%args) = @_;
  $self->String($args{String});
  $self->Structure($args{Structure});
  $self->Predicate($args{Predicate});
  $self->Arguments($args{Arguments} || []);
}

1;
