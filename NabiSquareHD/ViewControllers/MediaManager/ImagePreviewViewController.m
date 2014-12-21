//
//  ImagePreviewViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MDRadialProgress/MDRadialProgressLabel.h>
#import <MDRadialProgress/MDRadialProgressTheme.h>

@interface ImagePreviewViewController ()

@end

@implementation ImagePreviewViewController

@synthesize cameraFile;
@synthesize previewImageView;
@synthesize progressView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [progressView setHidden:YES];
    if ( cameraFile ) {
        NSString *fileName = [cameraFile.cameraFilePath lastPathComponent];
        UIImage *image = [self readFromFile:fileName];
        if ( image ) {
            previewImageView.image = image;
            cameraFile.completeDownloading = YES;
        }
        else {
            cameraFile.completeDownloading = NO;
            cameraFile.startDownloading = YES;
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
            
            [previewImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CAMERA_HTTP_HOST, cameraFile.cameraFilePath]]
                                placeholderImage:[UIImage imageNamed:@"default_image"]
                                         options:SDWebImageContinueInBackground
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                            progressView.progressCounter = receivedSize / (receivedSize + expectedSize);
                                        }
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           [progressView setHidden:YES];
                                           if ( image ) {
                                               [self writeToFile:image fileName:fileName];
                                               previewImageView.image = image;
                                               cameraFile.startDownloading = NO;
                                               cameraFile.completeDownloading = YES;
                                           }
                                           else {
                                               cameraFile.startDownloading = NO;
                                               cameraFile.completeDownloading = NO;
                                           }
                                       }];
        }
    }
}

- (NSString*) getFilePath:(NSString*)fileName {
//    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
//    NSString *documnetDirectoryPath = dirPaths[0];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    return filePath;
}

- (void) writeToFile:(UIImage *)image fileName:(NSString*)fileName {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    [imageData writeToFile:[self getFilePath:fileName] atomically:YES];
}

- (UIImage*) readFromFile:(NSString*)fileName {
    return [UIImage imageWithContentsOfFile:[self getFilePath:fileName]];
}

@end
