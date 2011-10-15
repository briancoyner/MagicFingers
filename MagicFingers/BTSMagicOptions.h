//
//  BTSMagicOptions.h
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BTSMagicOptionsLayerContentKey;
extern NSString * const BTSMagicOptionsEmitterInstanceCountKey;
extern NSString * const BTSMagicOptionsAnimationDurationKey;
extern NSString * const BTSMagicOptionsRotationConstantKey;

@interface BTSMagicOptions : NSObject 

@property (nonatomic, strong) id layerContent;
@property (nonatomic, assign) NSInteger emitterInstanceCount;
@property (nonatomic, assign) NSInteger rotationConstant;
@property (nonatomic, assign) CGFloat animationDuration;

@end