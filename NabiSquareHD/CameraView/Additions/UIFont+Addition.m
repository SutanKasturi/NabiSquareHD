//
//  UIFont+Addition.m
//  Video
//
//  Created by HAK Multimedia on 14/05/14.
//  Copyright (c) 2014 HAK Multimedia. All rights reserved.
//

#import "UIFont+Addition.h"

static NSString* const ZFontNormal     = @"Arial";
static NSString* const ZFontItalic     = @"Arial-Italic";
static NSString* const ZFontBold       = @"Arial-BoldMT";
static NSString* const ZFontBoldItalic = @"Arial-BoldItalic";


@implementation UIFont (Addition)

+ (UIFont*) OOFontWithSize:(CGFloat) size
{
    return [UIFont fontWithName:ZFontNormal size:size];
}

+ (UIFont*) OOItalicFontWithSize:(CGFloat) size
{
    return [UIFont fontWithName:ZFontItalic size:size];
}

+ (UIFont*) OOBoldFontWithSize:(CGFloat) size
{
    return [UIFont fontWithName:ZFontBold size:size];
}

+ (UIFont*) OOBoldItalicFontWithSize:(CGFloat) size
{
    return [UIFont fontWithName:ZFontBoldItalic size:size];
}


@end
