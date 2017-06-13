# This script demonstrates transfer speed tracking. It slowly reads the given
# file, pauses for a few seconds, and then resumes reading the file 4x faster.

source config
$PX perl -e 'use Time::HiRes; $i=0;while(sysread(STDIN,$d,1)){Time::HiRes::sleep(.05);last if $i++>40} sleep 5; while(sysread(STDIN,$d,4)){Time::HiRes::sleep(.05)}' < $TINY_FILE > /dev/null
