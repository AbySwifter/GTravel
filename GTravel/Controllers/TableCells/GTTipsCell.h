//
//  GTTipsCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/28/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTTipsCellDelegate;
@interface GTTipsCell : UITableViewCell

+ (CGFloat)tipsCellHeight;
- (void)setTips:(NSArray *)tips delegate:(id<GTTipsCellDelegate>)delegate;

@end

@protocol GTTipsCellDelegate <NSObject>
- (void)tipsCell:(GTTipsCell *)cell didClickTipAtIndex:(NSInteger)index;
- (void)tipsCellDidClickMoreTips:(GTTipsCell *)cell;
@end