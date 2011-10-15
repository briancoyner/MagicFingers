//
//  BTCEmitterView.m
//  Emitter
//
//  Created by Brian Coyner on 4/29/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import "BTSMagicFingerView.h"
#import <QuartzCore/QuartzCore.h>

@interface BTSMagicFingerView () {
    CFMutableDictionaryRef _touchesToLayers;
}

- (CABasicAnimation *)createShapeLayerAnimation;
@end

@implementation BTSMagicFingerView

static void * kLayerContentContextKey = &kLayerContentContextKey;
static void * kEmitterInstanceCountContextKey = &kEmitterInstanceCountContextKey;
static void * kRotationConstantContextKey = &kRotationConstantContextKey;
static void * kAnimationDurationContextKey = &kAnimationDurationContextKey;

@synthesize layerContent = _layerContent;
@synthesize emitterInstanceCount = _emitterInstanceCount;
@synthesize rotationConstant = _rotationConstant;
@synthesize animationDuration = _animationDuration;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _touchesToLayers = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
 
        [self setBackgroundColor:[UIColor blackColor]];
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        
        [self addObserver:self forKeyPath:@"layerContent" options:NSKeyValueObservingOptionNew context:kLayerContentContextKey];
        [self addObserver:self forKeyPath:@"emitterInstanceCount" options:NSKeyValueObservingOptionNew context:kEmitterInstanceCountContextKey];
        [self addObserver:self forKeyPath:@"animationDuration" options:NSKeyValueObservingOptionNew context:kAnimationDurationContextKey];        
        [self addObserver:self forKeyPath:@"rotationConstant" options:NSKeyValueObservingOptionNew context:kRotationConstantContextKey];        
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"layerContent"];
    [self removeObserver:self forKeyPath:@"emitterInstanceCount"];
    [self removeObserver:self forKeyPath:@"animationDuration"];
    [self removeObserver:self forKeyPath:@"rotationConstant"];
    
    CFDictionaryRemoveAllValues(_touchesToLayers);
    CFRelease(_touchesToLayers);
    
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];

        CAReplicatorLayer *touchLayer = [[CAReplicatorLayer alloc] init];
        [touchLayer setFrame:CGRectMake(point.x - 5, point.y - 5, 10, 10)];
        [touchLayer setBackgroundColor:[UIColor clearColor].CGColor];
        [touchLayer setInstanceCount:_emitterInstanceCount];
        [touchLayer setInstanceDelay:_animationDuration / _emitterInstanceCount];
        
        CATransform3D rotateTransform = CATransform3DMakeRotation(M_PI * _rotationConstant / [touchLayer instanceCount], 0, 0, 1);
        [touchLayer setInstanceTransform:rotateTransform];
        
        [touchLayer setInstanceGreenOffset:-0.5/[touchLayer instanceCount]];
        [touchLayer setInstanceBlueOffset:-0.2/[touchLayer instanceCount]];
        
        CALayer *shapeLayer = [CALayer layer];
        [shapeLayer setFrame:CGRectMake(75, 75, 16, 16)];

        [shapeLayer setContents:_layerContent];
        [shapeLayer addAnimation:[self createShapeLayerAnimation] forKey:@"position"];
        
        [touchLayer addSublayer:shapeLayer];
        
        CALayer *layer = [self layer];
        [layer addSublayer:touchLayer];

         CFDictionarySetValue(_touchesToLayers, (__bridge CFTypeRef)touch, (__bridge CFTypeRef)touchLayer);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [CATransaction setDisableActions:YES];
    for (UITouch *touch in touches) {
        CGPoint locationInView = [touch locationInView:self];
        CGPoint previousLocationInView = [touch previousLocationInView:self];

        CALayer *touchLayer = (__bridge CALayer *)CFDictionaryGetValue(_touchesToLayers, (__bridge CFTypeRef)touch);
        
        float deltaX = locationInView.x - previousLocationInView.x;
        float deltaY = locationInView.y - previousLocationInView.y;
        CGRect layerFrame = [touchLayer frame];
        layerFrame.origin.x += deltaX;
        layerFrame.origin.y += deltaY;
        [touchLayer setFrame:layerFrame];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CALayer *touchLayer = (__bridge CALayer *)(CFDictionaryGetValue(_touchesToLayers, (__bridge CFTypeRef)touch));
        [touchLayer removeFromSuperlayer];
        CFDictionaryRemoveValue(_touchesToLayers, (__bridge CFTypeRef)touch);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kLayerContentContextKey) {
                
        NSMutableDictionary *allTouches = (__bridge NSMutableDictionary *)_touchesToLayers;
        for (UITouch *touch in allTouches) {
            CAReplicatorLayer *touchLayer = (__bridge CAReplicatorLayer *)CFDictionaryGetValue(_touchesToLayers, (__bridge CFTypeRef)touch);
            CALayer *shapeLayer = [[touchLayer sublayers] objectAtIndex:0];
            [shapeLayer setContents:[self layerContent]];
        }
        
    } else if (context == kEmitterInstanceCountContextKey) {
        NSMutableDictionary *allTouches = (__bridge NSMutableDictionary *)_touchesToLayers;
        for (UITouch *touch in allTouches) {
            CAReplicatorLayer *touchLayer = (__bridge CAReplicatorLayer *)CFDictionaryGetValue(_touchesToLayers, (__bridge CFTypeRef)touch);
            [touchLayer setInstanceCount:_emitterInstanceCount];
        }
        
    } else if (context == kRotationConstantContextKey) {
        NSMutableDictionary *allTouches = (__bridge NSMutableDictionary *)_touchesToLayers;
        for (UITouch *touch in allTouches) {
            CAReplicatorLayer *touchLayer = (__bridge CAReplicatorLayer *)CFDictionaryGetValue(_touchesToLayers, (__bridge CFTypeRef)touch);
            CATransform3D rotateTransform = CATransform3DMakeRotation(M_PI*_rotationConstant/[touchLayer instanceCount], 0, 0, 1);
            [touchLayer setInstanceTransform:rotateTransform];
        }
        
    } else if (context == kAnimationDurationContextKey) {
        NSMutableDictionary *allTouches = (__bridge NSMutableDictionary *)_touchesToLayers;
        for (UITouch *touch in allTouches) {
            CAReplicatorLayer *touchLayer = (__bridge CAReplicatorLayer *)CFDictionaryGetValue(_touchesToLayers, (__bridge CFTypeRef)touch);
            [touchLayer setInstanceDelay:_animationDuration / _emitterInstanceCount];

            
            CALayer *shapeLayer = [[touchLayer sublayers] objectAtIndex:0];
            
            // the basic animation is immutable... we need to remove the old from the layer and and add a new animation
            [shapeLayer removeAnimationForKey:@"position"];
            
            // Yes... this causes the current animation to stop and start over... it doesn't look too bad.
            [shapeLayer addAnimation:[self createShapeLayerAnimation] forKey:@"position"];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Private Methods

- (CABasicAnimation *)createShapeLayerAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    [animation setKeyPath:@"position"];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointZero]];
    [animation setDuration:_animationDuration];
    [animation setRepeatCount:MAXFLOAT];
    return animation;
}

@end
