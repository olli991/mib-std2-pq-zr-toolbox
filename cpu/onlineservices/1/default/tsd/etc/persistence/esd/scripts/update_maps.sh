#!/bin/ksh
echo "This script will remove /maps on the navi SD card"
echo "and copy /maps_new folder from another SD card"
echo

#Process all media drives to find source and destination drives with /maps folders
if [ -d /media/mp000/maps_new ]; then
	SRC=/media/mp000/maps_new
	DST=/media/mp001/maps
else
	DST=/media/mp000/maps
	SRC=/media/mp001/maps_new
fi

if [ ! -d "$SRC" ]; then
	echo "ERROR! $SRC is not found."
	exit 1
fi

echo "Removing $DST on navi SD..."
rm -rf "$DST"
if [ -d "$DST" ]; then
	echo "ERROR! Cannot remove $DST on navi SD."
	echo "Maybe SD card is locked for writing?"
	exit 1
fi

echo "Calculating number and size of files to copy..."
ls -Rl "$SRC"|awk '{if (substr($1,1,1)=="-"){count++;total+=$5}};END{printf "Copying %d files, size: %d to navi SD. Please wait...\n", count, total}';

COPIED=0
start=`date -t`

copy() {
	for i in "$1"/*;do
		if [ -d "$i" ];then
			#echo "mkdir $DST${i##$SRC}"
			mkdir -p "$DST${i##$SRC}"
			copy "$i"
		elif [ -f "$i" ]; then
			cpstart=`date -t`
			cp -f "$i" "$DST${i##$SRC}"
			((COPIED=COPIED+1))
			if ((`date -t`-cpstart > 30)); then
				echo "$COPIED cp ${i##$SRC}"
			fi
		fi
	done
}
copy "$SRC"

end=`date -t`

if ((end-start < 60)); then
        echo "Done in $((end-start)) second(s)."
else
        echo "Done in $(((end-start)/60)) minute(s)."
fi

ls -Rl "$DST"|awk '{if (substr($1,1,1)=="-"){count++;total+=$5}};END{printf "%d files copied. Size: %d\n", count, total}';

sync
