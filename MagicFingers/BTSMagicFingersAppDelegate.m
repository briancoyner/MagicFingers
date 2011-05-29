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

@property (nonatomic, assign, readwrite) BTSMagicOptions *magicOptions;
@property (nonatomic, retain, readwrite) BTSMagicFingersViewController *viewController;

@end

@implementation BTSMagicFingersAppDelegate

@synthesize magicOptions = _magicOptions;
@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // the BTSMagicOptions is owned by the app delegate... it shared with the root view controller who 
    // listens for changes and updates the "magic fingers view".
    self.magicOptions = [[BTSMagicOptions alloc] init];
    
    self.viewController = [[BTSMagicFingersViewController alloc] initWithMagicOptions:_magicOptions];
    [_window setRootViewController:_viewController];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_viewController release];
    [_window release];
    [super dealloc];
}

@end
