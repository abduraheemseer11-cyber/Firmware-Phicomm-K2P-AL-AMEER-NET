# Xiaomi Mi Router CR6608 - Alameer firmware

Official OpenWrt **23.05** target `xiaomi_mi-router-cr6608` (ramips/mt7621; supported upstream since 22.03).
No custom device definition is used: kernel, DTS, EEPROM and MAC handling are the upstream ones.

## Build
Actions -> *Build OpenWrt 23.05 - Xiaomi Mi Router CR6608* -> Run workflow.
Artifacts: `*sysupgrade.bin` and `*initramfs-kernel.bin`.

## Defaults
| Item | Value |
|---|---|
| Hostname | `Alameer-AP` |
| LAN | `br-lan` with **all** ports (WAN + LAN1-3, names read from `/etc/board.json`), `192.168.10.1/24` |
| `IP_FROM_MAC` | `90-alameer-network`: set to `1` for `192.168.10.<last MAC byte>` |
| DHCP / DHCPv6 / RA | off (clients get addresses from the MikroTik hotspot) |
| 2.4GHz | open, `AL-AMEER-NET (XXXX)_2G`, ch 6, HE20 |
| 5GHz | open, `AL-AMEER-NET (XXXX)_5G`, ch 149, HE80 |
| Country / txpower | US / 30 dBm ceiling (driver clamps to the permitted maximum) |
| Neighbors | `lldpd` with CDP/EDP/FDP/SONMP so the AP shows in MikroTik *IP -> Neighbors* |
| Extras | `kmod-8021q`, `luci-app-watchcat` (configure the ping target in LuCI), `iw-full`, `curl` |

`XXXX` = last 4 hex digits of the radio MAC.

## Installing
This repository builds the images; the *installation procedure* for the CR6608 (unlocking the stock
firmware, which partition/slot to write) is device-specific. Follow the OpenWrt documentation for the
Xiaomi CR660x, and do not use a Breed or `mtd` procedure unless it is written for this exact model.
Keep a backup of every `/dev/mtdN` partition before writing anything.

## Notes
* `/etc/openwrt_release` is not replaced with a hand-written file: it carries the arch/target/revision that
  opkg and sysupgrade rely on. The name comes from `CONFIG_VERSION_DIST` and the description line is set
  at first boot by `99-alameer-branding`.
* Argon feeds are cloned from their GitHub `master` branches (not pinned).
* No static `files/etc/config/network`: the port list is taken from the board definition at first boot.
