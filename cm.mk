# Inherit device configuration for Droid3.
$(call inherit-product, device/motorola/solana/device_solana.mk)

# Inherit some common cyanogenmod stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit some common CM stuff.
#$(call inherit-product, vendor/cm/config/gsm.mk)

#
# Setup device specific product configuration.
#
PRODUCT_NAME := cm_solana
PRODUCT_BRAND := verizon
PRODUCT_DEVICE := solana
PRODUCT_MODEL := XT862
PRODUCT_MANUFACTURER := Motorola
PRODUCT_SFX := vzw

# Release name and versioning
PRODUCT_RELEASE_NAME := Droid3

UTC_DATE := $(shell date +%s)
DATE := $(shell date +%Y%m%d)
ACT_DATE := $(shell date +%F/%R)

PRODUCT_BUILD_PROP_OVERRIDES += \
   ANDROID_VERSION=4.0.3_r1 \
   BUILD_ID=5.5.1_84_D3G-55 \
   PRODUCT_NAME=${PRODUCT_DEVICE}_${PRODUCT_SFX} \
   BUILD_NUMBER=${DATE} \
   TARGET_DEVICE=cdma_solana \
   TARGET_BUILD_TYPE=user \
   BUILD_VERSION_TAGS=release-keys \
   BUILD_DISPLAY_ID=ICS_Alpha_${BUILD_ID} \
   BUILD_FINGERPRINT=${PRODUCT_BRAND}/${PRODUCT_DEVICE}_${PRODUCT_SFX}/${TARGET_DEVICE}:${ANDROID_VERSION}/${BUILD_ID}/${BUILD_NUMBER}:${TARGET_BUJILD_TYPE}/${BUILD_VERSION_TAGS} \
   PRIVATE_BUILD_DESC=${TARGET_DEVICE}"-"${TARGET_BUJILD_TYPE}" "${ANDROID_VERSION}" "${BUILD_ID}" "${BUILD_NUMBER}" "${BUILD_VERSION_TAGS} \
   PRODUCT_BRAND=verizon \
   BUILD_UTC_DATE= \
   USER=hashcode \
   BUILD_HOST=hashcode-unn \
   PRODUCT_DEFAULT_LANGUAGE=en \
   PRODUCT_DEFAULT_REGION=US \

# Extra Droid3 overlay
#PRODUCT_PACKAGE_OVERLAYS += vendor/cm/overlay/solana

