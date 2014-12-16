//
//  MainViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MainViewController.h"
#import "CustomViewController.h"
#import "GlobalConstants.h"
#import "FFMPEGWrapper.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "NabiCameraHttpCommands.h"
#import "RemoteViewController.h"

#define SPACE 8.0f

@interface MainViewController ()<FFMPEGWrapperDelegate> {
    NSString *mWifiConfigSSID;
    NSString *mWifiConfigEncryptionKey;
    BOOL isPortrait;
}

@property Reachability *localWiFiReach;
@end

@implementation MainViewController

static int _scanAttempt = 0;
static BOOL _firstCreate = YES;
static BOOL _remoteStarted = NO;
static BOOL _warningShownAlready = NO;

- (void) fadeControlIn:(UIView *)view speed:(int) speed {
    view.alpha = 0;
    [UIView animateWithDuration:speed animations:^{
        view.alpha = 1;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self.mainScreenMessage setHidden:YES];
    [self.mainActivityIndicator stopAnimating];
    
    self.localWiFiReach = [Reachability reachabilityForLocalWiFi];
    self.localWiFiReach.reachableOnWWAN = NO;
    [self showWiFi:self.localWiFiReach];
    self.buttonConnect.translatesAutoresizingMaskIntoConstraints = YES;
    self.mainActivityIndicator.translatesAutoresizingMaskIntoConstraints = YES;
    self.mainScreenMessage.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)viewDidAppear:(BOOL)animated {
//    [self setScreenMessage];
    // WiFiReceiver
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
//    [self startScan];
    
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    mWifiConfigSSID = [sharedInstance objectForKey:PREFS_SSID];
    mWifiConfigEncryptionKey = [sharedInstance objectForKey:PREFS_ENCRYPTION_KEY];
    
    if ( mWifiConfigSSID == nil || [mWifiConfigSSID isEqualToString:@""] ) {
        mWifiConfigSSID = DEFAULT_SSID;
    }
    
    if ( mWifiConfigEncryptionKey == nil || [mWifiConfigEncryptionKey isEqualToString:@""] ) {
        mWifiConfigEncryptionKey = DEFAULT_PRESHAREDKEY;
    }
    [self showMessage:@"Turning on WiFi..."];
    
    [self startScan];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:kReachabilityChangedNotification];
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
        [self setScreenMessage];
    }
}

#pragma mark - Button Actions
- (IBAction)onStartScan:(id)sender {
    _firstCreate = YES;
    [self startScan];
}

- (IBAction)onChangeWiFi:(id)sender {
    CustomViewController *changeWiFiViewController = [[CustomViewController alloc] initWithViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ConnectToViewController"] title:@"Connect To" hideNavBar:NO];
    changeWiFiViewController.view.frame = [UIScreen mainScreen].bounds;
    [self.navigationController pushViewController:changeWiFiViewController animated:YES];
}

#pragma mark - ScreenMessageView

- (void) setScreenMessage {
    
    // Set buttonConnect's rect
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat buttonPadding = 64.0f;
    CGFloat buttonSize = 0;
    
    if ( screenWidth > screenHeight ) {
        buttonSize = screenHeight;
        buttonSize = buttonSize - 2 * buttonPadding;
    }
    else {
        buttonSize = screenWidth;
        buttonSize = buttonSize - 2 * buttonPadding;
    }
    
    // Set mainScreenMessage's rect
    CGFloat maxMessageWidth = screenWidth;
    CGFloat indicatorActivityWidth = 37.0f;
    CGFloat paddingWidth = 30;
    if ( screenWidth > screenHeight ) {
        paddingWidth = 64;
    }
    maxMessageWidth = maxMessageWidth - 2 * paddingWidth;
    if ( ![self.mainActivityIndicator isHidden] ) {
        maxMessageWidth = maxMessageWidth - indicatorActivityWidth - SPACE;
    }
    
    CGSize constrainedSize = CGSizeMake(maxMessageWidth, 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self.mainScreenMessage font], NSFontAttributeName, nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.mainScreenMessage.text attributes:attributesDictionary];
    CGRect messageRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    if ( messageRect.size.width > maxMessageWidth ) {
        messageRect.size.width = maxMessageWidth;
    }
    
    messageRect.origin.x = paddingWidth + (maxMessageWidth - messageRect.size.width) / 2;

    if ( messageRect.size.height + buttonSize + SPACE > screenHeight - buttonPadding ) {
        buttonSize = screenHeight - messageRect.size.height - paddingWidth - SPACE;
    }
    messageRect.origin.y = (screenHeight - messageRect.size.height - SPACE - buttonSize) / 2;
    self.mainScreenMessage.frame = messageRect;
    self.buttonConnect.frame = CGRectMake((screenWidth - buttonSize)/2, messageRect.origin.y + messageRect.size.height + SPACE, buttonSize, buttonSize);
    
    // Set indicator's rect;
    CGRect indicatiorRect = self.mainActivityIndicator.bounds;
    indicatiorRect.origin.x = messageRect.origin.x + messageRect.size.width + SPACE;
    indicatiorRect.origin.y = messageRect.origin.y + (messageRect.size.height - indicatiorRect.size.height) / 2;
    self.mainActivityIndicator.frame = indicatiorRect;
}

#pragma mark - WiFiConnect

/*
 * fetch Wifi information
 */
- (NSString *)fetchSSIDInfo
{
    NSString *currentSSID = nil;
    
    NSArray *supportedInterfaces = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *interfaceName in supportedInterfaces) {
        info = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        if (info && [info count]) {
            break;
        }
        info = nil;
    }
    if (info) {
        currentSSID = [[NSString alloc]
                       initWithString:(NSString *)info[(id)kCNNetworkInfoKeySSID]];
    }
    
    return currentSSID;
}

- (BOOL) isCameraWiFi {
    NSString *SSID = [self fetchSSIDInfo];
    if ( SSID && [SSID isEqualToString:mWifiConfigSSID] ) {
        return YES;
    }
    
    return NO;
}

- (void) showMessage:(NSString *)text {
    if ( ![self.mainScreenMessage.text isEqualToString:text] ) {
        self.mainScreenMessage.text = text;
        [self setScreenMessage];
        [self.mainScreenMessage setHidden:NO];
    }
}
- (void) startScan {
    [self.buttonWifiConnectTo setHidden:YES];
    [self.mainActivityIndicator setHidden:NO];
    [self.mainActivityIndicator startAnimating];
    
    [self showMessage:@"Searching for camera's Wi-Fi"];
    
    [self.buttonConnect setEnabled:NO];
//    [self.localWiFiReach stopNotifier];
    
    if ( [self isWiFiConnectedToCamera] == NO ) {
//        [self.localWiFiReach startNotifier];
        [self showWiFi:self.localWiFiReach];
    }
}

#pragma mark - Camera Command

- (BOOL) isWiFiConnectedToCamera {
    _firstCreate = NO;
    if ( [self isCameraWiFi] ) {
        [NabiCameraHttpCommands sendCameraCommand:CAMERA_ALL_SETTINGS
                                          success:^(id result) {
                                              [self finishedSendCameraCommand:result];
                                          }
                                          failure:^(NSError *error) {
                                              [self finishedSendCameraCommand:nil];
                                          }];
        return YES;
    }
    
    return NO;
}

- (void)finishedSendCameraCommand:(NSString *)result {
    if ( result == nil || [result isEqualToString:@""]) {
        [self.buttonWifiConnectTo setHidden:NO];
        [self.mainActivityIndicator setHidden:YES];
        [self.buttonConnect setEnabled:YES];
        [self showMessage:@"Your camera could not be found. \nPlease check your camera's Wi-Fi is on.\n"];
        _remoteStarted = NO;
    }
    else {
        [self showMessage:@"Connection successful! Starting remote view"];
        NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
        NSString *cameraFirmwareVersion = [NabiCameraHttpCommands parseCameraSettings:result settingToFind:@"Camera.Menu.FWversion"];
        [sharedInstance setObject:cameraFirmwareVersion forKey:PREFS_FWVERSION];
        
        if ( [mWifiConfigSSID isEqualToString:DEFAULT_SSID] ) {
            CustomViewController *changeWiFiViewController = [[CustomViewController alloc] initWithViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ConnectToViewController"] title:@"Connect To" hideNavBar:NO];
            changeWiFiViewController.view.frame = [UIScreen mainScreen].bounds;
            [self.navigationController pushViewController:changeWiFiViewController animated:YES];
        }
        else {
            [self showRemote];
        }
    }
}

- (void) showRemote {
//    [self.localWiFiReach stopNotifier];
    double delayInSeconds = 2.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        CustomViewController *remoteViewController = [[CustomViewController alloc] initWithViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RemoteViewController"] title:@"Connect To" hideNavBar:YES];
        remoteViewController.view.frame = [UIScreen mainScreen].bounds;
        [self.navigationController pushViewController:remoteViewController animated:YES];

    });
}

#pragma mark - Reachability

- (void) reachabilityChanged:(NSNotification*)note {
    Reachability *reach = [note object];
    [self showWiFi:reach];
}

- (void) showWiFi:(Reachability *)reach {
    if ( reach == self.localWiFiReach ) {
        if ( [reach isReachable] ) {
            if ( [self isWiFiConnectedToCamera] ) {
            }
            else {
                [self.localWiFiReach stopNotifier];
                [self.buttonConnect setEnabled:YES];
                [self.mainActivityIndicator setHidden:YES];
                [self.buttonWifiConnectTo setHidden:NO];
                [self showMessage:@"Your camera could not be found. \nPlease turn on your camera's Wi-Fi and press below to connect again."];
            }
        }
        else {
            [self showMessage:@"Your wifi have been turned off. \nPlease turn on your camera's Wi-Fi."];
        }
    }
}

#pragma mark - FFMPEGWrapperDelegate

- (void)shellDone {
    NSDate *curDateTime = [NSDate new];
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[NSDate alloc] initWithTimeIntervalSince1970:[curDateTime timeIntervalSince1970] + 1];
    localNotification.alertBody = @"Hellow world";
    localNotification.alertAction = @"My notification";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)shellOut:(NSString *)msg {
    NSLog(@"FFMPEG%@", msg);
}

@end
