//
//  ConnectToViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ConnectToViewController.h"

@implementation ConnectToViewController

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
