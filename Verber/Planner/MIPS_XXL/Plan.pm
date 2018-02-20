package Verber::Planner::MIPS_XXL::Plan;

use Verber::Planner::Base::Plan;

our @ISA = qw(Verber::Planner::Base::Plan);

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->Verber::Planner::Base::Plan::init(%args);
}

1;
