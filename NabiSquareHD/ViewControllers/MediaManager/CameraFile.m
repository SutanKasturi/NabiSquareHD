//
//  CameraFile.m
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "CameraFile.h"

@implementation CameraFile

- (instancetype) init {
    self = [super init];
    if ( self ) {
        self.completeDownloading = NO;
        self.startDownloading = NO;
        self.thumbnailCreated = NO;
        self.cacheThumbnailPath = @"";
    }
    return self;
}

- (NSString*) getReadableDate {
    int year = [[self.time substringWithRange:NSMakeRange(0, 4)] intValue];
    int month = [[self.time substringWithRange:NSMakeRange(5, 2)] intValue];
    int day = [[self.time substringWithRange:NSMakeRange(8, 2)] intValue];
    int hour = [[self.time substringWithRange:NSMakeRange(11, 2)] intValue];
    int minute = [[self.time substringWithRange:NSMakeRange(14, 2)] intValue];
    int second = [[self.time substringWithRange:NSMakeRange(17, 2)] intValue];
    
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    [dc setYear:year];
    [dc setMonth:month];
    [dc setDay:day];
    [dc setHour:hour];
    [dc setMinute:minute];
    [dc setSecond:second];
    NSDate *date = [dc date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE, MMM d hh:mm a"];
    return [df stringFromDate:date];
}

@end
