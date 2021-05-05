#!/bin/ksh
echo "This script moves all SCREENSHOT_*.png from all drives"
echo "into one place - screenshot folder on the Toolbox's drive"
echo

# Locate Toolbox
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

OUT_PATH=$VOLUME/screenshots

# Check all possible mounts
for i in 0 1 2 3 4
do
	# Check for screenshots
	if [ -f /media/mp00$i/SCREENSHOT_*.png ]; then
		echo "Moving screenshots from /media/mp00$i to $OUT_PATH"
		# Create screenshots folder if absent
		if [ ! -d $OUT_PATH ]; then
			mkdir -p $OUT_PATH
		fi
		mv -v /media/mp00$i/SCREENSHOT_*.png $OUT_PATH/
		echo "Done."
		FOUND=yes
	fi
done

sync

if [ -z $FOUND ]; then
	echo "No screenshots were found."
else
	echo
	echo "Screenshot moving is finished."
fi
exit 0
