IOPING_SITE := package/ioping
IOPING_SOURCE := ioping.c
IOPING_SITE_METHOD := local
IOPING_INSTALL_TARGET:=YES

define IOPING_BUILD_CMDS
    "$(TARGET_CC)" -C $(@D)/$(IOPING_SOURCE) -o $(@D)/ioping -lm
endef

define IOPING_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/ioping $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

