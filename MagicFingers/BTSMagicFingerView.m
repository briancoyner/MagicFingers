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
        
        _touchesToLayers = CFDictionaryCreateMutable(NULL, 0, (void *)NULL, (void *)NULL);
 
        // TODO - this mimics the same default values as a BTSMagicOptions object.
        _layerContent = (id)[UIImage imageNamed:@"star.png"].CGImage;
        _emitterInstanceCount = 100;
        _animationDuration = 1.0;
        _rotationConstant = 4.0;
        
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
    
    [super dealloc];
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];

        CAReplicatorLayer *touchLayer = [[[CAReplicatorLayer alloc] init] autorelease];
        [touchLayer setFrame:CGRectMake(point.x - 5, point.y - 5, 10, 10)];
        [touchLayer setBackgroundColor:[UIColor clearColor].CGColor];
        [touchLayer setInstanceCount:_emitterInstanceCount];
        [touchLayer setInstanceDelay:_animationDuration / _emitterInstanceCount];
        
        CATransform3D rotateTransform = CATransform3DMakeRotation(M_PI *_rotationConstant / [touchLayer instanceCount], 0, 0, 1);
        [touchLayer setInstanceTransform:rotateTransform];
        
        [touchLayer setInstanceGreenOffset:-0.5/[touchLayer instanceCount]];
        [touchLayer setInstanceBlueOffset:-0.9/[touchLayer instanceCount]];
        
        CALayer *shapeLayer = [CALayer layer];
        [shapeLayer setFrame:CGRectMake(75, 75, 16, 16)];

        [shapeLayer setContents:_layerContent];
        [shapeLayer addAnimation:[self createShapeLayerAnimation] forKey:@"position"];
        
        [touchLayer addSublayer:shapeLayer];
        
        CALayer *layer = [self layer];
        [layer addSublayer:touchLayer];

         CFDictionarySetValue(_touchesToLayers, touch, touchLayer);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [CATransaction setDisableActions:YES];
    for (UITouch *touch in touches) {
        CGPoint locationInView = [touch locationInView:self];
        CGPoint previousLocationInView = [touch previousLocationInView:self];

        CALayer *touchLayer = (CALayer *)CFDictionaryGetValue(_touchesToLayers, touch);
        
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
    for (UITouch *touch in touches) {
        CALayer *touchLayer = CFDictionaryGetValue(_touchesToLayers, touch);
        [touchLayer removeFromSuperlayer];
        CFDictionaryRemoveValue(_touchesToLayers, touch);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CALayer *touchLayer = CFDictionaryGetValue(_touchesToLayers, touch);
        [touchLayer removeFromSuperlayer];
        CFDictionaryRemoveValue(_touchesToLayers, touch);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kLayerContentContextKey) {
                
        NSMutableDictionary *allTouches = (NSMutableDictionary *)_touchesToLayers;
        for (UITouch *touch in allTouches) {
            CAReplicatorLayer *touchLayer = (CAReplicatorLayer *)CFDictionaryGetValue(_touchesToLayers, touch);
            CALayer *shapeLayer = [[touchLayer sublayers] objectAtIndex:0];
            [shapeLayer setContents:[self layerContent]];
        }
        
    } else if (context == kEmitterInstanceCountContextKey) {
        NSMutableDictionary *allTouches = (NSMutableDictionary *)_touchesToLayers;
        for (UITouch *touch in allTouches) {
            CAReplicatorLayer *touchLayer = (CAReplicatorLayer *)CFDictionaryGetValue(_touchesToLayers, touch);
            [touchLayer setInstanceCount:_emitterInstanceCount];
        }
        
    } else if (context == kRotationConstantContextKey) {
        NSMutableDictionary *allTouches = (NSMutableDictionary *)_touchesToLayers;
        for (UITouch *touch in allTouches) {
            CAReplicatorLayer *touchLayer = (CAReplicatorLayer *)CFDictionaryGetValue(_touchesToLayers, touch);
            CATransform3D rotateTransform = CATransform3DMakeRotation(M_PI*_rotationConstant/[touchLayer instanceCount], 0, 0, 1);
            [touchLayer setInstanceTransform:rotateTransform];
        }
        
    } else if (context == kAnimationDurationContextKey) {
        NSMutableDictionary *allTouches = (NSMutableDictionary *)_touchesToLayers;
        for (UITouch *touch in allTouches) {
            CAReplicatorLayer *touchLayer = (CAReplicatorLayer *)CFDictionaryGetValue(_touchesToLayers, touch);
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
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    [animation setDuration:_animationDuration];
    
    [animation setRepeatCount:MAXFLOAT];
    
    return animation;
}


@end
