#
# This is the product configuration for a full solana
#

DEVICE_FOLDER := device/motorola/solana

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

## (3)  Finally, the least specific parts, i.e. the non-GSM-specific aspects

# Device overlay
    DEVICE_PACKAGE_OVERLAYS += $(DEVICE_FOLDER)/overlay

# high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_PACKAGES := \
    charger \
    charger_res_images

# Audio
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/audio/alsa.omap4.so:/system/lib/hw/alsa.omap4.so \
    $(DEVICE_FOLDER)/audio/audio.primary.omap4.so:/system/lib/hw/audio.primary.solana.so \
    $(DEVICE_FOLDER)/audio/audio_policy.omap4.so:/system/lib/hw/audio_policy.solana.so \
    $(DEVICE_FOLDER)/audio/libasound.so:/system/lib/libasound.so \
    $(DEVICE_FOLDER)/audio/libaudio_ext.so:/system/lib/libaudio_ext.so

# Hardware HALs
PRODUCT_PACKAGES += \
    camera.omap4 \
    libinvensense_mpl \
    hwcomposer.solana \
    libedid \

PRODUCT_PACKAGES += \
    libaudioutils \
    libaudiohw_legacy \

# BlueZ a2dp Audio HAL module
PRODUCT_PACKAGES += \
    audio.a2dp.default

# BlueZ test tools
PRODUCT_PACKAGES += \
    hciconfig \
    hcitool

# Modem
PRODUCT_PACKAGES += \
    libaudiomodemgeneric \
    libreference-cdma-sms \
    rild \
    radiooptions

# Wifi
PRODUCT_PACKAGES += \
    lib_driver_cmd_wl12xx \
    dhcpcd.conf \
    hostapd.conf \
    wifical.sh \
    wpa_supplicant.conf \
    TQS_D_1.7.ini \
    TQS_D_1.7_127x.ini \
    crda \
    regulatory.bin \
    calibrator \
    busybox \

# Wifi Direct and WPAN
PRODUCT_PACKAGES += \
    ti_wfd_libs \
    ti-wpan-fw

# Bluetooth
PRODUCT_PACKAGES += \
    bt_sco_app \
    uim-sysfs 


# Release utilities
PRODUCT_PACKAGES += \
    solana_releaseutils-check_kernel \
    solana_releaseutils-finalize_release \
    solana_releaseutils-mke2fs \
    solana_releaseutils-tune2fs

PRODUCT_PACKAGES += \
    evtest \
    camera_test \
    Camera \
    CameraOMAP4 \
    Superuser \
    su \
    DockAudio \
    parse_hdmi_edid \

PRODUCT_PACKAGES += \
    librs_jni \
    com.android.future.usb.accessory \
    FileManager \
    MusicFX \
    Apollo \

# WirelessTether
PRODUCT_PACKAGES += wifi_tether_v3_2-beta1
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/lib/libwtnativetask.so:system/lib/libwtnativetask.so \

# Rootfs files
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/root/default.prop:/root/default.prop \
    $(DEVICE_FOLDER)/root/init.rc:/root/init.rc \
    $(DEVICE_FOLDER)/root/init.mapphone_cdma.rc:/root/init.mapphone_cdma.rc \
    $(DEVICE_FOLDER)/root/init.mapphone_umts.rc:/root/init.mapphone_umts.rc \
    $(DEVICE_FOLDER)/root/ueventd.rc:/root/ueventd.rc \
    $(DEVICE_FOLDER)/root/ueventd.mapphone_cdma.rc:/root/ueventd.mapphone_cdma.rc \
    $(DEVICE_FOLDER)/root/ueventd.mapphone_umts.rc:/root/ueventd.mapphone_umts.rc \

# Kexec files
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/kexec/arm_kexec.ko:system/etc/kexec/arm_kexec.ko \
    $(DEVICE_FOLDER)/kexec/atags.ko:system/etc/kexec/atags.ko \
    $(DEVICE_FOLDER)/kexec/atags:system/etc/kexec/atags3 \
    $(DEVICE_FOLDER)/kexec/devtree:system/etc/kexec/devtree7 \
    $(DEVICE_FOLDER)/kexec/kexec:system/etc/kexec/kexec \
    $(DEVICE_FOLDER)/kexec/kexec.ko:system/etc/kexec/kexec.ko \
    $(DEVICE_FOLDER)/kexec/physicalmem:system/etc/kexec/physicalmem \
    $(DEVICE_FOLDER)/kexec/procfs_rw.ko:system/etc/kexec/procfs_rw.ko \
    $(DEVICE_FOLDER)/kexec/uart.ko:system/etc/kexec/uart.ko \
    out/target/product/solana/ramdisk.img:system/etc/kexec/ramdisk.gz \
    out/target/product/solana/kernel:system/etc/kexec/zImage \

# Permissions files
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \

# Prebuilts
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/bin/battd:system/bin/battd \
    $(DEVICE_FOLDER)/prebuilt/bin/mount_ext3.sh:system/bin/mount_ext3.sh \
    $(DEVICE_FOLDER)/prebuilt/bin/strace:system/bin/strace \
    $(DEVICE_FOLDER)/prebuilt/etc/firmware/ducati-m3.512MB.bin:system/etc/firmware/ducati-m3.512MB.bin \
    $(DEVICE_FOLDER)/prebuilt/etc/gps.conf:system/etc/gps.conf \
    $(DEVICE_FOLDER)/prebuilt/etc/media_codecs.xml:system/etc/media_codecs.xml \
    $(DEVICE_FOLDER)/prebuilt/etc/audio_policy.conf:system/etc/audio_policy.conf \
    $(DEVICE_FOLDER)/prebuilt/etc/vold.fstab:system/etc/vold.fstab \
    $(DEVICE_FOLDER)/prebuilt/etc/TICameraCameraProperties.xml:system/etc/TICameraCameraProperties.xml \
    $(DEVICE_FOLDER)/prebuilt/usr/idc/cpcap-key.idc:system/usr/idc/cpcap-key.idc \
    $(DEVICE_FOLDER)/prebuilt/usr/idc/light-prox.idc:system/usr/idc/light-prox.idc \
    $(DEVICE_FOLDER)/prebuilt/usr/idc/mapphone-switch.idc:system/usr/idc/mapphone-switch.idc \
    $(DEVICE_FOLDER)/prebuilt/usr/idc/omap4-keypad.idc:system/usr/idc/omap4-keypad.idc \
    $(DEVICE_FOLDER)/prebuilt/usr/idc/qtouch-touchscreen.idc:system/usr/idc/qtouch-touchscreen.idc \
    $(DEVICE_FOLDER)/prebuilt/usr/keychars/cpcap-key.kcm:system/usr/keychars/cpcap-key.kcm \
    $(DEVICE_FOLDER)/prebuilt/usr/keychars/light-prox.kcm:system/usr/keychars/light-prox.kcm \
    $(DEVICE_FOLDER)/prebuilt/usr/keychars/mapphone-switch.kcm:system/usr/keychars/mapphone-switch.kcm \
    $(DEVICE_FOLDER)/prebuilt/usr/keychars/omap4-keypad.kcm:system/usr/keychars/omap4-keypad.kcm \
    $(DEVICE_FOLDER)/prebuilt/usr/keychars/qtouch-touchscreen.kcm:system/usr/keychars/qtouch-touchscreen.kcm \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/cpcap-key.kl:system/usr/keylayout/cpcap-key.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/light-prox.kl:system/usr/keylayout/light-prox.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/mapphone-switch.kl:system/usr/keylayout/mapphone-switch.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/omap4-keypad.kl:system/usr/keylayout/omap4-keypad.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/qtouch-touchscreen.kl:system/usr/keylayout/qtouch-touchscreen.kl \

#    $(DEVICE_FOLDER)/prebuilt/etc/media_profiles.xml:system/etc/media_profiles.xml \

# Backup Tool
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/bin/backuptool.sh:system/bin/backuptool.sh \
    $(DEVICE_FOLDER)/prebuilt/bin/backuptool.functions:system/bin/backuptool.functions \
    $(DEVICE_FOLDER)/prebuilt/bin/50-backup.sh:system/addon.d/50-backup.sh

# Phone settings
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/etc/apns-conf.xml:system/etc/apns-conf.xml \
    vendor/cm/prebuilt/common/etc/spn-conf.xml:system/etc/spn-conf.xml \

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# still need to set english for audio init
PRODUCT_LOCALES += en_US

# stuff specific to ti OMAP4 hardware
$(call inherit-product, hardware/ti/omap4xxx/omap4.mk)
$(call inherit-product, hardware/ti/wpan/ti-wpan-products.mk)
$(call inherit-product, device/ti/proprietary-open/wl12xx/wlan/wl12xx-wlan-fw-products.mk)
$(call inherit-product-if-exists, vendor/motorola/common/proprietary/imgtec/sgx-imgtec-bins.mk)
$(call inherit-product-if-exists, vendor/motorola/common/proprietary/custom-omap4xxx/custom-omap4.mk)
$(call inherit-product-if-exists, vendor/motorola/solana/solana-vendor.mk)

