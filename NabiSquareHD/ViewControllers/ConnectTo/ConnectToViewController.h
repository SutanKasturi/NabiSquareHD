//
//  ConnectToViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextField.h"

@interface ConnectToViewController : UIViewController

@property (weak, nonatomic) IBOutlet DemoTextField *wifiNameTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *wifiPasswordTextField;

@end
