//
//  ChangeWiFiViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextField.h"

@interface ChangeWiFiViewController : UIViewController

@property (weak, nonatomic) IBOutlet DemoTextField *wifiNameTextField;
@property (weak, nonatomic) IBOutlet DemoTextField *wifiPasswordTextField;

@end
