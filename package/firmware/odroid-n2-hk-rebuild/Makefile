# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2017 - 2021 Stijn Tintel <stijn@linux-ipv6.be>

include $(TOPDIR)/rules.mk

PKG_NAME:=odroid-firmware-n2-hk-rebuild
PKG_VERSION:=2021-06-28
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/hardkernel/u-boot
PKG_SOURCE_DATE:=$(PKG_VERSION)
PKG_SOURCE_VERSION:=766167bbe787e494e47376b31cd017b897e9594c
PKG_MIRROR_HASH:=e8b0f290826a897fb343c4bbe894ad520cedbe8ea686b9dcfdb7f3243192e038

PKG_MAINTAINER:=Stijn Tintel <stijn@linux-ipv6.be>

PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk

define Package/odroid-firmware-n2-hk-rebuild
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Odroid N2 firmware
  DEPENDS:=@TARGET_mesongx
endef


CM3_GCC_NAME:=gcc-arm
CM3_GCC_RELEASE:=10.2-2020.11
CM3_GCC_ELF_VERSION:=$(HOST_ARCH)-aarch64-none-elf
CM3_GCC_ELF_NAME=$(CM3_GCC_NAME)-$(CM3_GCC_RELEASE)-$(CM3_GCC_ELF_VERSION)
CM3_GCC_ELF_SOURCE=$(CM3_GCC_ELF_NAME).tar.xz
CM3_GCC_EABI_VERSION:=$(HOST_ARCH)-arm-none-eabi
CM3_GCC_EABI_NAME=$(CM3_GCC_NAME)-$(CM3_GCC_RELEASE)-$(CM3_GCC_EABI_VERSION)
CM3_GCC_EABI_SOURCE=$(CM3_GCC_EABI_NAME).tar.xz

MAKE_VARS= \
	PATH=$(STAGING_DIR_IMAGE)/$(CM3_GCC_ELF_NAME)/bin:$(STAGING_DIR_IMAGE)/$(CM3_GCC_EABI_NAME)/bin:$(PATH) \
	CROSS_COMPILE=aarch64-none-elf-

define Download/aml-encrypt-g12b
  FILE:=aml_encrypt_g12b
  URL:=https://github.com/LibreELEC/amlogic-boot-fip/raw/3384f1bc82fc554ed1fa0716bd821e1a2a350db2/odroid-n2
  HASH:=skip
endef

define Download/blx-fix-sh
  FILE:=blx_fix.sh
  URL:=https://github.com/LibreELEC/amlogic-boot-fip/raw/3384f1bc82fc554ed1fa0716bd821e1a2a350db2/odroid-n2
  HASH:=skip
endef

define Download/cm3-gcc-elf
  FILE:=$(CM3_GCC_ELF_SOURCE)
  URL:=https://developer.arm.com/-/media/Files/downloads/gnu-a/$(CM3_GCC_RELEASE)/binrel
  HASH:=32abfbc7b24c56542f2a6e6969d6b8787e47f7223e8f2097d84151ebd9f86743
endef

define Download/cm3-gcc-eabi
  FILE:=$(CM3_GCC_EABI_SOURCE)
  URL:=https://developer.arm.com/-/media/Files/downloads/gnu-a/$(CM3_GCC_RELEASE)/binrel
  HASH:=bf7ee185936d22d787b80c8da573f72ead5675695331fb8b590f0133ef1f6bb9
endef

define Build/Clean
	rm -rf \
		$(STAGING_DIR_IMAGE)/$(CM3_GCC_ELF_NAME) \
		$(STAGING_DIR_IMAGE)/$(CM3_GCC_EABI_NAME)
endef

define Build/Prepare
	# Download sources
	$(eval $(call Download,cm3-gcc-elf))
	$(eval $(call Download,cm3-gcc-eabi))

	$(eval $(call Download,aml-encrypt-g12b))
	$(eval $(call Download,blx-fix-sh))

	$(call Build/Prepare/Default,)

	mkdir -p $(STAGING_DIR_IMAGE)
	$(TAR) -C $(STAGING_DIR_IMAGE) -xf $(DL_DIR)/$(CM3_GCC_ELF_SOURCE)
	$(TAR) -C $(STAGING_DIR_IMAGE) -xf $(DL_DIR)/$(CM3_GCC_EABI_SOURCE)

	$(CP) \
		$(DL_DIR)/aml_encrypt_g12b \
		$(STAGING_DIR_IMAGE)

	$(CP) \
		$(DL_DIR)/blx_fix.sh \
		$(STAGING_DIR_IMAGE)

	chmod +x $(STAGING_DIR_IMAGE)/aml_encrypt_g12b $(STAGING_DIR_IMAGE)/blx_fix.sh
endef

define Build/Configure
	+$(MAKE) -C $(PKG_BUILD_DIR) odroidn2_defconfig
	$(call Build/Configure/Default)
endef

define Build/Compile
	+$(MAKE_VARS) \
	$(MAKE) -C $(PKG_BUILD_DIR)
endef

define Package/odroid-firmware-n2-hk-rebuild/install
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)/odroidn2
	$(CP) \
		$(PKG_BUILD_DIR)/build/board/hardkernel/odroidn2/firmware/acs.bin \
		$(STAGING_DIR_IMAGE)/odroidn2
	$(CP) \
		$(PKG_BUILD_DIR)/build/scp_task/bl301.bin \
		$(STAGING_DIR_IMAGE)/odroidn2

	$(CP) \
		$(PKG_BUILD_DIR)/fip/g12b/{bl2.bin,bl30.bin} \
		$(STAGING_DIR_IMAGE)/odroidn2

	$(CP) \
		$(PKG_BUILD_DIR)/fip/g12b/{ddr3_1d,ddr4_1d,ddr4_2d}.fw \
		$(STAGING_DIR_IMAGE)/odroidn2

	$(CP) \
		$(PKG_BUILD_DIR)/fip/g12b/{diag_lpddr4,lpddr4_1d,lpddr4_2d,piei,aml_ddr}.fw \
		$(STAGING_DIR_IMAGE)/odroidn2
endef

$(eval $(call BuildPackage,odroid-firmware-n2-hk-rebuild))
