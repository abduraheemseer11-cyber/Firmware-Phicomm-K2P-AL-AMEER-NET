#!/bin/bash
# DIY Part 2: Injecting Custom Alameer Settings

echo "Starting Alameer Custom Injections..."

# 1. نسخ ملف الإعدادات الافتراضية (IP, WiFi, DHCP, IPv6)
cp $GITHUB_WORKSPACE/trunk/user/shared/defaults.h padavan/trunk/user/shared/defaults.h

# 2. نسخ الشعار المخصص
cp $GITHUB_WORKSPACE/trunk/user/www/n56u_ribbon_fixed/bootstrap/img/asus_logo.png padavan/trunk/user/www/n56u_ribbon_fixed/bootstrap/img/asus_logo.png

# 3. نسخ ملف النواة المخصص
cp $GITHUB_WORKSPACE/trunk/configs/boards/K2P/kernel-3.4.x.config padavan/trunk/configs/boards/K2P/kernel-3.4.x.config

# 4. نسخ قالب البناء المخصص
cp $GITHUB_WORKSPACE/trunk/configs/templates/K2P.config padavan/trunk/configs/templates/K2P.config

# 5. تعديل اسم ملف النواة داخل القالب ليتطابق مع اسم ملفنا
sed -i 's/kernel-3.4.x-5.0.config/kernel-3.4.x.config/g' padavan/trunk/configs/templates/K2P.config

# 6. التأكد من تعطيل DHCP و IPv6 في النظام الأساسي (إضافة احترازية)
# سيتم تطبيق الإعدادات الدقيقة عبر defaults.h

echo "Injections Done Successfully!"
