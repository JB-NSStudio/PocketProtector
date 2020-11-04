
INSTALL_TARGET_PROCESSES = SpringBoard
export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ppccmodule
ppccmodule_BUNDLE_EXTENSION = bundle
ppccmodule_FILES = ppccmodule.m
ppccmodule_CFLAGS = -fobjc-arc
# ppccmodule_LDFLAGS += $(THEOS_PROJECT_DIR)/ControlCenterUIKit/ControlCenterUIKit.tbd
ppccmodule_FRAMEWORKS = Foundation
ppccmodule_PRIVATE_FRAMEWORKS = ControlCenterUIKit Preferences
ppccmodule_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/aggregate.mk