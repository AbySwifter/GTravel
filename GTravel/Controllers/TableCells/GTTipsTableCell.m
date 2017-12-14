//
//  GTTipsTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/21/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTTipsTableCell.h"
#import "GTravelToolItem.h"
#import "RYCommon.h"
#import "GTModel.h"

@implementation GTTipsTableCell {
    BOOL isCellDisplay;
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

- (void)setTipItem:(GTravelToolItem *)item
{
    isCellDisplay = YES;
    self.itemTitleLabel.text = item.title;
    if (RYIsValidString(item.localThumbnail)) {
        UIImage *image = [UIImage imageWithContentsOfFile:[item.localThumbnail absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
        self.itemImageView.image = image;
    }
    else {
        [[GTModel sharedModel] downloadToolItemThumbnail:item
                                              completion:^(NSError *error, NSData *data) {
                                                if (error) {
                                                    RYCONDITIONLOG(DEBUG, @"%@", error);
                                                }
                                                else {
                                                    if (isCellDisplay) {
                                                        UIImage *image = [UIImage imageWithData:data];
                                                        self.itemImageView.image = image;
                                                    }
                                                }
                                              }];
    }
}

- (void)resetCell
{
    isCellDisplay = NO;
    self.itemTitleLabel.text = nil;
    self.itemImageView.image = nil;
}

@end
