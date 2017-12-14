//
//  UIImage+Additions.h
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (UIImage *)circleImage:(UIImage *)image withParam:(CGFloat)inset;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)screenSnapshot;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end