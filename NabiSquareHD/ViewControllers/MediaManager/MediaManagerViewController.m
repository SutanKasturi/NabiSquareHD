//
//  MediaManagerViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/15/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "MediaManagerViewController.h"
#import "MediaManagerCollectionViewCell.h"
#import "NabiCameraHttpCommands.h"
#import "XMLDictionary.h"
#import "CameraFile.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImagePreviewViewController.h"
#import "OverlayViewController.h"
#import "CustomViewController.h"
#import "VideoPreviewViewController.h"

@interface MediaManagerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, MediaManagerCollectionViewCellDelegate> {
    BOOL isPortrait;
}

@property (nonatomic, strong) NSMutableArray *cameraFiles;
@property (nonatomic, strong) OverlayViewController *overlayViewController;

@end

@implementation MediaManagerViewController

@synthesize cameraFiles = _cameraFiles;
@synthesize overlayViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    overlayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OverlayViewController"];
    [self addChildViewController:overlayViewController];
    [self.view addSubview:overlayViewController.view];
    [overlayViewController.view setHidden:YES];
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
        [self setupView];
    }
}

- (void) setupView {
    CGRect rect = [UIScreen mainScreen].bounds;
    overlayViewController.view.frame = rect;
}

#pragma mark - Get CameraFiles
- (NSMutableArray *)cameraFiles {
    if ( _cameraFiles )
        return _cameraFiles;
    
    _cameraFiles = [[NSMutableArray alloc] init];
    [NabiCameraHttpCommands getFilesList:YES
                                 success:^(id result) {
                                     [self getFilesOnTaskCompleted:result];
                                 }
                                 failure:^(NSError *error) {
                                     
                                 }];
    
    return _cameraFiles;
}

- (void) getFilesOnTaskCompleted:(NSString*)result {
    NSDictionary *dict = [NSDictionary dictionaryWithXMLString:result];
    if ( dict == nil ) {
        NSLog(@"getFilesOnTaskCompleted Error");
    }
    else {
        NSArray *files = [dict objectForKey:@"file"];
        for ( NSDictionary *file in files ) {
            NSString *filePath = [file objectForKey:@"name"];
            NSString *format = [[file objectForKey:@"format"] objectForKey:@"__text"];
            int size = [[file objectForKey:@"size"] intValue];
            NSString *attr = [file objectForKey:@"attr"];
            NSString *time = [file objectForKey:@"time"];
            NSString *thumbnailUrl = @"";
            if ( [format isEqualToString:@"jpeg"] ) {
                thumbnailUrl = [NSString stringWithFormat:@"http://192.72.1.1/%@", filePath];
            }
            else {
                NSString *fileName = [filePath substringFromIndex:[filePath rangeOfString:@"/" options:NSBackwardsSearch].location + 1];
                thumbnailUrl = [NSString stringWithFormat:@"http://192.72.1.1/thumb/DCIM/100DSCIM/%@", fileName];
            }
            
            CameraFile *cameraFile = [[CameraFile alloc] init];
            cameraFile.cameraFilePath = filePath;
            cameraFile.format = format;
            cameraFile.size = size;
            cameraFile.attr = attr;
            cameraFile.time = time;
            cameraFile.thumbnailUrl = thumbnailUrl;
            if ( [self isExistFile:filePath] )
                cameraFile.completeDownloading = YES;
            
            [_cameraFiles addObject:cameraFile];
        }
        
        int amountPulled = [[dict objectForKey:@"amount"] intValue];
        if ( amountPulled == 10 ) {
            [NabiCameraHttpCommands getFilesList:NO
                                         success:^(id result) {
                                             [self getFilesOnTaskCompleted:result];
                                         }
                                         failure:^(NSError *error) {
                                             
                                         }];
        }
        else {
            [self.collectionView reloadData];
        }
    }
}

- (BOOL) isExistFile:(NSString*)cameraFilePath {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documnetDirectoryPath = dirPaths[0];
    NSString *filePath = [documnetDirectoryPath stringByAppendingPathComponent:[cameraFilePath lastPathComponent]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ( [manager fileExistsAtPath:filePath] )
        return YES;
    
    return NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self cameraFiles] count];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaManagerCollectionViewCell" forIndexPath:indexPath];
    
    [cell setCameraFile:[self cameraFiles][indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CameraFile *cameraFile = [self cameraFiles][indexPath.row];
    if ( [cameraFile.format isEqualToString:@"jpeg"] ) {
        ImagePreviewViewController *imagePreviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagePreviewViewController"];
        imagePreviewViewController.cameraFile = cameraFile;
        CustomViewController *previewViewController = [[CustomViewController alloc] initWithViewController:imagePreviewViewController title:@"Image Preview" hideNavBar:NO];
        previewViewController.view.frame = [UIScreen mainScreen].bounds;
        [self.navigationController pushViewController:previewViewController animated:YES];
    }
    else {
        
    }
}

#pragma mark - MediaManagerCollectionViewCellDelegate

- (void)onVideoPlay:(NSString *)videoUrl {
    VideoPreviewViewController *videoPreviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoPreviewViewController"];
    videoPreviewViewController.videoUrl = videoUrl;
    CustomViewController *previewViewController = [[CustomViewController alloc] initWithViewController:videoPreviewViewController title:@"Video Preview" hideNavBar:NO];
    previewViewController.view.frame = [UIScreen mainScreen].bounds;
    [self.navigationController pushViewController:previewViewController animated:YES];
}

@end
