#
# Copyright 2020 The Paranoid Android Project
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
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_n.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/oneplus/msm8998-common/msm8998-common-vendor.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-pa

# Properties
-include $(LOCAL_PATH)/common-props.mk

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

# AID/fs configs
PRODUCT_PACKAGES += \
    fs_config_files

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@5.0 \
    android.hardware.audio.common@5.0 \
    android.hardware.audio.common@5.0-util \
    android.hardware.audio.effect@5.0 \
    libaudio-resampler

# Bluetooth
PRODUCT_PACKAGES += \
    libbluetooth_qti \
    libbt-logClient.so

# Custom init script
PRODUCT_PACKAGES += \
    init.pa.rc \
    ueventd.qcom.rc

# Display
PRODUCT_PACKAGES += \
    libdisplayconfig \
    libqdMetaData.system

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/keylayout/fpc1020.kl:system/usr/keylayout/fpc1020.kl \
    $(LOCAL_PATH)/rootdir/keylayout/synaptics.kl:system/usr/keylayout/synaptics.kl

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.oneplus_msm8998

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc@1.0 \
    android.hardware.nfc@1.1 \
    android.hardware.nfc@1.2 \
    android.hardware.secure_element@1.0 \
    com.android.nfc_extras \
    Tag \
    vendor.nxp.nxpese@1.0 \
    vendor.nxp.nxpnfc@1.0

# NN
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full

# Power
PRODUCT_PACKAGES += \
    power.qcom

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:system/etc/permissions/android.hardware.telephony.ims.xml

# QTI common
-include vendor/qcom/common/av/qti-av.mk
-include vendor/qcom/common/bt/qti-bt.mk
-include vendor/qcom/common/perf/qti-perf.mk

# tri-state-key
PRODUCT_PACKAGES += \
    TriStateHandler \
    tri-state-key_daemon

# VNDK
PRODUCT_TARGET_VNDK_VERSION := 28

# VNDK-SP
PRODUCT_PACKAGES += \
    vndk-sp

# WFD
PRODUCT_PACKAGES += \
    libnl \
    libwfdaac

PRODUCT_BOOT_JARS += \
    WfdCommon

# ParanoidDoze
 PRODUCT_PACKAGES += ParanoidDoze
