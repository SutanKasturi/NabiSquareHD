//
//  FirmwareUpdateViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/16/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirmwareUpdateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIProgressView *firmwareDownloadProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *firmwareStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *firmwareStatusActivity;
@end
