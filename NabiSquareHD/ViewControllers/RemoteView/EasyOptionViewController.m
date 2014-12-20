//
//  EasyOptionViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/13/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "EasyOptionViewController.h"

@implementation EasyOptionViewController

@synthesize currentEasyOptionType;

- (IBAction)onEZLandscape:(id)sender {
    currentEasyOptionType = kEasyOptionTypeLandscape;
    [self.delegate setEasyOptionType:currentEasyOptionType];
}
- (IBAction)onEZSports:(id)sender {
    currentEasyOptionType = kEasyOptionTypeSports;
    [self.delegate setEasyOptionType:currentEasyOptionType];
}
- (IBAction)onEZLongRec:(id)sender {
    currentEasyOptionType = kEasyOptionTypeLongRect;
    [self.delegate setEasyOptionType:currentEasyOptionType];
}

@end
