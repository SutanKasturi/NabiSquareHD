//
//  ImageOptionViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "ImageOptionViewController.h"
#import "NabiCameraHttpCommands.h"

@implementation ImageOptionViewController

- (IBAction)onImage6MP_4_3:(id)sender {
    [self setImageResolution:sender requestMode:CAMERA_IMAGE_RESOLUTION_6MP imageName:@"image_6MP_4x3"];
}
- (IBAction)onImage6MP_16_9:(id)sender {
    [self setImageResolution:sender requestMode:CAMERA_IMAGE_RESOLUTION_6MPW imageName:@"image_6MP_16x9"];
}
- (IBAction)onImage8MP_4_3:(id)sender {
    [self setImageResolution:sender requestMode:CAMERA_IMAGE_RESOLUTION_8MP imageName:@"image_8MP_4x3"];
}

- (void) setImageResolution:(UIButton*)button requestMode:(NSString*)requestMode imageName:(NSString*)imageName{
    if ( self.currentImageMPButton == button ) {
        [self.delegate hideAdvancedList];
    }
    else {
        [NabiCameraHttpCommands sendCameraCommand:requestMode
                                          success:^(id result) {
                                              [self.currentImageMPButton setSelected:NO];
                                              self.currentImageMPButton = button;
                                              [self.currentImageMPButton setSelected:YES];
                                              [self.delegate hideAdvancedList];

                                              NSString *advancedType = [NSString stringWithFormat:@"%d", kAdvancedTypeImage];
                                              NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:advancedType, kAdvancedType, imageName, kAdvancedImageName, nil];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kAdvancedSelected object:dict];
                                          }
                                          failure:^(NSError *error) {
                                          }];
    }
}

- (NSString*) setImageResolution:(NSString*)imageResolution {
    if ( imageResolution == nil || [imageResolution isEqualToString:@""] )
        return nil;
    
    if ( self.currentImageMPButton )
        [self.currentImageMPButton setSelected:NO];
    
    NSString *imageName = nil;
    if ( [imageResolution isEqualToString:@"6MP"] ) {
        self.currentImageMPButton = self.image6MP_4_3Button;
        imageName = @"image_6MP_4x3";
    }
    else if ( [imageResolution isEqualToString:@"6MPW"] ) {
        self.currentImageMPButton = self.image6MP_16_9Button;
        imageName = @"image_6MP_16x9";
    }
    else if ( [imageResolution isEqualToString:@"8MP"] ) {
        self.currentImageMPButton = self.image8MP_4_3Button;
        imageName = @"image_8MP_4x3";
    }
    
    if ( self.currentImageMPButton )
        [self.currentImageMPButton setSelected:YES];
    return imageName;
}

@end
