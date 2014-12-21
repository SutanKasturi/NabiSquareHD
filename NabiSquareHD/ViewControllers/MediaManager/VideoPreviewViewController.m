//
//  VideoPreviewViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "VideoPreviewViewController.h"

@implementation VideoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ( screenHeight > screenWidth ) {
        isPortrait = NO;
    }
    else {
        isPortrait = YES;
    }
    
    self.videoController = [[MPMoviePlayerController alloc] init];
    [self.videoController setContentURL:[NSURL URLWithString:self.videoUrl]];
    [self.view addSubview:self.videoController.view];
    
    [self deviceOrientationDidChange];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoController];
    
    [self isExistFile:self.videoUrl];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:UIDeviceOrientationDidChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:MPMoviePlayerPlaybackDidFinishNotification];
    
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
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
        self.videoController.view.frame = self.view.frame;
    }
}

- (void) videoPlayBackDidFinish:(NSNotification*) notification {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) isExistFile:(NSString*)cameraFilePath {
    //    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //    NSString *documnetDirectoryPath = dirPaths[0];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[cameraFilePath lastPathComponent]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ( [manager fileExistsAtPath:filePath] )
        [self.videoController play];
    else {
        NSLog(@"Not exist video file");
    }
    
    [self videoPlayBackDidFinish:nil];
}

@end
