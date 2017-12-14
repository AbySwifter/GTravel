//
//  GTShareView.h
//  GTravel
//
//  Created by QisMSoM on 15/7/23.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTShareViewDelegate <NSObject>

@optional
// 微信好友
- (void)didClickedWeiXinSessionBtn:(UIButton *)btn;
// 微信朋友圈
- (void)didClickedWeiXinTimelineBtn:(UIButton *)btn;
// 新浪微博
- (void)didClickedSinaWeiboBtn:(UIButton *)btn;


@end

@interface GTShareView : UIView

@property (nonatomic, weak) id<GTShareViewDelegate> delegate;

@end
