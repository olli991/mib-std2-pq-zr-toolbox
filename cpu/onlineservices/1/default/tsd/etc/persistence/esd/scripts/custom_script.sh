#!/bin/ksh
# This script will run a custom script from SD card or USB drive
# By Olli

echo "NOTE: Use proper text editor so script lines end with Unix (LF)"
echo 
echo "Searching toolbox.sh on all mounted drives..."
for i in /media/mp00*; do
	if [ -f $i/toolbox.sh ]; then
		echo "Found on $i. Executing..."
		echo
		. $i/toolbox.sh & wait $!
		echo
		echo "Script execution finished"
		exit 0
	fi
done

echo "ERROR: toolbox.sh is not found."
exit 0