# Here is an example,

my $taskhash =
  {
   Task-103032423 =>
   {
    Description => "Next time I go to Brian's, set up Server.",
    Operation => "(durative-action SetUpServer-1023
	(preconditions
		(and
			(at AndrewDougherty BrianSammonsApartment))
	)
	(effects
		(and
			(FinishedTask 103032423)
		)
	)
)",
    Comments => "Note that there is a type of
		  interaction here, meaning, next time I go, don't go,
		  unless I am already there.  Maybe this could be
		  modelled by intent.  I.e., don't go if just for
		  this.  The notion is that there will be some more
		  important task.  Or that, there is inherent risk
		  involved.  The risk will be computed by the addition
		  of a risk value for the durative actions of the
		  transportation to there, and in pursuit of the goal
		  of minimizing risk, this should be automatically
		  taken into account.  Still, how do you explicitly
		  state this.",
   },
   Task-103124312 =>
   {
    Description => "Remember to IM Stallman as soon as you finish Verber",
    Operation => "",
    Comments => "",
   },
   Task-103124312 =>
   {
    Description => "",
    Operation => "",
    Comments => "",
   },
  };
