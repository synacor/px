# This script demonstrates the ability to track the same file open in forks and
# after seeking. It forks itself many times, and then each fork seeks somewhere
# in the given file, sleeps for a unique number of seconds, and exits.

source config
$PX perl -e 'use Time::HiRes;pipe X,Y;my$s=-s$ARGV[0];my$v=.5;my$o=.25;sub f{$v+=fork?$o:-$o;$o/=2}f()for 1..4;open(F,$ARGV[0]);seek(F,$s*$v,0);sleep($v*32);' $SMALL_FILE | cat
