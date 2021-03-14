#!/bin/ksh
# This script will dump all. Based on the script for MIB High Toolbox by Jille
# Modified for MIB2STD toolbox by Olli

# Info
DESCRIPTION="This script will dump everything to SD card"

echo $DESCRIPTION
echo 
sleep 2

# . /eso/hmi/engdefs/scripts/mqb/util_info.sh # For later

# Check if SD card is inserted
. /tsd/scripts/util_checksd.sh

#Make dump folders
DUMPPATH=$VOLUME/dump

echo "Creating dump folders on SD card"
mkdir -p $DUMPPATH
echo 
sleep 1

# Include all dump scripts
echo "Dumping, please wait..."
sleep 1

### System dump scripts ###
echo "Dumping SWAP file"
. /tsd/scripts/dump_swap.sh > /dev/null & wait $!
echo "SWAP file dump done"
sleep 1

echo "Dumping SWDL file"
. /tsd/scripts/dump_swdl.sh > /dev/null & wait $!
echo "SWDL file dump done"
sleep 1

echo "Dumping HMI file"
. /tsd/scripts/dump_hmi.sh > /dev/null & wait $!
echo "HMI file dump done"
sleep 1

# Check if custom FEC is present, otherwise skip this dump
if [ -f /tsd/etc/slist/signed_exception_list.txt ]; then
	echo "Dumping FEC file"
	. /tsd/scripts/dump_fec.sh > /dev/null & wait $!
	echo "FEC file dump done"
	sleep 1
fi

echo "Dumping Mirrorlink config file"
. /tsd/scripts/dump_mirrorlink.sh > /dev/null & wait $!
echo "Mirrorlink config file dump done"
sleep 1

echo "Dumping navigation config file"
. /tsd/scripts/dump_nav.sh > /dev/null & wait $!
echo "Navigation config file dump done"
sleep 1

echo "Dumping shadow file"
. /tsd/scripts/dump_shadow.sh > /dev/null & wait $!
echo "Shadow file dump done"
sleep 1

## Sound dump scripts ##
echo "Dumping ringtones"
. /tsd/scripts/dump_ringtones.sh > /dev/null & wait $!
echo "Ringtones dump done"
sleep 1

echo "Dumping system sounds"
. /tsd/scripts/dump_sounds.sh > /dev/null & wait $!
echo "System sounds dump done"
sleep 1

## Graphic dump scripts ##
echo "Dumping navigation graphics. This will take some time"
. /tsd/scripts/dump_mapcfg.sh > /dev/null & wait $!
echo "Navigation graphics dump done"
sleep 1

echo "Dumping skin files. This will take some time"
. /tsd/scripts/dump_skins.sh > /dev/null & wait $!
echo "Skin files dump done"
sleep 1

echo "Dumping startup screens"
. /tsd/scripts/dump_startanim.sh > /dev/null & wait $!
echo "Startup screens dump done"
sleep 1

# Done
echo 
echo "All dumps done. You can now start tweaking the dumped stuff!"

exit 0
