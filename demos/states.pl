#!/usr/bin/perl -w
use strict;

# This script sets up a process in each state that px can display. The
# running ("R") state goes into an infinite loop, so try not to leave this
# script running if you value your CPU cycles. Press ctrl-C to exit.

use Time::HiRes;

sub subprocess (&) {
  my $child_pid = fork;
  die "failed to fork: $!" unless defined $child_pid;
  return $child_pid if $child_pid;
  $_[0]();
  exit;
}

my $root_pid = $$;

print "Press ctrl-C to exit.\n";

# attach px to our process
subprocess {
  system("/bin/sh", "-c", "source config && \$PX --pid $root_pid");
};

do {
  no warnings 'once';
  pipe X,Y;
};

# R = running
subprocess {
  while(1){}
};

# T = stopped
kill 19 => subprocess {
  sleep;
};

# X = dead
my $dead_pid = subprocess {
  Time::HiRes::sleep .2; #wait briefly to be noticed
};
waitpid $dead_pid, 0;

# Z = zombie
subprocess {
  Time::HiRes::sleep .2; #wait briefly to be noticed
};
# and don't waitpid() it

# S = sleep
sleep;
