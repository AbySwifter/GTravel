//
//  GTAroundTableCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/26/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTAroundTableCellDelegate;
@interface GTAroundTableCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)setCategoryItems:(NSArray *)items delegate:(id<GTAroundTableCellDelegate>)delegate;

@end

@protocol GTAroundTableCellDelegate <NSObject>

- (void)aroundTableCell:(GTAroundTableCell *)cell didClickCategoryAtIndex:(NSInteger)index;
@end