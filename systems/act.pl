#!/usr/bin/perl -w

# basic system for informing  the system about upcoming events, before
# they happen and possibly while or after they are happening.  it will
# then assist you in furthering those events

# for instance, you  might say you are going to the  store and it will
# print out the current shopping list,  or that you are going to sleep
# and it will set your alarm clock

# needs to know where you are

%events = {
	   "Getting ready to go to sleep" => ["",
					      "Print up the next days agenda"],
	   "Go to sleep" => ["Set the alarm clock"],
	   "Go to work" => ["Ride the bus"],
	   "Go to the store" => ["Print up the shopping list"],
	   "Eat" => ["Choose the next meal"],
	   "Ride the bus" => [""],
	  };

# interface  this  with SinLess  to  ensure  that  users are  properly
# briefed on what to avoid in each situation

# make sure this program works with all users
