LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_PACKAGE_NAME := MSM8998CommonTelephonyRes
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/overlay
LOCAL_IS_RUNTIME_RESOURCE_OVERLAY := true
LOCAL_PRIVATE_PLATFORM_APIS := true

LOCAL_RESOURCE_DIR := \
    $(LOCAL_PATH)/res

include $(BUILD_PACKAGE)

include $(call all-makefiles-under,$(LOCAL_PATH))
