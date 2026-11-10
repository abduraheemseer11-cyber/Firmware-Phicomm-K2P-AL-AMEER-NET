# KT GiGA WiFi Wave2 (KM08-708H) - Alameer firmware

OpenWrt **23.05** build for the KM08-708H (MT7621AT, 256 MB RAM, 128 MB NAND, MT7615E).

> **This device is not supported by upstream OpenWrt.** `target/dts/mt7621_kt_km08-708h.dts` and
> `target/image/kt_km08-708h.mk` are a bring-up draft written from a vendor-build dump
> (partition table, switch ports, PCIe layout). LED/button GPIOs, the ethernet MAC location and the
> exact EEPROM offset are **not verified**.

## Bring-up (do this before flashing NAND)
1. Run the workflow *Build OpenWrt 23.05 - KM08-708H* and download the artifact.
2. Connect a 3.3 V USB-serial adapter (115200 8N1) to the board's UART header.
3. Interrupt U-Boot and **netboot** `*-initramfs-kernel.bin` with TFTP (do not write it to flash).
4. In the netbooted system check: `dmesg`, `ip link` (lan1-lan4, mgm), `iw dev`, `iw phy`,
   and that both radios exist. Back up all `/dev/mtd*` partitions first.
5. Only when everything works, flash `*-squashfs-sysupgrade.bin`.

If the workflow fails in the DTS / image step, send the log - that is the expected place for fixes.


## Why this does not use another device's image (YouHua WR1200JS / Newifi D2)
Those targets are different hardware, and flashing their images over Breed is **not** safe:

| | KM08-708H (from the dump) | YouHua WR1200JS |
|---|---|---|
| Flash | 128 MB **NAND** (Winbond W29N01HV), UBI | 16 MB **SPI NOR** (GD25Q127C) |
| RAM | 256 MB | 128 MB |
| WiFi | **MT7615E** (one PCIe card, 2 phys) | MT7603E + MT7612E (two chips) |
| Calibration data | partition `factory` (NAND layout) | NOR offsets 0x20000 / 0x28000 |
| Image | needs NAND/UBI layout | 16064k NOR image |

As far as I know, Breed writes the file you give it to the flash offset you choose without checking
that it fits the board. A NOR-layout image on a NAND board would either not boot or overwrite the
bootloader area, and its kernel only contains MT7603/MT76x2 drivers (no MT7615), so WiFi would not work either.

## Safe path: get the real hardware description from your working unit
Your KM08-708H already runs a vendor OpenWrt build, which contains the exact device tree
(LED/button GPIOs, MAC location, EEPROM offset):

    scp km08-708h/scripts/dump-device-info.sh root@<router-ip>:/tmp/
    ssh root@<router-ip> sh /tmp/dump-device-info.sh
    scp root@<router-ip>:/tmp/km08-dump.tar.gz .

With `device.dtb` / `device.dts` the draft DTS here can be completed from real values instead of guesses.
Also keep a full backup of every `/dev/mtdN` before anything is written (use `ssh root@<ip> 'cat /dev/mtd4' > firmware.bin`).

## What the firmware does
| Item | Value |
|---|---|
| LAN | bridge `br-lan` (lan1-lan4 + mgm), `192.168.10.<last MAC byte>/24` (`IP_FROM_MAC=1`; set 0 for fixed 192.168.10.1), no DHCP, no WAN routing |
| 2.4GHz | open, `AL-AMEER-NET (XXXX)_2G`, ch 6 HT20, txpower requested 32 dBm |
| 5GHz | open, `AL-AMEER-NET (XXXX)_5G`, ch 149 VHT80, txpower requested 32 dBm |
| Country | US |
| Backhaul | 802.11s mesh `AL-AMEER-MESH-BACKUP` on 5GHz, **SAE**, interface `mesh0` |
| Failover | `/usr/bin/mesh-failover.sh` (procd service + cron watchdog) |
| Hostname | `AL-AMEER-NET-AP` |

`XXXX` = last 4 hex digits of the radio MAC.

## Mesh key
Set the repository secret `MESH_KEY` (min. 8 chars) before building. Without it the workflow generates a random
key and puts it in `mesh-key.txt` inside the artifact. **Do not build on a public repo without the secret.**

## Mesh failover - how it works and its limits
* Cable up: `mesh0` is removed from `br-lan`. Cable down for `DOWN_DELAY` s: `mesh0` is added to `br-lan`.
* Settings: `/etc/mesh-failover.conf`.
* In the default (loop-safe) mode a neighbour that still has its cable keeps `mesh0` out of its bridge, so it does
  not forward the orphan node's traffic. For wired neighbours to relay, set `GATE_MODE=1` (mesh always bridged,
  STP on) and test it against your MikroTik before production.
