//
//  MagicFingersViewController.h
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTSMagicOptions;

@interface BTSMagicFingersViewController : UIViewController 

// Designated initializer.
- (id)initWithMagicOptions:(BTSMagicOptions *)magicOptions;

- (IBAction)toggleOptions:(id)sender;

@end
