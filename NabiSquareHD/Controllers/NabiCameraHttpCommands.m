//
//  NabiCameraHttpCommands.m
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
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
    NSString *url = [NSString stringWithFormat:@"%@%@", CAMERA_HTTP_HOST, requestUri];
    NSLog(@"Camera Command : %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Success sendCameraCommand request : \n%@\n", result);
        if ( success ) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Uh oh. An error occurred in sendCameraCommand: \n%@\n", error.localizedDescription);
        if ( failure ) {
            failure(error);
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+ (void) ChangeWiFiSettings:(NSString*)wifiName
               wifiPassword:(NSString*)wifiPassword
                    success:(void (^)(id result))success
                    failure:(void (^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@/cgi-bin/Config.cgi?action=set&property=Net.WIFI_AP.SSID&value=%@&property=Net.WIFI_AP.CryptoKey&value=%@", CAMERA_HTTP_HOST, wifiName, wifiPassword];
    NSLog(@"Camera Command : %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Success sendCameraCommand request : \n%@\n", result);
        if ( success ) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Uh oh. An error occurred in sendCameraCommand: \n%@\n", error.localizedDescription);
        if ( failure ) {
            failure(error);
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+ (void) getLastThumbnail:(int)fromFirstFile
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure{
    NSString *url = CAMERA_HTTP_HOST;
    url = [NSString stringWithFormat:@"%@/cgi-bin/Config.cgi?action=dir&property=Normal&format=all&count=1&from=%d", url, fromFirstFile];
    NSLog(@"Camera Command : %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Success sendCameraCommand request : \n%@\n", result);
        if ( success ) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Uh oh. An error occurred in sendCameraCommand: \n%@\n", error.localizedDescription);
        if ( failure ) {
            failure(error);
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+ (void) getFilesList:(BOOL)fromFirstFile
              success:(void (^)(id result))success
              failure:(void (^)(NSError *error))failure {
    NSString *url = CAMERA_HTTP_HOST;
    url = [NSString stringWithFormat:@"%@/cgi-bin/Config.cgi?action=dir&property=Normal&format=all&count=10", url];
    if ( fromFirstFile ) {
        url = [NSString stringWithFormat:@"%@&from=0", url];
    }
    NSLog(@"Camera Command : %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Success sendCameraCommand request : \n%@\n", result);
        if ( success ) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Uh oh. An error occurred in sendCameraCommand: \n%@\n", error.localizedDescription);
        if ( failure ) {
            failure(error);
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

@end
