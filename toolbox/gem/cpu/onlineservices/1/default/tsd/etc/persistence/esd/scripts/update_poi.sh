#!/bin/ksh
echo "This script will copy /PersonalPOI/MIB2TSD/ content from Toolbox"
echo "to non navi SD, so you are able to install with navi update fuction"
echo

for i in /media/mp00*; do
	if [[ -d "$i/toolbox" && -d "$i/PersonalPOI/mib2tsd" ]]; then
		SRC=$i/PersonalPOI/mib2tsd
		break
	fi
done
if [ -z "$SRC" ]; then
	echo "ERROR: Toolbox drive does not contain /PersonalPOI/mib2tsd"
	exit 1
fi

for i in /media/mp00*; do
	if [[ ! -d "$i/toolbox" && ! -d "$i/maps" ]]; then
		DST=$i
		break
	fi
done
if [ -z "$DST" ]; then
	echo "ERROR: Cannot find destination SD card!"
	exit 1
fi

echo "Source: $SRC"
echo "Destination: $DST"
echo "Copying..."
cp -rf "$SRC/*" "$DST/"
sync

echo
echo "Done. Now you can go to NAV->Setup->Update and install it :)"