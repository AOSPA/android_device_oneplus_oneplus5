DEVICE_PACKAGE_OVERLAYS := device/oneplus/oneplus5/overlay
TARGET_USES_NQ_NFC := true

# Flag to enable and support NQ3XX chipsets
NQ3XX_PRESENT := true

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
BOARD_FRP_PARTITION_NAME := frp

# enable the SVA in UI area
TARGET_USE_UI_SVA := true

# Video codec configuration files
PRODUCT_COPY_FILES += \
    device/oneplus/oneplus5/media/media_profiles.xml:system/etc/media_profiles.xml \
    device/oneplus/oneplus5/media/media_codecs.xml:system/etc/media_codecs.xml \
    device/oneplus/oneplus5/media/media_codecs_performance.xml:system/etc/media_codecs_performance.xml

#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

$(call inherit-product, device/oneplus/oneplus5/common64.mk)

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# WLAN chipset
WLAN_CHIPSET := qca_cld3

PRODUCT_PACKAGES += libqmiextservices

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msm8998/msm8998.mk

PRODUCT_COPY_FILES += \
    device/oneplus/oneplus5/audio/mixer_paths_tasha.xml:system/etc/mixer_paths_tasha.xml \
    device/oneplus/oneplus5/audio/audio_platform_info.xml:system/etc/audio_platform_info.xml

PRODUCT_PACKAGE_OVERLAYS := \
    $(QCPATH)/qrdplus/Extension/res \
    $(QCPATH)/qrdplus/globalization/multi-language/res-overlay \
    $(PRODUCT_PACKAGE_OVERLAYS)

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    device/oneplus/oneplus5/sensors/hals.conf:system/etc/sensors/hals.conf

# QPerformance
PRODUCT_BOOT_JARS += QPerformance

# WLAN driver configuration file
PRODUCT_COPY_FILES += \
    device/oneplus/oneplus5/wifi/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/oneplus/oneplus5/wifi/wifi_concurrency_cfg.txt:system/etc/wifi/wifi_concurrency_cfg.txt

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

# Sensor features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:system/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:system/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:system/etc/permissions/android.hardware.sensor.hifi_sensors.xml

# High performance VR feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vr.high_performance.xml:system/etc/permissions/android.hardware.vr.high_performance.xml

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    device/oneplus/oneplus5/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf

# Powerhint configuration file
PRODUCT_COPY_FILES += \
    device/oneplus/oneplus5/powerhint_soc_id_292.xml:system/etc/powerhint_soc_id_292.xml

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# List of AAPT configurations
PRODUCT_AAPT_CONFIG += xlarge large

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml

# Call the proprietary setup
$(call inherit-product, vendor/oneplus/oneplus5/oneplus5-vendor.mk)
