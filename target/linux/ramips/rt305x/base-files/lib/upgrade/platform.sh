#
# Copyright (C) 2010 OpenWrt.org
#

PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

platform_check_image() {
	case "$(board_name)" in
	*ht-tm02)
		local config_size=$(mtd_get_part_size config)

		[ -n "$config_size" ] || return 0

		cat << EOF
The "config" partitions is not present.
Probably you are using wingspinner's image.
You need to roll back to vendor firmware + U-Boot first!
After that you should install OpenWrt through
"kernel" + "rootfs" TFTP recovery!
Once this is done, retry!
EOF
		return 1
		;;
	esac
	return 0
}


hootoo_do_upgrade() {
	local tar_file="$1"

	local board_dir=$(tar tf $tar_file | grep -m 1 '^sysupgrade-.*/$')
	board_dir=${board_dir%/}

	tar Oxf $tar_file ${board_dir}/kernel | mtd write - kernel

	if [ -n "$UPGRADE_BACKUP" ]; then
		tar Oxf $tar_file ${board_dir}/root | mtd -j "$UPGRADE_BACKUP" write - rootfs
	else
		tar Oxf $tar_file ${board_dir}/root | mtd write - rootfs
	fi
}


platform_do_upgrade() {
	local board=$(board_name)

	case "$board" in
	hootoo,ht-tm02)
		hootoo_do_upgrade "$1"
		;;
	*)
		default_do_upgrade "$1"
		;;
	esac
}
