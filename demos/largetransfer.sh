# This script demonstrates the ability to monitor a large, high-speed transfer
# without any loss of speed.

source config
$PX dd if=$LARGE_FILE of=/dev/null
