$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_NAME := msmcobalt
PRODUCT_DEVICE := msmcobalt
PRODUCT_BRAND := Android
PRODUCT_MODEL := Cobalt for arm64

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android
PRODUCT_BOOT_JARS += tcmiface
# Audio configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msmcobalt/audio_policy.conf:system/etc/audio_policy.conf \
    device/qcom/msmcobalt/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    device/qcom/msmcobalt/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/qcom/msmcobalt/mixer_paths_i2s.xml:system/etc/mixer_paths_i2s.xml \
    device/qcom/msmcobalt/audio_platform_info_i2s.xml:system/etc/audio_platform_info_i2s.xml

# Listen configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msmcobalt/listen_platform_info.xml:system/etc/listen_platform_info.xml

