package Verber::FedManager;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Feds Name2Fed / ];

sub init {
  my ($self,%args) = @_;
  $self->Feds({});
  $self->Name2Fed({});
  my $dir = $UNIVERSAL::systemdir."/Verber/Federated";
  # my $stuff = `ls $dir/*.pm`;
  my $stuff = `find $dir/ | grep -E '\.pm\$'`;
  my $dirre = $dir; 
  $dirre =~ s/([^[:alnum:]])/\\$1/sg;
  foreach my $file (split /\n/, $stuff) {
    if ($file =~ /^$dirre\/(.+?)\.pm$/ and $file !~ /\/\.?\#/) {
      my $fedname = $1;
      my $fednamecolons = $fedname;
      $fednamecolons =~ s/\//::/sg;
      print "Attempting to load: Fed Verber::Federated::$fednamecolons\n" if $UNIVERSAL::verber->Debug;
      require "$dir/$fedname.pm";
      my $federated = "Verber::Federated::$fednamecolons"->new();
      $self->Feds->{$fedname} = $federated;
      foreach my $worldname (@{$federated->RegisteredWorldNames}) {
	$self->Name2Fed->{lc($worldname)} = $federated;
      }
    }
  }
}

1;
