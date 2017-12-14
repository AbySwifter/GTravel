//
//  GTAroundTagsTableCell.h
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTCategory;
@protocol GTAroundTagsTableCellDelegate;
@interface GTAroundTagsTableCell : UITableViewCell

- (void)setCategories:(NSArray *)categories delegate:(id<GTAroundTagsTableCellDelegate>)delegate;
- (void)selectCategory:(GTCategory *)category;

@end

@protocol GTAroundTagsTableCellDelegate <NSObject>
- (void)tagsTableCell:(GTAroundTagsTableCell *)cell didClickCategory:(GTCategory *)category;
- (void)tagsTableCellFilterButtonDidClick:(GTAroundTagsTableCell *)cell;
@end
