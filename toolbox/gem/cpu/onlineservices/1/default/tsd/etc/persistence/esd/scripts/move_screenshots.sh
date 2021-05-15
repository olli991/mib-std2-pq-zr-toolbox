#!/bin/ksh
echo "This script moves SCREENSHOT_*.png from root of all drives"
echo "into one place - screenshots folder on the Toolbox's drive"
echo

# Locate Toolbox
. /tsd/etc/persistence/esd/scripts/util_checksd.sh

OUT_PATH=$VOLUME/screenshots

# Check all possible mounts
for i in /media/mp00*; do
	echo "Moving from $i to $OUT_PATH"
	# Create screenshots folder if absent
	if [ ! -d $OUT_PATH ]; then
		mkdir -p $OUT_PATH
	fi
	mv -f $i/SCREENSHOT_*.png $OUT_PATH/ 2> /dev/null
done
sync
echo
echo "Done."
exit 0
