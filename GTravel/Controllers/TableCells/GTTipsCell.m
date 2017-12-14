//
//  GTTipsCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/28/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTTipsCell.h"
#import "RYCommon.h"
#import "GTTipsView.h"
#import "GTModel.h"

#define TipsViewTag 100

@interface GTTipsCell () <GTTipsViewDelegate>
@property (nonatomic, weak) id<GTTipsCellDelegate> delegate;
- (void)initializedTipsCell;
- (void)resetCell;
@end

@implementation GTTipsCell
- (void)initializedTipsCell
{
    UIView *view = [self.contentView viewWithTag:TipsViewTag];
    if (view == nil) {
        CGFloat fHeight = RYWinRect().size.width / fTipsViewRatio;
        GTTipsView *tipsView = [GTTipsView tipsViewWithFrame:CGRectMake(0, 0, RYWinRect().size.width, fHeight) delegate:self];
        tipsView.tag = TipsViewTag;
        [self.contentView addSubview:tipsView];
    }
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)tipsCellHeight
{
    return RYWinRect().size.width / fTipsViewRatio;
}

- (void)setTips:(NSArray *)tips delegate:(id<GTTipsCellDelegate>)delegate
{
    [self initializedTipsCell];
    self.delegate = delegate;
    GTTipsView *tipsView = (GTTipsView *)[self.contentView viewWithTag:TipsViewTag];
    [tipsView setTips:tips];
}

- (void)resetCell
{
    GTTipsView *tipsView = (GTTipsView *)[self.contentView viewWithTag:TipsViewTag];
    [tipsView removeFromSuperview];
}

#pragma mark - GTTipsViewDelegate
- (void)tipsView:(GTTipsView *)view didClickTipAtIndex:(NSInteger)index
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(tipsCell:didClickTipAtIndex:))) {
        [self.delegate tipsCell:self didClickTipAtIndex:index];
    }
}
- (void)tipsViewDidClickMoreTips:(GTTipsView *)view
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(tipsCellDidClickMoreTips:))) {
        [self.delegate tipsCellDidClickMoreTips:self];
    }
}
@end
