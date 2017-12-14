//
//  DTPartnerLogo.m
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#define LEFT 77
#define RIGHT 78
#define BOTTOM 79
#define LABEL 80

#import "DTPartnerLogo.h"
#import "DTLogoButton.h"

@interface DTPartnerLogo ()
@property (nonatomic, weak) DTLogoButton *left;
@property (nonatomic, weak) DTLogoButton *right;

@end

@implementation DTPartnerLogo

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];

        // 添加子控件
        DTLogoButton *left = [DTLogoButton buttonWithType:UIButtonTypeCustom];
        left.tag = LEFT;
        left.backgroundColor = [UIColor whiteColor];
        self.left = left;
        left.linkURL = @"http://germany.dragontrail.com/partner/lufthansagroup";
        [left setImage:[UIImage imageNamed:@"bottom_logoLuf"] forState:UIControlStateNormal];
        [left addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        left.imageView.contentMode = UIViewContentModeCenter;

        DTLogoButton *right = [DTLogoButton buttonWithType:UIButtonTypeCustom];
        self.right = right;
        right.tag = RIGHT;
        right.backgroundColor = [UIColor whiteColor];
        right.linkURL = @"http://germany.dragontrail.com/partner/germany-travel";
        [right setImage:[UIImage imageNamed:@"bottom_logoGer"] forState:UIControlStateNormal];
        [right addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:left];
        [self addSubview:right];
    }
    return self;
}

- (void)leftButtonClicked:(DTLogoButton *)button
{
    if ([self.delegate respondsToSelector:@selector(showLogoViewDetailWithLeftBtn:)]) {
        [self.delegate showLogoViewDetailWithLeftBtn:button];
    }
}

- (void)buttonClicked:(DTLogoButton *)button
{
    if ([self.delegate respondsToSelector:@selector(showLogoViewDetail:)]) {
        [self.delegate showLogoViewDetail:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat leftWidth = ([UIScreen mainScreen].bounds.size.width - 1) / 8 * 3;
    CGFloat rightWidth = ([UIScreen mainScreen].bounds.size.width - 1) / 8 * 5;
    CGFloat y = 0;
    CGFloat h = self.frame.size.height - 1;
    UIButton *left = (UIButton *)[self viewWithTag:LEFT];
    UIButton *right = (UIButton *)[self viewWithTag:RIGHT];
    left.frame = CGRectMake(0, y, leftWidth, h);
    right.frame = CGRectMake(leftWidth + 1, y, rightWidth, h);
}

- (void)launchLogo
{
    self.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 1) / 8 * 3, self.frame.size.height / 4, 1, self.frame.size.height * 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
}

@end
