//
//  MediaManagerCollectionViewCell.m
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import "MediaManagerCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MediaManagerCollectionViewCell

- (void) setCameraFile:(CameraFile*)cameraFile {
    self.mCameraFile = cameraFile;
    if ( [cameraFile.format isEqualToString:@"jpeg"] ) {
        [self.playButton setHidden:YES];
    }
    else {
        [self.playButton setHidden:NO];
    }
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:cameraFile.thumbnailUrl]
                               placeholderImage:nil
                                        options:SDWebImageContinueInBackground
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if ( image ) {
                                              [[SDImageCache sharedImageCache] storeImage:image forKey:cameraFile.thumbnailUrl];
                                              self.thumbnailImageView.image = image;
                                          }
                                      }];
}

@end
