//
//  CustomViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarViewController.h"

@interface CustomViewController : UIViewController {
    NSString *mTitle;
    BOOL isHideNabBar;
}

@property (nonatomic, strong) NSString *mTitle;
@property (nonatomic, strong) NavBarViewController *mNavBarViewController;
@property (nonatomic, strong) UIViewController *mContentViewController;

- (instancetype) initWithViewController:(UIViewController*)viewController title:(NSString*)title hideNavBar:(BOOL) hideNavBar;

@end
