<div align="center">
<img src="docs/logo.png" width="220" alt="Alameer Software"/>

# Alameer Software Firmware
**Custom ImmortalWrt firmware for Phicomm K2P (MT7621 + MT7615, 16MB flash)**
</div>

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

## تقليل الحجم
أُزيل: الصينية والعربية، firewall4، dnsmasq/odhcpd، IPv6 (kernel + packages)، PPP، تطبيقات LuCI الإضافية، واستُبدل wpad بنسخة mesh-mbedtls الأصغر.
حجم `sysupgrade.bin` يظهر في خطوة "Collect images" في GitHub Actions (الحد الأقصى للجهاز ≈ 15.4MB).

## البناء
Actions ← Build Alameer Firmware ← Run workflow، ثم حمّل الملف `*phicomm_k2p*squashfs-sysupgrade.bin` من Artifacts.

## ملاحظات
- 2.4GHz لا يدعم AC؛ المستخدم HT20 (802.11n).
- القناة 116 DFS؛ إن لم يظهر الواي فاي 5G حدّد `COUNTRY` في ملف 999-alameer-defaults.
- بدون firewall وDHCP: الجهاز Access Point فقط، ويحتاج راوتراً رئيسياً بعنوان 10.0.0.1.
