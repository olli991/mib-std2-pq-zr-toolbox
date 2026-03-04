#!/bin/ksh
export TOPIC=tts
export MIBPATH=/tsd/etc/speech/tts/tones/Tones22kHz16Bitmono
export SDPATH=$TOPIC
export TYPE="folder"

echo "This script will dump tts"
. /tsd/etc/persistence/esd/scripts/util_dump.sh
 