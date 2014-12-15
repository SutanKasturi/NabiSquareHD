//
//  AWSOptionViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "AdvancedOptionViewController.h"

@interface AWSOptionViewController : UIViewController

@property (nonatomic, weak) id<AdvancedOptionTypeDelegate> delegate;

@property (nonatomic, strong) UIButton *currentAWSButton;

@property (weak, nonatomic) IBOutlet CustomButton *awsAutoButton;
@property (weak, nonatomic) IBOutlet CustomButton *awsDayLightButton;
@property (weak, nonatomic) IBOutlet CustomButton *awsFluorescentButton;
@property (weak, nonatomic) IBOutlet CustomButton *awsUnderWaterButton;
@property (weak, nonatomic) IBOutlet CustomButton *awsCloudyButton;

- (NSString *) setWhiteBalance:(NSString*)whiteBalance;

@end
