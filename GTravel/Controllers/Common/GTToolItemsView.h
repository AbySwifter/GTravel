//
//  GTToolItemsView.h
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const fToolItemsViewRatio;

@protocol GTToolItemsViewDelegate;
@interface GTToolItemsView : UIView

+ (GTToolItemsView *)itemsWithFrame:(CGRect)frame delegate:(id<GTToolItemsViewDelegate>)delegate;
- (void)setToolItems:(NSArray *)items;
- (void)setCategoryItems:(NSArray *)items;

//-(void)startObserver;
//-(void)stopObserver;

@property (nonatomic, strong) NSMutableArray *toolsSetArray;

@end

@protocol GTToolItemsViewDelegate <NSObject>
@optional
- (void)toolItems:(GTToolItemsView *)itemsView clickButtonAtIndex:(NSInteger)index;
@end