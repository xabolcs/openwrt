#
# Copyright (C) 2017-2019 Stijn Tintel <stijn@linux-ipv6.be>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Build/bootloader-odroid-c2
	fip_create \
		--bl30  $(STAGING_DIR_IMAGE)/odroidc2/bl30.bin \
		--bl301 $(STAGING_DIR_IMAGE)/odroidc2/bl301.bin \
		--bl31  $(STAGING_DIR_IMAGE)/bl31_gxbb.bin \
		--bl33  $(BIN_DIR)/u-boot-odroid-c2/u-boot.bin \
		$(STAGING_DIR_IMAGE)/odroidc2/fip.bin

	cat $(STAGING_DIR_IMAGE)/odroidc2/bl2.package $(STAGING_DIR_IMAGE)/odroidc2/fip.bin > $(STAGING_DIR_IMAGE)/odroidc2/boot_new.bin

	amlbootsig $(STAGING_DIR_IMAGE)/odroidc2/boot_new.bin $(STAGING_DIR_IMAGE)/odroidc2/boot_new.bin.signed

	dd if=$(STAGING_DIR_IMAGE)/odroidc2/boot_new.bin.signed of=$(STAGING_DIR_IMAGE)/odroidc2/u-boot.gxbb bs=512 skip=96
	dd if=$(STAGING_DIR_IMAGE)/odroidc2/bl1.bin.hardkernel of=$@ conv=fsync,notrunc bs=1 count=440
	dd if=$(STAGING_DIR_IMAGE)/odroidc2/bl1.bin.hardkernel of=$@ conv=fsync,notrunc bs=512 skip=1 seek=1
	dd if=$(STAGING_DIR_IMAGE)/odroidc2/u-boot.gxbb of=$@ conv=fsync,notrunc bs=512 seek=97
endef

# FIX ME: use gxlimg (https://github.com/repk/gxlimg), or meson-tools, or meson64-tools (https://github.com/angerman/meson64-tools)
# or at least use the aml_encrypt_g12b binary
define Build/bootloader-odroid-n2
	$(STAGING_DIR_IMAGE)/blx_fix.sh \
		$(STAGING_DIR_IMAGE)/odroidn2/bl30.bin \
		$(STAGING_DIR_IMAGE)/odroidn2/zero_tmp \
		$(STAGING_DIR_IMAGE)/odroidn2/bl30_zero.bin \
		\
		$(STAGING_DIR_IMAGE)/odroidn2/bl301.bin \
		$(STAGING_DIR_IMAGE)/odroidn2/bl301_zero.bin \
		$(STAGING_DIR_IMAGE)/odroidn2/bl30_new.bin \
		\
		bl30

	$(STAGING_DIR_IMAGE)/blx_fix.sh \
		$(STAGING_DIR_IMAGE)/odroidn2/bl2.bin \
		$(STAGING_DIR_IMAGE)/odroidn2/zero_tmp \
		$(STAGING_DIR_IMAGE)/odroidn2/bl2_zero.bin \
		\
		$(STAGING_DIR_IMAGE)/odroidn2/acs.bin \
		$(STAGING_DIR_IMAGE)/odroidn2/bl21_zero.bin \
		$(STAGING_DIR_IMAGE)/odroidn2/bl2_new.bin \
		\
		bl2

	$(STAGING_DIR_IMAGE)/aml_encrypt_g12b --bl30sig --input $(STAGING_DIR_IMAGE)/odroidn2/bl30_new.bin          --output $(STAGING_DIR_IMAGE)/odroidn2/bl30_new.bin.g12a.enc --level v3
	$(STAGING_DIR_IMAGE)/aml_encrypt_g12b --bl3sig  --input $(STAGING_DIR_IMAGE)/odroidn2/bl30_new.bin.g12a.enc --output $(STAGING_DIR_IMAGE)/odroidn2/bl30_new.bin.enc      --level v3 --type bl30
	$(STAGING_DIR_IMAGE)/aml_encrypt_g12b --bl3sig  --input $(STAGING_DIR_IMAGE)/bl31_g12a.bin                  --output $(STAGING_DIR_IMAGE)/odroidn2/bl31.img.enc          --level v3 --type bl31
	$(STAGING_DIR_IMAGE)/aml_encrypt_g12b --bl3sig  --input $(BIN_DIR)/u-boot-odroid-n2/u-boot.bin              --output $(STAGING_DIR_IMAGE)/odroidn2/bl33.bin.enc          --level v3 --type bl33
	$(STAGING_DIR_IMAGE)/aml_encrypt_g12b --bl2sig  --input $(STAGING_DIR_IMAGE)/odroidn2/bl2_new.bin           --output $(STAGING_DIR_IMAGE)/odroidn2/bl2.n.bin.sig
	$(STAGING_DIR_IMAGE)/aml_encrypt_g12b --bootmk                                                              --output $(STAGING_DIR_IMAGE)/odroidn2/u-boot.bin            --level v3 \
			--bl2 $(STAGING_DIR_IMAGE)/odroidn2/bl2.n.bin.sig \
			--bl30 $(STAGING_DIR_IMAGE)/odroidn2/bl30_new.bin.enc \
			--bl31 $(STAGING_DIR_IMAGE)/odroidn2/bl31.img.enc \
			--bl33 $(STAGING_DIR_IMAGE)/odroidn2/bl33.bin.enc \
			\
			--ddrfw1 $(STAGING_DIR_IMAGE)/odroidn2/ddr4_1d.fw \
			--ddrfw2 $(STAGING_DIR_IMAGE)/odroidn2/ddr4_2d.fw \
			--ddrfw3 $(STAGING_DIR_IMAGE)/odroidn2/ddr3_1d.fw \
			--ddrfw4 $(STAGING_DIR_IMAGE)/odroidn2/piei.fw \
			--ddrfw5 $(STAGING_DIR_IMAGE)/odroidn2/lpddr4_1d.fw \
			--ddrfw6 $(STAGING_DIR_IMAGE)/odroidn2/lpddr4_2d.fw \
			--ddrfw7 $(STAGING_DIR_IMAGE)/odroidn2/diag_lpddr4.fw \
			--ddrfw8 $(STAGING_DIR_IMAGE)/odroidn2/aml_ddr.fw
	
	dd if=$(STAGING_DIR_IMAGE)/odroidn2/u-boot.bin of=$@ conv=fsync,notrunc bs=512 seek=1
endef

define Build/sdcard-img
	$(INSTALL_DIR) $(KDIR)/boot.ext4
	$(CP) $(KDIR)/boot.$1.scr $(KDIR)/boot.ext4/boot.scr
	$(CP) $(IMAGE_KERNEL) $(KDIR)/boot.ext4/uImage
	$(foreach dts,$(DEVICE_DTS),$(CP) $(DTS_DIR)/$(dts).dtb $(KDIR)/boot.ext4/)
	PADDING="$(CONFIG_TARGET_IMAGES_PAD)" \
	PATH="$(TARGET_PATH)" \
	$(SCRIPT_DIR)/gen_image_generic.sh $@ \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(KDIR)/boot.ext4 \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS) \
		4096
	$(RM) -rf $(KDIR)/boot.ext4
endef

define Build/uImage-meson
	$(call Build/uImage,none)
	sed \
		-e 's#@ROOT@#$(IMG_PART_SIGNATURE)#g' \
		-e 's#@DTB@#$(firstword $(DEVICE_DTS))#g' \
		boot.$1.txt > $@-new.bootscript
	mkimage -A arm64 -T script -C none -n "boot.scr uImage" -d $@-new.bootscript $(KDIR)/boot.$1.scr
endef

### Devices ###
define Device/Default
  FILESYSTEMS := ext4 squashfs
  IMAGES := sdcard.img.gz
  IMAGE/sdcard.img.gz := sdcard-img $$(DEVICE_NAME) | bootloader-$$(DEVICE_NAME) | gzip | append-metadata
  KERNEL_DEPENDS = $$(wildcard $(DTS_DIR)/$$(DEVICE_DTS).dts)
  KERNEL_LOADADDR := 0x01080000
  KERNEL_NAME := Image
  PROFILES = Default $$(DEVICE_NAME)
endef

define Device/odroid-c2
  DEVICE_DTS := amlogic/meson-gxbb-odroidc2
  DEVICE_PACKAGES += odroid-firmware-c2 u-boot-odroid-c2
  DEVICE_TITLE := ODROID C2
  KERNEL := kernel-bin | uImage-meson $$(DEVICE_NAME)
  SUPPORTED_DEVICES += hardkernel,odroid-c2
endef
TARGET_DEVICES += odroid-c2

define Device/odroid-n2
  DEVICE_DTS := amlogic/meson-g12b-odroid-n2
  DEVICE_PACKAGES += amlogic-boot-fip u-boot-odroid-n2 kmod-rtc-pcf8563 kmod-usb-storage-uas kmod-usb-net-rtl8152
  DEVICE_TITLE := ODROID N2
  KERNEL := kernel-bin | uImage-meson $$(DEVICE_NAME)
  SUPPORTED_DEVICES += hardkernel,odroid-n2
endef
TARGET_DEVICES += odroid-n2

$(eval $(call BuildImage))
