//
//  ChangeWiFiViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ChangeWiFiViewController.h"
#import "GlobalConstants.h"
#import "OverlayViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NabiCameraHttpCommands.h"

@interface ChangeWiFiViewController ()


@end

@implementation ChangeWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    NSString *mWifiConfigSSID = [sharedInstance objectForKey:PREFS_SSID];
    NSString *mWifiConfigEncryptionKey = [sharedInstance objectForKey:PREFS_ENCRYPTION_KEY];
    
    if ( mWifiConfigSSID == nil || [mWifiConfigSSID isEqualToString:@""] ) {
        mWifiConfigSSID = DEFAULT_SSID;
    }
    
    if ( mWifiConfigEncryptionKey == nil || [mWifiConfigEncryptionKey isEqualToString:@""] ) {
        mWifiConfigEncryptionKey = DEFAULT_PRESHAREDKEY;
    }
    
    self.wifiNameTextField.text = mWifiConfigSSID;
    self.wifiPasswordTextField.text = mWifiConfigEncryptionKey;
}

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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Changing Wi-Fi";
    [NabiCameraHttpCommands ChangeWiFiSettings:self.wifiNameTextField.text
                                  wifiPassword:self.wifiPasswordTextField.text
                                       success:^(id result) {
                                           double delayInSeconds = 10.0f;
                                           dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                           dispatch_after(popTime, dispatch_get_main_queue(), ^{
                                               [NabiCameraHttpCommands sendCameraCommand:CAMERA_WIFI_RESET
                                                                                 success:^(id result) {
                                                                                     [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
                                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                                 }
                                                                                 failure:^(NSError *error) {
                                                                                     [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
                                                                                     [self showMessage:@"Unfortunately, Wi-Fi change has failed"];
                                                                                 }];
                                           });
                                       }
                                       failure:^(NSError *error) {
                                           [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
                                           [self showMessage:@"Unfortunately, Wi-Fi change has failed"];
                                       }];
}
- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showMessage:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
