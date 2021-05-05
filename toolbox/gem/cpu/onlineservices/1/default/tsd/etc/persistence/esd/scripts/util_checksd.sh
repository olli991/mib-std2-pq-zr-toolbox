# MIB2 script, part of the MIB High toolbox.
# Coded by Jille
# This script will determine if a SD card or USB drive is inserted.
# Modified for MIB STD2 PQ/ZR toolbox by Olli

unset VOLUME

# Find the volume with Toolbox folder
for i in 0 1 2 3 4
do
	if [ -d /media/mp00$i/toolbox ]; then
		export VOLUME=/media/mp00$i
		echo "Toolbox is found on" $VOLUME
		break
	fi
done

if [ -z $VOLUME ]; then
	echo "ERROR: No SD card or USB drive with toolbox folder were found"
	exit 1
fi
