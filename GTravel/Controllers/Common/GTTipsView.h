//
//  GTTipsView.h
//  GTravel
//
//  Created by Raynay Yue on 5/26/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const fTipsViewRatio;

@protocol GTTipsViewDelegate;
@interface GTTipsView : UIView

+ (GTTipsView *)tipsViewWithFrame:(CGRect)frame delegate:(id<GTTipsViewDelegate>)delegate;
- (void)setTips:(NSArray *)tips;

@end

@protocol GTTipsViewDelegate <NSObject>

- (void)tipsView:(GTTipsView *)view didClickTipAtIndex:(NSInteger)index;
- (void)tipsViewDidClickMoreTips:(GTTipsView *)view;

@end
