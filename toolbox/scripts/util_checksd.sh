# MIB2 script, part of the MIB High toolbox.
# Coded by Jille
# This script will determine if a SD card is inserted.
# Modified for MIB2STD toolbox by Olli

# Is there any SD card inserted?
if [ -d /media/mp000/toolbox ]; then
    echo "Toolbox SD found"
    export VOLUME=/media/mp000
elif [ -d /media/mp001/toolbox ]; then
    echo "Toolbox SD found"
    export VOLUME=/media/mp001
elif [ -d /media/mp002/toolbox ]; then
    echo "Toolbox USB found"
    export VOLUME=/media/mp002
elif [ -d /media/mp003/toolbox ]; then
    echo "Toolbox USB found"
    export VOLUME=/media/mp003
elif [ -d /media/mp004/toolbox ]; then
    echo "Toolbox USB found"
    export VOLUME=/media/mp004
else 
    echo "No toolbox SD card found"
    exit 0
fi
