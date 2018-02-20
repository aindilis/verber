package Verber::Federated;

use PerlLib::SwissArmyKnife;

use Moose;

use Data::Dumper;

has 'StartDate' => (is  => 'rw',isa => 'DateTime');
has 'EndDate' => (is  => 'rw',isa => 'DateTime');
has 'Duration' => (is  => 'rw',isa => 'DateTime::Duration');
has 'Units' => (is  => 'rw',isa => 'DateTime::Duration');

has 'DomainIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {[]});
has 'ProblemIncludesOrder' => (is  => 'rw',isa => 'ArrayRef',default => sub {[]});

sub GenerateDomainPrototype {
  my ($self,%args) = @_;
  $args{Indent} ||= '';
  $args{Contents} ||= '';
  if (exists $args{DoTemplateFilename}) {
    if (-e $args{DoTemplateFilename}) {
      $args{Contents} = read_file($args{TemplateFilename});
    } else {
      print "Domain TemplateFilename not found <$args{DoTemplateFilename}>\n";
    }
  }
  my $ref = ref($self);
  my $name = $args{Name};
  print $args{Indent}."Generating domain prototype for Federated Planning on <$name> of <$ref>\n";
  my $domain = Verber::Ext::PDDL::Domain->new
    (
     Contents => $args{Contents},
    );
  $domain->Parse();

  print SeeDumper({AndyDumperDomain => $domain}) if $UNIVERSAL::verber->Debug >= 3;

  $domain->Domain($name);
  foreach my $include (@{$self->DomainIncludesOrder}) {
    $domain->AddInclude(Include => $include);
  }
  return $domain;
}

sub GenerateProblemPrototype {
  my ($self,%args) = @_;
  $args{Indent} ||= '';
  $args{Contents} ||= '';
  if (exists $args{DoTemplateFilename}) {
    if (-e $args{DoTemplateFilename}) {
      $args{Contents} = read_file($args{TemplateFilename});
    } else {
      print "Problem TemplateFilename not found <$args{DoTemplateFilename}>\n";
    }
  }
  my $ref = ref($self);
  my $name = $args{Name};
  print $args{Indent}."Generating problem prototype for Federated Planning on <$name> of <$ref>\n";
  print SeeDumper({Args => \%args});
  my $problem = Verber::Ext::PDDL::Problem->new
    (
     Contents => $args{Contents},
    );
  $problem->Parse();

  $problem->Problem($name);
  $problem->Domain($name);
  foreach my $include (@{$self->ProblemIncludesOrder}) {
    $problem->AddInclude(Include => $include);
  }
  return $problem;
}

sub GenerateDomain {
  my ($self,%args) = @_;
  $args{Domain};
}

sub GenerateProblem {
  my ($self,%args) = @_;
  $args{Problem};
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
