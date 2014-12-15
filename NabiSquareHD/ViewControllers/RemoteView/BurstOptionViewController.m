//
//  BurstOptionViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "BurstOptionViewController.h"
#import "NabiCameraHttpCommands.h"

@implementation BurstOptionViewController

- (IBAction)onBurst_3_1:(id)sender {
    [self setBurstRate:sender requestMode:CAMERA_BURST_RATE_3X1 imageName:@"burst_3_1"];
}
- (IBAction)onBurst_5_1:(id)sender {
    [self setBurstRate:sender requestMode:CAMERA_BURST_RATE_5X1 imageName:@"burst_5_1"];
}
- (IBAction)onBurst_10_1:(id)sender {
    [self setBurstRate:sender requestMode:CAMERA_BURST_RATE_10X1 imageName:@"burst_10_1"];
}

- (void) setBurstRate:(UIButton*)button requestMode:(NSString*)requestMode imageName:(NSString*)imageName{
    if ( self.currentBurstButton == button ) {
        [self.delegate hideAdvancedList];
    }
    else {
        [NabiCameraHttpCommands sendCameraCommand:requestMode
                                          success:^(id result) {
                                              [self.currentBurstButton setSelected:NO];
                                              self.currentBurstButton = button;
                                              [self.currentBurstButton setSelected:YES];
                                              [self.delegate hideAdvancedList];

                                              NSString *advancedType = [NSString stringWithFormat:@"%d", kAdvancedTypeBurst];
                                              NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:advancedType, kAdvancedType, imageName, kAdvancedImageName, nil];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kAdvancedSelected object:dict];
                                          }
                                          failure:^(NSError *error) {
                                          }];
    }
}

- (NSString*) setBurstRate:(NSString*) burstRate {
    if ( burstRate == nil || [burstRate isEqualToString:@""] )
        return nil;
    
    if ( self.currentBurstButton )
        [self.currentBurstButton setSelected:NO];
    
    NSString *imageName = nil;
    if ( [burstRate isEqualToString:@"3_1SEC"] ) {
        self.currentBurstButton = self.burst_3_1Button;
        imageName = @"burst_3_1";
    }
    else if ( [burstRate isEqualToString:@"5_1SEC"] ) {
        self.currentBurstButton = self.burst_5_1Button;
        imageName = @"burst_5_1";
    }
    else if ( [burstRate isEqualToString:@"10_1SEC"] ) {
        self.currentBurstButton = self.burst_10_1Button;
        imageName = @"burst_10_1";
    }
    
    if ( self.currentBurstButton )
        [self.currentBurstButton setSelected:YES];
    
    return imageName;
}

@end
