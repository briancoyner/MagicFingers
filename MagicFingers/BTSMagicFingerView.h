//
//  BTCEmitterView.h
//  Emitter
//
//  Created by Brian Coyner on 4/29/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTSMagicFingerView : UIView 

@property (nonatomic, strong) id layerContent;
@property (nonatomic, assign) NSInteger emitterInstanceCount;
@property (nonatomic, assign) NSInteger rotationConstant;
@property (nonatomic, assign) CGFloat animationDuration;

@end
