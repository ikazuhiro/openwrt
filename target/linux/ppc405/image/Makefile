include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS += IMAGE_SIZE

define Device/Default
  PROFILES := Default
  KERNEL_ENTRY := 0x00000000
  KERNEL_LOADADDR := 0x00000000
  DEVICE_DTS = $(subst _,-,$(1))
endef

ifeq ($(SUBTARGET),generic)
include ./generic.mk
endif

$(eval $(call BuildImage))
