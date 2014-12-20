//
//  CustomViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController () {
    BOOL isPortrait;
}

@end

@implementation CustomViewController

@synthesize mTitle;

@synthesize mNavBarViewController;
@synthesize mContentViewController;

- (instancetype) initWithViewController:(UIViewController*)viewController title:(NSString*)title hideNavBar:(BOOL) hideNavBar {
    self = [super init];
    if ( self ) {
        self.mContentViewController = viewController;
        mTitle = title;
        isHideNabBar = hideNavBar;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( mContentViewController ) {
        [self addChildViewController:mContentViewController];
        [self.view addSubview:mContentViewController.view];
    }
    
    if ( mNavBarViewController == nil ) {
        mNavBarViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavBarViewController"];
        [self addChildViewController:mNavBarViewController];
        [self.view addSubview:mNavBarViewController.view];
    }
    mNavBarViewController.titleLabel.text = mTitle;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if ( isHideNabBar ) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavBar)];
        [mContentViewController.view addGestureRecognizer:tapGesture];
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ( screenWidth > screenHeight )
        isPortrait = YES;
    else
        isPortrait = NO;
        
    [self deviceOrientationDidChange];
    double delayInSeconds = 2.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self showNavBar];
    });
}

- (void)dealloc {
    if ( isHideNabBar )
        [[NSNotificationCenter defaultCenter] removeObserver:UIDeviceOrientationDidChangeNotification];
}

#pragma mark - Screen Orientation
- (BOOL)shouldAutorotate {
    return YES;
}

- (void) deviceOrientationDidChange
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ( (screenWidth > screenHeight && isPortrait == YES) || (screenHeight > screenWidth && isPortrait == NO) ) {
        isPortrait = !isPortrait;
        CGRect navBarRect = [UIScreen mainScreen].bounds;
        if ( screenWidth < screenHeight ) {
            navBarRect.size.height = 64.0f;
        }
        else {
            navBarRect.size.height = 44.0f;
        }
        mNavBarViewController.view.frame = navBarRect;
        
        if ( mContentViewController ) {
            CGRect contentViewRect = [UIScreen mainScreen].bounds;
            if ( isHideNabBar ) {
                
            }
            else {
                contentViewRect.origin.y = navBarRect.size.height;
                contentViewRect.size.height = contentViewRect.size.height - navBarRect.size.height;
            }
            mContentViewController.view.frame = contentViewRect;
        }
    }
}

- (void) showNavBar {
    CGRect rect = mNavBarViewController.view.frame;
    if ( mNavBarViewController.view.isHidden ) {
        rect.origin.y = 0 - rect.size.height;
        mNavBarViewController.view.frame = rect;
        [mNavBarViewController.view setHidden:NO];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                             CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                             CGRect navBarRect = [UIScreen mainScreen].bounds;
                             if ( screenWidth < screenHeight ) {
                                 navBarRect.size.height = 64.0f;
                             }
                             else {
                                 navBarRect.size.height = 44.0f;
                             }
                             navBarRect.origin.y = 0;
                             mNavBarViewController.view.frame = navBarRect;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else {
        rect.origin.y = 0;
        mNavBarViewController.view.frame = rect;
        [mNavBarViewController.view setHidden:NO];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                             CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                             CGRect navBarRect = [UIScreen mainScreen].bounds;
                             if ( screenWidth < screenHeight ) {
                                 navBarRect.size.height = 64.0f;
                             }
                             else {
                                 navBarRect.size.height = 44.0f;
                             }
                             navBarRect.origin.y = 0 - navBarRect.size.height;
                             mNavBarViewController.view.frame = navBarRect;
                         }
                         completion:^(BOOL finished) {
                             [mNavBarViewController.view setHidden:YES];
                         }];
    }
}

@end
