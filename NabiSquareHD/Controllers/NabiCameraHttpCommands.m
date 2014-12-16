//
//  NabiCameraHttpCommands.m
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "NabiCameraHttpCommands.h"
#import "MainViewController.h"


@implementation NabiCameraHttpCommands

+ (NSString*) parseCameraSettings:(NSString*)settingsResponse settingToFind:(NSString*)settingToFind {
    NSRange range1 = [settingsResponse rangeOfString:settingToFind];
    NSString *start = [settingsResponse substringFromIndex:range1.location + range1.length + 1];
    NSRange range2 = [start rangeOfString:@"\n"];
    return [start substringToIndex:range2.location - 1];
}

+ (void)sendCameraCommand:(NSString*)requestUri
                  success:(void (^)(id result))success
                  failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@", CAMERA_HTTP_HOST, requestUri];
    NSLog(@"Camera Command : %@", url);
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Success sendCameraCommand request : \n%@\n", responseObject);
             if ( success ) {
                 success(responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Uh oh. An error occurred in sendCameraCommand: \n%@\n", error.localizedDescription);
             if ( failure ) {
                 failure(error);
             }
         }];
}

+ (void) ChangeWiFiSettings:(NSString*)wifiName
               wifiPassword:(NSString*)wifiPassword
                    success:(void (^)(id result))success
                    failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/cgi-bin/Config.cgi?action=set&property=Net.WIFI_AP.SSID&value=%@&property=Net.WIFI_AP.CryptoKey&value=%@", CAMERA_HTTP_HOST, wifiName, wifiPassword];
    NSLog(@"Camera Command : %@", url);
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Success sendCameraCommand request : \n%@\n", responseObject);
             if ( success ) {
                 success(responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Uh oh. An error occurred in sendCameraCommand: \n%@\n", error.localizedDescription);
             if ( failure ) {
                 failure(error);
             }
         }];
}

+ (void) getLastThumbnail:(int)fromFirstFile
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = CAMERA_HTTP_HOST;
    url = [NSString stringWithFormat:@"%@/cgi-bin/Config.cgi?action=dir&property=Normal&format=all&count=1&from=%d", url, fromFirstFile];
    NSLog(@"Camera Command : %@", url);
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Success getLastThumbnail request : \n%@\n", responseObject);
             if ( success ) {
                 success(responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Uh oh. An error occurred in getLastThumbnail: \n%@\n", error.localizedDescription);
             if ( failure ) {
                 failure(error);
             }
         }];
}

+ (void) getFilesList:(BOOL)fromFirstFile
              success:(void (^)(id result))success
              failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = CAMERA_HTTP_HOST;
    url = [NSString stringWithFormat:@"%@/cgi-bin/Config.cgi?action=dir&property=Normal&format=all&count=10", url];
    if ( fromFirstFile ) {
        url = [NSString stringWithFormat:@"%@&from=0", url];
    }
    NSLog(@"Camera Command : %@", url);
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Success getFilesList request : \n%@\n", responseObject);
             if ( success ) {
                 success(responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Uh oh. An error occurred in getFilesList : \n%@\n", error.localizedDescription);
             if ( failure ) {
                 failure(error);
             }
         }];
}

@end
