//
//  TagListViewController.h
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTRootViewController.h"

@class GTCategory;
@protocol TagListViewControllerDelegate;
@interface TagListViewController : DTRootViewController
@property (nonatomic, weak) id<TagListViewControllerDelegate> delegate;
@property (nonatomic, strong) GTCategory *selectedCategory;
@end

@protocol TagListViewControllerDelegate <NSObject>

- (void)tagListViewController:(TagListViewController *)controller didSelectedCategory:(GTCategory *)category;

@end