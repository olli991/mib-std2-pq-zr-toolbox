#!/bin/ksh
echo "Date:" $(date)

#INFO=$(awk -F "" '{for(i=1;i<=NF;i++) if($i~/[A-Z0-9]/) {printf $i} else {printf " "}}' /tsd/var/itr.timer.log 2>/dev/null | sed 's/\b\w\{1,3\}\b\s*//g')
INFO=$(sloginfo | grep ".devinfo" | tail -1 | sed 's/.*DevInfo: //')
VCRN=$(sloginfo | grep "VCRN:" | tail -1 | awk '{print $10}' 2>/dev/null)
if [ -z "$VCRN" ]; then
	VCRN='----------'
fi

echo "SW-Version:" $(echo $INFO | awk -F " |=" '{print $2}' 2>/dev/null) "HW-Version:" $(echo $INFO | awk -F " |=" '{print $4}' 2>/dev/null) "PartNum:" $(echo $INFO | awk -F " |=" '{print $6}' 2>/dev/null)
echo "SerNum:" $(echo $INFO |awk -F " |=" '{print $8}' 2>/dev/null) "Mileage:" $(echo $INFO |awk -F " |=" '{print $12}' 2>/dev/null) "VIN:" $(echo $INFO |awk -F " |=" '{print $14}' 2>/dev/null)
echo "Train:" $(awk '/46924065 401 25/ {print $4}' /tsd/var/persistence/.persistence.vault 2>/dev/null | sed 's/[^[:print:]]//g') "VCRN: $VCRN" 

addr=$((0x020D8000 + 0x024))
set -A RES $(in32 ${addr})
gpio5=$((16#${RES[2]}))
hwVersion=$((${gpio5}&(0x1f)))
hwVariant=$((((${gpio5}&(1<<5))|((${gpio5}&(0x3f<<10))>>4))>>5))
swdlVariant=$(awk -F "\015| " '/Variant/{print $3}' /tsd/var/swdownload/.swdownload.conf 2>/dev/null)
swdlHwVersion=$(awk -F "\015| " '/HwVersion/{print $3}' /tsd/var/swdownload/.swdownload.conf 2>/dev/null)
echo "hwVersion: $hwVersion hwVariant: $hwVariant SWDL hwVersion: $swdlHwVersion SWDL Variant: $swdlVariant" 

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
echo "GEM version: $GEM_VERSION"

echo
echo "J5 OS version:"
on -n J5 uname -a

echo
echo "iMX6 OS version:"
uname -a

echo
echo "Shell version:"
echo $KSH_VERSION

echo
echo "iMX6 memory:"
showmem -S

echo
echo "J5 memory:"
on -n J5 showmem -S

echo
echo "Processes running:"
ps -A

echo
echo "Mounts:"
mount

echo
echo "Filesystem                  Size      Used     Avail     Use%  Mounted on"
df -h

echo
echo "Filesystem root:"
ls -C /

echo
echo "Interface config:"
ifconfig

echo
echo "USB info:"
usb

echo "Collection of the information is finished."