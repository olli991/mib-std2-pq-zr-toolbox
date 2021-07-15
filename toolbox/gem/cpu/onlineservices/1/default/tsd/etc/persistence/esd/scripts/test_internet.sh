#!/bin/ksh
echo "This script tests the connection of the unit to the Internet"
echo

echo "Pinging 8.8.8.8..." &
wait $!
ping -c 3 8.8.8.8

echo "Pinging www.google.com..." &
wait $!
ping -c 3 www.google.com

echo
echo "Script execution finished."
exit 0