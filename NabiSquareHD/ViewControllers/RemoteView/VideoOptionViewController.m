//
//  VideoOptionViewController.m
//  NabiSquareHD
//
//  Created by Admin on 12/14/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import "VideoOptionViewController.h"

@implementation VideoOptionViewController

@synthesize currentVideoOption;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVideoOption];
}

- (void) setVideoOption {
    if ( currentVideoOption == kVideoOptionAdvanced ) {
        [self.easyButton setSelected:NO];
        [self.advancedButton setSelected:YES];
    }
    else {
        [self.easyButton setSelected:YES];
        [self.advancedButton setSelected:NO];
    }
}
- (IBAction)onEasy:(id)sender {
    if ( currentVideoOption == kVideoOptionEasy )
        return;
    currentVideoOption = kVideoOptionEasy;
    [self setVideoOption];
    [self.delegate showVideoOptionView:currentVideoOption];
}
- (IBAction)onAdvanced:(id)sender {
    if ( currentVideoOption == kVideoOptionAdvanced )
        return;
    currentVideoOption = kVideoOptionAdvanced;
    [self setVideoOption];
    [self.delegate showVideoOptionView:currentVideoOption];
}

@end
