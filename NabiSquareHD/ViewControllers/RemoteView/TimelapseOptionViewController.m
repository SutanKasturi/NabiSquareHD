//
//  TimelapseOptionViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "TimelapseOptionViewController.h"
#import "NabiCameraHttpCommands.h"

@implementation TimelapseOptionViewController

- (IBAction)onTimelapse3Sec:(id)sender {
    [self setTimelapseRate:sender requestMode:CAMERA_TIMELAPSE_RATE_2SEC imageName:@"timelapse_3_sec"];
}
- (IBAction)onTimelapse5Sec:(id)sender {
    [self setTimelapseRate:sender requestMode:CAMERA_TIMELAPSE_RATE_2SEC imageName:@"timelapse_5_sec"];
}
- (IBAction)onTimelapse10Sec:(id)sender {
    [self setTimelapseRate:sender requestMode:CAMERA_TIMELAPSE_RATE_2SEC imageName:@"timelapse_10_sec"];
}
- (IBAction)onTimelapse30Sec:(id)sender {
    [self setTimelapseRate:sender requestMode:CAMERA_TIMELAPSE_RATE_2SEC imageName:@"timelapse_30_sec"];
}
- (IBAction)onTimelapse60Sec:(id)sender {
    [self setTimelapseRate:sender requestMode:CAMERA_TIMELAPSE_RATE_2SEC imageName:@"timelapse_60_sec"];
}

- (void) setTimelapseRate:(UIButton*)button requestMode:(NSString*)requestMode imageName:(NSString*)imageName{
    if ( self.currentTimelapseButton == button ) {
        [self.delegate hideAdvancedList];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSettingCameraStart object:nil];
        [NabiCameraHttpCommands sendCameraCommand:requestMode
                                          success:^(id result) {
                                              [self.currentTimelapseButton setSelected:NO];
                                              self.currentTimelapseButton = button;
                                              [self.currentTimelapseButton setSelected:YES];
                                              [self.delegate hideAdvancedList];
                                              
                                              NSString *advancedType = [NSString stringWithFormat:@"%d", kAdvancedTypeTimelapse];
                                              NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:advancedType, kAdvancedType, imageName, kAdvancedImageName, nil];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kAdvancedSelected object:dict];
                                          }
                                          failure:^(NSError *error) {
                                          }];
    }
}

- (NSString *) setTimelapseRate:(NSString*)timelapseRate {
    if ( timelapseRate == nil || [timelapseRate isEqualToString:@""] )
        return nil;
    
    if ( self.currentTimelapseButton )
        [self.currentTimelapseButton setSelected:NO];
    NSString *imageName;
    if ( [timelapseRate isEqualToString:@"2SEC"] ) {
        self.currentTimelapseButton = self.timelapse3SecButton;
        imageName = @"timelapse_3_sec";
    }
    else if ( [timelapseRate isEqualToString:@"5SEC"] ) {
        self.currentTimelapseButton = self.timelaspe5SecButton;
        imageName = @"timelapse_5_sec";
    }
    else if ( [timelapseRate isEqualToString:@"10SEC"] ) {
        self.currentTimelapseButton = self.timelapse10SecButton;
        imageName = @"timelapse_10_sec";
    }
    else if ( [timelapseRate isEqualToString:@"30SEC"] ) {
        self.currentTimelapseButton = self.timelapse30SecButton;
        imageName = @"timelapse_30_sec";
    }
    else if ( [timelapseRate isEqualToString:@"60SEC"] ) {
        self.currentTimelapseButton = self.timelapse60SecButton;
        imageName = @"timelapse_60_sec";
    }
    
    if ( self.currentTimelapseButton )
        [self.currentTimelapseButton setSelected:YES];
    return imageName;
}

@end
