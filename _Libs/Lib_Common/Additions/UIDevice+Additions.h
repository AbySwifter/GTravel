//
//  UIDevice+Additions.h
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const UIDeviceNameSimulator;
extern NSString *const UIDeviceNameiPhone4;
extern NSString *const UIDeviceNameiPhone4S;
extern NSString *const UIDeviceNameiPhone5;
extern NSString *const UIDeviceNameiPhone5S;

typedef NS_ENUM(NSUInteger, UIDeviceScreenSize) {
    UIDeviceScreenSize3Point5,
    UIDeviceScreenSize4Point0
};

@interface UIDevice (Additions)
- (NSString *)machineName;
- (BOOL)isSimulator;
- (UIDeviceScreenSize)screenSize __deprecated;
@end