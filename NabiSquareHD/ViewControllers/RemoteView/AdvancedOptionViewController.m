//
//  AdvancedOptionViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "AdvancedOptionViewController.h"
#import "CameraModeViewController.h"

@implementation AdvancedOptionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAdvancedType:) name:kAdvancedSelected object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:kAdvancedSelected];
}

- (IBAction)onResFPS:(id)sender {
    [self.delegate showAdvancedList:kAdvancedTypeResFPS];
}
- (IBAction)onAWS:(id)sender {
    [self.delegate showAdvancedList:kAdvancedTypeAWS];
}
- (IBAction)onImageMP:(id)sender {
    [self.delegate showAdvancedList:kAdvancedTypeImage];
}
- (IBAction)onTimelapse:(id)sender {
    [self.delegate showAdvancedList:kAdvancedTypeTimelapse];
}
- (IBAction)onBurst:(id)sender {
    [self.delegate showAdvancedList:kAdvancedTypeBurst];
}

- (void) showButtons:(int)cameramode {
    if ( cameramode == kCameraModeVideo ) {
        [self.resFPSButton setHidden:NO];
        [self.imageMPButton setHidden:YES];
    }
    else {
        [self.resFPSButton setHidden:YES];
        [self.imageMPButton setHidden:NO];
    }
    
    if ( cameramode == kCameraModeBurst ) {
        [self.timelapseButton setHidden:YES];
        [self.burstButton setHidden:NO];
    }
    else if ( cameramode == kCameraModeVideoTimer ) {
        [self.timelapseButton setHidden:NO];
        [self.burstButton setHidden:YES];
    }
    else {
        [self.timelapseButton setHidden:YES];
        [self.burstButton setHidden:YES];
    }
    
    [self.awsButton setHidden:NO];
}

- (void) setAdvancedType:(NSNotification*)note {
    NSDictionary *dict = note.object;
    int advancedType = [[dict objectForKey:kAdvancedType] intValue];
    NSString *imageName = [dict objectForKey:kAdvancedImageName];
    [self selectedAdvancedType:advancedType imageName:imageName];
}
- (void) selectedAdvancedType:(int)advancedtype imageName:(NSString*)imageName {
    UIButton *selectedButton;
    switch (advancedtype) {
        case kAdvancedTypeResFPS:
            selectedButton = self.resFPSButton;
            break;
        case kAdvancedTypeImage:
            selectedButton = self.imageMPButton;
            break;
        case kAdvancedTypeBurst:
            selectedButton = self.burstButton;
            break;
        case kAdvancedTypeAWS:
            selectedButton = self.awsButton;
            break;
        case kAdvancedTypeTimelapse:
            selectedButton = self.timelapseButton;
            
        default:
            break;
    }
    
    if ( selectedButton ) {
        [selectedButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
}

- (void) setAdvancedOptionResFPS:(NSString*)imageName {
    [self.resFPSButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void) setAdvancedOptionImageMP:(NSString*)imageName {
    [self.imageMPButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void) setAdvancedOptionTimelapse:(NSString*)imageName {
    [self.timelapseButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void) setAdvancedOptionBurst:(NSString*)imageName {
    [self.burstButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void) setAdvancedOptionAWS:(NSString*)imageName {
    [self.awsButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
