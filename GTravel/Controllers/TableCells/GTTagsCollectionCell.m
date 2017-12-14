//
//  GTTagsCollectionCell.m
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTTagsCollectionCell.h"
#import "RYCommon.h"

#define fWidthFilterButton 60

@interface GTTagsCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GTTagsCollectionCell


+ (CGSize)sizeForTagsCollectionCell
{
    CGFloat fHeight = 44;
    CGFloat fWidth = (RYWinRect().size.width - fWidthFilterButton - 5) / 4;
    return CGSizeMake(fWidth, fHeight);
}

- (void)setNameOfCell:(NSString *)name
{
    self.titleLabel.text = name;
}
@end
