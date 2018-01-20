# Copyright (C) 2018 Paranoid Android
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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# Set the firmware path in the environment
target_firmware_path := $(ANDROID_BUILD_TOP)/vendor/oneplus/oneplus5/firmware_images/

# Oneplus 5
# Radio fusion file
$(call add-firmware-file,$(target_firmware_path)/NON-HLOS.bin-op5)
# Bluetooth file
$(call add-firmware-file,$(target_firmware_path)/BTFM.bin-op5)
# rpm image
$(call add-firmware-file,$(target_firmware_path)/rpm.mbn-op5)
# pmic file
$(call add-firmware-file,$(target_firmware_path)/pmic.elf-op5)
# tz version image
$(call add-firmware-file,$(target_firmware_path)/tz.mbn-op5)
# hyp image
$(call add-firmware-file,$(target_firmware_path)/hyp.mbn-op5)
# adspso file
$(call add-firmware-file,$(target_firmware_path)/adspso.bin-op5)
# cmnlib image
$(call add-firmware-file,$(target_firmware_path)/cmnlib.mbn-op5)
# cmnlib64 image
$(call add-firmware-file,$(target_firmware_path)/cmnlib64.mbn-op5)
# devcfg image
$(call add-firmware-file,$(target_firmware_path)/devcfg.mbn-op5)
# keymaster image
$(call add-firmware-file,$(target_firmware_path)/keymaster.mbn-op5)
# xbl file
$(call add-firmware-file,$(target_firmware_path)/xbl.elf-op5)

# Oneplus 5T
# Radio fusion file
$(call add-firmware-file,$(target_firmware_path)/NON-HLOS.bin-op5t)
# Bluetooth file
$(call add-firmware-file,$(target_firmware_path)/BTFM.bin-op5t)
# rpm image
$(call add-firmware-file,$(target_firmware_path)/rpm.mbn-op5t)
# pmic file
$(call add-firmware-file,$(target_firmware_path)/pmic.elf-op5t)
# tz version image
$(call add-firmware-file,$(target_firmware_path)/tz.mbn-op5t)
# hyp image
$(call add-firmware-file,$(target_firmware_path)/hyp.mbn-op5t)
# adspso file
$(call add-firmware-file,$(target_firmware_path)/adspso.bin-op5t)
# cmnlib image
$(call add-firmware-file,$(target_firmware_path)/cmnlib.mbn-op5t)
# cmnlib64 image
$(call add-firmware-file,$(target_firmware_path)/cmnlib64.mbn-op5t)
# devcfg image
$(call add-firmware-file,$(target_firmware_path)/devcfg.mbn-op5t)
# keymaster image
$(call add-firmware-file,$(target_firmware_path)/keymaster.mbn-op5t)
# xbl file
$(call add-firmware-file,$(target_firmware_path)/xbl.elf-op5t)

# Unset local variable
target_firmware_path :=
