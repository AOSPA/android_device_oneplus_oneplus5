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

$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_n_mr1.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/oneplus/oneplus5/oneplus5-vendor.mk)

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
    libaudio-resampler \
    libaudiohal \
    libaudiohal_deathhandler \
    libstagefright_softomx

# Bluetooth
PRODUCT_PACKAGES += \
    libbluetooth_qti \
    libbt-logClient.so \
    vendor.qti.hardware.bluetooth_dun@1.0

# Custom init script
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.pa.rc \
    init.target.rc \
    init.qcom.post_boot.sh \
    ueventd.qcom.rc

# Display
PRODUCT_PACKAGES += \
    libdisplayconfig \
    libqdMetaData.system

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/keylayout/fpc1020.kl:system/usr/keylayout/fpc1020.kl \
    $(LOCAL_PATH)/rootdir/keylayout/gf_input.kl:system/usr/keylayout/gf_input.kl \
    $(LOCAL_PATH)/rootdir/keylayout/synaptics.kl:system/usr/keylayout/synaptics.kl

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.oneplus_msm8998

# Media
PRODUCT_PACKAGES += \
    libmediaplayerservice

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/media_profiles.xml:system/etc/media_profiles.xml

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

# Common RRO Overlays
PRODUCT_PACKAGES += \
    MSM8998CommonBluetoothRes \
    MSM8998CommonCarrierConfigRes \
    MSM8998CommonFrameworkRes \
    MSM8998CommonFrameworkPARes \
    MSM8998CommonSystemUIRes \
    MSM8998CommonSystemUIPARes \
    MSM8998CommonTelephonyRes

# Power
PRODUCT_PACKAGES += \
    power.qcom

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:system/etc/permissions/android.hardware.telephony.ims.xml

# Perf
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/perfconfigstore.xml:system/product/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/perf/perfconfigstore.xml \
    $(LOCAL_PATH)/configs/targetresourceconfigs.xml:system/product/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/perf/targetresourceconfigs.xml \
    $(LOCAL_PATH)/configs/perfboostsconfig.xml:system/product/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/perf/perfboostsconfig.xml

# QTI common
TARGET_COMMON_QTI_COMPONENTS := \
    av \
    bt \
    perf \
    telephony \
    wfd-legacy

# tri-state-key
PRODUCT_PACKAGES += \
    TriStateHandler \
    tri-state-key_daemon

# VNDK
PRODUCT_TARGET_VNDK_VERSION := 29

# VNDK-SP
PRODUCT_PACKAGES += \
    vndk-sp

# ParanoidDoze
PRODUCT_PACKAGES += ParanoidDoze
