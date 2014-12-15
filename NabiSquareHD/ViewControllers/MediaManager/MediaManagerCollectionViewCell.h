//
//  MediaManagerCollectionViewCell.h
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraFile.h"

@interface MediaManagerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CameraFile *mCameraFile;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (void) setCameraFile:(CameraFile*)cameraFile;

@end
