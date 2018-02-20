package Verber::Util::Graph;

# we probably want to have some kind of object oriented interface to
# the model, which we then update which then reflects on the display

use Class::ISA;
use GraphViz;
use Text::Wrap;
use Tk;
use Tk::GraphViz;
use Ubigraph;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Type MyUbigraph MyGraphViz MyTkGraphViz MyMainWindow Edges
   Count Colors Entries Text H L LastScale MyMenu LastEvent LastTags /

  ];

my $entryText = '';

sub init {
  my ($self,%args) = @_;
  $self->Type($args{Type} || "Tk::GraphViz");
  $self->LastScale(2500.0);
  if ($self->Type eq "UbiGraph") {
    $self->MyUbigraph
      (Ubigraph->new);
    $self->MyUbigraph->clear;
    $self->Edges
      ({});
  } elsif ($self->Type eq "GraphViz") {
    $self->Count(0);
    $Text::Wrap::columns = 40;
    $self->MyGraphViz
      (GraphViz->new
       (directed => 1,
	rankdir => 'LR',
	node => {shape => 'record'}));
    $self->Text({});
    $self->H({});
    $self->L({});
  } elsif ($self->Type eq "Tk::GraphViz") {
    $self->MyTkGraphViz({});
    $self->MyTkGraphViz->{MainWindow} = MainWindow->new
      (
       -title => "Shared Priority System Editor",
       -width => 1024,
       -height => 768,
      );
    $self->MyTkGraphViz->{Scrolled} = $self->MyTkGraphViz->{MainWindow}->Scrolled
      (
       'GraphViz',
       -background => 'white',
       -scrollbars => 'sw',
      )->pack(-expand => '1', -fill => 'both' );

    $self->Count(0);
    $Text::Wrap::columns = 40;
    $self->MyGraphViz
      (GraphViz->new
       (
	directed => 1,
	rankdir => 'LR',
	node => {
		 shape => 'box',
		},
       ));
    $self->Text({});
    $self->H({});
    $self->L({});

    $self->MyMenu
      ($self->MyTkGraphViz->{MainWindow}->Menu());

    $self->MyMenu->add('command', -label => 'Dismiss Menu', -command => sub {});
    $self->MyMenu->add
      (
       'command',
       -label => 'Mark Task as Complete',
       -command => sub {
	 my %args = @{$self->LastTags};
	 my $node = $args{node};
	 if ($node =~ /^node(\d+)$/) {
	   my $id = $1;
	   $self->MyGraphViz->{NODES}->{$id}->{fillcolor} = "darkgray";
	   my $ref = ref $self->MyTkGraphViz->{Scrolled};
	   print Dumper(Class::ISA::super_path($ref));
	   $self->MyTkGraphViz->{Scrolled}->show( $self->MyGraphViz );
	   # $self->MyTkGraphViz->{Scrolled}->zoom(-in => $self->LastScale);
	 }
       },
      );
    $self->MyMenu->add('command', -label => 'Cancel Task', -command => sub {});
    $self->MyMenu->add('command', -label => 'Hide Node', -command => sub {});
    $self->MyMenu->add('command', -label => 'Similarity Search', -command => sub {});
    $self->MyMenu->add('command', -label => 'Explain Holdup', -command => sub {});
    $self->MyMenu->add('command', -label => 'Add Subtasks', -command => sub {});
    $self->MyMenu->add('command', -label => 'Dispute Task', -command => sub {});
  }
  $self->Colors
    ({
      "Ubigraph" => {
		     "depends" => "#FF0000",
		     "provides" => "#0000FF",
		     "eases" => "#00FF00",
		    },
      "GraphViz" => {
		     "depends" => "red",
		     "provides" => "blue",
		     "eases" => "green",
		    },
      "Tk::GraphViz" => {
			 "depends" => "red",
			 "provides" => "blue",
			 "eases" => "green",
			},
     });
}

sub AddNode {
  my ($self,%args) = @_;
  my $size = 25;
  my $label = substr($args{EN},0,$size);
  if ($self->Type eq "Ubigraph") {
    my %args2 = (
		 label => $args{FullEntry},
		);
    $self->Entries->{$args{EN}} = $self->MyUbigraph->Vertex
      (
       %args2,
      );
  } elsif ($self->Type eq "GraphViz") {
    $self->Text->{$label} = myformat($args{FullEntry});
    $self->Count($self->Count + 1);
    $self->H->{$label} = $self->Count;
    $self->MyGraphViz->add_node($self->H->{$label}, label => $self->Text->{$label});
  } elsif ($self->Type eq "Tk::GraphViz") {
    $self->Text->{$label} = myformat($args{FullEntry});
    $self->Count($self->Count + 1);
    $self->H->{$label} = $self->Count;
    $self->MyGraphViz->add_node
      (
       $self->H->{$label},
       label => $self->Text->{$label},
       style => 'filled',
       color => 'black',
       fillcolor => 'lightgray',
      );
  }
}

sub AddEdge {
  my ($self,%args) = @_;
  my $entryname1 = $args{EN1};
  my $entryname2 = $args{EN2};
  my $size = 25;
  my $label1 = substr($entryname1,0,$size);
  my $label2 = substr($entryname2,0,$size);
  if ($self->Type eq "Ubigraph") {
    my $edge = $self->MyUbigraph->Edge
      (
       $self->Entries->{$entryname1},
       $self->Entries->{$entryname2},
       arrow => "true",
       color => $self->Colors->{"Ubigraph"}->{$args{Pred}},
      );
    $self->Edges->{$entryname1}->{$entryname2} = $edge;
  } elsif ($self->Type eq "GraphViz") {
    # $self->L->{$label1}->{$label2} = 1;
    $self->MyGraphViz->add_edge
      (
       $self->H->{$label1} => $self->H->{$label2},
       label => $args{Pred},
       color => $self->Colors->{"GraphViz"}->{$args{Pred}},
      );
  } elsif ($self->Type eq "Tk::GraphViz") {
    # $self->L->{$label1}->{$label2} = 1;
    $self->MyGraphViz->add_edge
      (
       $self->H->{$label1} => $self->H->{$label2},
       label => $args{Pred},
       color => $self->Colors->{"GraphViz"}->{$args{Pred}},
      );
  }
}

sub Display {
  my ($self,%args) = @_;
  if ($self->Type eq "Ubigraph") {
    # nothing to do here, it's a dynamic visualizer
  } elsif ($self->Type eq "GraphViz") {
    my $fn = "/var/lib/myfrdcsa/codebases/internal/verber/data/psex.jpg";
    print Dumper($self->MyGraphViz);
    $self->MyGraphViz->as_jpeg($fn);
    system "xview \"$fn\"";
  } elsif ($self->Type eq "Tk::GraphViz") {
    my $instrumentationframe = $self->MyTkGraphViz->{MainWindow}->Frame;
    my $entry = $instrumentationframe->Entry
      (
       -width => 80,
       -textvariable => \$entryText,
      )->pack
	(
	 -side => 'bottom',
	 -expand => '1',
	 -fill => 'x',
	 -pady => 2,
	);
    $self->MyTkGraphViz->{Scale} = $instrumentationframe->Scale
      (
       -orient => "horizontal",
       -from => 0,
       -to => 5000,
      )->pack(-side => "right");
    $self->MyTkGraphViz->{Scale}->set(2500.0);
    $instrumentationframe->pack
      (
       -side => 'bottom',
       -fill => 'none',
       -expand => 0,
      );

    $self->MyTkGraphViz->{Scrolled}->show( $self->MyGraphViz );
    $self->MyTkGraphViz->{Scrolled}->zoom(-in => $self->LastScale);
    $self->MyTkGraphViz->{Scrolled}->createBindings();
    $self->MyTkGraphViz->{Scrolled}->bind
      (
       'all',
       '<3>',
       sub {
	 $self->LastTags([$self->MyTkGraphViz->{Scrolled}->gettags('current')]);
	 pop @{$self->LastTags};
	 $self->ShowMenu(@_);
       },
      );
    $self->MyMainLoop();
  }
}

sub MyMainLoop {
  my ($self,%args) = @_;
  $self->MyTkGraphViz->{Scrolled}->repeat(1, sub {$self->Check()});
  MainLoop();
}

sub Check {
  my ($self,%args) = @_;
  my $scale = $self->MyTkGraphViz->{Scale}->get();
  if ($self->LastScale != $scale) {
    my $adjustment = $scale / $self->LastScale;
    $self->LastScale($scale);
    print Dumper({
		  Scale =>  $scale,
		  Adjustment => $adjustment,
		 }) if 0;
    $self->MyTkGraphViz->{Scrolled}->zoom(-in => $adjustment);
  }
}

sub ShowMenu {
  my ($self,@items) = @_;
  my $w = shift @items;
  my $Ev = $w->XEvent;
  $self->LastEvent($Ev);
  $self->MyMenu->post($Ev->X, $Ev->Y);
}

sub myformat {
  my $text = shift;
  $text =~ s/-/ /g;
  $text = wrap('', '', $text);
  $text =~ s/\n/\\n/g;
  return $text;
}

1;

sub remove_node {
  my $self = shift;
  my $node = shift;

  # Cope with the new simple notation
  if (ref($node) ne 'HASH') {
    my $name = $node;
    my %node;
    if (@_ % 2 == 1) {
      # No name passed
      %node = ($name, @_);
    } else {
      # Name passed
      %node = (@_, name => $name);
    }
    $node = \%node;
  }

  $self->add_node_munge($node) if $self->can('add_node_munge');

  # The _code attribute is our internal name for the node
  $node->{_code} = $self->_quote_name($node->{name});

  if (not exists $node->{name}) {
    $node->{name} = $node->{_code};
  }

  if (not exists $node->{label})  {
    if (exists $self->{NODES}->{$node->{name}} and defined $self->{NODES}->{$node->{name}}->{label}) {
      # keep our old label if we already exist
      $node->{label} = $self->{NODES}->{$node->{name}}->{label};
    } else {
      $node->{label} = $node->{name};
    }
  } else {
    $node->{label} =~ s#([|<>\[\]{}"])#\\$1#g unless $node->{shape} &&
      ($node->{shape} eq 'record' || ($node->{label} =~ /^<</ && $node->{shape} eq
				      'plaintext'));
  }

  delete $node->{cluster}
    if exists $node->{cluster} && !length $node->{cluster} ;

  $node->{_label} =  $node->{label};

  # Deal with ports
  if (ref($node->{label}) eq 'ARRAY') {
    $node->{shape} = 'record'; # force a record
    my $nports = 0;
    $node->{label} = join '|', map
      { $_ =~ s#([|<>\[\]{}"])#\\$1#g; '<port' . $nports++ . '>' . $_ }
      (@{$node->{label}});
  }

  # Save ourselves
  if (!exists($self->{NODES}->{$node->{name}})) {
    $self->{NODES}->{$node->{name}} = $node;
  } else {
    # If the node already exists, add or overwrite attributes.
    foreach (keys %$node) {
      $self->{NODES}->{$node->{name}}->{$_} = $node->{$_};
    }
  }

  $self->{CODES}->{$node->{_code}} = $node->{name};

  # Add the node to the nodelist, which contains the names of
  # all the nodes in the order that they were inserted (but only
  # if it's not already there)
  push @{$self->{NODELIST}}, $node->{name} unless
    grep { $_ eq $node->{name} } @{$self->{NODELIST}};

  return $node->{name};
}

sub add_edge {
  my $self = shift;
  my $edge = shift;

  # Also cope with simple $from => $to
  if (ref($edge) ne 'HASH') {
    my $from = $edge;
    my %edge = (from => $from, to => shift, @_);
    $edge = \%edge;
  }

  $self->add_edge_munge($edge) if $self->can('add_edge_munge');

  if (not exists $edge->{from} or not exists $edge->{to}) {
    carp("GraphViz add_edge: 'from' or 'to' parameter missing!");
    return;
  }

  my $from = $edge->{from};
  my $to = $edge->{to};
  $self->add_node($from) unless exists $self->{NODES}->{$from};
  $self->add_node($to) unless exists $self->{NODES}->{$to};

  push @{$self->{EDGES}}, $edge; # should remove!
}
