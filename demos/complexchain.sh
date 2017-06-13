# This script demonstrates the ability to track processes across pipes and
# subshells automatically.

source config
cat $PLAIN_LOG <(zcat $GZIPPED_LOGS) | cat - <(zcat $GZIPPED_LOGS) | $PX cat -A | tail -n 1
