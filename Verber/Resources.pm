package Verber::Resources;

use Verber::Util::DateManip;

use Moose;

has 'DateManip' => (
		    is  => 'rw',
		    isa => 'Verber::Util::DateManip',
		    default => sub { Verber::Util::DateManip->new() },
		   );


__PACKAGE__->meta->make_immutable;
no Moose;
1;
