//
//  ViewController.h
//  Alert
//
//  Created by c2nprds on 04/16/12.
//  Copyright (c) 2012 c2nprds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet MPVolumeView *mpVolumeView;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, assign) UIDeviceBatteryState status;

@end
