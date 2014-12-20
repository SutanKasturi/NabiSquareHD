//
//  ImageOptionViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "AdvancedOptionViewController.h"

@interface ImageOptionViewController : UIViewController

@property (nonatomic, weak) id<AdvancedOptionTypeDelegate> delegate;

@property (nonatomic, strong) UIButton *currentImageMPButton;

@property (weak, nonatomic) IBOutlet CustomButton *image6MP_4_3Button;
@property (weak, nonatomic) IBOutlet CustomButton *image6MP_16_9Button;
@property (weak, nonatomic) IBOutlet CustomButton *image8MP_4_3Button;

- (NSString*) setImageResolution:(NSString*)imageResolution;

@end
