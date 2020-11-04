THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
TARGET := iphone:clang:13.4:10.3
INSTALL_TARGET_PROCESSES = SpringBoard backboardd
export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = pocketprotector

pocketprotector_FRAMEWORKS = Foundation CoreMotion IOKit
pocketprotector_EXTRA_FRAMEWORKS += Cephei
pocketprotector_FILES = Tweak.xm
pocketprotector_PRIVATE_FRAMEWORKS = Preferences
pocketprotector_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += pocketprotectorprefs ppccmodule
include $(THEOS_MAKE_PATH)/aggregate.mk
