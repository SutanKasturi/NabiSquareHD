//
//  CameraModeViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kCameraModeVideo = 1,
    kCameraModePhoto,
    kCameraModeBurst,
    kCameraModeVideoTimer
}CameraMode;

@protocol CameraModeDelegate <NSObject>

- (void) showCameraMode:(int)cameramode;
- (void) hideCameraMode:(int)cameramode;

@end

@interface CameraModeViewController : UIViewController

@property (weak, nonatomic) id<CameraModeDelegate> delegate;

@property (nonatomic, strong) UIButton* currentModeButton;

@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *burstButton;
@property (weak, nonatomic) IBOutlet UIButton *videoTimerButton;

- (void) setCameraMode:(int)cameraMode;

@end
