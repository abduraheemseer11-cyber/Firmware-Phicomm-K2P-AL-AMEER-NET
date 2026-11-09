#!/bin/bash
# Run inside the ImmortalWrt source dir AFTER feeds install.
set -e
# Default IP -> 10.0.0.20
for f in package/base-files/files/bin/config_generate package/emortal/default-settings/files/99-default-settings; do
  [ -f "$f" ] && sed -i 's/192\.168\.[0-9]*\.1\b/10.0.0.20/g' "$f"
done
# Default language: English (ImmortalWrt defaults to Chinese)
for f in package/emortal/default-settings/files/99-default-settings package/emortal/default-settings/files/zzz-default-settings; do
  [ -f "$f" ] && sed -i 's/zh_cn/en/g; s/zh_Hans/en/g' "$f"
done
sed -i 's/ImmortalWrt/Alameer/g' package/base-files/files/bin/config_generate || true
cp ../files/etc/banner package/base-files/files/etc/banner 2>/dev/null || true
