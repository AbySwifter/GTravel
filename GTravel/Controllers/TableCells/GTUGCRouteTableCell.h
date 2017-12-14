//
//  GTUGCRouteTableCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTableViewCell.h"

@class GTravelRouteItem;
@interface GTUGCRouteTableCell : GTTableViewCell

+ (CGFloat)heightOfUGCRouteTableCell;

- (void)setRouteItem:(GTravelRouteItem *)item;
- (void)resetCell;

@end
