//
//  GTImageTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTImageTableCell.h"

@interface GTImageTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GTImageTableCell

- (void)setmode
{
    //    self.iconImageView.contentMode = UIViewContentModeCenter;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)image title:(NSString *)title
{
    self.iconImageView.image = image;
    self.titleLabel.text = title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
