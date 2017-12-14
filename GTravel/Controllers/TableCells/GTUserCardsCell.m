//
//  GTUserCardsCell.m
//  GTravel
//
//  Created by QisMSoM on 15/7/31.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTUserCardsCell.h"

@interface GTUserCardsCell ()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation GTUserCardsCell

+ (instancetype)cardsCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CARDSCELL";
    GTUserCardsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GTUserCardsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        // 添加子控件
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    [self.contentView addSubview:iconView];

    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
}

- (void)layoutSubviews
{
    CGFloat spacing = 15;
    CGFloat iconViewW = self.frame.size.height * 0.6;
    CGFloat iconViewH = iconViewW;
    CGFloat iconViewY = self.frame.size.height * 0.2;
    CGFloat iconViewX = spacing;

    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);

    CGFloat textLabelW = 100;
    CGFloat textLabelH = iconViewH;
    CGFloat textLabelY = iconViewY;
    CGFloat textLabelX = CGRectGetMaxX(self.iconView.frame) + spacing * 3 / 2;

    self.titleLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);

    [super layoutSubviews];
}

- (void)setImage:(UIImage *)image title:(NSString *)title
{
    self.iconView.image = image;
    self.titleLabel.text = title;
}

@end
