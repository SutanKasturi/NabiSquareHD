//
//  MediaManagerCollectionViewCell.h
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraFile.h"
#import <MDRadialProgressView.h>

@protocol MediaManagerCollectionViewCellDelegate <NSObject>

- (void) onVideoPlay:(NSString*)videoUrl;

@end

@interface MediaManagerCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<MediaManagerCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) CameraFile *mCameraFile;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet MDRadialProgressView *progressView;

- (void) setCameraFile:(CameraFile*)cameraFile;

@end
