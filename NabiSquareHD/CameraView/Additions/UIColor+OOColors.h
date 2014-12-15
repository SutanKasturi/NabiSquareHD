//
//  UIColor+OOColors.h
//  Video
//
//  Created by HAK Multimedia on 14/05/14.
//  Copyright (c) 2014 HAK Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (OOColors)

/** Create a UIColor object from the RGB representation and the given alpha value */
+ (UIColor*) colorFromRGB:(float)red blue:(float)blue green:(float)green alpha:(float)alpha;

/** Create a UIColor object from the RGB representation */
+ (UIColor*) colorFromRGB:(float)red blue:(float)blue green:(float)green;

/** Create a UIColor object from the Hex RGB */
+ (UIColor*) colorFromHexRGB:(unsigned) rgbHexValue;

+ (UIColor*) OOGrey;

+ (UIColor*) OODarkGrey;

+ (UIColor*) OOBlack;

+ (UIColor*) OOWhite;

+ (UIColor*) OOMidBlack;

+ (UIColor*) OOLightBlack;

+ (UIColor*) OOShinyGreen;

+ (UIColor*) OOlighBlue;

+ (UIColor*) OOBorderColor;

@end


