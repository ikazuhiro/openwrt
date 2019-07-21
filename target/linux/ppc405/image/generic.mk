define Build/obs600-kernel
	cp $(KDIR)/vmlinux $@
endef

define Build/obs600-uImage-initramfs
	( cd $(TARGET_DIR); find . | cpio -o -H newc -R root:root | gzip -9n > $(KDIR)/tmp/$(IMG_PREFIX)-initramfs-gz)
	mkimage -n '$(call toupper,$(ARCH)) $(VERSION_DIST) Linux-$(LINUX_VERSION)' -A $(LINUX_KARCH) -O linux -T multi -C gzip \
	-d $@:$(KDIR)/tmp/$(IMG_PREFIX)-initramfs-gz:$(KDIR)/image-$(firstword $(DEVICE_DTS)).dtb \
	$(KDIR)/tmp/obs600-uImage-initramfs
	mv $(KDIR)/tmp/obs600-uImage-initramfs $@
	rm -f $(KDIR)/tmp/$(IMG_PREFIX)-initramfs-gz
endef

define Build/obs600-uImage-dummyfs
	dd if=/dev/zero bs=1 count=1 >> $(KDIR)/tmp/dummyfs
	mkimage -n '$(call toupper,$(ARCH)) $(VERSION_DIST) Linux-$(LINUX_VERSION)' -A $(LINUX_KARCH) -O linux -T multi -C gzip \
	-d $@:$(KDIR)/tmp/dummyfs:$(KDIR)/image-$(firstword $(DEVICE_DTS)).dtb \
	$@.new
	mv $@.new $@
	rm $(KDIR)/tmp/dummyfs
endef

define Device/obs600
  DEVICE_DTS:=obs600
  DEVICE_DTS_DIR:=$(DTS_DIR)
  DEVICE_TITLE := PlatHome OpenBlocks 600
  KERNEL := kernel-bin | gzip
  KERNEL_INITRAMFS := obs600-kernel | gzip | obs600-uImage-initramfs
  DEVICE_PACKAGES := kmod-leds-gpio kmod-gpio-button-hotplug		\
  kmod-usb2 kmod-usb-ledtrig-usbport			\
  kmod-ledtrig-default-on kmod-ledtrig-netdev
  FEATURES+=ramdisk dt usb squashfs cpiogz
  IMAGE_SIZE = 63000k
  BLOCKSIZE = 128k
  IMAGES += sysupgrade.bin
  IMAGE/sysupgrade.bin := obs600-kernel | gzip | obs600-uImage-dummyfs | pad-to $$$$(BLOCKSIZE) | append-rootfs | check-size $$$$(IMAGE_SIZE) | append-metadata
  SUPPORTED_DEVICES += plathome,obs600 obs600
endef

TARGET_DEVICES += obs600
