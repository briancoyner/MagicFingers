//
//  BTSMagicOptions.h
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *BTSMagicOptionsLayerContentKey;
extern NSString *BTSMagicOptionsEmitterInstanceCountKey;
extern NSString *BTSMagicOptionsAnimationDurationKey;
extern NSString *BTSMagicOptionsRotationConstantKey;

@interface BTSMagicOptions : NSObject 

@property (nonatomic, retain) id layerContent;
@property (nonatomic, assign) NSInteger emitterInstanceCount;
@property (nonatomic, assign) NSInteger rotationConstant;
@property (nonatomic, assign) CGFloat animationDuration;


@end
