//
//  GTUserTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTUserTableCell.h"
#import "RYCommon.h"

@interface GTUserTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@end

@implementation GTUserTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle
{
    UIImage *img = image == nil ? [UIImage imageNamed:@"default_user_icon"] : image;
    self.userImageView.image = [UIImage circleImage:img withParam:0];
    self.labelName.text = title;
    self.labelDescription.text = subTitle;
}

@end
