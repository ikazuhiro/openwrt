#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define KernelPackage/usb-obs600-dwc-otg
  TITLE:=OpenBlocks 600 DWC_OTG wrapper
  KCONFIG:= \
	CONFIG_OBS600_DWC_OTG
  FILES:= \
	$(LINUX_DIR)/arch/powerpc/platforms/40x/obs600-usb.ko
AUTOLOAD:=$(call AutoLoad,54,obs600-usb,1)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-obs600-dwc-otg/description
 dwc_otg driver wrapper for OpenBlocks 600
endef

$(eval $(call KernelPackage,usb-obs600-dwc-otg))


define KernelPackage/usb-dwc-otg
  TITLE:=Synopsis DWC_OTG support
  KCONFIG:= \
	CONFIG_DWC_OTG \
	CONFIG_DWC_OTG_HOST_ONLY=y \
	CONFIG_DWC_OTG_LANTIQ=n \
	CONFIG_DWC_OTG_405EX=y
  DEPENDS:=+kmod-usb-obs600-dwc-otg
  FILES:= \
	$(LINUX_DIR)/drivers/usb/dwc_otg/dwc_otg.ko
AUTOLOAD:=$(call AutoLoad,54,dwc_otg,1)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-dwc-otg/description
 This driver provides USB Device Controller support for the
 Synopsys DesignWare USB OTG Core.
endef

$(eval $(call KernelPackage,usb-dwc-otg))


define KernelPackage/crypto-hw-crypto4xx
  TITLE:=AMCC PPC4xx crypto accelerator
  DEPENDS:= \
	+kmod-crypto-hash +kmod-crypto-aead +kmod-crypto-ccm \
	+kmod-crypto-ctr +kmod-crypto-gcm
  KCONFIG:= \
        CONFIG_CRYPTO_HW=y \
	CONFIG_CRYPTO_DEV_PPC4XX
  FILES:= \
        $(LINUX_DIR)/drivers/crypto/amcc/crypto4xx.ko
  AUTOLOAD:=$(call AutoLoad,09,crypto4xx)
  $(call AddDepends/crypto)
endef

$(eval $(call KernelPackage,crypto-hw-crypto4xx))
