# MIB2 script, part of the MIB High toolbox.
# Coded by Jille
# This script will determine if a SD card or USB drive is inserted.
# Modified for MIB STD2 PQ/ZR toolbox by Olli

unset VOLUME

# Find the volume with Toolbox folder
for i in /media/mp00*; do
	if [ -d $i/toolbox ]; then
		export VOLUME=$i
		echo "Toolbox is found on" $VOLUME
		break
	fi
done

if [ -z $VOLUME ]; then
	echo "ERROR: No SD card or USB drive with toolbox folder were found"
	exit 1
fi