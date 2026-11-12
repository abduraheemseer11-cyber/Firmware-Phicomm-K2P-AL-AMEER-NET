#!/bin/bash
# Run inside the OpenWrt source dir BEFORE "feeds update": adds the Argon theme + Argon config feeds.
grep -q luci-theme-argon feeds.conf.default 2>/dev/null || echo 'src-git argon https://github.com/jerrykuku/luci-theme-argon.git' >> feeds.conf.default
grep -q luci-app-argon-config feeds.conf.default 2>/dev/null || echo 'src-git argonconfig https://github.com/jerrykuku/luci-app-argon-config.git' >> feeds.conf.default
