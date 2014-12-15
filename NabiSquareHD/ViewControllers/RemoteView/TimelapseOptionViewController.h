//
//  TimelapseOptionViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "AdvancedOptionViewController.h"

@interface TimelapseOptionViewController : UIViewController

@property (nonatomic, weak) id<AdvancedOptionTypeDelegate> delegate;

@property (nonatomic, strong) UIButton *currentTimelapseButton;

@property (weak, nonatomic) IBOutlet CustomButton *timelapse3SecButton;
@property (weak, nonatomic) IBOutlet CustomButton *timelaspe5SecButton;
@property (weak, nonatomic) IBOutlet CustomButton *timelapse10SecButton;
@property (weak, nonatomic) IBOutlet CustomButton *timelapse30SecButton;
@property (weak, nonatomic) IBOutlet CustomButton *timelapse60SecButton;

- (NSString *) setTimelapseRate:(NSString*)timelapseRate;

@end
