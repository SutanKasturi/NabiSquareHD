//
//  RemoteViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionJpegImageView.h"
#import "MZTimerLabel.h"
#import "OverlayViewController.h"
#import "CameraControllerViewController.h"
#import "NavBarViewController.h"

@interface RemoteViewController : UIViewController<CameraControllerDelegate>

@property (nonatomic, strong) NavBarViewController *navBarViewController;
@property (nonatomic, strong) CameraControllerViewController *cameraControllerViewController;
@property (nonatomic, strong) OverlayViewController *overlayViewController;

@property (strong, nonatomic) UIImageView *mediaManagerImageView;
@property (strong, nonatomic) UILabel *remainingFormatLabel;
@property (strong, nonatomic) UIImageView *batteryLevelImageView;
@property (strong, nonatomic) MotionJpegImageView *motionJpegImageView;
@property (strong, nonatomic) MZTimerLabel *timerLabel;

@end
