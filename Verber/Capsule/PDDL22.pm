package Verber::Capsule::PDDL22;

use PerlLib::SwissArmyKnife;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / ContextDir WorldDir TemplateDir PrototypeDir Name DomainFile
   ProblemFile DomainFileFull ProblemFileFull DomainFileContents
   ProblemFileContents/

  ];

sub init {
  my ($self,%args) = @_;
  $self->ContextDir($args{ContextDir});
  $self->WorldDir($args{WorldDir});
  $self->TemplateDir($args{TemplateDir});
  $self->PrototypeDir($args{PrototypeDir});
  $self->Name($args{Name});
  my $nametr = lc($self->Name);
  $nametr =~ tr/_/\//;
  $self->DomainFile($nametr.".d.".$args{Extension});
  $self->ProblemFile($nametr.".p.".$args{Extension});
  $self->DomainFileFull($self->Dir."/".$self->DomainFile);
  $self->ProblemFileFull($self->Dir."/".$self->ProblemFile);
}

sub Dir {
  my ($self,%args) = @_;
  return $self->WorldDir;
}

1;
