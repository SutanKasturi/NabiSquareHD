//
//  CameraModeViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "CameraModeViewController.h"
#import "NabiCameraHttpCommands.h"

@interface CameraModeViewController ()<NabiCameraHttpCommandsDelegate>

@end

@implementation CameraModeViewController

- (IBAction)onCameraModeVideo:(id)sender {
    [self setCameraMode:kCameraModeVideo button:sender requestMode:CAMERA_MODE_VIDEO];
}

- (IBAction)onCameraModePhoto:(id)sender {
    [self setCameraMode:kCameraModePhoto button:sender requestMode:CAMERA_MODE_CAMERA];
}

- (IBAction)onCameraModeBurst:(id)sender {
    [self setCameraMode:kCameraModeBurst button:sender requestMode:CAMERA_MODE_BURST];
}

- (IBAction)onCameraModeVideoTimer:(id)sender {
    [self setCameraMode:kCameraModeVideoTimer button:sender requestMode:CAMERA_MODE_TIMELAPSE];
}

- (void) setCameraMode:(int)cameramode button:(UIButton*)button requestMode:(NSString*)requestMode{
    if ( self.currentModeButton == button ) {
        if ( self.currentModeButton.isSelected )
            [self.delegate hideCameraMode:cameramode];
        else
            [self.delegate showCameraMode:cameramode];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSettingCameraStart object:nil];
        [NabiCameraHttpCommands sendCameraCommand:requestMode
                                          success:^(id result) {
                                              [self.delegate showCameraMode:cameramode];
                                              if ( self.currentModeButton )
                                                  [self.currentModeButton setSelected:NO];
                                              self.currentModeButton = button;
                                              [self.currentModeButton setSelected:YES];
                                              [self finishedSendCameraCommand:result];
                                          }
                                          failure:^(NSError *error) {
                                              [self finishedSendCameraCommand:nil];
                                          }];
    }
}

- (void)finishedSendCameraCommand:(NSString *)result {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSettingCameraEnd object:result];
}

- (void) setCameraMode:(int)cameraMode {
    if ( self.currentModeButton )
        [self.currentModeButton setSelected:NO];
    
    switch (cameraMode) {
        case kCameraModeVideo:
            self.currentModeButton = self.videoButton;
            break;
        case kCameraModePhoto:
            self.currentModeButton = self.photoButton;
            break;
        case kCameraModeBurst:
            self.currentModeButton = self.burstButton;
            break;
        case kCameraModeVideoTimer:
            self.currentModeButton = self.videoTimerButton;
            break;
            
        default:
            break;
    }
    
    if ( self.currentModeButton )
        [self.currentModeButton setSelected:YES];
}

@end
