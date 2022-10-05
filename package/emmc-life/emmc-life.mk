EMMC_LIFE_SITE := package/emmc-life
EMMC_LIFE_SOURCE := emmc-life.c
EMMC_LIFE_SITE_METHOD := local

define EMMC_LIFE_BUILD_CMDS
    "$(TARGET_CC)" -C $(@D)/$(EMMC_LIFE_SOURCE) -o $(@D)/emmc-life
endef

define EMMC_LIFE_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/emmc-life $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
