#!/bin/bash
# Run inside the ImmortalWrt source dir AFTER feeds install.
set -e
for f in package/base-files/files/bin/config_generate package/emortal/default-settings/files/99-default-settings; do
  [ -f "$f" ] && sed -i 's/192\.168\.[0-9]*\.1\b/192.168.1.20/g' "$f"
done
sed -i 's/ImmortalWrt/Alameer/g' package/base-files/files/bin/config_generate || true
cp ../files/etc/banner package/base-files/files/etc/banner 2>/dev/null || true
