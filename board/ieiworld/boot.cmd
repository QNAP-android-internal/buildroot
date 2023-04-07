setenv ramdisk_file rootfs.cpio.uboot
setexpr ramdisk_addr_r ${fdt_addr} + 0x1F0000
setenv loadramdisk 'fatload mmc ${mmcdev}:${mmcpart} ${ramdisk_addr_r} ${ramdisk_file}'
setenv mmcroot ${mmcroot}
run mmcargs
run loadimage
run loadfdt
run loadramdisk
booti ${loadaddr} ${ramdisk_addr_r} ${fdt_addr}
