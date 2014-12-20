//
//  AdvancedOptionViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kAdvancedTypeResFPS,
    kAdvancedTypeImage,
    kAdvancedTypeTimelapse,
    kAdvancedTypeBurst,
    kAdvancedTypeAWS
}AdvancedType;

@protocol AdvancedOptionTypeDelegate <NSObject>

- (void) showAdvancedList:(int)advancedtype;
- (void) hideAdvancedList;

@end

@interface AdvancedOptionViewController : UIViewController

@property (weak, nonatomic) id<AdvancedOptionTypeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *resFPSButton;
@property (weak, nonatomic) IBOutlet UIButton *imageMPButton;
@property (weak, nonatomic) IBOutlet UIButton *timelapseButton;
@property (weak, nonatomic) IBOutlet UIButton *burstButton;
@property (weak, nonatomic) IBOutlet UIButton *awsButton;

- (void) showButtons:(int)cameramode;

- (void) setAdvancedOptionResFPS:(NSString*)imageName;
- (void) setAdvancedOptionImageMP:(NSString*)imageName;
- (void) setAdvancedOptionTimelapse:(NSString*)imageName;
- (void) setAdvancedOptionBurst:(NSString*)imageName;
- (void) setAdvancedOptionAWS:(NSString*)imageName;

@end
