# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2021 Stijn Tintel <stijn@linux-ipv6.be>

include $(TOPDIR)/rules.mk

PKG_VERSION:=2.5
PKG_RELEASE:=1

PKG_HASH:=ad8a2ffcbcd12d919723da07630fc0840c3c2fba7656d1462e45488e42995d7c

include $(INCLUDE_DIR)/trusted-firmware-a.mk
include $(INCLUDE_DIR)/package.mk

define Package/arm-trusted-firmware-meson/Default
    SECTION:=boot
    CATEGORY:=Boot Loaders
    TITLE:=ARM Trusted Firmware for Meson
    DEPENDS:=@TARGET_mesongx
endef

define Package/arm-trusted-firmware-meson-g12a
    $(call Package/arm-trusted-firmware-meson/Default)
    VARIANT:=g12a
endef

define Package/arm-trusted-firmware-meson-gxbb
    $(call Package/arm-trusted-firmware-meson/Default)
    VARIANT:=gxbb
endef

MAKE_VARS = \
	CROSS_COMPILE="$(TARGET_CROSS)"

MAKE_FLAGS += \
	PLAT=$(BUILD_VARIANT) \
	bl31

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/build/$(BUILD_VARIANT)/release/bl31.bin $(STAGING_DIR_IMAGE)/bl31_$(BUILD_VARIANT).bin
endef

define Package/arm-trusted-firmware-meson/install
endef

$(eval $(call BuildPackage,arm-trusted-firmware-meson-g12a))
$(eval $(call BuildPackage,arm-trusted-firmware-meson-gxbb))
