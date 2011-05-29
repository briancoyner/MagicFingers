//
//  MagicFingersAppDelegate.h
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTSMagicFingersViewController;

@interface BTSMagicFingersAppDelegate : NSObject <UIApplicationDelegate> 

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain, readonly) BTSMagicFingersViewController *viewController;

@end
