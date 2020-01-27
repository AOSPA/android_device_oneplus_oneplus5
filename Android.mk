#
# Copyright 2019 Paranoid Android
# This empty Android.mk file exists to prevent the build system from
# automatically including any other Android.mk files under this directory.
#

LOCAL_PATH := $(call my-dir)

ifneq ($(filter oneplus5 oneplus5t,$(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif