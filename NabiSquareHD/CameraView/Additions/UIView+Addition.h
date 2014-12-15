//
//  UIView+Addition.h
//  Video
//
//  Created by HAK Multimedia on 14/05/14.
//  Copyright (c) 2014 HAK Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

/**
 * The x coordinate of the view.
 */
@property (nonatomic) CGFloat x;

/**
 * The y coordinate of the view.
 */
@property (nonatomic) CGFloat y;

/**
 * The width of the view.
 */
@property (nonatomic) CGFloat width;

/**
 * The height of the view.
 */
@property (nonatomic) CGFloat height;

/**
 * The right-most coordinate of the view.
 * Calculated as x + width.
 */
@property (nonatomic, readonly) CGFloat right;

/**
 * The bottom-most coordinate of the view.
 * Calculated as y + height.
 */
@property (nonatomic, readonly) CGFloat bottom;

/**
 * The origin of the view.
 */
@property (nonatomic) CGPoint origin;

/**
 * The size of the view.
 */
@property (nonatomic) CGSize  size;


@end
