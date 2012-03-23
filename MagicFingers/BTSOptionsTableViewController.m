//
//  BTSOptionsTableViewController.m
//  MagicFingers
//
//  Created by Brian Coyner on 5/27/11.
//  Copyright 2011 Brian Coyner. All rights reserved.
//

#import "BTSOptionsTableViewController.h"
#import "BTSMagicOptions.h"

@interface BTSOptionsTableViewController() {
    NSMutableArray *_tableModel;
}    

@end

@implementation BTSOptionsTableViewController

@synthesize magicOptions = _magicOptions;

- (id)initWithMagicOptions:(BTSMagicOptions *)magicOptions;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.magicOptions = magicOptions;
    }
    return self;
}

static int kViewTag = 1;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableModel = [[NSMutableArray alloc] initWithCapacity:3];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    { // Emitter Instance Count
        NSMutableDictionary *cellObjects = [[NSMutableDictionary alloc] initWithCapacity:3];
        [cellObjects setObject:BTSMagicOptionsEmitterInstanceCountKey forKey:@"key"];
        [cellObjects setObject:NSLocalizedString(@"Emitter Count", @"The number of emitter layers to create when a finger touches the screen.") forKey:@"title"];       
        [cellObjects setObject:numberFormatter forKey:@"formatter"];       

        UISlider *slider = [self createSliderWithActionSelector:@selector(emitterInstanceCountChanged:) minimumValue:1.0 maximumValue:100.0 initialValue:[_magicOptions emitterInstanceCount]];
        
        [cellObjects setObject:slider forKey:@"view"];        
        
        [_tableModel addObject:cellObjects];
    }

    { // Animation Duration
        NSMutableDictionary *cellObjects = [[NSMutableDictionary alloc] initWithCapacity:3];
        [cellObjects setObject:BTSMagicOptionsAnimationDurationKey forKey:@"key"];
        [cellObjects setObject:NSLocalizedString(@"Animation Duration", @"How fast the emitter layer animates.") forKey:@"title"];       
        [cellObjects setObject:numberFormatter forKey:@"formatter"];       

        UISlider *slider = [self createSliderWithActionSelector:@selector(animationDurationChanged:) minimumValue:0.0 maximumValue:10.0 initialValue:[_magicOptions animationDuration]];
        [cellObjects setObject:slider forKey:@"view"];        
        
        [_tableModel addObject:cellObjects];
    }
    
    { // Rotation Constant
        NSMutableDictionary *cellObjects = [[NSMutableDictionary alloc] initWithCapacity:3];
        [cellObjects setObject:BTSMagicOptionsRotationConstantKey forKey:@"key"];
        [cellObjects setObject:NSLocalizedString(@"Rotation", @"Multiplied by PI.") forKey:@"title"];       
        [cellObjects setObject:numberFormatter forKey:@"formatter"];       
        
        UISlider *slider = [self createSliderWithActionSelector:@selector(rotationConstantChanged:) minimumValue:1.0 maximumValue:15.0 initialValue:[_magicOptions rotationConstant]];
        [cellObjects setObject:slider forKey:@"view"];        
        
        [_tableModel addObject:cellObjects];
    }
}

- (UISlider *)createSliderWithActionSelector:(SEL)selector minimumValue:(CGFloat)minimumValue maximumValue:(CGFloat)maximumValue initialValue:(CGFloat) initialValue
{
    CGRect frame = CGRectMake(10.0, 12.0, 280.0, 7.0);
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider setTag:kViewTag];
    
    [slider addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    
    slider.backgroundColor = [UIColor clearColor];
    slider.minimumValue = minimumValue;
    slider.maximumValue = maximumValue;
    slider.value = initialValue;
    slider.continuous = YES;
    
    return slider;
}

- (void)viewDidUnload
{
    _tableModel = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table View Data Source 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // each object in the array represents a single "magic option" dictionary.
    return [_tableModel count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // the first row in the section is the name and current value of the "magic option".
    // the second row in the section is a slider that changes the "magic option" value.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([indexPath row] == 0) {
    
        static NSString *CellIdentifier = @"BTSMagicOptionCellValues";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } 
        
        NSDictionary *cellObjects = [_tableModel objectAtIndex:[indexPath section]];
        
        [[cell textLabel] setText:[cellObjects objectForKey:@"title"]];
        
        id value = [_magicOptions valueForKey:[cellObjects objectForKey:@"key"]];
        NSFormatter *formatter = [cellObjects objectForKey:@"formatter"];
        NSString *valueAsString = formatter != nil ? [formatter stringForObjectValue:value] : [value description];
        [[cell detailTextLabel] setText:valueAsString];
    } else {
        static NSString *CellIdentifier = @"BTSMagicOptionCellView";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else {
            UIView *viewToRemove = [[cell contentView] viewWithTag:1];
			if (viewToRemove) {
				[viewToRemove removeFromSuperview];
            }
        }
        
        NSDictionary *cellObjects = [_tableModel objectAtIndex:[indexPath section]];
        UIView *controlView = [cellObjects objectForKey:@"view"];
        [[cell contentView] addSubview:controlView];
        
    }
    
    return cell;
}

#pragma mark - View/ Model Synchronization

- (void)emitterInstanceCountChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [_magicOptions setEmitterInstanceCount:(NSInteger) [slider value]];
    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)animationDurationChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [_magicOptions setAnimationDuration:[slider value]];
    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)rotationConstantChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [_magicOptions setRotationConstant:(NSInteger) [slider value]];
    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
}

@end
