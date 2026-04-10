#!/bin/ksh
echo "This script tests the connection of the unit to the Internet"
echo

echo "Pinging 8.8.8.8..."
ping -c 3 8.8.8.8 2>&1

echo
echo "Pinging www.google.com..."
ping -c 3 www.google.com 2>&1

echo
echo "Script execution finished."
exit 0