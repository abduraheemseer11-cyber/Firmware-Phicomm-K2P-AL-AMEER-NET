#!/bin/sh
# Run this ON the existing KM08-708H (the one that already runs the vendor OpenWrt build).
#   scp scripts/dump-device-info.sh root@<router-ip>:/tmp/ && ssh root@<router-ip> sh /tmp/dump-device-info.sh
# Output: /tmp/km08-dump.tar.gz  (copy it off with scp). Read-only: nothing is written to flash.
#   FULL=1  also dumps kernel/ubi/firmware partitions (large; stream them with ssh instead if /tmp is small)

OUT=/tmp/km08-dump
rm -rf "$OUT" /tmp/km08-dump.tar.gz; mkdir -p "$OUT/mtd"

ubus call system board           > "$OUT/board.json"      2>&1
cat /proc/mtd                    > "$OUT/proc-mtd.txt"
cat /proc/cpuinfo                > "$OUT/cpuinfo.txt"
cat /proc/meminfo | head -3      > "$OUT/meminfo.txt"
cat /proc/interrupts             > "$OUT/interrupts.txt"
dmesg                            > "$OUT/dmesg.txt"
iwinfo                           > "$OUT/iwinfo.txt"      2>&1
iw phy                           > "$OUT/iw-phy.txt"      2>&1
ip -d link                       > "$OUT/ip-link.txt"     2>&1
ls -l /sys/class/leds            > "$OUT/leds.txt"        2>&1
ls -l /sys/class/gpio            > "$OUT/gpio.txt"        2>&1
cat /etc/board.json              > "$OUT/etc-board.json"  2>&1
cat /etc/config/network /etc/config/wireless > "$OUT/etc-config.txt" 2>&1
opkg list-installed              > "$OUT/packages.txt"    2>&1
mount                            > "$OUT/mount.txt"

# the compiled device tree of the running kernel (this contains the real GPIOs, MAC cells, eeprom offsets)
if [ -r /sys/firmware/fdt ]; then
	cp /sys/firmware/fdt "$OUT/device.dtb"
else
	tar cf "$OUT/device-tree.tar" -C /proc/device-tree . 2>/dev/null
fi
command -v dtc >/dev/null 2>&1 && [ -f "$OUT/device.dtb" ] && dtc -I dtb -O dts "$OUT/device.dtb" > "$OUT/device.dts" 2>/dev/null

# raw copies of the small partitions
while read -r dev size erase name; do
	case "$dev" in mtd*:) ;; *) continue ;; esac
	n=${dev%:}; name=${name//\"/}
	case "$name" in
		u-boot|u-boot-env|factory|bdinfo|nvram) cat "/dev/$n" > "$OUT/mtd/$n-$name.bin" ;;
		kernel|ubi|firmware|recoverk|recoverr|log) [ "$FULL" = "1" ] && cat "/dev/$n" > "$OUT/mtd/$n-$name.bin" ;;
	esac
done < /proc/mtd

tar czf /tmp/km08-dump.tar.gz -C /tmp km08-dump
ls -lh /tmp/km08-dump.tar.gz
echo "Done. The archive contains your MAC addresses and wifi calibration - share it privately."
