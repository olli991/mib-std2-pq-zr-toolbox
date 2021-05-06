#!/bin/ksh
# Original by Jille for MIB High toolbox.
# This script will uninstall the toolbox.
# Modified for MIB STD2 toolbox by Olli

echo "This script will uninstall the MIB STD2 Toolbox"
echo

# Mount system partition in read/write mode
. /tsd/etc/persistence/esd/scripts/util_mount.sh

# Delete Toolbox Green Engineering Menu screens
echo "Deleting Toolbox Green Engineering Menu screens..."
rm -f /tsd/etc/persistence/esd/mibstd2-*.esd

# Delete Toolbox scripts
echo "Deleting Toolbox scripts..."
rm -r /tsd/etc/persistence/esd/scripts

# Delete legacy toolbox screens and scripts
rm -f /tsd/etc/persistence/esd/mib2std-*.esd
rm -f /tsd/etc/persistence/esd/mibstd2_yox.esd
rm -f /tsd/etc/persistence/esd/TOOLBOX.esd
rm -f /tsd/etc/persistence/esd/mib2std_yox.esd
rm -rf /tsd/scripts

# Mount system partition in read/only mode
. /tsd/etc/persistence/esd/scripts/util_mount_ro.sh

echo
echo "Uninstallation is done. Please reopen Green Engineering Menu!"
exit 0