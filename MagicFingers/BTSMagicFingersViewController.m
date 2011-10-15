//
//  MagicFingersViewController.m
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import "BTSMagicFingersViewController.h"
#import "BTSOptionsTableViewController.h"
#import "BTSMagicFingerView.h"
#import "BTSMagicOptions.h"

@interface BTSMagicFingersViewController() {
    UIPopoverController *_optionsViewController;
}

@property (nonatomic, strong, readwrite) BTSMagicOptions *magicOptions;

@end

@implementation BTSMagicFingersViewController

static void *kEmitterInstanceContextKey = &kEmitterInstanceContextKey;
static void *kAnimationDurationContextKey = &kAnimationDurationContextKey;
static void *kRotationConstantContextKey = &kRotationConstantContextKey;

@synthesize magicOptions = _magicOptions;

- (id)initWithMagicOptions:(BTSMagicOptions *)magicOptions
{
    // load the NIB with the same class name
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        self.magicOptions = magicOptions;
        
        [_magicOptions addObserver:self forKeyPath:BTSMagicOptionsEmitterInstanceCountKey options:NSKeyValueObservingOptionNew context:kEmitterInstanceContextKey];
        [_magicOptions addObserver:self forKeyPath:BTSMagicOptionsAnimationDurationKey options:NSKeyValueObservingOptionNew context:kAnimationDurationContextKey];
        [_magicOptions addObserver:self forKeyPath:BTSMagicOptionsRotationConstantKey options:NSKeyValueObservingOptionNew context:kRotationConstantContextKey];        
    }
    return self;
}

- (void)dealloc 
{
    [_magicOptions removeObserver:self forKeyPath:BTSMagicOptionsEmitterInstanceCountKey];
    [_magicOptions removeObserver:self forKeyPath:BTSMagicOptionsAnimationDurationKey];
    [_magicOptions removeObserver:self forKeyPath:BTSMagicOptionsRotationConstantKey];
  
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BTSMagicFingerView *magicView = (BTSMagicFingerView *)[[self view] viewWithTag:100];

    // set the view's values based on the "model".
    
    [magicView setEmitterInstanceCount:[_magicOptions emitterInstanceCount]];
    [magicView setAnimationDuration:[_magicOptions animationDuration]];
    [magicView setRotationConstant:[_magicOptions rotationConstant]];
    [magicView setLayerContent:[_magicOptions layerContent]];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (![_optionsViewController isPopoverVisible]) {
        _optionsViewController = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kEmitterInstanceContextKey || context == kAnimationDurationContextKey || context == kRotationConstantContextKey) {
        
        // The BTSMagicFingersViewController sets the tag value.
        BTSMagicFingerView *magicView = (BTSMagicFingerView *)[[self view] viewWithTag:100];
        
        // sync the BTSMagicFingerView with the BTSMagicOptions model object.
        id value = [_magicOptions valueForKey:keyPath];
        [magicView setValue:value forKey:keyPath];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)toggleOptions:(id)sender
{
    if (_optionsViewController == nil) {
        BTSOptionsTableViewController *viewController = [[BTSOptionsTableViewController alloc] initWithMagicOptions:_magicOptions];
        [[viewController navigationItem] setTitle:NSLocalizedString(@"Magic Finger Values", @"All Mutable Magic Values Popover Title.")];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        _optionsViewController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        
        // we still want to interact with the touch view even when the popover displays
        [_optionsViewController setPassthroughViews:[NSArray arrayWithObject:[self view]]];
        
        // TODO - remove the hard coded size in favor of a calculated size "that fits".
        [_optionsViewController setPopoverContentSize:CGSizeMake(320, 380)];
    }
        
    if ([_optionsViewController isPopoverVisible]) {
        [_optionsViewController dismissPopoverAnimated:YES];
    } else {
        [_optionsViewController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];   
    }
}

@end
