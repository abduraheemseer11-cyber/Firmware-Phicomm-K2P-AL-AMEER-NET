<div align="center">
<img src="docs/logo.png" width="220" alt="Alameer Software"/>

# Alameer Software Firmware
**Firmware خاص مبني على ImmortalWrt لجهاز Phicomm K2P (MT7621 + MT7615، Flash 16MB)**
</div>

## الإعدادات الافتراضية

| الإعداد | القيمة |
|---|---|
| IP الجهاز | `192.168.1.20` |
| DHCP / DHCPv6 / IPv6 | معطّل |
| منفذ WAN | يُضاف إلى الجسر (وضع Access Point) |
| Gateway / DNS | `192.168.1.1` (عدّله في `files/etc/uci-defaults/99-alameer-defaults`) |

**WiFi 2.4GHz:** Access Point، قناة 4، عرض 20، قدرة 20dBm، SSID `AL-AMEER-NET (XXXX)_2G`، شبكة lan، بدون كلمة مرور.

**WiFi 5GHz:** Access Point (WDS)، قناة 116، عرض 40 (VHT40)، قدرة 23dBm، SSID `AL-AMEER-NET (XXXX)_5G`، شبكة lan، بدون كلمة مرور.

`XXXX` = آخر 4 خانات من MAC الجهاز تلقائياً. غيّرها من صفحة "البرمجة السريعة ← اسم الشبكة".

## صفحة LuCI «البرمجة السريعة»
أول عنصر في القائمة الجانبية: **البرمجة السريعة**، على نمط واجهة حديثة بقائمة جانبية (ثيم Material الافتراضي):
النوع (Access Point / WDS / MESH)، IPv4 address، IPv4 netmask، اسم الشبكة، إضافة فيلان، تخصيص كلمة مرور Wifi، وتبويب More Settings (القنوات والقدرة والعرض).
الحفظ يطبّق الإعدادات تلقائياً عبر `/usr/libexec/alameer-apply`.

## البناء على GitHub
1. أنشئ مستودعاً جديداً وارفع كل محتويات هذا المجلد.
2. تبويب **Actions ← Build Alameer Firmware (Phicomm K2P) ← Run workflow**.
3. بعد ~1-2 ساعة حمّل `*phicomm_k2p*sysupgrade.bin` من Artifacts.
4. لإصدار Release: `git tag v1.0 && git push --tags`.

## البناء محلياً
```bash
git clone --depth 1 -b openwrt-24.10 https://github.com/immortalwrt/immortalwrt openwrt
cd openwrt && ./scripts/feeds update -a && ./scripts/feeds install -a
cp -r ../package/luci-app-alameer-quick package/ && cp -r ../files files
cp ../config/k2p.config .config && bash ../scripts/diy-part2.sh
make defconfig && make download -j8 && make -j$(nproc)
```

## ملاحظات
- 2.4GHz لا يدعم AC فعلياً؛ استُخدم أعلى وضع ممكن (HT20 / 802.11n).
- القناة 116 على 5GHz قناة DFS في بعض الدول، وقد تحتاج ضبط `country` في إعدادات الراديو.
- وضع MESH يجعل راديو 5GHz Mesh بدل AP.
