# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2017 - 2021 Stijn Tintel <stijn@linux-ipv6.be>

include $(TOPDIR)/rules.mk

PKG_NAME:=amlogic-boot-fip
PKG_VERSION:=2021-08-07
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/LibreELEC/amlogic-boot-fip
PKG_SOURCE_DATE:=$(PKG_VERSION)
PKG_SOURCE_VERSION:=3384f1bc82fc554ed1fa0716bd821e1a2a350db2
PKG_MIRROR_HASH:=ea2c31bd508e0b2b91e45371173f3c38adacde885fe6b32e8280626de833263a

PKG_MAINTAINER:=Stijn Tintel <stijn@linux-ipv6.be>

PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk

define Package/amlogic-boot-fip
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=LibreELEC's amlogic-boot-fip
  DEPENDS:=@TARGET_mesongx
endef

define Package/amlogic-boot-fip/description
  Firmware Image Pacakge (FIP) sources used to sign Amlogic u-boot binaries in LibreELEC images
endef

define Build/Compile

endef

define Package/amlogic-boot-fip/install
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)/odroidn2

	$(CP) \
		$(PKG_BUILD_DIR)/odroid-n2/aml_encrypt_g12b \
		$(STAGING_DIR_IMAGE)
	$(CP) \
		$(PKG_BUILD_DIR)/odroid-n2/blx_fix.sh \
		$(STAGING_DIR_IMAGE)
	chmod -v +x $(STAGING_DIR_IMAGE)/aml_encrypt_g12b $(STAGING_DIR_IMAGE)/blx_fix.sh

	$(CP) \
		$(PKG_BUILD_DIR)/odroid-n2/acs.bin \
		$(STAGING_DIR_IMAGE)/odroidn2
	$(CP) \
		$(PKG_BUILD_DIR)/odroid-n2/bl301.bin \
		$(STAGING_DIR_IMAGE)/odroidn2

	$(CP) \
		$(PKG_BUILD_DIR)/odroid-n2/{bl2.bin,bl30.bin} \
		$(STAGING_DIR_IMAGE)/odroidn2

	$(CP) \
		$(PKG_BUILD_DIR)/odroid-n2/{ddr3_1d,ddr4_1d,ddr4_2d}.fw \
		$(STAGING_DIR_IMAGE)/odroidn2

	$(CP) \
		$(PKG_BUILD_DIR)/odroid-n2/{diag_lpddr4,lpddr4_1d,lpddr4_2d,piei,aml_ddr}.fw \
		$(STAGING_DIR_IMAGE)/odroidn2
endef

$(eval $(call BuildPackage,amlogic-boot-fip))
