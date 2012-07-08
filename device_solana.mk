#
# This is the product configuration for a full solana
#

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

## (3)  Finally, the least specific parts, i.e. the non-GSM-specific aspects

# Device overlay
    DEVICE_PACKAGE_OVERLAYS += device/motorola/solana/overlay

# high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_PACKAGES := \
    charger \
    charger_res_images

# Audio
PRODUCT_COPY_FILES += \
    device/motorola/solana/audio/alsa.omap4.so:/system/lib/hw/alsa.omap4.so \
    device/motorola/solana/audio/audio.a2dp.default.so:/system/lib/hw/audio.a2dp.default.so \
    device/motorola/solana/audio/audio.primary.omap4.so:/system/lib/hw/audio.primary.omap4.so \
    device/motorola/solana/audio/audio_policy.omap4.so:/system/lib/hw/audio_policy.omap4.so \
    device/motorola/solana/audio/libasound.so:/system/lib/libasound.so \
    device/motorola/solana/audio/libaudio_ext.so:/system/lib/libaudio_ext.so

# Hardware HALs
PRODUCT_PACKAGES += \
    camera.omap4 \
    libinvensense_mpl \

PRODUCT_PACKAGES += \
    libaudioutils \
    libaudiohw_legacy \

# BlueZ test tools
PRODUCT_PACKAGES += \
    hciconfig \
    hcitool

# Modem
PRODUCT_PACKAGES += \
    libaudiomodemgeneric \
    libreference-cdma-sms \
    rild \
    radiooptions \
    sh 

# Wifi
PRODUCT_PACKAGES += \
    lib_driver_cmd_wl12xx \
    dhcpcd.conf \
    hostapd.conf \
    wifical.sh \
    wpa_supplicant.conf \
    TQS_D_1.7.ini \
    crda \
    regulatory.bin \
    calibrator


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
    Superuser \
    su \
    DockAudio \


PRODUCT_PACKAGES += \
    librs_jni \
    com.android.future.usb.accessory \
    FileManager \
    MusicFX \
    Apollo \

# WirelessTether
PRODUCT_PACKAGES += wifi_tether_v3_1-beta14
PRODUCT_COPY_FILES += \
    device/motorola/solana/prebuilt/lib/libwtnativetask.so:system/lib/libwtnativetask.so \


# Rootfs files
PRODUCT_COPY_FILES += \
    device/motorola/solana/root/default.prop:/root/default.prop \
    device/motorola/solana/root/init.rc:/root/init.rc \
    device/motorola/solana/root/init.mapphone_cdma.rc:/root/init.mapphone_cdma.rc \
    device/motorola/solana/root/init.mapphone_umts.rc:/root/init.mapphone_umts.rc \
    device/motorola/solana/root/ueventd.rc:/root/ueventd.rc \
    device/motorola/solana/root/ueventd.mapphone_cdma.rc:/root/ueventd.mapphone_cdma.rc \
    device/motorola/solana/root/ueventd.mapphone_umts.rc:/root/ueventd.mapphone_umts.rc \
    device/motorola/solana/root/omaplfb_sgx540_120.ko:/root/omaplfb_sgx540_120.ko \
    device/motorola/solana/root/pvrsrvkm_sgx540_120.ko:/root/pvrsrvkm_sgx540_120.ko \

#    out/target/product/solana/kernel:system/etc/kexec/zImage \
# Kexec files
PRODUCT_COPY_FILES += \
    device/motorola/solana/kexec/arm_kexec.ko:system/etc/kexec/arm_kexec.ko \
    device/motorola/solana/kexec/atags.ko:system/etc/kexec/atags.ko \
    device/motorola/solana/kexec/atags3:system/etc/kexec/atags3 \
    device/motorola/solana/kexec/devtree7:system/etc/kexec/devtree7 \
    device/motorola/solana/kexec/kexec:system/etc/kexec/kexec \
    device/motorola/solana/kexec/kexec.ko:system/etc/kexec/kexec.ko \
    device/motorola/solana/kexec/physicalmem:system/etc/kexec/physicalmem \
    device/motorola/solana/kexec/procfs_rw.ko:system/etc/kexec/procfs_rw.ko \
    device/motorola/solana/kexec/uart.ko:system/etc/kexec/uart.ko \
    device/motorola/solana/kernel:system/etc/kexec/zImage \
    out/target/product/solana/ramdisk.img:system/etc/kexec/ramdisk.gz \

# Permissions files
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:/system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.camera.front.xml:/system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/base/data/etc/android.hardware.camera.xml:/system/etc/permissions/android.hardware.camera.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:/system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:/system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.sensor.compass.xml:/system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:/system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:/system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.telephony.cdma.xml:/system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:/system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:/system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.xml:/system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:/system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.wifi.direct.xml:/system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/base/data/etc/handheld_core_hardware.xml:/system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/base/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \


# Prebuilts
PRODUCT_COPY_FILES += \
    device/motorola/solana/prebuilt/bin/battd:system/bin/battd \
    device/motorola/solana/prebuilt/bin/mount_ext3.sh:system/bin/mount_ext3.sh \
    device/motorola/solana/prebuilt/bin/strace:system/bin/strace \
    device/motorola/solana/prebuilt/etc/gps.conf:system/etc/gps.conf \
    device/motorola/solana/prebuilt/etc/media_profiles.xml:system/etc/media_profiles.xml \
    device/motorola/solana/prebuilt/etc/vold.fstab:system/etc/vold.fstab \
    device/motorola/solana/prebuilt/usr/idc/cpcap-key.idc:system/usr/idc/cpcap-key.idc \
    device/motorola/solana/prebuilt/usr/idc/light-prox.idc:system/usr/idc/light-prox.idc \
    device/motorola/solana/prebuilt/usr/idc/mapphone-switch.idc:system/usr/idc/mapphone-switch.idc \
    device/motorola/solana/prebuilt/usr/idc/omap-keypad.idc:system/usr/idc/omap-keypad.idc \
    device/motorola/solana/prebuilt/usr/idc/qtouch-touchscreen.idc:system/usr/idc/qtouch-touchscreen.idc \
    device/motorola/solana/prebuilt/usr/keychars/cpcap-key.kcm:system/usr/keychars/cpcap-key.kcm \
    device/motorola/solana/prebuilt/usr/keychars/light-prox.kcm:system/usr/keychars/light-prox.kcm \
    device/motorola/solana/prebuilt/usr/keychars/mapphone-switch.kcm:system/usr/keychars/mapphone-switch.kcm \
    device/motorola/solana/prebuilt/usr/keychars/omap-keypad.kcm:system/usr/keychars/omap-keypad.kcm \
    device/motorola/solana/prebuilt/usr/keychars/qtouch-touchscreen.kcm:system/usr/keychars/qtouch-touchscreen.kcm \
    device/motorola/solana/prebuilt/usr/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/motorola/solana/prebuilt/usr/keylayout/cpcap-key.kl:system/usr/keylayout/cpcap-key.kl \
    device/motorola/solana/prebuilt/usr/keylayout/light-prox.kl:system/usr/keylayout/light-prox.kl \
    device/motorola/solana/prebuilt/usr/keylayout/mapphone-switch.kl:system/usr/keylayout/mapphone-switch.kl \
    device/motorola/solana/prebuilt/usr/keylayout/omap-keypad.kl:system/usr/keylayout/omap-keypad.kl \
    device/motorola/solana/prebuilt/usr/keylayout/qtouch-touchscreen.kl:system/usr/keylayout/qtouch-touchscreen.kl \

# Graphics
PRODUCT_COPY_FILES += \
    device/motorola/solana/prebuilt/imgtec/lib/hw/gralloc.omap4430.so:/system/vendor/lib/hw/gralloc.omap4430.so \
    device/motorola/solana/prebuilt/imgtec/lib/egl/libEGL_POWERVR_SGX540_120.so:/system/vendor/lib/egl/libEGL_POWERVR_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/egl/libGLESv1_CM_POWERVR_SGX540_120.so:/system/vendor/lib/egl/libGLESv1_CM_POWERVR_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/egl/libGLESv2_POWERVR_SGX540_120.so:/system/vendor/lib/egl/libGLESv2_POWERVR_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/libglslcompiler_SGX540_120.so:/system/vendor/lib/libglslcompiler_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/libIMGegl_SGX540_120.so:/system/vendor/lib/libIMGegl_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/libpvr2d_SGX540_120.so:/system/vendor/lib/libpvr2d_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/libpvrANDROID_WSEGL_SGX540_120.so:/system/vendor/lib/libpvrANDROID_WSEGL_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/libPVRScopeServices_SGX540_120.so:/system/vendor/lib/libPVRScopeServices_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/libsrv_init_SGX540_120.so:/system/vendor/lib/libsrv_init_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/libsrv_um_SGX540_120.so:/system/vendor/lib/libsrv_um_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/lib/libusc_SGX540_120.so:/system/vendor/lib/libusc_SGX540_120.so \
    device/motorola/solana/prebuilt/imgtec/bin/pvrsrvinit_SGX540_120:/system/bin/pvrsrvinit \
    device/motorola/solana/prebuilt/imgtec/bin/pvrsrvctl:/system/bin/pvrsrvctl \
    device/motorola/solana/prebuilt/imgtec/etc/powervr.ini:/system/etc/powervr.ini \

# Temporarily use prebuilt DOMX
# Prebuilts /system/lib
PRODUCT_COPY_FILES += \
    device/motorola/solana/prebuilt/lib/libdomx.so:/system/lib/libdomx.so \
    device/motorola/solana/prebuilt/lib/libmm_osal.so:/system/lib/libmm_osal.so \
    device/motorola/solana/prebuilt/lib/libOMX.TI.DUCATI1.MISC.SAMPLE.so:/system/lib/libOMX.TI.DUCATI1.MISC.SAMPLE.so \
    device/motorola/solana/prebuilt/lib/libOMX.TI.DUCATI1.VIDEO.CAMERA.so:/system/lib/libOMX.TI.DUCATI1.VIDEO.CAMERA.so \
    device/motorola/solana/prebuilt/lib/libOMX.TI.DUCATI1.VIDEO.DECODER.secure.so:/system/lib/libOMX.TI.DUCATI1.VIDEO.DECODER.secure.so \
    device/motorola/solana/prebuilt/lib/libOMX.TI.DUCATI1.VIDEO.DECODER.so:/system/lib/libOMX.TI.DUCATI1.VIDEO.DECODER.so \
    device/motorola/solana/prebuilt/lib/libOMX.TI.DUCATI1.VIDEO.H264E.so:/system/lib/libOMX.TI.DUCATI1.VIDEO.H264E.so \
    device/motorola/solana/prebuilt/lib/libOMX.TI.DUCATI1.VIDEO.MPEG4E.so:/system/lib/libOMX.TI.DUCATI1.VIDEO.MPEG4E.so \
    device/motorola/solana/prebuilt/lib/libOMX_Core.so:/system/lib/libOMX_Core.so \

# Wifi firmware
PRODUCT_COPY_FILES += \
    device/motorola/solana/prebuilt/etc/firmware/ti-connectivity/wl127x-fw-4-mr.bin:/system/etc/firmware/ti-connectivity/wl127x-fw-4-mr.bin.bin \
    device/motorola/solana/prebuilt/etc/firmware/ti-connectivity/wl127x-fw-4-plt.bin:/system/etc/firmware/ti-connectivity/wl127x-fw-4-plt.bin \
    device/motorola/solana/prebuilt/etc/firmware/ti-connectivity/wl127x-fw-4-sr.bin:/system/etc/firmware/ti-connectivity/wl127x-fw-4-sr.bin \
    device/motorola/solana/prebuilt/etc/firmware/ti-connectivity/wl128x-fw-4-mr.bin:/system/etc/firmware/ti-connectivity/wl128x-fw-4-mr.bin \
    device/motorola/solana/prebuilt/etc/firmware/ti-connectivity/wl128x-fw-4-plt.bin:/system/etc/firmware/ti-connectivity/wl128x-fw-4-plt.bin \
    device/motorola/solana/prebuilt/etc/firmware/ti-connectivity/wl128x-fw-4-sr.bin:/system/etc/firmware/ti-connectivity/wl128x-fw-4-sr.bin \
    device/motorola/solana/prebuilt/etc/firmware/ti-connectivity/wl1271-nvs.bin:/system/etc/firmware/ti-connectivity/wl1271-nvs.bin \

# Phone settings
PRODUCT_COPY_FILES += \
    device/motorola/solana/prebuilt/etc/apns-conf.xml:system/etc/apns-conf.xml \
    vendor/cm/prebuilt/common/etc/spn-conf.xml:system/etc/spn-conf.xml \

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# still need to set english for audio init
PRODUCT_LOCALES += en_US


# copy all kernel modules under the "modules" directory to system/lib/modules
PRODUCT_COPY_FILES += $(shell \
    find device/motorola/solana/modules -name '*.ko' \
    | sed -r 's/^\/?(.*\/)([^/ ]+)$$/\1\2:system\/lib\/modules\/\2/' \
    | tr '\n' ' ')

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/motorola/solana/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# stuff specific to ti OMAP4 hardware
$(call inherit-product, hardware/ti/omap4xxx/omap4.mk)
$(call inherit-product, hardware/ti/wpan/ti-wpan-products.mk)


$(call inherit-product-if-exists, vendor/motorola/solana/solana-vendor.mk)


$(call inherit-product, build/target/product/full_base_telephony.mk)

PRODUCT_NAME := full_solana
PRODUCT_DEVICE := solana
