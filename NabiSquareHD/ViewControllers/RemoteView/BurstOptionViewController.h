//
//  BurstOptionViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "AdvancedOptionViewController.h"

@interface BurstOptionViewController : UIViewController

@property (nonatomic, weak) id<AdvancedOptionTypeDelegate> delegate;

@property (nonatomic, strong) UIButton *currentBurstButton;

@property (weak, nonatomic) IBOutlet CustomButton *burst_3_1Button;
@property (weak, nonatomic) IBOutlet CustomButton *burst_5_1Button;
@property (weak, nonatomic) IBOutlet CustomButton *burst_10_1Button;

- (NSString*) setBurstRate:(NSString*) burstRate;

@end
