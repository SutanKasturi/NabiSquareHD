//
//  AWSOptionViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "AWSOptionViewController.h"
#import "NabiCameraHttpCommands.h"

@implementation AWSOptionViewController

- (IBAction)onAWSAuto:(id)sender {
    [self setWhiteBalance:sender requestMode:CAMERA_WHITE_BALANCE_AUTO imageName:@"aws_auto"];
}
- (IBAction)onAWSDayLight:(id)sender {
    [self setWhiteBalance:sender requestMode:CAMERA_WHITE_BALANCE_DAYLIGHT imageName:@"aws_daylight"];
}
- (IBAction)onAWSFluorescent:(id)sender {
    [self setWhiteBalance:sender requestMode:CAMERA_WHITE_BALANCE_FLOURESC imageName:@"aws_fluorescent"];
}
- (IBAction)onAWSUnderWater:(id)sender {
    [self setWhiteBalance:sender requestMode:CAMERA_WHITE_BALANCE_UNDERWATER imageName:@"aws_underwater"];
}
- (IBAction)onAWSCloudy:(id)sender {
    [self setWhiteBalance:sender requestMode:CAMERA_WHITE_BALANCE_CLOUDY imageName:@"aws_cloudy"];
}

- (void) setWhiteBalance:(UIButton*)button requestMode:(NSString*)requestMode imageName:(NSString*)imageName{
    if ( self.currentAWSButton == button ) {
        [self.delegate hideAdvancedList];
    }
    else {
        [NabiCameraHttpCommands sendCameraCommand:requestMode
                                          success:^(id result) {
                                              [self.currentAWSButton setSelected:NO];
                                              self.currentAWSButton = button;
                                              [self.currentAWSButton setSelected:YES];
                                              [self.delegate hideAdvancedList];
                                              
                                              NSString *advancedType = [NSString stringWithFormat:@"%d", kAdvancedTypeAWS];
                                              NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:advancedType, kAdvancedType, imageName, kAdvancedImageName, nil];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kAdvancedSelected object:dict];
                                          }
                                          failure:^(NSError *error) {
                                          }];
    }
}

- (NSString *) setWhiteBalance:(NSString*)whiteBalance {
    if ( whiteBalance == nil || [whiteBalance isEqualToString:@""] )
        return nil;
    
    if ( self.currentAWSButton )
        [self.currentAWSButton setSelected:NO];
    
    NSString *imageName = nil;
    if ( [whiteBalance isEqualToString:@"AUTO"] ) {
        self.currentAWSButton = self.awsAutoButton;
        imageName = @"aws_auto";
    }
    else if ( [whiteBalance isEqualToString:@"DAYLIGHT"] ) {
        self.currentAWSButton = self.awsDayLightButton;
        imageName = @"aws_daylight";
    }
    else if ( [whiteBalance isEqualToString:@"CLOUDY"] ) {
        self.currentAWSButton = self.awsCloudyButton;
        imageName = @"aws_cloudy";
    }
    else if ( [whiteBalance isEqualToString:@"FLOURESC"] ) {
        self.currentAWSButton = self.awsFluorescentButton;
        imageName = @"aws_fluorescent";
    }
    else if ( [whiteBalance isEqualToString:@"UNDERWATER"] ) {
        self.currentAWSButton = self.awsUnderWaterButton;
        imageName = @"aws_underwater";
    }
    
    if ( self.currentAWSButton )
        [self.currentAWSButton setSelected:YES];
    
    return imageName;
}

@end
