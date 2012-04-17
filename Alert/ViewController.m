//
//  ViewController.m
//  Alert
//
//  Created by c2nprds on 04/16/12.
//  Copyright (c) 2012 c2nprds. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize status          = _status;
@synthesize player          = _player;
@synthesize mpVolumeView    = _mpVolumeView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    // Ignore silence
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    UInt32 category = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(UInt32), &category);
    AudioSessionSetActive(YES);

    
    [self.mpVolumeView setBackgroundColor:[UIColor clearColor]];

    
    // Prepare player
    NSString *path = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.volume = 1.0f;
    self.player.numberOfLoops = -1;
    [self.player prepareToPlay];
    

    // UIDeviceBatteryStateDidChangeNotification
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    self.status = [UIDevice currentDevice].batteryState;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryStateDidChange)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];
}

- (BOOL)isUnplugged
{
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnplugged) {
        return YES;
    }
    return NO;
}

- (void)batteryStateDidChange
{
    if ([self isUnplugged] && self.status != UIDeviceBatteryStateUnplugged) {
        [self.mpVolumeView setHidden:YES];
        [self.player play];
    } else if (![self isUnplugged] && (
                                     self.status != UIDeviceBatteryStateFull ||
                                     self.status != UIDeviceBatteryStateCharging
                                    )) {
        [self.mpVolumeView setHidden:NO];
        [self.player stop];
    }
    self.status = [UIDevice currentDevice].batteryState;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self batteryStateDidChange];
}

- (void)viewDidUnload
{
    self.mpVolumeView = nil;
    self.player = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
