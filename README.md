<div align="center">
<img src="docs/logo.png" width="220" alt="Alameer Software"/>

# Alameer Software Firmware
**Custom ImmortalWrt firmware for Phicomm K2P (MT7621 + MT7615, 16MB flash)**
</div>


## Devices
| Device | Base | Workflow | Folder |
|---|---|---|---|
| Phicomm K2P | ImmortalWrt 24.10 | `build.yml` | repo root (`files/`, `config/`, `package/`) |
| KT GiGA WiFi Wave2 KM08-708H | OpenWrt 23.05 | `build-openwrt.yml` | `km08-708h/` (see its README - bring-up draft) |

## الإعدادات الافتراضية

| الإعداد | القيمة |
|---|---|
| اللغة | English |
| IP الجهاز | `10.0.0.20` |
| DHCP / DHCPv6 / IPv6 | معطّل |
| WAN | يُضاف إلى الجسر (وضع Access Point) |
| Gateway / DNS | `10.0.0.1` (عدّله في `files/etc/uci-defaults/999-alameer-defaults`) |

**2.4GHz:** AP، قناة 4، عرض 20، **Max Tx power = 20 dBm**، ESSID `AL-AMEER-NET (XXXX)_2G`، شبكة lan، بدون كلمة مرور.

**5GHz:** AP (WDS)، قناة 116، عرض 40 (VHT40)، **Max Tx power = 23 dBm**، ESSID `AL-AMEER-NET (XXXX)_5G`، شبكة lan، بدون كلمة مرور.

`XXXX` = آخر 4 خانات من MAC الجهاز.

## Quick Programming
أول عنصر في القائمة الجانبية. الصفحة تقرأ وتكتب مباشرة في `/etc/config/network` و`/etc/config/wireless`
(نفس الإعدادات الحقيقية في Network ← Wireless)، وتحتوي: IP / Netmask / Gateway، وقناة وعرض وقدرة كل راديو،
ونوع البرمجة (AP / AP-WDS / MESH)، وESSID، والتشفير وكلمة المرور.

## ملفات الإعداد عند أول إقلاع
| الملف | الوظيفة |
|---|---|
| `files/etc/uci-defaults/99-custom-settings` | IP 10.0.0.20، إيقاف DHCP/IPv6/WAN، الهوستنيم، اللغة (عربي مع رجوع للإنجليزية) |
| `files/usr/sbin/alameer-wifi` | Country US، قناة/عرض/قدرة (20 / 23 dBm)، الـ SSID — ينتظر ظهور الراديو |
| `files/etc/init.d/alameer-wifi` | احتياطي: يكمل إعداد الواي فاي بعد الإقلاع إذا لم يكن الراديو جاهزاً |
| `files/etc/rc.button/reset` | تعطيل زر Reset |
| `files/usr/sbin/alameer-quick` | Quick Programming: VLAN، عزل العملاء، تغيير IP |
| `scripts/diy-part2.sh` | يعطّل سكربت ImmortalWrt الصيني `99-default-settings` حتى لا يكتب فوق الإعدادات |

## alameer-quick
```
alameer-quick vlan add 20 5g t     # VLAN 20 على 5GHz، منافذ LAN كـ trunk
alameer-quick vlan del 20
alameer-quick isolate both on      # عزل العملاء
alameer-quick ip 10.0.0.30 255.255.255.0 10.0.0.1
alameer-quick wifi-reset
alameer-quick apply
```

## ملاحظات
- زر Reset: التعطيل برمجي فقط. وضع Failsafe عند الإقلاع والـ bootloader لا يتأثران، إلا إذا فعّلت خيار `disable_failsafe` عند تشغيل الـ workflow (وعندها لا يوجد استرجاع عبر failsafe).
- Country US: يرفع حدود القدرة لكنه قد يخالف أنظمة بلدك. القناة 116 DFS وقد تتأخر دقيقة قبل البث.
- 2.4GHz لا يدعم AC؛ المستخدم HT20.
