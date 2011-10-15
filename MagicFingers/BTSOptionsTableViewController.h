//
//  BTSOptionsTableViewController.h
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTSMagicOptions;

@interface BTSOptionsTableViewController : UITableViewController 

@property (nonatomic, strong, readwrite) BTSMagicOptions *magicOptions;

- (id)initWithMagicOptions:(BTSMagicOptions *)magicOptions;

@end
