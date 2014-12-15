//
//  CameraControllerViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "CameraControllerViewController.h"
#import "NabiCameraHttpCommands.h"

#define CAMERA_MODE_VIEW_RATIO          (50.0f / 320.0f)
#define VIDEO_OPTION_VIEW_RATIO         (43.0f / 200.0f)
#define EASY_OPTION_VIEW_RATIO          (43.0f / 240.0f)
#define ADVANCED_OPTION_VIEW_RATIO      (43.0f / 274.0f)

#define RES_RPS_OPTION_VIEW_RATIO       (355.0f / 98.0f)
#define AWS_OPTION_VIEW_RATIO           (402.0f / 82.0f)
#define BURST_OPTION_VIEW_RATIO         (179.0f / 98.0f)
#define IMAGE_OPTION_VIEW_RATIO         (179.0f / 98.0f)
#define TIMELAPSE_OPTION_VIEW_RATIO     (297.0f / 98.0f)

#define PADDING                         20.0f
#define SETTING_BUTTON_WIDTH            60.0f
#define LIST_WIDTH                      80.0f
#define RECORD_BUTTON_WIDTH             80.0f

@interface CameraControllerViewController () {
    CGFloat deviceRatio;
    BOOL isPortrait;
    CGFloat resFPSListHeight;
    CGFloat burstListHeight;
    CGFloat imageListHeight;
    CGFloat timelapseListHeight;
    CGFloat awsListHeight;
    CGFloat listWidth;
}

@end

@implementation CameraControllerViewController

@synthesize recordButton;

@synthesize cameraModeViewController;
@synthesize videoOptionViewController;
@synthesize easyOptionViewController;
@synthesize advancedOptionViewController;

@synthesize resFPSOptionViewController;
@synthesize burstOptionViewController;
@synthesize imageOptionViewController;
@synthesize timelapseOptionViewController;
@synthesize awsOptionViewController;

@synthesize resFPSOptionScrollView;
@synthesize burstOptionScrollView;
@synthesize imageOptionScrollView;
@synthesize timelapseOptionScrollView;
@synthesize awsOptionScrollView;

@synthesize currentOptionScrollView;
@synthesize currentCameraMode;

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
        [self showAdvancedOptionView];
    }
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    if ( deviceSize.height > deviceSize.width ) {
        deviceRatio = deviceSize.width / 320;
        isPortrait = YES;
    }
    else {
        deviceRatio = deviceSize.height / 320;
        isPortrait = NO;
    }
    deviceRatio = 1.0f;
    
    listWidth = LIST_WIDTH * deviceRatio;
    
    resFPSListHeight = listWidth * RES_RPS_OPTION_VIEW_RATIO;
    burstListHeight = listWidth * BURST_OPTION_VIEW_RATIO;
    imageListHeight = listWidth * IMAGE_OPTION_VIEW_RATIO;
    timelapseListHeight = listWidth * TIMELAPSE_OPTION_VIEW_RATIO;
    awsListHeight = listWidth * AWS_OPTION_VIEW_RATIO;
    
    
    // CameraModeView
    cameraModeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraModeViewController"];
    cameraModeViewController.view.backgroundColor = [UIColor clearColor];
    cameraModeViewController.delegate = self;
    [self addChildViewController:cameraModeViewController];
    [self.view addSubview:cameraModeViewController.view];
    
    // VideoOptionView
    videoOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoOptionViewController"];
    videoOptionViewController.view.backgroundColor = [UIColor clearColor];
    videoOptionViewController.delegate = self;
    [videoOptionViewController.view setHidden:YES];
    [self addChildViewController:videoOptionViewController];
    [self.view addSubview:videoOptionViewController.view];
    
    // EasyOptionView
    easyOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EasyOptionViewController"];
    easyOptionViewController.view.backgroundColor = [UIColor clearColor];
    [easyOptionViewController.view setHidden:YES];
    [self addChildViewController:easyOptionViewController];
    [self.view addSubview:easyOptionViewController.view];
    
    // AdvancedOptionView
    advancedOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdvancedOptionViewController"];
    advancedOptionViewController.view.backgroundColor = [UIColor clearColor];
    advancedOptionViewController.delegate = self;
    [advancedOptionViewController.view setHidden:YES];
    [self addChildViewController:advancedOptionViewController];
    [self.view addSubview:advancedOptionViewController.view];
    
    // ResFPSOptionView
    resFPSOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResFPSOptionViewController"];
    resFPSOptionViewController.view.backgroundColor = [UIColor clearColor];
    resFPSOptionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, listWidth, resFPSListHeight)];
    [resFPSOptionScrollView setHidden:YES];
    resFPSOptionViewController.delegate = self;
    [self addChildViewController:resFPSOptionViewController];
    [self.resFPSOptionScrollView addSubview:resFPSOptionViewController.view];
    [self.view addSubview:self.resFPSOptionScrollView];
    
    resFPSOptionViewController.view.frame = CGRectMake(0, 0, listWidth, resFPSListHeight);
    resFPSOptionScrollView.contentSize = CGSizeMake(0, resFPSListHeight);
    [self setupScrollView:resFPSOptionScrollView];
    
    // BurstOptionView
    burstOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BurstOptionViewController"];
    burstOptionViewController.view.backgroundColor = [UIColor clearColor];
    burstOptionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, listWidth, burstListHeight)];
    [burstOptionScrollView setHidden:YES];
    [self addChildViewController:burstOptionViewController];
    [self.burstOptionScrollView addSubview:burstOptionViewController.view];
    [self.view addSubview:self.burstOptionScrollView];
    
    burstOptionViewController.view.frame = CGRectMake(0, 0, listWidth, burstListHeight);
    burstOptionScrollView.contentSize = CGSizeMake(0, burstListHeight);
    [self setupScrollView:burstOptionScrollView];
    
    // ImageOptionView
    imageOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageOptionViewController"];
    imageOptionViewController.view.backgroundColor = [UIColor clearColor];
    imageOptionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, listWidth, imageListHeight)];
    [imageOptionScrollView setHidden:YES];
    [self addChildViewController:imageOptionViewController];
    [self.imageOptionScrollView addSubview:imageOptionViewController.view];
    [self.view addSubview:self.imageOptionScrollView];
    
    imageOptionViewController.view.frame = CGRectMake(0, 0, listWidth, imageListHeight);
    imageOptionScrollView.contentSize = CGSizeMake(0, imageListHeight);
    [self setupScrollView:imageOptionScrollView];
    
    // TimelapseOptionView
    timelapseOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimelapseOptionViewController"];
    timelapseOptionViewController.view.backgroundColor = [UIColor clearColor];
    
    timelapseOptionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, listWidth, timelapseListHeight)];
    [timelapseOptionScrollView setHidden:YES];
    [self addChildViewController:timelapseOptionViewController];
    [self.timelapseOptionScrollView addSubview:timelapseOptionViewController.view];
    [self.view addSubview:self.timelapseOptionScrollView];
    
    timelapseOptionViewController.view.frame = CGRectMake(0, 0, listWidth, timelapseListHeight);
    timelapseOptionScrollView.contentSize = CGSizeMake(0, timelapseListHeight);
    [self setupScrollView:timelapseOptionScrollView];
    
    // AwsOptionView
    awsOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AWSOptionViewController"];
    awsOptionViewController.view.backgroundColor = [UIColor clearColor];
    awsOptionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, listWidth, awsListHeight)];
    [awsOptionScrollView setHidden:YES];
    [self addChildViewController:awsOptionViewController];
    [self.awsOptionScrollView addSubview:awsOptionViewController.view];
    [self.view addSubview:self.awsOptionScrollView];
    
    awsOptionViewController.view.frame = CGRectMake(0, 0, listWidth, awsListHeight);
    awsOptionScrollView.contentSize = CGSizeMake(0, awsListHeight);
    [self setupScrollView:awsOptionScrollView];
    
    currentOptionScrollView = nil;
    
    [self setupView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:UIDeviceOrientationDidChangeNotification];
}

- (void) setupScrollView:(UIScrollView*)scrollView{
    scrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    scrollView.layer.borderWidth = 1.0f;
    scrollView.layer.backgroundColor = [UIColor blackColor].CGColor;
}

- (void)setupView {
    
    // Setting Size;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat cameraModeViewWidth = SETTING_BUTTON_WIDTH * 4 * deviceRatio;
    CGFloat cameraModeViewHeight = cameraModeViewWidth * CAMERA_MODE_VIEW_RATIO;
    
    CGFloat recordButtonWidth = RECORD_BUTTON_WIDTH * deviceRatio;
    
    CGFloat videoOptionViewWidth = cameraModeViewHeight / VIDEO_OPTION_VIEW_RATIO;
    CGFloat videoOptionViewHeight = cameraModeViewHeight;
    
    CGFloat easyOptionViewWidth = cameraModeViewHeight / EASY_OPTION_VIEW_RATIO;
    CGFloat easyOptionViewHeight = cameraModeViewHeight;
    
    CGFloat advancedOptionViewHeight = cameraModeViewHeight;
    CGFloat advancedOptionViewWidth = 0;
    
    // Setting position
    CGFloat recordButtonX = (screenWidth - recordButtonWidth) / 2;
    CGFloat recordButtonY = screenHeight;
    CGFloat cameraModeViewY;
    if ( cameraModeViewWidth + PADDING * 2 > screenWidth / 2 ) {
        recordButtonY = screenHeight - recordButtonWidth;
        cameraModeViewY = recordButtonY - PADDING - cameraModeViewHeight;
    }
    else {
        recordButtonY = screenHeight - recordButtonWidth;
        cameraModeViewY = screenHeight - PADDING - cameraModeViewHeight;
    }
    recordButton.translatesAutoresizingMaskIntoConstraints = YES;
    recordButton.frame = CGRectMake(recordButtonX, recordButtonY, recordButtonWidth, recordButtonWidth);

    cameraModeViewController.view.frame = CGRectMake(PADDING, cameraModeViewY, cameraModeViewWidth, cameraModeViewHeight);
    
    CGFloat easyOptionViewY = cameraModeViewY - PADDING - easyOptionViewHeight;
    easyOptionViewController.view.frame = CGRectMake(PADDING, easyOptionViewY, easyOptionViewWidth, easyOptionViewHeight);
    advancedOptionViewController.view.frame = CGRectMake(PADDING, easyOptionViewY, advancedOptionViewWidth, advancedOptionViewHeight);
    
    CGFloat videoOptionViewY = easyOptionViewY - PADDING - videoOptionViewHeight;
    videoOptionViewController.view.frame = CGRectMake(PADDING, videoOptionViewY, videoOptionViewWidth, videoOptionViewHeight);
    
    CGFloat maxListHeight = easyOptionViewY - PADDING;
    
    CGFloat resFPSScrollHeight = resFPSListHeight;
    if (resFPSScrollHeight > maxListHeight )
        resFPSScrollHeight = maxListHeight;
    resFPSOptionScrollView.frame = CGRectMake(PADDING, easyOptionViewY - resFPSScrollHeight, listWidth, resFPSScrollHeight);
    
    CGFloat awsScrollHeight = awsListHeight;
    if (awsScrollHeight > maxListHeight )
        awsScrollHeight = maxListHeight;
    awsOptionScrollView.frame = CGRectMake(PADDING, easyOptionViewY - awsScrollHeight, listWidth, awsScrollHeight);
    
    CGFloat imageMPScrollHeight = imageListHeight;
    if (imageMPScrollHeight > maxListHeight )
        imageMPScrollHeight = maxListHeight;
    imageOptionScrollView.frame = CGRectMake(PADDING, easyOptionViewY - imageMPScrollHeight, listWidth, imageMPScrollHeight);
    
    CGFloat burstScrollHeight = burstListHeight;
    if (burstScrollHeight > maxListHeight )
        burstScrollHeight = maxListHeight;
    burstOptionScrollView.frame = CGRectMake(PADDING + listWidth, easyOptionViewY - burstScrollHeight, listWidth, burstScrollHeight);
    
    CGFloat timelapseScrollHeight = timelapseListHeight;
    if (timelapseScrollHeight > maxListHeight )
        timelapseScrollHeight = maxListHeight;
    timelapseOptionScrollView.frame = CGRectMake(PADDING + listWidth, easyOptionViewY - timelapseScrollHeight, listWidth, timelapseScrollHeight);
}

#pragma mark - CameraModeDelegate

- (void)showCameraMode:(int)cameramode {
    [currentOptionScrollView setHidden:YES];
    currentOptionScrollView = nil;
    if ( currentCameraMode == cameramode )
        return;
    
    currentCameraMode = cameramode;
    switch (currentCameraMode) {
        case kCameraModeVideo:
            [self showVideoOptionView:videoOptionViewController.currentVideoOption];
            break;
            
        case kCameraModePhoto:
            [self showAdvancedOptionView];
            break;
            
        case kCameraModeBurst:
            [self showAdvancedOptionView];
            break;
            
        case kCameraModeVideoTimer:
            [self showAdvancedOptionView];
            break;
            
        default:
            break;
    }
    
    if ( currentCameraMode != kCameraModeVideo ) {
        [videoOptionViewController.view setHidden:YES];
        [easyOptionViewController.view setHidden:YES];
        [advancedOptionViewController.view setHidden:NO];
    }
}

- (void)hideCameraMode:(int)cameramode {
    currentCameraMode = -1;
    [videoOptionViewController.view setHidden:YES];
    [easyOptionViewController.view setHidden:YES];
    [advancedOptionViewController.view setHidden:YES];
}

#pragma mark - VideoOptionDelegate

- (void)showVideoOptionView:(int)videooption {
    [videoOptionViewController.view setHidden:NO];
    if ( videooption == kVideoOptionEasy ) {
        [easyOptionViewController.view setHidden:NO];
        [advancedOptionViewController.view setHidden:YES];
    }
    else {
        [self showAdvancedOptionView];
        [easyOptionViewController.view setHidden:YES];
        [advancedOptionViewController.view setHidden:NO];
    }
}

#pragma mark - Show Advanced Option

- (void) showAdvancedOptionView {
    CGRect advancedOptionRect = advancedOptionViewController.view.frame;
    CGFloat advancedOptionViewHeight = advancedOptionRect.size.height;
    CGFloat advancedOptionViewWidth = 0;
    CGRect awsScrollRect = awsOptionScrollView.frame;
    switch (currentCameraMode) {
        case kCameraModeVideo:
        case kCameraModePhoto:
            advancedOptionViewWidth = (advancedOptionViewHeight / ADVANCED_OPTION_VIEW_RATIO) * 2 / 3 + 10;
            awsScrollRect.origin.x = PADDING + listWidth;
            break;
            
        default:
            advancedOptionViewWidth = advancedOptionViewHeight / ADVANCED_OPTION_VIEW_RATIO + 10;
            awsScrollRect.origin.x = PADDING + listWidth * 2;
            break;
    }
    awsOptionScrollView.frame = awsScrollRect;
    advancedOptionRect.size.width = advancedOptionViewWidth;
    advancedOptionViewController.view.frame = advancedOptionRect;
    [advancedOptionViewController showButtons:currentCameraMode];
}

#pragma mark - AdvancedOptionDelegate
- (void)showAdvancedList:(int)advancedtype {
    
    UIScrollView *scrollView = [self getAdvancedScrollView:advancedtype];
    if ( scrollView == nil )
        return;
    
    if ( scrollView == currentOptionScrollView )
    {
        [currentOptionScrollView setHidden:YES];
        currentOptionScrollView = nil;
    }
    else {
        if ( currentOptionScrollView )
            [currentOptionScrollView setHidden:YES];
        currentOptionScrollView = scrollView;
        [currentOptionScrollView setHidden:NO];
    }
}

- (UIScrollView*) getAdvancedScrollView:(int)advancedtype {
    switch (advancedtype) {
        case kAdvancedTypeResFPS:
            return resFPSOptionScrollView;
            break;
        case kAdvancedTypeAWS:
            return awsOptionScrollView;
            break;
        case kAdvancedTypeImage:
            return imageOptionScrollView;
            break;
        case kAdvancedTypeBurst:
            return burstOptionScrollView;
            break;
        case kAdvancedTypeTimelapse:
            return timelapseOptionScrollView;
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)hideAdvancedList {
    if ( currentOptionScrollView )
        [currentOptionScrollView setHidden:YES];
    
    currentOptionScrollView = nil;
}

#pragma mark - Record

- (IBAction)onRecord:(id)sender {
    [self.delegate startRecord];
}

- (void) startedRecord {
    [self.recordButton setImage:[UIImage imageNamed:@"record_active"] forState:UIControlStateNormal];
}
- (void) stoppedRecord {
    [self.recordButton setImage:[UIImage imageNamed:@"recordbutton"] forState:UIControlStateNormal];
}

#pragma mark - Init CameraSettings

- (void) setCameraSettings:(NSString*)settings {
    NSString *videoResolution = [NabiCameraHttpCommands parseCameraSettings:settings settingToFind:@"Camera.Menu.VideoRes"];
    NSString *imageResolution = [NabiCameraHttpCommands parseCameraSettings:settings settingToFind:@"Camera.Menu.ImageRes"];
    NSString *whiteBalance = [NabiCameraHttpCommands parseCameraSettings:settings settingToFind:@"Camera.Menu.AWB"];
    NSString *burstRate = [NabiCameraHttpCommands parseCameraSettings:settings settingToFind:@"Camera.Menu.PhotoBurst"];
    NSString *timelapseRate = [NabiCameraHttpCommands parseCameraSettings:settings settingToFind:@"Camera.Menu.Timelapse"];
    
    [advancedOptionViewController setAdvancedOptionResFPS:[resFPSOptionViewController setVideoResolution:videoResolution]];
    [advancedOptionViewController setAdvancedOptionImageMP:[imageOptionViewController setImageResolution:imageResolution]];
    [advancedOptionViewController setAdvancedOptionAWS:[awsOptionViewController setWhiteBalance:whiteBalance]];
    [advancedOptionViewController setAdvancedOptionBurst:[burstOptionViewController setBurstRate:burstRate]];
    [advancedOptionViewController setAdvancedOptionTimelapse:[timelapseOptionViewController setTimelapseRate:timelapseRate]];
}

- (void) setCameraMode:(int) cameraMode {
    currentCameraMode = cameraMode;
    [cameraModeViewController setCameraMode:cameraMode];
    if ( currentCameraMode != -1 )
        [self showCameraMode:cameraMode];
}
@end
