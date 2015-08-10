$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_NAME := cobalt
PRODUCT_DEVICE := cobalt
PRODUCT_BRAND := Android
PRODUCT_MODEL := Cobalt for arm64

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

# Audio configuration file
PRODUCT_COPY_FILES += \
    device/qcom/cobalt/audio_policy.conf:system/etc/audio_policy.conf \
    device/qcom/cobalt/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    device/qcom/cobalt/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/qcom/cobalt/mixer_paths_i2s.xml:system/etc/mixer_paths_i2s.xml \
    device/qcom/cobalt/audio_platform_info_i2s.xml:system/etc/audio_platform_info_i2s.xml

# Listen configuration file
PRODUCT_COPY_FILES += \
    device/qcom/cobalt/listen_platform_info.xml:system/etc/listen_platform_info.xml

