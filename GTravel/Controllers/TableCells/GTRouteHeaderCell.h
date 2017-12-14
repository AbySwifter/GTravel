//
//  GTRouteHeaderCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTableViewCell.h"

@protocol GTRouteHeaderCellDelegate;
@interface GTRouteHeaderCell : GTTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setDelegate:(id<GTRouteHeaderCellDelegate>)delegate title:(NSString *)title;

@end

@protocol GTRouteHeaderCellDelegate <NSObject>

- (void)routeHeaderCell:(GTRouteHeaderCell *)cell didClickMoreButton:(UIButton *)sender;

@end