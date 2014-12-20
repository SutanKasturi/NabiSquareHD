//
//  CustomButton.m
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self draw];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self draw];
    }
    return self;
}

- (void) draw {
    CALayer *layer = self.layer;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
