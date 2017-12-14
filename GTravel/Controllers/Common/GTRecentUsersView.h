//
//  GTRecentUsersView.h
//  GTravel
//
//  Created by Raynay Yue on 5/27/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const fRecentUsersViewRatio;

@protocol GTRecentUsersViewDelegate;
@interface GTRecentUsersView : UIView

+ (GTRecentUsersView *)recentUsersViewWithFrame:(CGRect)frame delegate:(id<GTRecentUsersViewDelegate>)delegate;

- (void)setRecentUsers:(NSArray *)users;

@end

@protocol GTRecentUsersViewDelegate <NSObject>

- (void)recentUsersView:(GTRecentUsersView *)view didClickUserAtIndex:(NSInteger)index;

@end