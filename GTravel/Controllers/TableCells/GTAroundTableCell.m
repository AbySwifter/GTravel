//
//  GTAroundTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/26/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTAroundTableCell.h"
#import "GTToolItemsView.h"
#import "GTCategory.h"
#import "RYCommon.h"
#import "GTModel.h"

#define TitleLabelHeight 30
#define fMarginTop 5
#define fMarginLeft 10
#define fMarginBottom 10

#define ToolItemViewTagTop 100
#define ToolItemViewTagBottom 200

#define TotalCategoryCount 8
#define CategoryCountPerLine 4

@interface GTAroundTableCell () <GTToolItemsViewDelegate>
@property (nonatomic, weak) id<GTAroundTableCellDelegate> delegate;
- (void)initializedCell;
- (void)resetCell;

@end

@implementation GTAroundTableCell
#pragma mark - Non-Public Methods
- (void)initializedCell
{
    CGFloat fWidthToolItemView = RYWinRect().size.width - 2 * fMarginLeft;
    CGFloat fHeightToolItemView = fWidthToolItemView / fToolItemsViewRatio;
    UIView *view = [self.contentView viewWithTag:ToolItemViewTagTop];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    if (view == nil) {
        CGRect rect = CGRectMake(fMarginLeft, TitleLabelHeight + fMarginTop, fWidthToolItemView, fHeightToolItemView);
        GTToolItemsView *itemsView = [GTToolItemsView itemsWithFrame:rect delegate:self];
        itemsView.tag = ToolItemViewTagTop;
        [self.contentView addSubview:itemsView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [NSThread sleepForTimeInterval:0.02];
          dispatch_async(dispatch_get_main_queue(), ^{
            itemsView.frame = rect;
          });
        });
    }

    UIView *bottomView = [self.contentView viewWithTag:ToolItemViewTagBottom];
    if (bottomView == nil) {
        CGRect rect = CGRectMake(fMarginLeft, TitleLabelHeight + fMarginTop * 2 + fHeightToolItemView, fWidthToolItemView, fHeightToolItemView);
        GTToolItemsView *itemsView = [GTToolItemsView itemsWithFrame:rect delegate:self];
        itemsView.tag = ToolItemViewTagBottom;
        [self.contentView addSubview:itemsView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [NSThread sleepForTimeInterval:0.02];
          dispatch_async(dispatch_get_main_queue(), ^{
            itemsView.frame = rect;
          });
        });
    }
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

#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    CGFloat fHeightToolItemView = (RYWinRect().size.width - 2 * fMarginLeft) / fToolItemsViewRatio;
    return fHeightToolItemView * 2 + TitleLabelHeight + fMarginTop * 2 + fMarginBottom;
}

- (void)setCategoryItems:(NSArray *)items delegate:(id<GTAroundTableCellDelegate>)delegate
{
    [self initializedCell];
    self.delegate = delegate;
    if (items.count >= TotalCategoryCount) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < CategoryCountPerLine; i++) {
            [arr addObject:items[i]];
        }
        GTToolItemsView *topToolItemView = (GTToolItemsView *)[self.contentView viewWithTag:ToolItemViewTagTop];
        [topToolItemView setCategoryItems:arr];
        [arr removeAllObjects];

        for (int i = CategoryCountPerLine; i < CategoryCountPerLine * 2; i++) {
            [arr addObject:items[i]];
        }
        GTToolItemsView *bottomToolItemView = (GTToolItemsView *)[self.contentView viewWithTag:ToolItemViewTagBottom];
        [bottomToolItemView setCategoryItems:arr];
    }
    else {
        RYCONDITIONLOG(DEBUG, @"There aren't enough Category items to be set!");
    }
}

- (void)resetCell
{
    GTToolItemsView *topToolItemView = (GTToolItemsView *)[self.contentView viewWithTag:ToolItemViewTagTop];
    [topToolItemView removeFromSuperview];

    GTToolItemsView *bottomToolItemView = (GTToolItemsView *)[self.contentView viewWithTag:ToolItemViewTagBottom];
    [bottomToolItemView removeFromSuperview];
}


#pragma mark - GTToolItemsViewDelegate
- (void)toolItems:(GTToolItemsView *)itemsView clickButtonAtIndex:(NSInteger)index
{
    NSInteger iIndex = 0;
    if (itemsView.tag == ToolItemViewTagTop) {
        iIndex = index;
    }
    else {
        iIndex = index + CategoryCountPerLine;
    }

    if (RYDelegateCanResponseToSelector(self.delegate, @selector(aroundTableCell:didClickCategoryAtIndex:))) {
        [self.delegate aroundTableCell:self didClickCategoryAtIndex:iIndex];
    }
}

@end
