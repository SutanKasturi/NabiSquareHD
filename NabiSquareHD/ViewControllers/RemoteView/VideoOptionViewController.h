//
//  VideoOptionViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kVideoOptionEasy,
    kVideoOptionAdvanced
}VideoOption;

@protocol VideoOptionDelegate <NSObject>

- (void) showVideoOptionView:(int)videooption;

@end

@interface VideoOptionViewController : UIViewController

@property (weak, nonatomic) id<VideoOptionDelegate> delegate;

@property (nonatomic, assign) int currentVideoOption;

@property (weak, nonatomic) IBOutlet UIButton *easyButton;
@property (weak, nonatomic) IBOutlet UIButton *advancedButton;

@end
