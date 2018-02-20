package Verber::Visualizer;

# use Manager::Dialog qw(ApproveCommands);
use MyFRDCSA;

use File::Basename;
use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Commands World / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->Commands
    ($args{Commands} ||
     {
      showsoln => $UNIVERSAL::systemdir."/data/support-tools/ShowSoln",
      validate => "echo",
      vega => "java -classpath ".$UNIVERSAL::systemdir."/data/support-tools/Vega.jar Vega",
     });
  $self->World($args{World});
}

sub PrintSolution {
  my $self = shift;
  my $file = basename($self->World->SolFile);
  print `pwd`;
  print "$file\n";
  if (-e $file) {
    my $res = `cat $file`;
    print $res."\n";
  }
}

sub Display {
  my $self = shift;
  $self->GenerateGanttChart and $self->DisplayGanttChart;
}

sub GenerateGanttChart {
  my ($self) = (shift);
  chdir "/var/lib/myfrdcsa/codebases/releases/verber-0.1/verber-0.1";
  if (-e ConcatDir($self->World->SolutionDir,$self->World->SolFile)) {
    my $command = join
      (" ",
       ($self->Commands->{showsoln},
	ConcatDir($self->World->SolutionDir,$self->World->SolFile),
	ConcatDir($self->World->SolutionDir,$self->World->SceneFile)));
    print "<<<$command>>>\n";
    my $results = `$command`;
    print $results."\n";
    return 1;
  }
}

sub DisplayGanttChart {
  my ($self,$scenefile) = (shift,shift);
  chdir "/var/lib/myfrdcsa/codebases/releases/verber-0.1/verber-0.1";
  if (-e ConcatDir($self->World->SolutionDir,$self->World->SceneFile)) {
    my $command = join
      (" ",
       ($self->Commands->{vega},
	ConcatDir($self->World->SolutionDir,$self->World->SceneFile)));
    print "<<<$command>>>\n";
    my $results = `$command`;
    print $results."\n";
    return 1;
  }
}

1;
