//
//  GTHotelCell.m
//  GTravel
//
//  Created by QisMSoM on 15/7/13.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTHotelCell.h"
#import "UIImage+ZH.h"

@implementation GTHotelCell

- (void)awakeFromNib
{
}

- (void)setFrame:(CGRect)frame
{
    CGFloat spacing = 10;
    frame.origin.x = spacing;
    frame.size.width -= 2 * spacing;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CELLID = @"GTHotelCell";
    GTHotelCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GTHotelCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.topView.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSomeVC:)];
    [self.hotelNameView addGestureRecognizer:tap];
}

- (void)pushSomeVC:(UIView *)view
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewClicked" object:nil];
}
@end
