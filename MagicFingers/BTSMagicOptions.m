//
//  BTSMagicOptions.m
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import "BTSMagicOptions.h"

NSString *BTSMagicOptionsLayerContentKey = @"layerContent";
NSString *BTSMagicOptionsEmitterInstanceCountKey = @"emitterInstanceCount";
NSString *BTSMagicOptionsAnimationDurationKey = @"animationDuration";
NSString *BTSMagicOptionsRotationConstantKey = @"rotationConstant";

@implementation BTSMagicOptions

@synthesize emitterInstanceCount = _emitterInstanceCount;
@synthesize layerContent = _layerContent;
@synthesize animationDuration = _animationDuration;
@synthesize rotationConstant = _rotationConstant;

- (id)init {
    self = [super init];
    if (self) {
        _layerContent = (id)[UIImage imageNamed:@"star.png"].CGImage;
        _emitterInstanceCount = 70;
        _animationDuration = 1.0;
        _rotationConstant = 4;
    }
    return self;
}

@end
