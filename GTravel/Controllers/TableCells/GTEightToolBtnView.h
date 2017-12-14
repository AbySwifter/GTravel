//
//  GTEightToolBtnView.h
//  GTravel
//
//  Created by QisMSoM on 15/7/21.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTToolsItem;
@class GTEightToolBtnView;
@protocol GTEightToolBtnViewDelegate <NSObject>

@optional
- (void)didClickEightToolBtnView:(GTEightToolBtnView *)view;

@end

@interface GTEightToolBtnView : UIView

@property (nonatomic, weak) id<GTEightToolBtnViewDelegate> delegate;

@property (nonatomic, strong) GTToolsItem *item;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *label;

@end
