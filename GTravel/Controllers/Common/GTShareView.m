//
//  GTShareView.m
//  GTravel
//
//  Created by QisMSoM on 15/7/23.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTShareView.h"

@implementation GTShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        UIButton *wx = [UIButton buttonWithType:UIButtonTypeCustom];
        wx.tag = 10;
        [wx setImage:[UIImage imageNamed:@"share_wechat_normal"] forState:UIControlStateNormal];
        [wx setImage:[UIImage imageNamed:@"share_wechat_pressed"] forState:UIControlStateHighlighted];
        [wx addTarget:self action:@selector(didClickedWeiXinSessionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wx];

        UIButton *wxFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        wxFriend.tag = 11;
        [wxFriend setImage:[UIImage imageNamed:@"share_moment_normal"] forState:UIControlStateNormal];
        [wxFriend setImage:[UIImage imageNamed:@"share_moment_pressed"] forState:UIControlStateHighlighted];
        [wxFriend addTarget:self action:@selector(didClickedWeiXinTimelineBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wxFriend];

        UIButton *sina = [UIButton buttonWithType:UIButtonTypeCustom];
        sina.tag = 12;
        [sina setImage:[UIImage imageNamed:@"share_sina_normal"] forState:UIControlStateNormal];
        [sina setImage:[UIImage imageNamed:@"share_sina_pressed"] forState:UIControlStateHighlighted];
        [sina addTarget:self action:@selector(didClickedSinaWeiboBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sina];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat width = 81;
    CGFloat height = 81;
    CGFloat y = (self.frame.size.height - height) / 2;
    CGFloat spacing = ([UIScreen mainScreen].bounds.size.width - width * 3) / 4;
    for (int i = 0; i < self.subviews.count; i++) {

        UIButton *btn = self.subviews[i];

        CGFloat x = spacing + i * (width + spacing);
        btn.frame = CGRectMake(x, y, width, height);
    }
}

// 微信好友
- (void)didClickedWeiXinSessionBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickedWeiXinSessionBtn:)]) {
        [self.delegate didClickedWeiXinSessionBtn:btn];
    }
}
// 微信朋友圈
- (void)didClickedWeiXinTimelineBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickedWeiXinTimelineBtn:)]) {
        [self.delegate didClickedWeiXinTimelineBtn:btn];
    }
}
// 新浪微博
- (void)didClickedSinaWeiboBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickedSinaWeiboBtn:)]) {
        [self.delegate didClickedSinaWeiboBtn:btn];
    }
}


@end
