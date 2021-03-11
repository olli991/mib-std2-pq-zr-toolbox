#!/bin/ksh
echo "Welcome on Technisat console by Yox... You can now easly brick this unit... ;) ;) ;)"
export TSD_COMMON_CONFIG=/tsd/etc/system/tsd.mibstd2.main.root.conf
export TSD_LOGCHANNEL=J5e

echo /net/J5/dev/ser1 \"/bin/login -f root\" qansi-m on > /net/J5/tmp/ttys
on -f imx6 /sbin/tinit -f /net/J5/tmp/ttys &
sleep 10
on -p25 /tsd/bin/system/tsd.mibstd2.config.memwatch 4194304 'echo "\$mem" > /proc/dumper' &
on -f imx6 inetd
on -f imx6 qconn
on -f imx6 waitfor /dev/pf
on -f imx6 pfctl -d
sleep 1
mount -t qnx6 -o remount,rw /dev/hd0t177 /

