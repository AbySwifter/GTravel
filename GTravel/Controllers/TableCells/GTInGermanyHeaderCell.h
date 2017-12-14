//
//  GTInGermanyHeaderCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/26/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTravelUserItem;
@protocol GTInGermanyHeaderCellDelegate;
@interface GTInGermanyHeaderCell : UITableViewCell

- (void)setUserItem:(GTravelUserItem *)item welcomeMessage:(NSString *)message delegate:(id<GTInGermanyHeaderCellDelegate>)delegate;
- (void)resetCell;

@end

@protocol GTInGermanyHeaderCellDelegate <NSObject>
- (void)headerCell:(GTInGermanyHeaderCell *)cell didClickCameraButton:(UIButton *)button;
- (void)headerCell:(GTInGermanyHeaderCell *)cell didClickUserHeadImage:(UIButton *)button;
@end