//
//  NabiCameraHttpCommands.h
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NabiCameraHttpCommandsDelegate <NSObject>

- (void)finishedSendCameraCommand:(NSString *)result;

@end

@interface NabiCameraHttpCommands : NSObject

+ (void)sendCameraCommand:(NSString*)requestUri
                  success:(void (^)(id result))success
                  failure:(void (^)(NSError *error))failure;

+ (NSString*) parseCameraSettings:(NSString*)settingsResponse settingToFind:(NSString*)settingToFind;

+ (void) getLastThumbnail:(int)fromFirstFile
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure;

+ (void) getFilesList:(BOOL)fromFirstFile
              success:(void (^)(id result))success
              failure:(void (^)(NSError *error))failure;
@end
