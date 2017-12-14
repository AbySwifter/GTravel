//
//  GTTownsCell.m
//  GTravel
//
//  Created by QisMSoM on 15/7/27.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#define TagSubViewBase 10

#define MaxTownCount 3

#import "GTTownsCell.h"
#import "GTravelTownItem.h"

@interface GTTownsCell ()

@property (nonatomic, strong) NSArray *toolsSetArray;

@end

@implementation GTTownsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSArray *)toolsSetArray
{
    if (!_toolsSetArray) {
        _toolsSetArray = [NSArray array];
    }
    return _toolsSetArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        // 创建子控件
        for (int i = 0; i < MaxTownCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = TagSubViewBase + i;
            button.layer.cornerRadius = 3.0;
            button.titleLabel.numberOfLines = 2;
            [button setTitleColor:[UIColor colorWithRed:76 / 255.0 green:76 / 255.0 blue:76 / 255.0 alpha:1] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1]];
            //            [button setBackgroundColor:[UIColor grayColor]];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            //            [button setBackgroundColor:[UIColor blackColor]];
            [button addTarget:self action:@selector(didClickedButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat spacing = 10;
    CGFloat btnSpacing = spacing * 2 / 3;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - 2 * spacing - btnSpacing * 2) / MaxTownCount;
    CGFloat h = 50;

    for (int i = 0; i < self.toolsSetArray.count; i++) {
        UIButton *button = (UIButton *)[self.contentView viewWithTag:TagSubViewBase + i];
        CGFloat x = spacing + i * (w + btnSpacing);
        CGFloat y = 5;
        button.frame = CGRectMake(x, y, w, h);
    }
}

- (void)didClickedButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(townsCell:didClickTownButton:)]) {
        [self.delegate townsCell:self didClickTownButton:(button.tag - TagSubViewBase)];
    }
}

- (void)setTownsItems:(NSArray *)items
{
    self.toolsSetArray = items;
    NSInteger iCount = MIN(items.count, MaxTownCount);
    for (int i = 0; i < iCount; i++) {
        UIButton *button = (UIButton *)[self.contentView viewWithTag:TagSubViewBase + i];
        GTravelTownItem *townItem = items[i];
        [button setTitle:townItem.name forState:UIControlStateNormal];
    }
}

@end
