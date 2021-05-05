#!/bin/ksh
# This script will run a custom script from SD card or USB drive
# By Olli

echo "NOTE: Use proper text editor so script lines end with Unix (LF)"
echo 
echo "Searching toolbox.sh on all mounted drives..."
for i in 0 1 2 3 4
do
	if [ -f /media/mp00$i/toolbox.sh ]; then
		echo "Found on /media/mp00$i/. Executing..."
		echo
		. /media/mp00$i/toolbox.sh & wait $!
		echo
		echo "Script execution finished"
		exit 0
	fi
done

echo "ERROR: toolbox.sh is not found."
