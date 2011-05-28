//
//  MagicFingersAppDelegate.h
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Black Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MagicFingersViewController;

@interface MagicFingersAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MagicFingersViewController *viewController;

@end
