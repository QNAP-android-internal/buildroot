RTK_HCIATTACH_SITE := package/rtk_hciattach
RTK_HCIATTACH_INSTALL_TARGET :=YES
RTK_HCIATTACH_SITE_METHOD := local

define RTK_HCIATTACH_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="-g -Wall" -C $(@D)
endef

define RTK_HCIATTACH_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/rtk_hciattach $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
