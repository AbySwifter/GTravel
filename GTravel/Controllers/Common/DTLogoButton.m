//
//  DTLogoButton.m
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTLogoButton.h"
#import "UIImageView+WebCache.h"

@implementation DTLogoButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat spacing = 10;
    CGFloat w = contentRect.size.width - spacing * 2;
    CGFloat h = w / 4;
    CGFloat x = spacing;
    CGFloat y = (contentRect.size.height - h) / 2;

    return CGRectMake(x, y, w, h);
}

@end
