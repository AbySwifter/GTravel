//
//  DTSubLogoImage.m
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTSubLogoImage.h"
#import "UIImageView+WebCache.h"

@implementation DTSubLogoImage

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setSubLogo:(DTSubLogoDetail *)subLogo
{
    _subLogo = subLogo;

    self.name = subLogo.name;
    self.linkURL = subLogo.link_url;
    NSURL *imageURL = [NSURL URLWithString:subLogo.image];
    [self setImageWithURL:imageURL];
}

- (void)imageClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(logoImageDidClicked:)]) {

        [self.delegate logoImageDidClicked:self];
    }
}

@end
