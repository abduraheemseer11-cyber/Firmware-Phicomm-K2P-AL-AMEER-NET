#!/bin/bash
# Adds the KM08-708H device to an OpenWrt 23.05 source tree.
# usage: add-device.sh <openwrt-source-dir>
set -e
SRC="$(cd "$1" && pwd)"
HERE="$(cd "$(dirname "$0")/.." && pwd)"

cp "$HERE/target/dts/mt7621_kt_km08-708h.dts" "$SRC/target/linux/ramips/dts/"

MK="$SRC/target/linux/ramips/image/mt7621.mk"
grep -q 'Device/kt_km08-708h' "$MK" || cat "$HERE/target/image/kt_km08-708h.mk" >> "$MK"

# sysupgrade: NAND "kernel + ubi" layout
python3 - "$SRC/target/linux/ramips/mt7621/base-files/lib/upgrade/platform.sh" <<'PY'
import sys
p = sys.argv[1]
s = open(p).read()
if 'kt,km08-708h' in s:
    sys.exit(0)
start = s.index('platform_do_upgrade() {')
marker = '\t*)\n\t\tdefault_do_upgrade "$1"\n\t\t;;'
i = s.index(marker, start)           # fails loudly if the layout changed
patch = '\tkt,km08-708h)\n\t\tnand_do_upgrade "$1"\n\t\t;;\n'
open(p, 'w').write(s[:i] + patch + s[i:])
print("platform.sh patched")
PY
echo "KM08-708H device added to $SRC"
