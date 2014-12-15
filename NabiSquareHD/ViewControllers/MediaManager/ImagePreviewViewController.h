//
//  ImagePreviewViewController.h
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraFile.h"

@interface ImagePreviewViewController : UIViewController

@property (nonatomic, strong) CameraFile *cameraFile;

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end
