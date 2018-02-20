#!/usr/bin/perl -w

# this is responsible for knowing  how to invoke various other systems
# to generate PDDL files we need.

# should know how long each takes, by timing, logging, and predicting.

use MyFRDCSA qw (ConcatDir Dir);

my %AgentRegistry = (
		     "Audience" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"audience","audience"). " -u -a OSCAR",
		      UniLangCommand => "",
		     },
		     "Broker" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"broker","broker") . " -u",
		      UniLangCommand => "",
		     },
		     "BusRoute" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"busroute","busroute") . " -u",
		      UniLangCommand => "",
		     },
		     "CLEAR" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"clear","clear") . " -u -r",
		      UniLangCommand => "",
		     },
		     "Corpus" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"corpus","browser.pl"),
		      UniLangCommand => "",
		     },
		     "Manager" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"manager","manager") . " -u",
		      UniLangCommand => "",
		     },
		     "OpenCyc" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"opencyc-common",
				"opencyc.pl") . " -a",
		      UniLangCommand => "",
		     },
		     "PSE" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"pse","pse"),
		      UniLangCommand => "",
		     },
		     "Sorcerer" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"sorcerer","sorcerer") . " -u",
		      UniLangCommand => "",
		     },
		     "Unilang-Client" =>
		     {
		      ShellCommand =>
		      ConcatDir(Dir("internal codebases"),
				"unilang","unilang-client"),
		      UniLangCommand => "",
		     },
		    );

my $prog = ConcatDir(Dir("internal codebases"),"unilang","unilang");

system "$prog &";
sleep 1;

while ($agent = shift @ARGV) {
  system "$AgentRegistry{$agent}" . (@ARGV ? " &" : "");
}


