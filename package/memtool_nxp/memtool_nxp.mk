MEMTOOL_NXP_SITE := package/memtool_nxp
MEMTOOL_NXP_INSTALL_TARGET :=YES
MEMTOOL_NXP_SITE_METHOD := local

define MEMTOOL_NXP_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="-g -Wall" -C $(@D)
endef

define MEMTOOL_NXP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/memtool_nxp $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
