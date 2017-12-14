//
//  UserListViewController.h
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTRootViewController.h"

@interface UserListViewController : DTRootViewController
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, assign) BOOL cellType;
@property (nonatomic, copy) NSString *showTitle;
@end
