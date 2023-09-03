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
	CONFIG_DWC_OTG_405EX=y \
	CONFIG_DWC_OTG_DEBUG=y
  DEPENDS:=+kmod-usb-obs600-dwc-otg
  FILES:= \
	$(LINUX_DIR)/drivers/usb/dwc_otg/dwc_otg.ko
AUTOLOAD:=$(call AutoLoad,55,dwc_otg,1)
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
  AUTOLOAD:=$(call AutoLoad,09,crypto4xx,1)
  $(call AddDepends/crypto)
endef

$(eval $(call KernelPackage,crypto-hw-crypto4xx))

define KernelPackage/crypto-aes
  TITLE:=CryptoAPI AES support
  DEPENDS:= +kmod-crypto-algapi
  KCONFIG:= \
	CONFIG_CRYPTO_AES \
	CONFIG_CRYPTO_LIB_AES
  FILES:= \
	$(LINUX_DIR)/crypto/aes_generic.ko \
	$(LINUX_DIR)/lib/crypto/libaes.ko
  AUTOLOAD:=$(call AutoLoad,09,aes_generic)
  $(call AddDepends/crypto)
endef

$(eval $(call KernelPackage,crypto-aes))

define KernelPackage/crypto-algapi
  TITLE:=Cryptographic low level API
  DEPENDS:= 
  KCONFIG:= \
        CONFIG_CRYPTO_ALGAPI \
	CONFIG_CRYPTO_ALGAPI2
  FILES:= \
	$(LINUX_DIR)/crypto/crypto_algapi.ko
  AUTOLOAD:=$(call AutoLoad,09,crypto_algapi)
  $(call AddDepends/crypto)
endef

$(eval $(call KernelPackage,crypto-algapi))

define KernelPackage/crypto-skcipher
  TITLE:= Symmetric key cipher CryptoAPI module
  DEPENDS:= +kmod-crypto-algapi
  KCONFIG:= \
        CONFIG_CRYPTO_SKCIPHER \
        CONFIG_CRYPTO_SKCIPHER2
  FILES:= \
	$(LINUX_DIR)/crypto/skcipher.ko
  AUTOLOAD:=$(call AutoLoad,09,skcipher)
  $(call AddDepends/crypto)
endef

$(eval $(call KernelPackage,crypto-skcipher))

define KernelPackage/ibm-emac
  SUBMENU:=$(NETWORK_DEVICES_MENU)
  TITLE:=IBM EMAC Ethernet support
  DEPENDS:= +kmod-crypto-crc32 +kmod-libphy +kmod-mdio-devres
  KCONFIG:= \
	CONFIG_IBM_EMAC \
	CONFIG_IBM_EMAC4=y \
	CONFIG_IBM_EMAC_POLL_WEIGHT=32 \
	CONFIG_IBM_EMAC_RGMII=y \
	CONFIG_IBM_EMAC_RXB=128 \
	CONFIG_IBM_EMAC_RX_COPY_THRESHOLD=256 \
	CONFIG_IBM_EMAC_TXB=64
  FILES:= \
	$(LINUX_DIR)/drivers/net/ethernet/ibm/emac/ibm_emac.ko
  AUTOLOAD:=$(call AutoLoad,51,ibm_emac,1)
endef

define KernelPackage/ibm-emac/description
 This driver supports the IBM EMAC family of Ethernet controllers
 typically found on 4xx embedded PowerPC chips.
endef

$(eval $(call KernelPackage,ibm-emac))

define KernelPackage/gpio-ppc4xx
  SUBMENU:=$(OTHER_MENU)
  TITLE:=GPIO support for PPC4xx
  DEPENDS:=
  KCONFIG:= \
	CONFIG_GPIO_CDEV=y \
	CONFIG_GPIO_GENERIC \
	CONFIG_GPIO_GENERIC_PLATFORM \
	CONFIG_PPC4xx_GPIO=y
  FILES:= \
	$(LINUX_DIR)/drivers/gpio/gpio-generic.ko
  AUTOLOAD:=$(call AutoLoad,08,gpio_generic,1)
endef

$(eval $(call KernelPackage,gpio-ppc4xx))
