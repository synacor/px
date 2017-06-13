# This script demonstrates the ability to track progress of a process that
# reads a file backwards, just for fun. (The progress goes from 100% to 0%).

source config
$PX tac $LARGE_FILE > /dev/null
