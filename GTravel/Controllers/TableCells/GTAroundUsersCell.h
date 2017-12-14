//
//  GTAroundUsersCell.h
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTravelUserItem.h"

@protocol GTAroundUsersCellDelegate <NSObject>

@optional
- (void)DidClickedUserImage:(GTDistanceUser *)user;

@end

@interface GTAroundUsersCell : UITableViewCell
- (void)setAroundUsers:(NSArray *)users;
@property (nonatomic, weak) id<GTAroundUsersCellDelegate> delegate;
@end
