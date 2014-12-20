//
//  ResFPSViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "ResFPSOptionViewController.h"
#import "NabiCameraHttpCommands.h"

@implementation ResFPSOptionViewController
- (IBAction)onResFPS4K:(id)sender {
    [self setVideoResolution:sender requestMode:CAMERA_VIDEO_FORMAT_4K15 imageName:@"res_4k_15fps"];
}
- (IBAction)onResFPS27K:(id)sender {
    [self setVideoResolution:sender requestMode:CAMERA_VIDEO_FORMAT_2K30 imageName:@"res_27k_30fps"];
}
- (IBAction)onResFPS720_100:(id)sender {
    [self setVideoResolution:sender requestMode:CAMERA_VIDEO_FORMAT_720P100 imageName:@"res_720p_100fps"];
}
- (IBAction)onResFPS720_120:(id)sender {
    [self setVideoResolution:sender requestMode:CAMERA_VIDEO_FORMAT_720P120 imageName:@"res_720p_120fps"];
}
- (IBAction)onResFPS1080_50:(id)sender {
    [self setVideoResolution:sender requestMode:CAMERA_VIDEO_FORMAT_1080P30 imageName:@"res_1080p_50fps"];
}
- (IBAction)onResFPS1080_60:(id)sender {
    [self setVideoResolution:sender requestMode:CAMERA_VIDEO_FORMAT_1080P60 imageName:@"res_1080p_60fps"];
}

- (void) setVideoResolution:(UIButton*)button requestMode:(NSString*)requestMode imageName:(NSString*)imageName{
    if ( self.currentResFPSButton == button ) {
        [self.delegate hideAdvancedList];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSettingCameraStart object:nil];
        [NabiCameraHttpCommands sendCameraCommand:requestMode
                                          success:^(id result) {
                                              [self.currentResFPSButton setSelected:NO];
                                              self.currentResFPSButton = button;
                                              [self.currentResFPSButton setSelected:YES];
                                              [self.delegate hideAdvancedList];
                                              [self finishedSendCameraCommand:result];
                                              
                                              NSString *advancedType = [NSString stringWithFormat:@"%d", kAdvancedTypeResFPS];
                                              NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:advancedType, kAdvancedType, imageName, kAdvancedImageName, nil];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kAdvancedSelected object:dict];
                                          }
                                          failure:^(NSError *error) {
                                              [self finishedSendCameraCommand:nil];
                                          }];
    }
}

- (void)finishedSendCameraCommand:(NSString *)result {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSettingCameraEnd object:result];
}

- (NSString*) setVideoResolution:(NSString*)videoRes {
    if ( videoRes == nil || [videoRes isEqualToString:@""] )
        return nil;
    
    if ( self.currentResFPSButton )
        [self.currentResFPSButton setSelected:NO];
    
    NSString *imageName = nil;
    if ( [videoRes isEqualToString:@"4K15"] ) {
        self.currentResFPSButton = self.resFPS4KButton;
        imageName = @"res_4k_15fps";
    }
    else if ( [videoRes isEqualToString:@"2.7K30"] ) {
        self.currentResFPSButton = self.resFPS27KButton;
        imageName = @"res_27k_30fps";
    }
    else if ( [videoRes isEqualToString:@"720P100"] ) {
        self.currentResFPSButton = self.resFPS4KButton;
        imageName = @"res_720p_100fps";
    }
    else if ( [videoRes isEqualToString:@"720P120"] ) {
        self.currentResFPSButton = self.resFPS4KButton;
        imageName = @"res_720p_120fps";
    }
    else if ( [videoRes isEqualToString:@"1080P30"] ) {
        self.currentResFPSButton = self.resFPS4KButton;
        imageName = @"res_1080p_50fps";
    }
    else if ( [videoRes isEqualToString:@"1080P60"] ) {
        self.currentResFPSButton = self.resFPS4KButton;
        imageName = @"res_1080p_60fps";
    }
    if ( self.currentResFPSButton )
         [self.currentResFPSButton setSelected:YES];
    return imageName;
}

@end
