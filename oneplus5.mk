#
# Copyright (C) 2022 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

# AID/fs configs
PRODUCT_PACKAGES += \
    fs_config_files

# Board Platform
TARGET_BOARD_PLATFORM := msm8998

# IPC router config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# Kernel
TARGET_KERNEL_VERSION := 4.4

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/fpc1020.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/fpc1020.kl \
    $(LOCAL_PATH)/configs/keylayout/gf_input.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gf_input.kl \
    $(LOCAL_PATH)/configs/keylayout/synaptics_s3320.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/synaptics_s3320.kl

# Overlay
PRODUCT_PACKAGES += \
    FrameworksResTarget \
    OnePlus5SeriesFrameworks \
    OnePlus5Settings \
    WifiResTarget

# Public Libraries
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# QTI common
TARGET_COMMON_QTI_COMPONENTS := \
    overlay

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/oneplus/oneplus5/oneplus5-vendor.mk)
