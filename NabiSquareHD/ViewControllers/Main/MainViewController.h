//
//  MainViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NabiCameraHttpCommands.h"

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *mainScreenMessage;
@property (weak, nonatomic) IBOutlet UIButton *buttonWifiConnectTo;
@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainActivityIndicator;

@end
