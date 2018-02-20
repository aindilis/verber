package Verber::Util::ForwardWindow;

use Moose;

has 'years' => (is  => 'rw',isa => 'Int',default => sub { 0 },);
has 'months' => (is  => 'rw',isa => 'Int',default => sub { 0 },);
has 'days' => (is  => 'rw',isa => 'Int',default => sub { 0 },);

__PACKAGE__->meta->make_immutable;
no Moose;
1;


