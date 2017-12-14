//
//  GTTableViewCell.m
//  GTravel
//
//  Created by QisMSoM on 15/7/15.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTTableViewCell.h"

@implementation GTTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 15 / 2;
    [super setFrame:frame];
}

@end
