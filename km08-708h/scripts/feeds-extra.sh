#!/bin/bash
# Run inside the OpenWrt source dir BEFORE "feeds update": adds the Argon theme feed.
grep -q luci-theme-argon feeds.conf.default 2>/dev/null || echo 'src-git argon https://github.com/jerrykuku/luci-theme-argon.git' >> feeds.conf.default
