include $(THEOS)/makefiles/common.mk
TARGET := iphone:clang:latest:7.0
BUNDLE_NAME = pocketprotectorprefs

pocketprotectorprefs_FILES = PPPRootListController.m
pocketprotectorprefs_INSTALL_PATH = /Library/PreferenceBundles
pocketprotectorprefs_FRAMEWORKS = UIKit Cephei CepheiPrefs
pocketprotectorprefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
pocketprotectorprefs_PRIVATE_FRAMEWORKS = Preferences
pocketprotectorprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/pocketprotectorprefs.plist$(ECHO_END)
