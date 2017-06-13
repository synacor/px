# This script demonstrates the ability to track newly generated processes.  The
# Perl script in the middle throttles data from `cat $f` to make the effect more
# visible.

source config
for f in $GZIPPED_LOGS; do cat $f | perl -e 'use Time::HiRes; $|=1; while(sysread(STDIN,$d,1)){print $d}'; done | $PX --maxdead 3 gunzip | tail -n 1
