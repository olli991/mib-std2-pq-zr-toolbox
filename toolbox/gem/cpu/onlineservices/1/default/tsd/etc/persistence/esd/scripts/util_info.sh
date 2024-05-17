#!/bin/sh
# MIB2 script, part of the MIB High toolbox.
# Coded by Jille & Olli
# This script will show unit info on screen and write this data to variables for use in other scripts.
# Modified for MIB STD2 Toolbox by Olli, based on sysinfo by lprot
########################################################################################

#INFO=$(awk -F "" '{for(i=1;i<=NF;i++) if($i~/[A-Z0-9]/) {printf $i} else {printf " "}}' /tsd/var/itr.timer.log 2>/dev/null | sed 's/\b\w\{1,3\}\b\s*//g')
INFO=$(grep "STD_KEY_MU_VERSION:" /tmp/sloginfo | tail -1 | sed 's/.*STD_KEY_MU_VERSION: //')
export SWVER=$(echo $INFO | awk '{print substr($3,1,4)}' 2>/dev/null)

# Firmware version (Train)
export TRAIN=$(awk '/46924065 401 25/ {print $4}' /tsd/var/persistence/.persistence.vault 2>/dev/null | sed 's/[^[:print:]]//g')

# CPU type
export SYS=$(uname -m)

# Serial number
INFO=$(sloginfo | grep ".devinfo" | tail -1 | sed 's/.*DevInfo: //')
export SERIAL=$(echo $INFO |awk -F " |=" '{print $8}' 2>/dev/null)


# Car brand detection #### Needs to be recoded for MST ####
#export BRAND="$(/eso/bin/apps/pc i:0x286f058c:10 2> /dev/null)"
#if [ $BRAND == "1" ]; then
#	export BRAND="Volkswagen"
#elif [ $BRAND == "2" ]; then
#	export BRAND="Audi"
#elif [ $BRAND == "3" ]; then
#	export BRAND="Skoda"
#elif [ $BRAND == "4" ]; then
#	export BRAND="Seat"
#elif [ $BRAND == "5" ]; then
#	export BRAND="Porsche"
#elif [ $BRAND == "6" ]; then
#	export BRAND="Bentley"
#elif [ $BRAND == "7" ]; then
#	export BRAND="Lamborghini"
#else
#	export BRAND="No brand detected!"
#fi


#---------------------------------------------------------------------------------
# Output
#echo "---------------------------"
#echo Serial of this unit: "$SERIAL"
#echo Firmware version: "$TRAIN"
# echo Detected brand: "$BRAND"
#echo "---------------------------"
