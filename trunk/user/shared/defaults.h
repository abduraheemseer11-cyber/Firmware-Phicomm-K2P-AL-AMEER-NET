/* defaults.h - Alameer Software Custom Defaults for Phicomm K2P */

#ifndef _DEFAULTS_H_
#define _DEFAULTS_H_

/* LAN IP Address */
#define DEF_LAN_IP_ADDR         "192.168.1.20"
#define DEF_LAN_IP_MASK         "255.255.255.0"

/* DHCP Server - Disabled */
#define DEF_DHCP_ENABLE         0

/* IPv6 - Disabled */
#define DEF_IPV6_ENABLE         0

/* Wireless 2.4GHz */
#define DEF_WLAN_2G_SSID        "AL-AMEER-NET (   )_2G"
#define DEF_WLAN_2G_CHANNEL     4
#define DEF_WLAN_2G_BW          20
#define DEF_WLAN_2G_TXPOWER     20
#define DEF_WLAN_2G_MODE        "ap"
#define DEF_WLAN_2G_AUTH        "open"   /* بدون كلمة مرور */

/* Wireless 5GHz */
#define DEF_WLAN_5G_SSID        "AL-AMEER-NET (   )_5G"
#define DEF_WLAN_5G_CHANNEL     116
#define DEF_WLAN_5G_BW          40
#define DEF_WLAN_5G_TXPOWER     23
#define DEF_WLAN_5G_MODE        "ap"     /* Access Point */
#define DEF_WLAN_5G_AUTH        "open"

/* Web UI Logo customization is handled via file replacement (asus_logo.png) */

#endif
