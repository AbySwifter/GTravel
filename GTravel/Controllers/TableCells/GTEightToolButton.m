//
//  GTEightToolButton.m
//  GTravel
//
//  Created by QisMSoM on 15/7/20.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTEightToolButton.h"

@implementation GTEightToolButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width * 0.6;
    CGFloat h = contentRect.size.height * 0.6;
    CGFloat x = contentRect.size.width * 0.25;
    CGFloat y = contentRect.size.height * 0.1;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height * 0.2;
    CGFloat x = 0;
    CGFloat y = contentRect.size.height - h - 2;
    return CGRectMake(x, y, w, h);
}

@end
