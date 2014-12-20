//
//  CameraControllerViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraModeViewController.h"
#import "VideoOptionViewController.h"
#import "EasyOptionViewController.h"
#import "AdvancedOptionViewController.h"

#import "ResFPSOptionViewController.h"
#import "BurstOptionViewController.h"
#import "ImageOptionViewController.h"
#import "TimelapseOptionViewController.h"
#import "AWSOptionViewController.h"

@protocol CameraControllerDelegate <NSObject>

- (void) startRecord;

@end

@interface CameraControllerViewController : UIViewController<AdvancedOptionTypeDelegate, CameraModeDelegate, VideoOptionDelegate>

@property (nonatomic, weak) id<CameraControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (nonatomic, strong) CameraModeViewController *cameraModeViewController;
@property (nonatomic, strong) VideoOptionViewController *videoOptionViewController;
@property (nonatomic, strong) EasyOptionViewController *easyOptionViewController;
@property (nonatomic, strong) AdvancedOptionViewController *advancedOptionViewController;

@property (nonatomic, strong) ResFPSOptionViewController *resFPSOptionViewController;
@property (nonatomic, strong) BurstOptionViewController *burstOptionViewController;
@property (nonatomic, strong) ImageOptionViewController *imageOptionViewController;
@property (nonatomic, strong) TimelapseOptionViewController *timelapseOptionViewController;
@property (nonatomic, strong) AWSOptionViewController *awsOptionViewController;

@property (nonatomic, strong) UIScrollView *resFPSOptionScrollView;
@property (nonatomic, strong) UIScrollView *burstOptionScrollView;
@property (nonatomic, strong) UIScrollView *imageOptionScrollView;
@property (nonatomic, strong) UIScrollView *timelapseOptionScrollView;
@property (nonatomic, strong) UIScrollView *awsOptionScrollView;

@property (nonatomic, strong) UIScrollView *currentOptionScrollView;
@property (nonatomic, assign) int currentCameraMode;

- (void) setupView;
- (void) setCameraSettings:(NSString*)settings;
- (void) setCameraMode:(int) cameraMode;

- (void) startedRecord;
- (void) stoppedRecord;

@end
