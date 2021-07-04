#!/bin/ksh
echo "This script will remove /maps folder on the navigation SD"
echo "and copy the new one from another SD/USB drive"
echo

#Process all media drives to find source and destination drives with /maps folders
SRC=""
NDSFILE=/maps/00/nds/product/product.nds
for i in /media/mp00*; do
	if [ -d $i/maps ]; then
		if [ -n "$SRC" ]; then
			if [ -n "$(awk -v num1=$(ls -l $SRC$NDSFILE|awk '{print $5}' 2>/dev/null) -v num2=$(ls -l $i$NDSFILE|awk '{print $5}' 2>/dev/null) 'BEGIN{if (num1>num2) print "true"}' 2>/dev/null)" ]; then
				SRC=$SRC/maps
				DST=$i/maps
			else
				DST=$SRC/maps
				SRC=$i/maps
			fi
			break
		fi
		SRC=$i
	fi
done

if [ -z "$DST" ]; then
	echo "ERROR: Cannot find a source drive with /maps folder!"
	exit 1
fi

echo "Calculating number of files to copy..."
FILENUM=0
list() {
	for i in "$1"/*; do
		if [ -d "$i" ];then
			list "$i"
		elif [ -f "$i" ]; then
			((FILENUM=FILENUM+1))
		fi
	done
}
list $SRC

echo "Removing /maps folder on the navigation SD..."
rm -rf "$DST"
if [ -d "$DST" ]; then
	echo "ERROR: Cannot remove $DST!"
	exit 1
fi

echo "Copying $FILENUM file(s) to navigation SD, please wait..."
(start=`date -t`

trap 'echo "File(s) copied: $COPIED"' USR1

copy() {
	for i in "$1"/*;do
		if [ -d "$i" ];then
			#echo "Mkdir: $DST${i##$SRC}"
			mkdir -p "$DST${i##$SRC}"
			copy "$i"
		elif [ -f "$i" ]; then
			#echo "Cp: $i to $DST${i##$SRC}"
			cp "$i" $DST${i##$SRC} &
			wait $!
			((COPIED=COPIED+1))
		fi
	done
}
copy "$SRC"

sync
echo "File(s) copied: $COPIED"
end=`date -t`
if ((end-start < 60)); then
	echo "Done in $((end-start)) second(s)."
else
	echo "Done in $(((end-start)/60)) minute(s)."
fi
kill -INT $$) &

CHPID=$!

trap 'kill $CHPID 2>/dev/null;exit 0' INT
while :; do
	sleep 30 &
	wait $!
	kill -USR1 $CHPID
done
