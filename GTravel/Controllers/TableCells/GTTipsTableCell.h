//
//  GTTipsTableCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/21/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTravelToolItem;
@interface GTTipsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

- (void)setTipItem:(GTravelToolItem *)item;
- (void)resetCell;

@end
