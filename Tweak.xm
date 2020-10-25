#include "Tweak.h"
#import <UIKit/UIKit.h>
#import "substrate.h"

static int sixOff = 0;
static int tenOff = 0;
static SBLockScreenManager *sharedRef;
static bool deviceUpsideDown = false;
static float cachedScreenBrightness = 1.0;
//Cant figure out how to enable and disable AutoScreenDimm.
//static bool  cacheedScreenAutoDimm = true;
static bool isDimmed;
static float kLockDelay = 5;
static double kSensitivity = -0.436332;


extern "C" void IOHIDEventQueueEnqueue(IOHIDEventQueueRef queue, IOHIDEventRef event);
void (*old_Enqueue)(IOHIDEventQueueRef queue, IOHIDEventRef event);

#pragma mark - Enqueue
void newEnqueue(IOHIDEventQueueRef queue, IOHIDEventRef event){
		if(IOHIDEventGetType(event) == (unsigned)14){
				if(sixOff == 0){
					sixOff = 5;
					if(PROX_VALUE(event) < (unsigned)300){
						POST_NOTIF("dev.squiddy.PP/StartM")
						 
					}else{
						HBLogDebug(@" Stop");
						POST_NOTIF("dev.squiddy.PP/StopM")
					}	
				}else{
					sixOff--;
				}
			}
		old_Enqueue(queue, event);
}



@implementation UX

UIWindow *__strong dimWindow;
+(void)restoreScreenBrightness{
		dispatch_async (dispatch_get_main_queue(), ^{
		dimWindow.hidden = YES;
		dimWindow = nil;
		isDimmed = false;

		[[%c(SBBrightnessController) sharedBrightnessController] setBrightnessLevel:cachedScreenBrightness];
	});
}
+(void)dimmScreenBrightness{
	dispatch_async (dispatch_get_main_queue(), ^{
	//Cache the screen brightness
		cachedScreenBrightness = [UIScreen mainScreen].brightness;

		//Dimm the screen
		[[%c(SBBrightnessController) sharedBrightnessController] setBrightnessLevel:0];

		dimWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		dimWindow.windowLevel = UIWindowLevelAlert +1;
		UIViewController *controller = [[UIViewController alloc] init];
		dimWindow.rootViewController = controller;

		UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
			backgroundView.backgroundColor = [UIColor colorWithRed:0.1 green:.1 blue:.1 alpha:1];
			//TODO PREFS here
			UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restoreScreenBrightness)];
			[backgroundView addGestureRecognizer:singleFingerTap];
			backgroundView.alpha = 0.8;

		[controller.view addSubview:backgroundView];
		

		[dimWindow setHidden:NO];
		[dimWindow makeKeyAndVisible];
		//Tell console what happened
		//Remember we've dimmed it
		isDimmed = true;
		//TODO PREFS here
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kLockDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			lockScreen();
		});
	});
	return;
}
@end


#pragma mark - Screen Brightness
%hook SpringBoard
	-(void)_ringerChanged:(struct __IOHIDEvent *)arg1 {
		HBLogDebug(@" isDimmed: %d", isDimmed);
		HBLogDebug(@" kDelay: %f", kLockDelay);
		HBLogDebug(@" deviceUpsideDow: %d", deviceUpsideDown);
		HBLogDebug(@" sensitivity %f", kSensitivity);
		%orig;
	}
%end





static void lockScreen(){
	if(isDimmed){
		[[[%c(SpringBoard) sharedApplication] pluginUserAgent] lockAndDimDevice];
		[UX restoreScreenBrightness];
	}

}


#pragma mark - Start/Stop Motion & hook
%hook SBLockScreenManager
	%property (nonatomic, retain) CMMotionManager *motionManager;
		-(id)init {
			self.motionManager = [[%c(CMMotionManager) alloc] init];
			self.motionManager.deviceMotionUpdateInterval = 1.0;
			sharedRef = %orig;
			return sharedRef;

		}
		
		%new
		-(void)startMotion {
			cachedScreenBrightness = [UIScreen mainScreen].brightness;
			[self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical
			toQueue:[NSOperationQueue mainQueue]
			withHandler:^(CMDeviceMotion *accelerometerData, NSError *error) {
				dispatch_async(dispatch_get_main_queue(), ^{
					if ((double)[[NSNumber numberWithDouble:accelerometerData.attitude.pitch] doubleValue] < (double)TRIGGERANGLE ){
						if(!deviceUpsideDown){
							deviceUpsideDown = true;
							[UX dimmScreenBrightness];
				
						}
					}else{
						if(deviceUpsideDown){
							deviceUpsideDown = false;
							[UX restoreScreenBrightness];
						}else {
							tenOff++;
							if(tenOff == 10){
								[self stopMotion];
								tenOff = 0;
							}
						}
					}
				
			});
			return;
			}];
		}

		%new
		-(void)stopMotion{
			[self.motionManager stopDeviceMotionUpdates];
			isDimmed = 0;
			deviceUpsideDown = 0;
		}

%end


static void startMotion(){
	[sharedRef startMotion];
}
static void stopMotion(){
	[sharedRef stopMotion];
	[UX restoreScreenBrightness];
}

void loadPrefs(){
	NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"dev.squiddy.PP"];
	if (prefs) {
		kLockDelay  =  [prefs objectForKey:@"delay"] ? [[prefs objectForKey:@"delay"] floatValue] : 5.f;
		float temp = 0;
		temp  =  [prefs objectForKey:@"sensitivity"] ? [[prefs objectForKey:@"sensitivity"] floatValue] : -20.f;
		//Convert Degrees to radian.
		kSensitivity = (temp * M_PI)/180;
	}
	
	
}








%ctor {
	if ([[[NSProcessInfo processInfo].processName uppercaseString] isEqualToString:@"SPRINGBOARD"]) {
		LISTEN_NOTIF(startMotion, "dev.squiddy.PP/StartM")
		LISTEN_NOTIF(stopMotion, "dev.squiddy.PP/StopM")
		LISTEN_NOTIF(loadPrefs, "dev.squiddy.PP/prefs")
	}
	MSHookFunction(&IOHIDEventQueueEnqueue,&newEnqueue,&old_Enqueue);
}
