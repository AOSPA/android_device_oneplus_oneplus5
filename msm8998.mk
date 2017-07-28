TARGET_USES_AOSP := true
TARGET_USES_QCOM_BSP := false

ifneq ($(TARGET_USES_AOSP),true)
DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8998/overlay
endif

TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
TARGET_DISABLE_DASH := true

# Default vendor configuration.
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE := true
endif

# Default A/B configuration.
ENABLE_AB ?= true

# Disable QTIC until it's brought up in split system/vendor
# configuration to avoid compilation breakage.
ifeq ($(ENABLE_VENDOR_IMAGE), true)
#TARGET_USES_QTIC := false
endif

TARGET_KERNEL_VERSION := 4.4
BOARD_HAVE_QCOM_FM := true
TARGET_USES_NQ_NFC := true

ifeq ($(TARGET_USES_NQ_NFC),true)
# Flag to enable and support NQ3XX chipsets
NQ3XX_PRESENT := true
endif

BOARD_FRP_PARTITION_NAME :=frp

# enable the SVA in UI area
TARGET_USE_UI_SVA := true

# Video codec configuration files
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += \
    device/qcom/msm8998/media_profiles.xml:system/etc/media_profiles.xml \
    device/qcom/msm8998/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml \
    device/qcom/msm8998/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/qcom/msm8998/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif
# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/msm8998/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/msm8998/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

# Add support for whitelisted apps
PRODUCT_COPY_FILES += device/qcom/msm8998/whitelistedapps.xml:system/etc/whitelistedapps.xml

#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

# Add soft home, back and multitask keys
PRODUCT_PROPERTY_OVERRIDES += \
    qemu.hw.mainkeys=0

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_NAME := msm8998
PRODUCT_DEVICE := msm8998
PRODUCT_BRAND := Android
PRODUCT_MODEL := MSM8998 for arm64

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# WLAN chipset
WLAN_CHIPSET := qca_cld3

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android
PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext

PRODUCT_PACKAGES += telephony-ext

ifneq ($(strip $(QCPATH)),)
PRODUCT_BOOT_JARS += WfdCommon
#Android oem shutdown hook
PRODUCT_BOOT_JARS += oem-services
endif

# system prop for Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=cherokee

ifeq ($(strip $(BOARD_HAVE_QCOM_FM)),true)
PRODUCT_BOOT_JARS += qcom.fmradio
endif #BOARD_HAVE_QCOM_FM

DEVICE_MANIFEST_FILE := device/qcom/msm8998/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msm8998/msm8998.mk

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
#        $(PRODUCT_PACKAGE_OVERLAYS)

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    device/qcom/msm8998/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# WLAN host driver
ifneq ($(WLAN_CHIPSET),)
PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko
endif

# WLAN driver configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8998/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8998/wifi_concurrency_cfg.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wifi_concurrency_cfg.txt

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.0-service \
    android.hardware.broadcastradio@1.0-impl

PRODUCT_PACKAGES += \
    vendor.display.color@1.0-service \
    vendor.display.color@1.0-impl

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

# Sensor features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml

PRODUCT_PACKAGES += libsensor1_system
PRODUCT_PACKAGES += libsensor_reg_system
PRODUCT_PACKAGES += libqmi_cci_system
PRODUCT_PACKAGES += libdiag_system

# High performance VR feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vr.high_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vr.high_performance.xml

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/msm8998/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += device/qcom/msm8998/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Powerhint configuration file
PRODUCT_COPY_FILES += device/qcom/msm8998/powerhint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.xml

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# dm-verity configuration
PRODUCT_SUPPORTS_VERITY := true
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/bootdevice/by-name/system
ifeq ($(ENABLE_VENDOR_IMAGE), true)
PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/bootdevice/by-name/vendor
endif

PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_VENDOR_MOVE_ENABLED := true

# List of AAPT configurations
PRODUCT_AAPT_CONFIG += xlarge large

#for wlan
PRODUCT_PACKAGES += \
	wificond \
	wifilogd

ifeq ($(ENABLE_AB), true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
		    update_engine_client \
		    update_verifier \
		    bootctrl.msm8998 \
		    brillo_update_payload \
		    android.hardware.boot@1.0-impl \
		    android.hardware.boot@1.0-service

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif


#Healthd packages
PRODUCT_PACKAGES += android.hardware.health@1.0-impl \
		    android.hardware.health@1.0-convert \
		    android.hardware.health@1.0-service \
		    libhealthd.msm

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

#Enable QTI KEYMASTER and GATEKEEPER HIDLs
ifeq ($(ENABLE_VENDOR_IMAGE), true)
KMGK_USE_QTI_SERVICE := true
endif

#Enable AOSP KEYMASTER and GATEKEEPER HIDLs
ifneq ($(KMGK_USE_QTI_SERVICE), true)
PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-impl \
                    android.hardware.gatekeeper@1.0-service \
                    android.hardware.keymaster@3.0-impl \
                    android.hardware.keymaster@3.0-service
endif
