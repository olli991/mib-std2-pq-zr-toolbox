#!/bin/ksh
GEM_SIZE=$(ls -la '/tsd/hmi/HMI/jar/GEM.jar' | awk '{print $5}' 2>/dev/null)
GEM_VERSION="Unknown, size $GEM_SIZE"
if [ "$GEM_SIZE" = "187047" ]; then
	GEM_VERSION="3.4t"
elif [ "$GEM_SIZE" = "187234" ]; then
	GEM_VERSION="3.5t"
elif [ "$GEM_SIZE" = "242383" ]; then
	GEM_VERSION="4.3t"
elif [ "$GEM_SIZE" = "250770" ]; then
	GEM_VERSION="4.11t"
elif [ "$GEM_SIZE" = "250996" ]; then
	GEM_VERSION="4.12t"
fi
TOOLBOX_VERSION=$(awk '/Version:/{print $NF}' /tsd/etc/persistence/esd/mibstd2-main.esd 2>/dev/null)
echo "Date: $(date) GEM version: $GEM_VERSION Toolbox: $TOOLBOX_VERSION"

sloginfo >/tmp/sloginfo

INFO=$(grep "STD_KEY_MU_VERSION:" /tmp/sloginfo | tail -1 | sed 's/.*STD_KEY_MU_VERSION: //')
VIN=$(grep "vin=" /tmp/sloginfo | tail -1 | sed 's/.*vin=//')
if [ -z "$VIN" ]; then
	VIN='--------------'
fi
INFO2=$(grep ".devinfo" /tmp/sloginfo | tail -1 | sed 's/.*DevInfo: //')
if [ -z "$INFO2" ]; then
	SERNUM='----------'
	MILEAGE='----------'
else
	SERNUM=$(echo $INFO2 | sed 's/.*SerNum=\(.*\) Wdog=.*/\1/' 2>/dev/null)
	MILEAGE=$(echo $INFO2 | sed 's/.*Mileage=\(.*\) VIN=.*/\1/' 2>/dev/null)
fi
VCRN=$(grep "VCRN:" /tmp/sloginfo | tail -1 | awk '{print $10}' 2>/dev/null)
if [ -z "$VCRN" ]; then
	VCRN='----------'
fi
echo "SW-Version: $(echo $INFO | awk '{print substr($3,1,4)}' 2>/dev/null) HW-Version: $(echo $INFO | awk '{print substr($3,5)}' 2>/dev/null) PartNum: $(echo $INFO | awk '{print $1}' 2>/dev/null) HW: $(echo $INFO | awk '{print $2}' 2>/dev/null)"
echo "VIN: $VIN SerNum: $SERNUM Mileage: $MILEAGE"
echo "Train:" $(awk '/46924065 401 25/ {print $4}' /tsd/var/persistence/.persistence.vault 2>/dev/null | sed 's/[^[:print:]]//g') "VCRN: $VCRN"

swdlHwVersion=$(awk -F "\015| " '/HwVersion/{print $3+1}' /tsd/var/swdownload/.swdownload.conf 2>/dev/null)
swdlVariant=$(awk -F "\015| " '/Variant/{print $3}' /tsd/var/swdownload/.swdownload.conf 2>/dev/null)
echo "SWDL HwVersion: $swdlHwVersion SWDL Variant: $swdlVariant" 

RF_MODULE=$(grep "hw version = " /tmp/sloginfo | tail -1)
if [ -n "$RF_MODULE" ]; then
	RF_MODULE_HW=$(echo $RF_MODULE | awk -F 'hw version = |fw version = ' '{printf "%x",strtonum($2)}' 2>/dev/null)
	RF_MODULE_FW=$(echo $RF_MODULE | awk -F 'hw version = |fw version = ' '{printf "%X",strtonum($3)}' 2>/dev/null)
else
	RF_MODULE=$(grep ", hardware=" /tmp/sloginfo | tail -1)
	RF_MODULE_HW=$(echo $RF_MODULE | awk -F 'hardware=|firmware=' '{printf "%x",strtonum($2)}' 2>/dev/null)
	RF_MODULE_FW=$(echo $RF_MODULE | awk -F 'hardware=|firmware=' '{printf "%X",strtonum($3)}' 2>/dev/null)
fi
case $RF_MODULE_HW in
	101a)
		RF_MODULE="Alps UGZZF-1 01A (BT+WiFi) FW: $RF_MODULE_FW" ;;
	201a)
		RF_MODULE="Alps UGZZF-2 01A (BT only) FW: $RF_MODULE_FW" ;;
	1a1a)
		RF_MODULE="Alps UGZZF-1 A1A (BT+WiFi) FW: $RF_MODULE_FW" ;;
	2a1a)
		RF_MODULE="Alps UGZZF-2 A1A (BT only) FW: $RF_MODULE_FW" ;;
	*)
		RF_MODULE="Unknown, ID: $RF_MODULE_HW, FW: $RF_MODULE_FW" ;;
esac
echo "RF module: $RF_MODULE"
GPS_MODULE=$(awk -F "Info ] " '/\[Info \] GNSS-Module/{print $2}' /tmp/sloginfo 2>/dev/null)
if [ -n "$GPS_MODULE" ]; then
	echo $GPS_MODULE
fi

rm -f /tmp/sloginfo
echo
if [ -d /net/imx6 ]; then
	echo "J5 $(on -f J5 /net/imx6/bin/pidin info) "
	echo "$(on -n J5 uname -a)"
	echo
	echo "iMX6 $(pidin info)"
else
	echo "J5 $(pidin info)"
fi
echo "$(uname -a)"
echo "Shell version: $KSH_VERSION"
echo
echo "Mounts:"
mount
echo
echo "Filesystem                  Size      Used     Avail     Use%  Mounted on"
df -h
echo
echo "J5 root:"
if [ -d /net/imx6 ]; then
	ls -C /net/J5/
	echo
	echo "iMX6 root:"
fi
ls -C /
echo
echo "Interface config:"
ifconfig
echo
echo "USB info:"
usb
echo "Collection of the information has finished."
