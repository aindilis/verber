package Verber::Util::Beautifier;

use Verber::Util::Light;

use Lisp::Symbol;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / MyLight / ];

sub init {
  my ($self,%args) = @_;
  $self->MyLight
    (Verber::Util::Light->new
      ());
}

sub Beautify {
  my ($self,%args) = @_;
  my $domain = $self->MyLight->Parse
    (Contents => $args{Lisp});
  # print Dumper($domain);
  return $self->MyLight->PrettyGenerate
    (Structure => $domain->[0])."\n";
}

1;
