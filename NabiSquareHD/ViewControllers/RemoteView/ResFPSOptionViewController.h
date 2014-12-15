//
//  ResFPSViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "AdvancedOptionViewController.h"

@interface ResFPSOptionViewController : UIViewController

@property (nonatomic, weak) id<AdvancedOptionTypeDelegate> delegate;

@property (nonatomic, strong) UIButton *currentResFPSButton;

@property (weak, nonatomic) IBOutlet CustomButton *resFPS4KButton;
@property (weak, nonatomic) IBOutlet CustomButton *resFPS27KButton;
@property (weak, nonatomic) IBOutlet CustomButton *resFPS720_100Button;
@property (weak, nonatomic) IBOutlet CustomButton *resFPS720_120Button;
@property (weak, nonatomic) IBOutlet CustomButton *resFPS1080_50Button;
@property (weak, nonatomic) IBOutlet CustomButton *resFPS1080_60Button;

- (NSString*) setVideoResolution:(NSString*)videoRes;

@end
