# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2017 - 2021 Stijn Tintel <stijn@linux-ipv6.be>

include $(TOPDIR)/rules.mk

PKG_NAME:=odroid-firmware-n2-hk-straight
PKG_VERSION:=travis-odroidc4-189
PKG_RELEASE:=1

PKG_SOURCE:=u-boot-odroidn2-189.tar.gz
PKG_HASH:=0165bd9604f77779d990d2d1054b1d5e0846db2b8211c8caab29ec53d722a3af
PKG_SOURCE_URL:=https://github.com/hardkernel/u-boot/releases/download/travis/odroidc4-189

PKG_MAINTAINER:=Stijn Tintel <stijn@linux-ipv6.be>

PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk

define Package/odroid-firmware-n2-hk-straight
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Odroid N2 firmware (straight from HardKernel U-Boot releases)
  DEPENDS:=@TARGET_mesongx
endef

define Build/Compile

endef

# FIX ME: ../sd_fuse
define Package/odroid-firmware-n2-hk-straight/install
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)/odroidn2

	$(CP) -v \
		$(PKG_BUILD_DIR)/../sd_fuse/u-boot.bin \
		$(STAGING_DIR_IMAGE)/odroidn2
endef

$(eval $(call BuildPackage,odroid-firmware-n2-hk-straight))
