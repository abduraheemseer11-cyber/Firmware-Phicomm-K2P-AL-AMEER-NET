#!/bin/bash
# Run inside the ImmortalWrt source dir AFTER feeds install.
set -e

# 1) Default IP -> 10.0.0.20 (in case anything reads the build-time default)
for f in package/base-files/files/bin/config_generate; do
  [ -f "$f" ] && sed -i 's/192\.168\.[0-9]*\.1\b/10.0.0.20/g' "$f"
done
sed -i 's/ImmortalWrt/Alameer/g' package/base-files/files/bin/config_generate || true

# 2) Neutralise ImmortalWrt's own first-boot scripts (they set Chinese language, timezone,
#    IP, ... and can run AFTER ours). Our 99-custom-settings is the single source of truth.
for f in package/emortal/default-settings/files/*; do
  [ -f "$f" ] && printf '#!/bin/sh\nexit 0\n' > "$f"
done

# 3) Banner
cp ../files/etc/banner package/base-files/files/etc/banner

# 4) Optional: remove failsafe mode (reset-button-at-boot recovery). Off by default.
if [ "${DISABLE_FAILSAFE:-0}" = "1" ]; then
  rm -f package/base-files/files/lib/preinit/30_failsafe_wait
  echo ">> failsafe wait removed"
fi
