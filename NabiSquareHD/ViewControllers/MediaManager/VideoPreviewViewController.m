//
//  VideoPreviewViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
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
    
    [self.videoController play];
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

@end
