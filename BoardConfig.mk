#
# Copyright 2019 The Android Open Source Project
# Copyright 2020 Paranoid Android
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

BOARD_VENDOR := oneplus
COMMON_PATH := device/oneplus/oneplus5

# Asserts
TARGET_BOARD_INFO_FILE := $(COMMON_PATH)/board-info.txt

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a73

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a73

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := msm8998
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Dex
ifeq ($(HOST_OS),linux)
    ifneq ($(TARGET_BUILD_VARIANT),eng)
      WITH_DEXPREOPT ?= true
      WITH_DEXPREOPT_PIC := false
    endif
endif

# Kernel
BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 sched_enable_hmp=1 sched_enable_power_aware=1 service_locator.enable=1 swiotlb=2048 androidboot.usbconfigfs=true androidboot.usbcontroller=a800000.dwc3 firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7 androidboot.configfs=true
#BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME  := Image.gz-dtb
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000
BOARD_ROOT_EXTRA_FOLDERS := oem
BOARD_ROOT_EXTRA_SYMLINKS := /vendor/bt_firmware:/bt_firmware /vendor/dsp:/dsp /vendor/firmware_mnt:/firmware /mnt/vendor/persist:/persist
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/oneplus/msm8998
TARGET_KERNEL_CONFIG := paranoid_defconfig
TARGET_KERNEL_CLANG_COMPILE := true

# Platform
TARGET_BOARD_PLATFORM := msm8998
TARGET_BOARD_PLATFORM_GPU := qcom-adreno540

# Charger Mode
BOARD_CHARGER_ENABLE_SUSPEND := true

# Display
TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_QCOM_DISPLAY_BSP := true
TARGET_USES_COLOR_METADATA := true
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
MAX_VIRTUAL_DISPLAY_DIMENSION := 4096
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
USE_OPENGL_RENDERER := true

# DRM
TARGET_ENABLE_MEDIADRM_64 := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(COMMON_PATH)/config.fs

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 56908316672
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)

TARGET_COPY_OUT_VENDOR := vendor

# Recovery
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/recovery.fstab
TARGET_USES_MKE2FS := true

# Power
TARGET_OVERLAYS_POWERHAL := true
TARGET_USES_INTERACTION_BOOST := true

# Properties
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Treble
PRODUCT_FULL_TREBLE_OVERRIDE := true
BOARD_VNDK_VERSION := current
BOARD_VNDK_RUNTIME_DISABLE := false
BOARD_SYSTEMSDK_VERSIONS := 28
PRODUCT_EXTRA_VNDK_VERSIONS := 28
PRODUCT_SHIPPING_API_LEVEL := 25

# Wifi
TARGET_USES_QCOM_WCNSS_QMI       := false
BOARD_HAS_QCOM_WLAN              := true
BOARD_WLAN_DEVICE                := qcwcn
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"
WIFI_DRIVER_FW_PATH_P2P          := "p2p"
#WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/wlan.ko"
#WIFI_DRIVER_MODULE_NAME          := "wlan"
#WIFI_DRIVER_MODULE_ARG           := ""
WIFI_DRIVER_STATE_CTRL_PARAM     := "/dev/wlan"
WIFI_DRIVER_STATE_ON             := "ON"
WIFI_DRIVER_STATE_OFF            := "OFF"
WIFI_DRIVER_BUILT                := qca_cld3
WIFI_DRIVER_DEFAULT              := qca_cld3
#WIFI_HIDL_FEATURE_AWARE          := true
#WIFI_DRIVER_LOAD_DELAY           := true
DISABLE_EAP_PROXY                := true
CONFIG_ACS                       := true
CONFIG_IEEE80211AC               := true

# inherit from the proprietary version
-include vendor/oneplus/oneplus5/BoardConfigVendor.mk

