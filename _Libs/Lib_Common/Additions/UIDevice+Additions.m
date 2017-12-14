//
//  UIDevice+Additions.m
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import "UIDevice+Additions.h"
#import <sys/utsname.h>
#import "RYCommonFunctions.h"

/*
 @"i386"      on the simulator
 @"iPod1,1"   on iPod Touch
 @"iPod2,1"   on iPod Touch Second Generation
 @"iPod3,1"   on iPod Touch Third Generation
 @"iPod4,1"   on iPod Touch Fourth Generation
 @"iPhone1,1" on iPhone
 @"iPhone1,2" on iPhone 3G
 @"iPhone2,1" on iPhone 3GS
 @"iPad1,1"   on iPad
 @"iPad2,1"   on iPad 2
 @"iPad3,1"   on 3rd Generation iPad
 @"iPhone3,1" on iPhone 4
 @"iPhone4,1" on iPhone 4S
 @"iPhone5,1" on iPhone 5 (model A1428, AT&T/Canada)
 @"iPhone5,2" on iPhone 5 (model A1429, everything else)
 @"iPad3,4" on 4th Generation iPad
 @"iPad2,5" on iPad Mini
 @"iPhone5,3" on iPhone 5c (model A1456, A1532 | GSM)
 @"iPhone5,4" on iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
 @"iPhone6,1" on iPhone 5s (model A1433, A1533 | GSM)
 @"iPhone6,2" on iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
 @"iPad4,1" on 5th Generation iPad (iPad Air) - Wifi
 @"iPad4,2" on 5th Generation iPad (iPad Air) - Cellular
 @"iPad4,4" on 2nd Generation iPad Mini - Wifi
 @"iPad4,5" on 2nd Generation iPad Mini - Cellular
 */

NSString *const UIDeviceNameSimulator = @"x86_64";
NSString *const UIDeviceNameiPhone4 = @"iPhone3,1";
NSString *const UIDeviceNameiPhone4S = @"iPhone4,1";
NSString *const UIDeviceNameiPhone5 = @"iPhone5";
NSString *const UIDeviceNameiPhone5S = @"iPhone6";

@implementation UIDevice (Additions)

- (NSString *)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (BOOL)isSimulator
{
    return [self.machineName isEqualToString:UIDeviceNameSimulator] || [self.machineName rangeOfString:@"iPhone"].location == NSNotFound;
}

- (UIDeviceScreenSize)screenSize
{
    return RYWinRect().size.height > 480 ? UIDeviceScreenSize4Point0 : UIDeviceScreenSize3Point5;
}
@end