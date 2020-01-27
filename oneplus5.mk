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

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/oneplus/msm8998-common/msm8998-common-vendor.mk)

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:system/product/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.sensor.assist.xml:system/product/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/permissions/android.hardware.sensor.assist.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:system/product/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/permissions/android.hardware.wifi.passpoint.xml

# VNDK
PRODUCT_TARGET_VNDK_VERSION := 28

# AID/fs configs
PRODUCT_PACKAGES += \
    fs_config_files

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

# Power
PRODUCT_PACKAGES += \
    power.qcom

# VNDK-SP
PRODUCT_PACKAGES += \
    vndk-sp
