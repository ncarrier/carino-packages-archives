
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := hostapd
LOCAL_DESCRIPTION := Wi-Fi access point daemon
LOCAL_CATEGORY_PATH := network/wireless
LOCAL_LIBRARIES := \
	libnl \
	openssl

LOCAL_AUTOTOOLS_VERSION := 2.3
LOCAL_AUTOTOOLS_ARCHIVE := $(LOCAL_MODULE)-$(LOCAL_AUTOTOOLS_VERSION).tar.gz
LOCAL_AUTOTOOLS_SUBDIR := $(LOCAL_MODULE)-$(LOCAL_AUTOTOOLS_VERSION)

HOSTAPD_SRC_DIR := $(call local-get-build-dir)/$(LOCAL_AUTOTOOLS_SUBDIR)

HOSTAPD_CONFIG_FILE := $(call module-get-config,$(LOCAL_MODULE))
ifeq ("$(wildcard $(HOSTAPD_CONFIG_FILE))","")
	HOSTAPD_CONFIG_FILE := $(LOCAL_PATH)/hostapd.config
endif

HOSTAPD_LIBNL_LDFLAGS := \
	-Wl,--no-as-needed \
	-lnl-3 -lnl-route-3 -lnl-genl-3 -lnl-nf-3 -lnl-cli-3 \
	-Wl,--as-needed
HOSTAPD_LIBNL_CFLAGS := \
	-I$(TARGET_OUT_STAGING)/usr/include/libnl3

define LOCAL_AUTOTOOLS_CMD_CONFIGURE
	$(Q) sed "s@#CFLAGS += -I$$<path to libnl .*@CFLAGS += $(HOSTAPD_LIBNL_CFLAGS)@g" \
		$(HOSTAPD_CONFIG_FILE) $(HOSTAPD_SRC_DIR)/hostapd/.config | \
		sed "s@#LIBS += -L$$<path to libnl .*@LIBS += $(HOSTAPD_LIBNL_LDFLAGS)@g" \
		> $(HOSTAPD_SRC_DIR)/hostapd/.config
endef

define LOCAL_AUTOTOOLS_CMD_BUILD
	$(Q) $(AUTOTOOLS_CONFIGURE_ENV) $(MAKE) -C $(PRIVATE_SRC_DIR)/hostapd \
		DESTDIR="$(TARGET_OUT_STAGING)"
endef

define LOCAL_AUTOTOOLS_CMD_INSTALL
	$(Q) mkdir -p $(TARGET_OUT_STAGING)/sbin
	$(Q) cp -pf $(PRIVATE_SRC_DIR)/hostapd/hostapd $(TARGET_OUT_STAGING)/sbin
	$(Q) cp -pf $(PRIVATE_SRC_DIR)/hostapd/hostapd_cli $(TARGET_OUT_STAGING)/sbin
endef

define LOCAL_AUTOTOOLS_CMD_POST_CLEAN
	$(Q) rm -f $(TARGET_OUT_STAGING)/sbin/hostapd
	$(Q) rm -f $(TARGET_OUT_STAGING)/sbin/hostapd_cli
endef

include $(BUILD_AUTOTOOLS)

