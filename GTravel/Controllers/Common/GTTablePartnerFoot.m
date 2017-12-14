//
//  GTTablePartnerFoot.m
//  GTravel
//
//  Created by QisMSoM on 15/7/17.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#define LABELTEXT @"德国汉莎航空公司与德国国家旅游局共同推出"

#import "GTTablePartnerFoot.h"
#import "DTLogoButton.h"

@interface GTTablePartnerFoot ()

@property (nonatomic, weak) UIButton *left;
@property (nonatomic, weak) UIButton *right;
@property (nonatomic, weak) UILabel *label;

@end

@implementation GTTablePartnerFoot

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];

        // 添加子控件

        //bottom_logoGer
        //bottom_logoLuf

        DTLogoButton *left = [DTLogoButton buttonWithType:UIButtonTypeCustom];
        self.left = left;
        left.backgroundColor = [UIColor whiteColor];
        left.linkURL = @"http://germany.dragontrail.com/partner/lufthansagroup";
        [left setImage:[UIImage imageNamed:@"bottom_logoLuf"] forState:UIControlStateNormal];
        [left addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        DTLogoButton *right = [DTLogoButton buttonWithType:UIButtonTypeCustom];
        self.right = right;
        right.backgroundColor = [UIColor whiteColor];
        right.linkURL = @"http://germany.dragontrail.com/partner/germany-travel";
        [right setImage:[UIImage imageNamed:@"bottom_logoGer"] forState:UIControlStateNormal];
        [right addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        label.text = LABELTEXT;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];

        [self addSubview:left];
        [self addSubview:right];
        [self addSubview:label];
    }
    return self;
}

- (void)buttonClicked:(DTLogoButton *)button
{
    if ([self.delegate respondsToSelector:@selector(showLogoDetail:)]) {
        [self.delegate showLogoDetail:button];
    }
}

- (void)leftButtonClicked:(DTLogoButton *)button
{
    if ([self.delegate respondsToSelector:@selector(showLogoDetailWithLeftButton:)]) {
        [self.delegate showLogoDetailWithLeftButton:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat leftWidth = ([UIScreen mainScreen].bounds.size.width - 1) / 8 * 3;
    CGFloat rightWidth = ([UIScreen mainScreen].bounds.size.width - 1) / 8 * 5;
    CGFloat y = 0;
    CGFloat h = self.frame.size.height / 3 * 2 - 1;

    self.left.frame = CGRectMake(0, y, leftWidth, h);
    self.right.frame = CGRectMake(leftWidth + 1, y, rightWidth, h);
    self.label.frame = CGRectMake(0, h + 1, [UIScreen mainScreen].bounds.size.width, (h + 1) / 2);
}

@end
