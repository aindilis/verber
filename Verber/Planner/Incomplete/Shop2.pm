package Verber::Planner::Shop2;

# This is a  planning interface.  This basically starts  up SHOP2 with
# the correct domain  and generates the plans and  then uses dialog to
# display them.

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Paths / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->Paths({});
  $self->Paths->{Domain} = ($args{Domain} || "Satellite");
  $self->Paths->{Resources} = ($args{Resources} || "Complex");

  $self->Paths->{Verber} = "/home/ajd/myfrdcsa/codebases/verber";
  $self->Paths->{Domains} = ConcatDir($self->Paths->{'Verber'},"IPC-2002");
  $self->Paths->{Shop2} = "/home/ajd/media/software/shop2-120";
  $self->Paths->{Shop2Exec} = ConcatDir($self->Paths->{Shop2},"shop2");
  $self->Paths->{Problems} = ConcatDir($self->Paths->{Domains}, $self->Paths->{Domain}, $self->Paths->{Resources},"hard_probs");
  $self->Paths->{Loader}  = ConcatDir($self->Paths->{Problems},"run.lisp");
  chdir $self->Paths->{Problems};
}

sub Execute {
  my ($self) = (shift);
  if (! -f "pfile1.lisp") {
    system "lisp -load problem-converter.lisp -batch";
  }
  system "lisp -load ".$self->Paths->{Shop2Exec}." -load ".$self->Paths->{Loader}." -batch";
}

sub ConcatDir {
  my @dirs = @_;
  my $flag = ($dirs[0] =~ /^\s*\//);
  map {s/\/*\s*$//g; s/^\s*\/*//g} @dirs;
  return ($flag ? "/" : "") . join '/',@dirs;
}

1;
