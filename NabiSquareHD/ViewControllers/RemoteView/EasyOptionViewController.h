//
//  EasyOptionViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kEasyOptionTypeLandscape,
    kEasyOptionTypeSports,
    kEasyOptionTypeLongRect
}EasyOptionType;

@protocol EasyOptionDelegate <NSObject>

- (void) setEasyOptionType:(int)easytype;

@end

@interface EasyOptionViewController : UIViewController

@property (weak, nonatomic) id<EasyOptionDelegate> delegate;

@property (nonatomic, assign) int currentEasyOptionType;

@property (weak, nonatomic) IBOutlet UIButton *ezLandscapeButton;
@property (weak, nonatomic) IBOutlet UIButton *ezSportsButton;
@property (weak, nonatomic) IBOutlet UIButton *ezLongRecButton;

@end
