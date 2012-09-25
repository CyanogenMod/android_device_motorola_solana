# Copyright (C) 2011 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Camera and Gallery
PRODUCT_PACKAGES := \
    Gallery

#if we do this after the full_base_telephony is included some of these don't get picked up..
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
# Inherit from solana device
$(call inherit-product-if-exists, device/motorola/kexec/kexec.mk)
$(call inherit-product, device/motorola/solana/device.mk)

# Set those variables here to overwrite the inherited values.
PRODUCT_NAME := full_solana
PRODUCT_DEVICE := solana
PRODUCT_BRAND := verizon
PRODUCT_MODEL := DROID3
