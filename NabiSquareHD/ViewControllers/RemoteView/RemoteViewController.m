//
//  RemoteViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "RemoteViewController.h"
#import <MZTimerLabel/MZTimerLabel.h>
#import "MotionJpegImageView.h"
#import "OverlayViewController.h"
#import "NabiCameraHttpCommands.h"
#import "XMLDictionary.h"
#import "CustomViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RemoteViewController () {
    BOOL showingSegue;
    BOOL isPortrait;
    BOOL pauseSync;
    BOOL getLastThumnailDone;
    int totalFiles;
    BOOL firstGetFilesOnTaskCompleted;
    BOOL recStarted;
    CGFloat mediaManagerSize;
    BOOL isConnected;
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RemoteViewController

@synthesize cameraControllerViewController;
@synthesize overlayViewController;
@synthesize mediaManagerImageView;
@synthesize remainingFormatLabel;
@synthesize batteryLevelImageView;
@synthesize motionJpegImageView;
@synthesize timerLabel;

- (void) fadeControlIn:(UIView*) view speed:(int) speed {
    view.alpha = 0;
    [view setHidden:NO];
    [UIView animateWithDuration:speed
                     animations:^{
                         view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [view setHidden:NO];
                     }];
}

- (void) fadeControlOut:(UIView*) view speed:(int) speed {
    view.alpha = 1;
    [view setHidden:NO];
    [UIView animateWithDuration:speed
                     animations:^{
                         view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [view setHidden:YES];
                     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cameraControllerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraControllerViewController"];
    cameraControllerViewController.delegate = self;
    [self addChildViewController:cameraControllerViewController];
    [self.view insertSubview:cameraControllerViewController.view aboveSubview:self.view];
    cameraControllerViewController.view.frame = [UIScreen mainScreen].bounds;

    motionJpegImageView = [[MotionJpegImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:motionJpegImageView];
    [motionJpegImageView setUrl:[NSURL URLWithString:CAMERA_STREAM_LIVEMJPEG_HTTP]];

    remainingFormatLabel = [[UILabel alloc] init];
    [self.view addSubview:remainingFormatLabel];
    
    timerLabel = [[MZTimerLabel alloc] init];
    timerLabel.timeFormat = @"h:mm:ss";
    timerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timerLabel];
    [timerLabel setHidden:YES];
    
    batteryLevelImageView = [[UIImageView alloc] init];
    [self.view addSubview:batteryLevelImageView];
    batteryLevelImageView.image = [UIImage imageNamed:@"battery100"];
    
    getLastThumnailDone = NO;
    mediaManagerImageView = [[UIImageView alloc] init];
    mediaManagerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    mediaManagerImageView.layer.borderWidth = 1.0f;
    mediaManagerImageView.layer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view addSubview:mediaManagerImageView];
    
    totalFiles = 0;
    firstGetFilesOnTaskCompleted = NO;
    
    overlayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OverlayViewController"];
    [self addChildViewController:overlayViewController];
    [self.view addSubview:overlayViewController.view];
    overlayViewController.view.frame = [UIScreen mainScreen].bounds;
    [overlayViewController.view setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupCameraSettings:) name:kSettingCameraStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endCameraSettings:) name:kSettingCameraEnd object:nil];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *mediaTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMediaManager)];
    [mediaManagerImageView addGestureRecognizer:mediaTapGestureRecognizer];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ( screenHeight > screenWidth ) {
        mediaManagerSize = 100 * (screenWidth / 640);
    }
    else {
        mediaManagerSize = 100 * (screenHeight / 640);
    }
    
    [self setupView];
    
    [self showSegue:@""];
    [self syncCameraSettings];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ( timerLabel ) {
        [timerLabel pause];
        [timerLabel reset];
        timerLabel.text = @"";
    }
    remainingFormatLabel.text = @"";
    pauseSync = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(syncCameraSettings) userInfo:nil repeats:YES];
    [motionJpegImageView play];
    [self loadStreamAfterWait];
}

- (void) viewWillDisappear:(BOOL)animated {
    pauseSync = YES;
    [self.timer invalidate];
    self.timer = nil;
    [motionJpegImageView stop];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:UIDeviceOrientationDidChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kSettingCameraStart];
    [[NSNotificationCenter defaultCenter] removeObserver:kSettingCameraEnd];
}
#pragma mark - Screen Orientation
- (BOOL)shouldAutorotate {
    return YES;
}

- (void) deviceOrientationDidChange
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ( (screenWidth > screenHeight && isPortrait == YES) || (screenHeight > screenWidth && isPortrait == NO) ) {
        isPortrait = !isPortrait;
        [self setupView];
    }
}

- (void) setupView {
    CGRect rect = [UIScreen mainScreen].bounds;
    motionJpegImageView.frame = rect;
    overlayViewController.view.frame = rect;
    cameraControllerViewController.view.frame = rect;
    
    remainingFormatLabel.frame = CGRectMake(20, 64, rect.size.width, 20);
    
    CGRect timerLabelRect = rect;
    timerLabelRect.origin.y = 100.0f;
    timerLabelRect.size.height = 20.0f;
    timerLabel.frame = timerLabelRect;
    
    batteryLevelImageView.frame = CGRectMake(rect.size.width - 20 - 44, 84, 44, 24);

    mediaManagerImageView.frame = CGRectMake(rect.size.width - 20 - mediaManagerSize, rect.size.height - 20 - mediaManagerSize, mediaManagerSize, mediaManagerSize);
}

#pragma mark - Setup CammeraSettings

- (void) setupCameraSettings:(NSNotification*)note {
    [self showSegue:@""];
}

- (void) endCameraSettings:(NSNotification*)note {
    double delayInSeconds = 1.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self loadStreamAfterWait];
        [self syncCameraSettings];
    });
}

- (MZTimerLabel*)getRecordTimer {
    if ( self.timerLabel )
        return self.timerLabel;
    
//    [self.timerLabel setCountDownTime:60];
    
    return self.timerLabel;
}

- (void) showSegue:(NSString*)text {
    if ( showingSegue == NO ) {
        showingSegue = YES;
        overlayViewController.textLabel.text = text;
        [self fadeControlIn:overlayViewController.view speed:0.1f];
    }
}

- (void) hideSegue {
    if ( showingSegue == YES ) {
        [self fadeControlOut:overlayViewController.view speed:0.1f];
        showingSegue = NO;
    }
}

- (void) loadStreamAfterWait {
    [self showSegue:@""];
    
    [self hideSegue];
}

- (void) timerSyncSettings {
    [self syncCameraSettings];
}
- (void) syncCameraSettings {
    if ( pauseSync )
        return;
    
    [NabiCameraHttpCommands sendCameraCommand:CAMERA_ALL_SETTINGS
                                      success:^(id result) {
                                          if ( result == nil || [result isEqualToString:@""] )
                                              [self onBack];
                                          
                                          [self setUIMode:[NabiCameraHttpCommands parseCameraSettings:result settingToFind:@"UIMode"] availableRecordTime:[NabiCameraHttpCommands parseCameraSettings:result settingToFind:@"Camera.Record.Remaining"]];
                                          [self setBatteryLevel:[NabiCameraHttpCommands parseCameraSettings:result settingToFind:@"Camera.Battery.Level"]];
                                          
                                          if ( cameraControllerViewController )
                                              [cameraControllerViewController setCameraSettings:result];
                                          
                                          if ( getLastThumnailDone == NO ) {
                                              totalFiles = [[NabiCameraHttpCommands parseCameraSettings:result settingToFind:@"Camera.File.Total"] intValue];
                                              getLastThumnailDone = YES;
                                              [self getLastThumbnail];
                                          }
                                      }
                                      failure:^(NSError *error) {
                                          [self onBack];
                                      }];
}

- (void) onBack {
    [timerLabel pause];
    timerLabel = nil;
    [motionJpegImageView stop];
    motionJpegImageView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setUIMode:(NSString*)uimode availableRecordTime:(NSString*)availableRecordTime {
    int cameraMode = -1;
    if ( [uimode isEqualToString:@"VIDEO"] ) {
        cameraMode = kCameraModeVideo;
        int recordTime = [availableRecordTime intValue];
        int hours = recordTime / 3600;
        int minutes = (recordTime % 3600) / 60;
        int seconds = recordTime % 60;
        NSString *timeString = [NSString stringWithFormat:@"%01d:%02d:%02d", hours, minutes, seconds];
        remainingFormatLabel.text = [NSString stringWithFormat:@"%@ video remaining", timeString];
    }
    else {
        remainingFormatLabel.text = [NSString stringWithFormat:@"%@ snaps remaining", availableRecordTime];
        if ( [uimode isEqualToString:@"CAMERA"] ) {
            cameraMode = kCameraModePhoto;
        }
        else if ( [uimode isEqualToString:@"BURST"] ) {
            cameraMode = kCameraModeBurst;
        }
        else if ( [uimode isEqualToString:@"TIMELAPSE"] ) {
            cameraMode = kCameraModeVideoTimer;
        }
    }
    
    [cameraControllerViewController setCameraMode:cameraMode];
}

- (void) setBatteryLevel:(NSString*)batteryLevel {
    if ( [batteryLevel isEqualToString:@"100"] ) {
        [batteryLevelImageView setImage:[UIImage imageNamed:@"battery100"]];
    }
    else if ( [batteryLevel isEqualToString:@"75"] ) {
        [batteryLevelImageView setImage:[UIImage imageNamed:@"battery75"]];
    }
    else if ( [batteryLevel isEqualToString:@"50"] ) {
        [batteryLevelImageView setImage:[UIImage imageNamed:@"battery50"]];
    }
    else if ( [batteryLevel isEqualToString:@"25"] ) {
        [batteryLevelImageView setImage:[UIImage imageNamed:@"battery25"]];
    }
    else if ( [batteryLevel isEqualToString:@"0"] ) {
        [batteryLevelImageView setImage:[UIImage imageNamed:@"battery0"]];
    }
}

- (void) getLastThumbnail {
    [NabiCameraHttpCommands getLastThumbnail:0
                                     success:^(id result) {
                                         [self getFilesOnTaskCompleted:result];
                                     }
                                     failure:^(NSError *error) {
                                         [self hideSegue];
                                     }];
}

- (void) getFilesOnTaskCompleted:(NSString*)result {
    if ( firstGetFilesOnTaskCompleted ) {
        firstGetFilesOnTaskCompleted = NO;
        [NabiCameraHttpCommands getLastThumbnail:totalFiles - 1
                                         success:^(id result) {
                                             [self getFilesOnTaskCompleted:result];
                                         }
                                         failure:^(NSError *error) {
                                             [self loadStreamAfterWait];
                                         }];
    }
    else {
        NSDictionary *dict = [NSDictionary dictionaryWithXMLString:result];
        if ( dict == nil ) {
            NSLog(@"getFilesOnTaskCompleted Error");
            [self loadStreamAfterWait];
        }
        else {
            NSDictionary *file = [[dict objectForKey:@"DCIM"] objectForKey:@"file"];
            NSString *filePath = [file objectForKey:@"name"];
            NSString *format = [file objectForKey:@"format"];
            NSString *thumbnailUrl = @"";
            if ( [format isEqualToString:@"jpeg"] ) {
                thumbnailUrl = [NSString stringWithFormat:@"http://192.72.1.1/%@", filePath];
            }
            else {
                NSString *fileName = [filePath substringFromIndex:[filePath rangeOfString:@"/" options:NSBackwardsSearch].location + 1];
                thumbnailUrl = [NSString stringWithFormat:@"http://192.72.1.1/thumb/DCIM/100DSCIM/%@", fileName];
            }
            
            [mediaManagerImageView sd_setImageWithURL:[NSURL URLWithString:thumbnailUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if ( image )
                    mediaManagerImageView.image = image;
            }];
            [self loadStreamAfterWait];
        }
    }
}

#pragma mark - RecordButton Action
- (void)startRecord {
    NSString *captureCommand = CAMERA_START_STOP_RECORD;
    if ( cameraControllerViewController.currentCameraMode == kCameraModeVideo )
        captureCommand = CAMERA_START_STOP_RECORD;
    else
        [self showSegue:@""];
    
    [NabiCameraHttpCommands sendCameraCommand:captureCommand
                                      success:^(id result) {
                                          if ( cameraControllerViewController.currentCameraMode == kCameraModeVideo ) {
                                              if ( recStarted ) {
                                                  recStarted = NO;
                                                  [cameraControllerViewController stoppedRecord];
                                                  
                                                  [timerLabel setHidden:YES];
                                                  [timerLabel pause];
                                                  
                                                  getLastThumnailDone = NO;
                                                  [self syncCameraSettings];
                                              }
                                              else {
                                                  recStarted = YES;
                                                  [cameraControllerViewController startedRecord];
                                                  
                                                  [timerLabel reset];
                                                  [timerLabel setHidden:YES];
                                                  [timerLabel start];
                                              }
                                          }
                                          else {
                                              getLastThumnailDone = NO;
                                              [self syncCameraSettings];
                                          }
                                      }
                                      failure:^(NSError *error) {
                                          
                                      }];
}

#pragma mark - MediaManager
- (void) showMediaManager {
    CustomViewController *cameraRollViewController = [[CustomViewController alloc] initWithViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MediaManagerViewController"] title:@"Camera Roll" hideNavBar:NO];
    cameraRollViewController.view.frame = [UIScreen mainScreen].bounds;
    [self.navigationController pushViewController:cameraRollViewController animated:YES];
}

@end
