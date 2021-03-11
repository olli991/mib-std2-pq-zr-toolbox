# MIB2 script, part of the MIB High toolbox.
# Coded by Jille
# This script will determine if an SD is inserted.
# Modified for MIB2STD toolbox by Olli

#Is there any SD card inserted?
if [ -d /media/mp000 ]
then
    echo "SD in slot 1 found"
    export VOLUME=/media/mp000
elif [ -d /media/mp001 ]
then
    echo "SD in slot 2 found"
    export VOLUME=/media/mp001
else 
    echo "No SD cards found"
    exit 0
fi