//
//  ChangeWiFiViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ChangeWiFiViewController.h"
#import "GlobalConstants.h"

@implementation ChangeWiFiViewController

- (IBAction)onUpdate:(id)sender {
    BOOL isValid = YES;
    if ( ![self.wifiNameTextField validate] || [self.wifiNameTextField.text isEqualToString:DEFAULT_SSID] ) {
        isValid = NO;
        [self.wifiNameTextField setInvalidateState];
    }
    
    if ( ![self.wifiPasswordTextField validate] || [self.wifiPasswordTextField.text isEqualToString:DEFAULT_PRESHAREDKEY] ) {
        isValid = NO;
        [self.wifiPasswordTextField setInvalidateState];
    }
    
    if ( isValid == NO )
        return;
    
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    [sharedInstance setObject:self.wifiNameTextField.text forKey:PREFS_SSID];
    [sharedInstance setObject:self.wifiPasswordTextField.text forKey:PREFS_ENCRYPTION_KEY];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
