//
//  GTUserCell.h
//  GTravel
//
//  Created by Raynay Yue on 6/16/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTDistanceUser;
@interface GTUserCell : UITableViewCell

- (void)setDistanceUser:(GTDistanceUser *)user;
- (void)resetCell;
- (void)setUser:(GTDistanceUser *)user;

@end
