# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2017-2021 Stijn Tintel <stijn@linux-ipv6.be>

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_VERSION:=2021.07
PKG_RELEASE:=1

PKG_HASH:=312b7eeae44581d1362c3a3f02c28d806647756c82ba8c72241c7cdbe68ba77e

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  ARCH:=arm
  BUILD_TARGET:=mesongx
  HIDDEN:=1
endef

define U-Boot/odroid-c2
  TITLE:=ODROID C2
  BUILD_DEVICES:=odroid-c2
  DEPENDS:=+PACKAGE_u-boot-odroid-c2:arm-trusted-firmware-meson-gxbb
endef

define U-Boot/odroid-n2
  TITLE:=ODROID N2
  BUILD_DEVICES:=odroid-n2
  DEPENDS:=+PACKAGE_u-boot-odroid-n2:arm-trusted-firmware-meson-g12a
endef

UBOOT_TARGETS:= \
	odroid-c2 \
	odroid-n2

$(eval $(call BuildPackage/U-Boot))
