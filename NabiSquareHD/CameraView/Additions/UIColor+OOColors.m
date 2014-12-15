//
//  UIColor+OOColors.m
//  Video
//
//  Created by HAK Multimedia on 14/05/14.
//  Copyright (c) 2014 HAK Multimedia. All rights reserved.
//

#import "UIColor+OOColors.h"

@implementation UIColor (OOColors)


+ (UIColor*) colorFromRGB:(float)red blue:(float)blue green:(float)green alpha:(float)alpha
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor*) colorFromRGB:(float)red blue:(float)blue green:(float)green
{
    return [UIColor colorFromRGB:red blue:blue green:green alpha:1.0];
}

+ (UIColor*) colorFromHexRGB:(unsigned) rgbHexValue alpha:(float)alpha
{
    return [UIColor colorWithRed:
            ((float)((rgbHexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbHexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor*) colorFromHexRGB:(unsigned) rgbHexValue
{
    return [UIColor colorFromHexRGB:rgbHexValue alpha:1.0];
}


+ (UIColor*) OOBlack
{
    return [self colorFromRGB:0.f blue:0.f green:0.f alpha:1.f];
}

+ (UIColor*) OOWhite
{
    return [self colorFromRGB:255.f blue:255.f green:255.f alpha:1.f];
}
+ (UIColor*) OOGrey
{
    return [self colorFromHexRGB:0x777777];
}

+ (UIColor*) OODarkGrey
{
    return [self colorFromHexRGB:0x444444];
}

+ (UIColor*) OOMidBlack
{
    return [self colorFromHexRGB:0x111111];
}

+ (UIColor*) OOLightBlack
{
    return [self colorFromHexRGB:0x222222];
}

+ (UIColor*) OOShinyGreen
{
    //return [self colorFromRGB:200 blue:175 green:255];
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"shineColor"]];
}

+ (UIColor*) OOlighBlue
{
    return [self colorFromRGB:172 blue:253 green:210];
}

+ (UIColor*) OOBorderColor
{
    return [self colorFromRGB:80 blue:92 green:88];
}
@end
