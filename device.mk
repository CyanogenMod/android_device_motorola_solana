#
# This is the product configuration for a full solana
#

DEVICE_FOLDER := device/motorola/solana
BOARD_USES_KEXEC := true

# Device overlay
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_FOLDER)/overlay

# high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# Hardware HALs
PRODUCT_PACKAGES += \
    hwcomposer.solana \
    sensors.solana \
    lights.solana \
    audio.usb.default \
    audio.a2dp.default

PRODUCT_PACKAGES += \
    audio_policy.omap4 \
    libasound \
    libaudioutils \
    libaudiohw_legacy

# BlueZ test tools
PRODUCT_PACKAGES += \
    hciconfig \
    hcitool

# Modem
PRODUCT_PACKAGES += \
    libreference-cdma-sms \
    libaudiomodemgeneric \
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
    busybox

# Wifi Direct and WPAN
PRODUCT_PACKAGES += \
    ti_wfd_libs \
    ti-wpan-fw

# Bluetooth
PRODUCT_PACKAGES += \
    uim-sysfs \
    libbt-vendor

# Misc
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# Motorola Binaries
PRODUCT_PACKAGES += \
    aplogd \
    charge_only_mode \
    modemlog \
    mot_boot_mode \
    motobox \
    usbd

# OMAP4
PRODUCT_PACKAGES += \
    libdomx \
    libOMX_Core \
    libOMX.TI.DUCATI1.VIDEO.H264E \
    libOMX.TI.DUCATI1.VIDEO.MPEG4E \
    libOMX.TI.DUCATI1.VIDEO.DECODER \
    libOMX.TI.DUCATI1.VIDEO.DECODER.secure \
    libOMX.TI.DUCATI1.VIDEO.CAMERA \
    libOMX.TI.DUCATI1.MISC.SAMPLE \
    libstagefrighthw \
    libI420colorconvert \
    libtiutils \
    libion_ti \
    smc_pa_ctrl \
    tf_daemon \
    libtf_crypto_sst \
    libmm_osal

PRODUCT_PACKAGES += \
    evtest \
    DockAudio \
    libjni_filtershow_filters \
    libjni_mosaic

# Permissions files
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
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
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

# WLAN firmware
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/firmware/ti-connectivity/wl128x-fw-4-mr.bin:system/etc/firmware/ti-connectivity/wl128x-fw-4-mr.bin \
    $(DEVICE_FOLDER)/firmware/ti-connectivity/wl128x-fw-4-plt.bin:system/etc/firmware/ti-connectivity/wl128x-fw-4-plt.bin \
    $(DEVICE_FOLDER)/firmware/ti-connectivity/wl128x-fw-4-sr.bin:system/etc/firmware/ti-connectivity/wl128x-fw-4-sr.bin \
    $(DEVICE_FOLDER)/firmware/ti-connectivity/wl1271-nvs.bin:system/etc/firmware/ti-connectivity/wl1271-nvs.bin

# WPAN firmware
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/firmware/wpan/bluetooth/TIInit_10.6.15.bts:system/etc/firmware/TIInit_10.6.15.bts \
    $(DEVICE_FOLDER)/firmware/wpan/bluetooth/TIInit_7.2.31.bts:system/etc/firmware/TIInit_7.2.31.bts \
    $(DEVICE_FOLDER)/firmware/wpan/bluetooth/TIInit_7.6.15.bts:system/etc/firmware/TIInit_7.6.15.bts \
    $(DEVICE_FOLDER)/firmware/wpan/bluetooth/TIInit_12.7.27.bts:system/etc/firmware/TIInit_12.7.27.bts

# Rootfs files
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/root/default.prop:/root/default.prop \
    $(DEVICE_FOLDER)/root/init.mapphone_cdma.rc:/root/init.mapphone_cdma.rc \
    $(DEVICE_FOLDER)/root/init.mapphone_umts.rc:/root/init.mapphone_umts.rc \
    $(DEVICE_FOLDER)/root/init.usb.rc:/root/init.usb.rc \
    $(DEVICE_FOLDER)/root/ueventd.mapphone.rc:/root/ueventd.mapphone_cdma.rc \
    $(DEVICE_FOLDER)/root/ueventd.mapphone.rc:/root/ueventd.mapphone_umts.rc

# Kexec files
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/kexec/arm_kexec.ko:system/etc/kexec/arm_kexec.ko \
    $(DEVICE_FOLDER)/kexec/devtree:system/etc/kexec/devtree \
    $(DEVICE_FOLDER)/kexec/kexec.ko:system/etc/kexec/kexec.ko \
    $(DEVICE_FOLDER)/kexec/uart.ko:system/etc/kexec/uart.ko \
    $(DEVICE_FOLDER)/kexec/atags:system/etc/kexec/atags \
    $(DEVICE_FOLDER)/kexec/kexec:system/etc/kexec/kexec \
    $(OUT)/ramdisk.img:system/etc/kexec/ramdisk.img \
    $(OUT)/kernel:system/etc/kexec/kernel

# Bin files for kexec load
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/bin/bbx:/root/sbin/bbx \
    $(DEVICE_FOLDER)/prebuilt/bin/fixboot.sh:/root/sbin/fixboot.sh

# Prebuilts
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/etc/firmware/ducati-m3.512MB.bin:system/etc/firmware/ducati-m3.512MB.bin \
    $(DEVICE_FOLDER)/prebuilt/etc/apns-conf.xml:system/etc/apns-conf.xml \
    $(DEVICE_FOLDER)/prebuilt/etc/audio_policy.conf:system/etc/audio_policy.conf \
    $(DEVICE_FOLDER)/prebuilt/etc/gps.conf:system/etc/gps.conf \
    $(DEVICE_FOLDER)/prebuilt/etc/media_codecs.xml:system/etc/media_codecs.xml \
    $(DEVICE_FOLDER)/prebuilt/etc/media_profiles.xml:system/etc/media_profiles.xml \
    $(DEVICE_FOLDER)/prebuilt/etc/vold.fstab:system/etc/vold.fstab \
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
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/cpcap-key.kl:system/usr/keylayout/cpcap-key.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/light-prox.kl:system/usr/keylayout/light-prox.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/mapphone-switch.kl:system/usr/keylayout/mapphone-switch.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/omap4-keypad.kl:system/usr/keylayout/omap4-keypad.kl \
    $(DEVICE_FOLDER)/prebuilt/usr/keylayout/qtouch-touchscreen.kl:system/usr/keylayout/qtouch-touchscreen.kl

# sw vsync setting
PRODUCT_PROPERTY_OVERRIDES += \
    persist.hwc.sw_vsync=1

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# still need to set english for audio init
PRODUCT_LOCALES += en_US

$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)
# stuff specific to ti OMAP4 hardware
#$(call inherit-product, hardware/ti/omap4xxx/omap4.mk)
$(call inherit-product, hardware/ti/omap4xxx/security/Android.mk)
$(call inherit-product-if-exists, $(DEVICE_FOLDER)/imgtec/sgx-imgtec-bins.mk)
$(call inherit-product-if-exists, vendor/motorola/omap4-common/common-vendor.mk)
$(call inherit-product-if-exists, vendor/motorola/solana/solana-vendor.mk)

