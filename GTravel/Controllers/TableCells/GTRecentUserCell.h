//
//  GTRecentUserCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/26/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTRecentUserCellDelegate;
@interface GTRecentUserCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)setUserItems:(NSArray *)items delegate:(id<GTRecentUserCellDelegate>)delegate;

@end

@protocol GTRecentUserCellDelegate <NSObject>
- (void)recentUserCell:(GTRecentUserCell *)cell didClickUserAtIndex:(NSInteger)index;
@end