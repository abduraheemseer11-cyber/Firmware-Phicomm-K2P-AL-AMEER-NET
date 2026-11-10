
define Device/kt_km08-708h
  $(Device/dsa-migration)
  $(Device/uimage-lzma-loader)
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  KERNEL_SIZE := 4096k
  IMAGE_SIZE := 108544k
  UBINIZE_OPTS := -E 5
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
  DEVICE_VENDOR := KT
  DEVICE_MODEL := GiGA WiFi Wave2 KM08-708H
  DEVICE_PACKAGES := kmod-mt7615e kmod-mt7615-firmware
endef
TARGET_DEVICES += kt_km08-708h
