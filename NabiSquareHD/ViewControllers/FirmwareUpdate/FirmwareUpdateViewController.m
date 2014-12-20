//
//  FirmwareUpdateViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/16/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "FirmwareUpdateViewController.h"
#import "OverlayViewController.h"
#import "NabiCameraHttpCommands.h"

@interface FirmwareUpdateViewController () {
    BOOL makingHttpCall;
    BOOL firmwareDownloadComplete;
    BOOL connectionSuccess;
}

@property (nonatomic, assign) BOOL requireFullBattery;
@property (nonatomic, strong) NSString *latestVersionUrl;
@property Reachability *mReach;

@end

@implementation FirmwareUpdateViewController

@synthesize requireFullBattery;
@synthesize latestVersionUrl;
@synthesize firmwareDownloadProgressBar;
@synthesize mReach;
@synthesize firmwareStatusActivity;
@synthesize firmwareStatusLabel;

- (void)viewDidLoad {
    requireFullBattery = NO;
    makingHttpCall = NO;
    firmwareDownloadComplete = NO;
    connectionSuccess = NO;
    
    [firmwareDownloadProgressBar setHidden:YES];
    [firmwareStatusActivity setHidden:YES];
    
    mReach = [Reachability reachabilityForInternetConnection];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NabiCameraHttpCommands sendCameraCommand:CAMERA_ALL_SETTINGS
                                      success:^(id result) {
                                          int batteryLevel = [[NabiCameraHttpCommands parseCameraSettings:result settingToFind:@"Camera.Battery.Level"] intValue];
                                          if ( batteryLevel != 100 && requireFullBattery ) {
                                              firmwareStatusLabel.text = @"Please use a fully charged battery before continuing.";
                                          }
                                          else {
                                              [self beginFirmwareCheck];
                                          }
                                      }
                                      failure:^(NSError *error) {
                                          
                                      }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:kReachabilityChangedNotification];
}

- (void) beginFirmwareCheck {
    if ( makingHttpCall || firmwareDownloadComplete || connectionSuccess )
        return;
    
    NSLog(@"beginFirmwareCheck");
    
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    NSString *cameraFirmwareVersion = [sharedInstance objectForKey:PREFS_FWVERSION];
    if ( cameraFirmwareVersion == nil )
        cameraFirmwareVersion = @"";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = FIRMWARE_UPDATE_URL_;
    NSLog(@"Firmware Update : %@", url);
    [manager.requestSerializer setValue:@"8142f0c0-600f-11e2-bcfd-0800200c9a66" forHTTPHeaderField:@"APIKey"];
    [manager.requestSerializer setTimeoutInterval:60.0f];
    makingHttpCall = YES;
    
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Success sendCameraCommand request : \n%@\n", responseObject);
             connectionSuccess = YES;
             makingHttpCall = NO;
             
             NSError *error;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
             if ( error ) {
                 NSLog(@"Error : %@", error.localizedDescription);
             }
             else {
                 NSString *latestVersion = [json objectForKey:@"itemLatestVersion"];
                 latestVersionUrl = [json objectForKey:@"itemURL"];
                 
                 [self firmwareDownload];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Uh oh. An error occurred in sendCameraCommand: \n%@\n", error.localizedDescription);
             if ( !connectionSuccess ) {
                 makingHttpCall = NO;
                 firmwareStatusLabel.text = @"Attempting to connect to the internet...";
                 [mReach startNotifier];
             }
         }];
}

- (void) firmwareDownload {
    if ( latestVersionUrl == nil || [latestVersionUrl isEqualToString:@""] ) {
        NSLog(@"There is no lastestVersionUrl");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:latestVersionUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"SD_CarDV.bin"];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"bytesRead: %u, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
        [firmwareDownloadProgressBar setProgress:(bytesRead / totalBytesRead) animated:YES];
    }];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        
        if ( error ) {
            NSLog(@"Firmware Downloading ERR: %@", error.description);
        }
        else {
            NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
            long long filesize = [fileSizeNumber longLongValue];
            NSLog(@"Filesize : %llu", filesize);
        }
        firmwareStatusLabel.text = @"Download Complete.";
        firmwareDownloadComplete = YES;
        [self startScan];
        firmwareStatusLabel.text = @"Connecting to camera..";
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Firmware Downloading ERR: %@", error.description);
    }];
    
    [operation start];
    firmwareStatusLabel.text = @"Starting firmware download...";
    [firmwareDownloadProgressBar setProgress:0 animated:NO];
    [firmwareDownloadProgressBar setHidden:NO];
}

- (void) beginFirmwareUpdate {
    [NabiCameraHttpCommands sendCameraCommand:CAMERA_FIRMWARE_PREPARE_UPDATE
                                      success:^(id result) {
                                          NSLog(@"CAMERA FIRMWARE PREPARE");
                                          NSLog(@"%@", result);
                                          
                                          NSURL *url = [NSURL URLWithString:@"http://192.72.1.1/cgi-bin/FWupload.cgi"];
                                          NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                          
                                          AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                                          
                                          NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"SD_CarDV.bin"];
                                          
                                          [operation setInputStream:[NSInputStream inputStreamWithFileAtPath:fullPath]];
                                          
                                          [operation setUploadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                                              NSLog(@"bytesRead: %u, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
                                              [firmwareDownloadProgressBar setProgress:(bytesRead / totalBytesRead) animated:YES];
                                          }];
                                          
                                          [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
                                              
//                                              NSError *error;
//                                              NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
//                                              
//                                              if ( error ) {
//                                                  NSLog(@"Firmware Downloading ERR: %@", error.description);
//                                              }
//                                              else {
//                                                  NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
//                                                  long long filesize = [fileSizeNumber longLongValue];
//                                                  
//                                              }
//                                              firmwareStatusLabel.text = @"Download Complete.";
//                                              firmwareDownloadComplete = YES;
//                                              [self startScan];
//                                              firmwareStatusLabel.text = @"Connecting to camera..";
                                          }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               NSLog(@"Firmware Uploadin ERR: %@", error.description);
                                           }];
                                          
                                          [operation start];
                                          firmwareStatusLabel.text = @"Starting firmware upload...";
                                          [firmwareDownloadProgressBar setProgress:0 animated:NO];
                                          [firmwareDownloadProgressBar setHidden:NO];
                                          
                                      }
                                      failure:^(NSError *error) {
                                          
                                      }];
}

#pragma mark - Reachability

- (void) reachabilityChanged:(NSNotification*)note {
    [self startScan];
}

- (void) startScan {
    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    NSString *wifiConfigSSID = [sharedInstance objectForKey:PREFS_SSID];
    [wifiConfigSSID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    if ( [mReach isReachableViaWiFi] ) {
        if ( firmwareDownloadComplete ) {
            firmwareStatusLabel.text = @"Connect to camera.";
            [self beginFirmwareUpdate];
        }
        else {
            NSLog(@"Network state changed");
            [self beginFirmwareCheck];
        }
    }
    else {
        [mReach startNotifier];
    }
}

@end
