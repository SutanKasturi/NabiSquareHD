//
//  MediaManagerCollectionViewCell.m
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "MediaManagerCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MDRadialProgressTheme.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "CustomViewController.h"
#import "VideoPreviewViewController.h"

@implementation MediaManagerCollectionViewCell

@synthesize progressView;

- (void) setCameraFile:(CameraFile*)cameraFile {
    self.mCameraFile = cameraFile;
    UIImage *defaultImage;
    
//    if ( self.mCameraFile.completeDownloading ) {
//        [self.playButton setSelected:YES];
//        [self.playButton setHidden:NO];
//        [self.progressView setHidden:YES];
//    }
//    else if ( self.mCameraFile.startDownloading ) {
//        [self.playButton setHidden:YES];
//        [self.progressView setHidden:NO];
//    }
//    else {
//        [self.playButton setHidden:NO];
//        [self.playButton setSelected:NO];
//        [self.progressView setHidden:YES];
//    }
    
    if ( [cameraFile.format isEqualToString:@"jpeg"] ) {
        [self.playButton setHidden:YES];
        defaultImage = [UIImage imageNamed:@"default_image"];
    }
    else {
        [self.playButton setHidden:NO];
        defaultImage = [UIImage imageNamed:@"default_video"];
    }
    
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:cameraFile.thumbnailUrl]
                               placeholderImage:defaultImage
                                        options:SDWebImageContinueInBackground
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if ( image ) {
                                              [[SDImageCache sharedImageCache] storeImage:image forKey:cameraFile.thumbnailUrl];
                                              self.thumbnailImageView.image = image;
                                          }
                                      }];
}

- (IBAction)onStart:(id)sender {
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[self.mCameraFile.cameraFilePath lastPathComponent]];
    
    if ( self.mCameraFile.completeDownloading ) {
        [self.delegate onVideoPlay:fullPath];
        return;
    }
    
    
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.completedColor = [UIColor colorWithRed:90/255.0 green:212/255.0 blue:39/255.0 alpha:1.0];
    newTheme.incompletedColor = [UIColor colorWithRed:164/255.0 green:231/255.0 blue:134/255.0 alpha:1.0];
    newTheme.centerColor = [UIColor clearColor];
    newTheme.centerColor = [UIColor colorWithRed:224/255.0 green:248/255.0 blue:216/255.0 alpha:1.0];
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = [UIColor blackColor];
    newTheme.labelShadowColor = [UIColor whiteColor];
    
    progressView.progressTotal = 100;
    progressView.progressCounter = 0;
    [progressView setHidden:NO];
    [self.playButton setHidden:YES];
    
    NSURL *url = [NSURL URLWithString:self.mCameraFile.cameraFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"bytesRead: %u, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
        progressView.progressCounter = (bytesRead / totalBytesRead);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        self.mCameraFile.startDownloading = NO;
        [self.progressView setHidden:YES];
        [self.playButton setHidden:NO];
        if ( error ) {
            NSLog(@"Firmware Downloading ERR: %@", error.description);
            self.mCameraFile.completeDownloading = NO;
            [self.playButton setSelected:NO];
        }
        else {
            self.mCameraFile.completeDownloading = YES;
            [self.playButton setSelected:YES];
            NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
            long long filesize = [fileSizeNumber longLongValue];
            NSLog(@"Filesize : %llu", filesize);
            [self.delegate onVideoPlay:fullPath];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Firmware Downloading ERR: %@", error.description);
        self.mCameraFile.startDownloading = NO;
        self.mCameraFile.completeDownloading = NO;
        [self.playButton setHidden:NO];
        [self.playButton setSelected:NO];
        [self.progressView setHidden:YES];
    }];
    
    [operation start];
    
    self.mCameraFile.startDownloading = YES;
}

@end
