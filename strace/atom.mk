
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := strace
LOCAL_DESCRIPTION := Trace system call
LOCAL_CATEGORY_PATH := devel

LOCAL_AUTOTOOLS_VERSION := 4.10
LOCAL_AUTOTOOLS_ARCHIVE := $(LOCAL_MODULE)-$(LOCAL_AUTOTOOLS_VERSION).tar.xz
LOCAL_AUTOTOOLS_SUBDIR := $(LOCAL_MODULE)-$(LOCAL_AUTOTOOLS_VERSION)

include $(BUILD_AUTOTOOLS)

