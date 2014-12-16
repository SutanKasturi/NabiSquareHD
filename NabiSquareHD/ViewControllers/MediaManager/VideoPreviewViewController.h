//
//  VideoPreviewViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>

@interface VideoPreviewViewController : UIViewController {
    BOOL isPortrait;
}

@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) MPMoviePlayerController *videoController;

@end
