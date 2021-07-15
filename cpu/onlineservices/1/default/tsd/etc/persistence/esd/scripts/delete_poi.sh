#!/bin/ksh
echo "This script will delete /personalpoi and metainfo2.txt from SD card"
echo

for i in /media/mp00*; do
	if [[ ! -d "$i/toolbox" && -d "$i/personalpoi" ]]; then
		echo "Found /personalpoi on $i. Deleting..."
		rm -r "$i/personalpoi"
		rm "$i/metainfo2.txt"
	fi
done

echo
echo "Done."