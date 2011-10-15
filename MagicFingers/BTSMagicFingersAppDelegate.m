//
//  MagicFingersAppDelegate.m
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import "BTSMagicFingersAppDelegate.h"
#import "BTSMagicFingersViewController.h"
#import "BTSMagicOptions.h"

@interface BTSMagicFingersAppDelegate() 

@property (nonatomic, strong, readwrite) BTSMagicOptions *magicOptions;
@end

@implementation BTSMagicFingersAppDelegate

@synthesize magicOptions = _magicOptions;
@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // the BTSMagicOptions is owned by the app delegate... it shared with the root view controller who 
    // listens for changes and updates the "magic fingers view".
    _magicOptions = [[BTSMagicOptions alloc] init];
       
    BTSMagicFingersViewController *viewController = [[BTSMagicFingersViewController alloc] initWithMagicOptions:_magicOptions];
    [_window setRootViewController:viewController];
    [_window makeKeyAndVisible];
    return YES;
}


@end