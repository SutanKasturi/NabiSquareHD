//
//  FFMPEGWrapper.h
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Sutan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FFMPEGWrapperDelegate <NSObject>

- (void) shellOut:(NSString*)msg;
- (void) shellDone;

@end

@interface FFMPEGWrapper : NSObject

@end
