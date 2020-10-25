#import "HBLog.h"

#import <CoreMotion/CoreMotion.h>
#import "substrate.h"
#include <math.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import <IOKit/pwr_mgt/IOPM.h>
#import <IOKit/pwr_mgt/IOPMLibPrivate.h>
#import <IOKit/IOKitLib.h>
#include <IOKit/hid/IOHIDEventQueue.h>


@interface SBLockScreenManager : NSObject
-(void)startMotion;
-(void)stopMotion;
-(id)init;
@property (nonatomic, retain) CMMotionManager *motionManager;
@end

@interface SBUserAgent
-(void)lockAndDimDevice;
@end

@interface CBAdaptationClient : NSObject
-(BOOL)setEnabled:(BOOL)arg1 ;
@end

@interface CBClient : NSObject
-(CBAdaptationClient *)adaptationClient;
@end



@interface SpringBoardClass
+(id)sharedApplication;
-(id)pluginUserAgent;
@end

@class NSMutableArray;

@interface SBBrightnessController : NSObject
+(id)sharedBrightnessController;
-(void)setBrightnessLevel:(float)arg1 ;
-(void)handleBrightnessEvent:(IOHIDEventRef)arg1 ;
-(void)cancelBrightnessEvent;
-(float)_calcButtonRepeatDelay;
-(void)_increaseBrightnessAndRepeat;
-(void)_decreaseBrightnessAndRepeat;
-(void)_exitMaximumBrightnessMode;
-(void)_enterMaximumBrightnessMode;
-(void)_setBrightnessLevel:(float)arg1 showHUD:(BOOL)arg2 ;
-(void)_adjustBacklightLevel:(BOOL)arg1 ;
-(id)acquireMaximumBrightnessAssertionForReason:(id)arg1 ;
@end


@interface UX : NSObject
+(void)restoreScreenBrightness;
+(void)dimmScreenBrightness;
@end

@class NSString;
@interface PSBrightnessSettingsDetail : NSObject 

@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
+(void)setValue:(double)arg1 ;
+(double)currentValue;
+(id)iconImage;
+(id)preferencesURL;
+(double)incrementedBrightnessValue:(double)arg1 ;
+(void)incrementBrightnessValue:(double)arg1 ;
+(void)beginBrightnessAdjustmentTransaction;
+(void)endBrightnessAdjustmentTransaction;
+(void)beginObservingExternalBrightnessChanges:(/*^block*/id)arg1 changedAction:(/*^block*/id)arg2 ;
+(void)endObservingExternalBrightnessChanges;
+(BOOL)deviceSupportsAutoBrightness;
+(void)setAutoBrightnessEnabled:(BOOL)arg1 ;
+(BOOL)autoBrightnessEnabled;
@end

static void lockScreen();



#define PROX_VALUE(_event) IOHIDEventGetIntegerValue(_event, kIOHIDEventFieldProximityLevel)

#define TRIGGERANGLE -0.4

#define POST_NOTIF(_name)                       CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),\
                                                CFSTR(_name), NULL, NULL, YES);
                                                
#define LISTEN_NOTIF(_call, _name)              CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),\
                                                NULL, (CFNotificationCallback)_call, CFSTR(_name), NULL, CFNotificationSuspensionBehaviorCoalesce);