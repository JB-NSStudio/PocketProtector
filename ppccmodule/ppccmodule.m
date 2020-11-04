#import "ppccmodule.h"
#import "ControlCenterUI/ControlCenterUI-Structs.h"

#import <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>
#define POST_NOTIF(_name)                       CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),\
                                                CFSTR(_name), NULL, NULL, YES);
//static dispatch_once_t onceToken;


@implementation ppccmodule

//Return the icon of your module here
- (UIImage *)iconGlyph{
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

- (CCUILayoutSize)moduleSizeForOrientation:(int)orientation
{
	CCUILayoutSize size;
    //Default value
    size.height = 1;
    //Default value
    size.width = 1;

	return size;
}

//Return the color selection color of your module here
- (UIColor *)selectedColor{
	return [UIColor blueColor];
}

- (BOOL)isSelected{

    // if([[[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"dev.squiddy.PP"] objectForKey:@"enabled"] boolValue])
    // dispatch_once (&onceToken, ^{
    //     _selected = true;
    // });
  return _selected;
}

- (void)setSelected:(BOOL)selected{
	_selected = selected;
  [super refreshState];

  NSMutableDictionary *prefs = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"dev.squiddy.PP"] mutableCopy];
  if(_selected){
    [prefs setObject:@YES forKey:@"enabled"];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:@"dev.squiddy.PP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //Your module got selected, do something
  }
  else{
    [prefs setObject:@NO forKey:@"enabled"];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:@"dev.squiddy.PP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //Your module got unselected, do something
  }
  POST_NOTIF("dev.squiddy.PP/prefs")
}

@end
