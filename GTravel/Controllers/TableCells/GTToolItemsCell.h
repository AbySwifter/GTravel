//
//  GTToolItemsCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTableViewCell.h"
#import "GTToolsSet.h"

@class GTravelToolItem;
@protocol GTToolItemsCellDelegate;
@interface GTToolItemsCell : GTTableViewCell

+ (CGFloat)heightOfToolItemsCellWithRatio:(CGFloat)ratio;
- (void)setCellContentWithItems:(NSArray *)items delegate:(id<GTToolItemsCellDelegate>)delegate;


- (void)setContentWithToolsSetArray:(NSMutableArray *)toolsSetArray delegate:(id<GTToolItemsCellDelegate>)delegate;

// tools集合
@property (nonatomic, strong) NSMutableArray *toolsSetArray;

@end

@protocol GTToolItemsCellDelegate <NSObject>
- (void)itemsCell:(GTToolItemsCell *)itemsCell didSelectItemAtIndex:(NSInteger)index;
//-(void)itemsCell:(GTToolItemsCell*)itemsCell didClickMoreButton:(UIButton*)sender;
@end