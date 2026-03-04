#!/bin/ksh
# This script will dump all. Based on the script for MIB High Toolbox by Jille
# Modified for MIB STD2 toolbox by Olli

echo "This script will run all dump scripts (beside Developer files)"
echo "to copy files into dump folder of Toolbox SD card or USB drive."
echo

### System files ###
echo "Dumping SWAP file..."
. /tsd/etc/persistence/esd/scripts/dump_swap.sh > /dev/null & wait $!
echo "Dumping SWAP file is done."

echo "Dumping SWDL file..."
. /tsd/etc/persistence/esd/scripts/dump_swdl.sh > /dev/null & wait $!
echo "Dumping SWDL file is done."

echo "Dumping HMI file..."
. /tsd/etc/persistence/esd/scripts/dump_hmi.sh > /dev/null & wait $!
echo "Dumping HMI file is done."

# Check if custom FEC is present, otherwise skip this dump
if [ -f /tsd/etc/slist/signed_exception_list.txt ]; then
	echo "Dumping FEC (signed_exception_list.txt) file..."
	. /tsd/etc/persistence/esd/scripts/dump_fec.sh > /dev/null & wait $!
	echo "Dumping FEC file is done."
fi

echo "Dumping /etc/shadow file..."
. /tsd/etc/persistence/esd/scripts/dump_shadow.sh > /dev/null & wait $!
echo "Dumping /etc/shadow file is done."

## Sound dump scripts ##
echo "Dumping ringtones..."
. /tsd/etc/persistence/esd/scripts/dump_ringtones.sh > /dev/null & wait $!
echo "Dumping ringtones is done"

echo "Dumping system sounds..."
. /tsd/etc/persistence/esd/scripts/dump_sounds.sh > /dev/null & wait $!
echo "Dumping system sounds is done"

echo "Dumping text-to-speech sounds..."
. /tsd/etc/persistence/esd/scripts/dump_tts.sh > /dev/null & wait $!
echo "Dumping text-to-speech sounds is done"

## Graphic dump scripts ##
echo "Dumping navigation graphics..."
. /tsd/etc/persistence/esd/scripts/dump_mapcfg.sh > /dev/null & wait $!
echo "Dumping navigation graphics is done"

echo "Dumping skin files..."
. /tsd/etc/persistence/esd/scripts/dump_skins.sh > /dev/null & wait $!
echo "Dumping skin files is done"

echo "Dumping startup screens..."
. /tsd/etc/persistence/esd/scripts/dump_startanim.sh > /dev/null & wait $!
echo "Dumping startup screens is done"

echo "Dumping carplay oem icon..."
. /tsd/etc/persistence/esd/scripts/dump_carplayicon.sh > /dev/null & wait $!
echo "Dumping carplay oem icon is done"

## Database dump scripts ##
echo "Dumping radio station logo DB..."
. /tsd/etc/persistence/esd/scripts/dump_stationdb.sh > /dev/null & wait $!
echo "Dumping radio station logo DB is done"

echo
echo "Dumping is finished. You can now start tweaking the dumped stuff!"
exit 0