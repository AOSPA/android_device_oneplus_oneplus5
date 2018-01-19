$(call inherit-product, device/oneplus/oneplus5/base.mk)

PRODUCT_BRAND := oneplus

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    ro.hardware.power_library=/system/lib/hw/power.qcom.so \
    ro.hardware.power_hint_library=/system/lib/hw/powerhint.qti.so \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.sib16_support=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.rat_on=combine \
    persist.radio.schd.cache=3500 \
    sys.vendor.shutdown.waittime=500 \
    ro.build.shutdown_timeout=0

ifneq ($(BOARD_FRP_PARTITION_NAME),)
    PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/bootdevice/by-name/$(BOARD_FRP_PARTITION_NAME)
else
    PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/bootdevice/by-name/config
endif

# whitelisted app
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/qti_whitelist.xml:system/etc/sysconfig/qti_whitelist.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/privapp-permissions-qti.xml:system/etc/permissions/privapp-permissions-qti.xml
