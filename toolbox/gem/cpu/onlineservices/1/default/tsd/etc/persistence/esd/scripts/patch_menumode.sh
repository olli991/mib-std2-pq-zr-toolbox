#!/bin/ksh
echo "This script will set UserSwitchableMenuMode=true in info.txt"
echo "of every skin to enable menu mode selection in the Setup menu."
echo

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh 

for i in /tsd/hmi/Resources/skin*; do
	if [ -f "$i/info.txt" ]; then
		echo "Processing $i/info.txt..."
		sed -i 's/UserSwitchableMenuMode=false/UserSwitchableMenuMode=true/g' $i/info.txt
	fi
done

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh 

echo
echo "Done. Please reboot the unit and find menu mode option in the Setup menu."
exit 0