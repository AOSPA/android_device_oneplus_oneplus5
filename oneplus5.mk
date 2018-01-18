TARGET_USES_AOSP := true
TARGET_USES_QCOM_BSP := false
DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay
TARGET_USES_NQ_NFC := true

TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
TARGET_DISABLE_DASH := true

# Default A/B configuration.
ENABLE_AB := false

# Flag to enable and support NQ3XX chipsets
NQ3XX_PRESENT := true

# enable the SVA in UI area
TARGET_USE_UI_SVA := true

# Video codec configuration files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/media/media_profiles.xml:system/vendor/etc/media_profiles_vendor.xml \
    $(LOCAL_PATH)/media/media_codecs.xml:system/vendor/etc/media_codecs.xml \
    $(LOCAL_PATH)/media/media_codecs_performance.xml:system/vendor/etc/media_codecs_performance.xml

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Add support for whitelisted apps
# PRODUCT_COPY_FILES += $(LOCAL_PATH)/whitelistedapps.xml:system/etc/whitelistedapps.xml

#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

$(call inherit-product, $(LOCAL_PATH)/common64.mk)

# system prop for opengles version
#
# 196608 is decimal for 0x30000 to report version 3
# 196609 is decimal for 0x30001 to report version 3.1
# 196610 is decimal for 0x30002 to report version 3.2
PRODUCT_PROPERTY_OVERRIDES  += \
    ro.opengles.version=196610

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# system prop for Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=cherokee

DEVICE_MANIFEST_FILE := $(LOCAL_PATH)/manifest.xml
DEVICE_MATRIX_FILE   := $(LOCAL_PATH)/compatibility_matrix.xml

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msm8998/msm8998.mk

PRODUCT_PACKAGES += \
    audiod \
    audio.r_submix.default \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/mixer_paths_tasha.xml:system/etc/mixer_paths_tasha.xml \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:system/etc/audio_platform_info.xml

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl


# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sensors/hals.conf:system/vendor/sensors/hals.conf

# Exclude TOF sensor from InputManager
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/excluded-input-devices.xml:system/etc/excluded-input-devices.xml

# QPerformance
PRODUCT_BOOT_JARS += QPerformance

# WLAN driver configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/WCNSS_qcom_cfg.ini:system/vendor/etc/wifi/WCNSS_qcom_cfg.ini \
    $(LOCAL_PATH)/wifi/wifi_concurrency_cfg.txt:system/vendor/etc/wifi/wifi_concurrency_cfg.txt

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:system/vendor/etc/permissions/android.software.midi.xml

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf \
    libcld80211 \
    wpa_supplicant.conf \
    android.hardware.wifi@1.0-service

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

# Android_net
PRODUCT_PACKAGES += \
    libandroid_net \
    libandroid_net_32

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

# Display
PRODUCT_PACKAGES += \
    libjson \
    libtinyxml

# GPS
PRODUCT_PACKAGES += \
    gps.msm8998 \
    libvehiclenetwork-native

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gps/etc/flp.conf:system/vendor/etc/flp.conf \
    $(LOCAL_PATH)/gps/etc/izat.conf:system/vendor/etc/izat.conf \
    $(LOCAL_PATH)/gps/etc/lowi.conf:system/vendor/etc/lowi.conf \
    $(LOCAL_PATH)/gps/etc/sap.conf:system/vendor/etc/sap.conf \
    $(LOCAL_PATH)/gps/etc/xtwifi.conf:system/vendor/etc/xtwifi.conf

# Sensor features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/vendor/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/vendor/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/vendor/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/vendor/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/vendor/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/vendor/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/vendor/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/vendor/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:system/vendor/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:system/vendor/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:system/vendor/etc/permissions/android.hardware.sensor.hifi_sensors.xml

PRODUCT_PACKAGES += libsensor1_system
PRODUCT_PACKAGES += libsensor_reg_system
PRODUCT_PACKAGES += libqmi_cci_system
PRODUCT_PACKAGES += libdiag_system

# High performance VR feature
#PRODUCT_COPY_FILES += \
#    frameworks/native/data/etc/android.hardware.vr.high_performance.xml:system/etc/permissions/android.hardware.vr.high_performance.xml

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf

# Powerhint configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/powerhint.xml:system/vendor/etc/powerhint.xml

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# List of AAPT configurations
PRODUCT_AAPT_CONFIG += xlarge large

# Lights
PRODUCT_PACKAGES += lights.qcom

#for wlan
PRODUCT_PACKAGES += \
       wificond \
       wifilogd

#Healthd packages
PRODUCT_PACKAGES += android.hardware.health@1.0-impl \
                   android.hardware.health@1.0-convert \
                   android.hardware.health@1.0-service \
                   libhealthd.msm

#Enable AOSP KEYMASTER and GATEKEEPER HIDLs
PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-impl \
                    android.hardware.gatekeeper@1.0-service \
                    android.hardware.keymaster@3.0-impl \
                    android.hardware.keymaster@3.0-service

PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/system/vendor/lib64/libril-qc-qmi-1.so

#VR
PRODUCT_PACKAGES += android.hardware.vr@1.0-impl \
                    android.hardware.vr@1.0-service

#Thermal
PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service

#Android fingerprint daemon implementation
PRODUCT_PACKAGES += \
    fingerprintd \
    android.hardware.biometrics.fingerprint@2.1-service

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:system/vendor/etc/permissions/android.hardware.fingerprint.xml

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/vendor/etc/permissions/android.hardware.opengles.aep.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/power/power_profile.xml:system/vendor/etc/power_profile.xml \
    $(LOCAL_PATH)/power/power_profile_5t.xml:system/vendor/etc/power_profile_5t.xml

# Call the proprietary setup
$(call inherit-product, vendor/oneplus/oneplus5/oneplus5-vendor.mk)
