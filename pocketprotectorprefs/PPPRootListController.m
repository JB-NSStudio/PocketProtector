#include "PPPRootListController.h"
//#include <UIKit/UIKit.h>

@implementation PPPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

@end
