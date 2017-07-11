LOCAL_PATH := $(call my-dir)

#----------------------------------------------------------------------
# Copy additional target-specific files
#----------------------------------------------------------------------

# Create symbolic links for WLAN
$(shell mkdir -p $(TARGET_OUT_ETC)/firmware/wlan/qca_cld; \
	ln -sf /system/etc/wifi/WCNSS_qcom_cfg.ini \
	$(TARGET_OUT_ETC)/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini)

# Create symbolic links for msadp
$(shell  mkdir -p $(TARGET_OUT_VENDOR)/firmware; \
	ln -sf /dev/block/bootdevice/by-name/msadp \
	$(TARGET_OUT_VENDOR)/firmware/msadp)
