//
//  GTCitiesCell.m
//  GTravel
//
//  Created by QisMSoM on 15/7/28.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTCitiesCell.h"
#import "GTravelCityItem.h"

#define BaseSubViewTag 10
#define MaxCityCount 6

@interface GTCitiesCell ()

@property (nonatomic, weak) NSArray *citiesArray;

@end

@implementation GTCitiesCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        // 创建子控件
        self.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < MaxCityCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = BaseSubViewTag + i;
            button.layer.cornerRadius = 3.0;
            [button setTitleColor:[UIColor colorWithRed:76 / 255.0 green:76 / 255.0 blue:76 / 255.0 alpha:1] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1]];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(didClickedButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.numberOfLines = 2;
            [self.contentView addSubview:button];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    int spaceCount = MaxCityCount / 2 - 1;
    int num = MaxCityCount / 2;
    CGFloat spacing = 10;
    CGFloat btnSpacingX = spacing * 2 / 3;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - spaceCount * spacing - btnSpacingX * spaceCount) / num;
    CGFloat h = 50;


    for (int i = 0; i < self.citiesArray.count; i++) {
        UIButton *button = (UIButton *)[self.contentView viewWithTag:BaseSubViewTag + i];
        CGFloat x = spacing + (i % num) * (w + btnSpacingX);
        CGFloat y = 3 + (i / num) * (h + 5);
        button.frame = CGRectMake(x, y, w, h);
    }
}

- (void)didClickedButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(citiesCell:didClickCityButton:)]) {
        [self.delegate citiesCell:self didClickCityButton:(button.tag - BaseSubViewTag)];
    }
}

- (void)setCityItems:(NSArray *)items
{
    NSInteger iCount = MIN(items.count, MaxCityCount);
    for (int i = 0; i < iCount; i++) {
        self.citiesArray = items;
        UIButton *button = (UIButton *)[self.contentView viewWithTag:BaseSubViewTag + i];
        button.layer.cornerRadius = 3.0;
        GTravelCityItem *cityItem = items[i];
        [button setTitle:cityItem.name forState:UIControlStateNormal];
    }
}

@end
