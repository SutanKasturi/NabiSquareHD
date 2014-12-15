//
//  ImagePreviewViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ImagePreviewViewController

@synthesize cameraFile;
@synthesize previewImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ( cameraFile ) {
        [previewImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", CAMERA_HTTP_HOST, cameraFile.cameraFilePath]]
                            placeholderImage:nil
                                     options:SDWebImageContinueInBackground
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       if ( image ) {
                                           UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                                           previewImageView.image = image;
                                       }
                                   }];
    }
}
@end
