//
//  CameraFile.h
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraFile : NSObject

@property (nonatomic, strong) NSString *cameraFilePath;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) int size;
@property (nonatomic, strong) NSString *attr;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL thumbnailCreated;
@property (nonatomic, strong) NSString *cacheThumbnailPath;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, assign) BOOL completeDownloading;
@property (nonatomic, assign) BOOL startDownloading;

- (NSString*) getReadableDate;

@end
