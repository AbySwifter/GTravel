//
//  UserRouteCollectionCell.m
//  GTravel
//
//  Created by QisMSoM on 15/8/4.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "UserRouteCollectionCell.h"
#import "GTCategory.h"

@interface UserRouteCollectionCell ()


@end

@implementation UserRouteCollectionCell
- (IBAction)didClickedTagButton:(id)sender
{
}

- (void)awakeFromNib
{
    self.tagButton.backgroundColor = [UIColor clearColor];
    [self.tagButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.tagButton.userInteractionEnabled = NO;
}

- (void)setCategory:(GTCategory *)category
{
    _category = category;

    [self.tagButton setTitle:category.title forState:UIControlStateNormal];
}

- (void)setFirstAll
{
    [self.tagButton setTitle:@"全部" forState:UIControlStateNormal];
}

@end
