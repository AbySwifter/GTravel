//
//  GTravelTownsCell.h
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTableViewCell.h"

@protocol GTravelTownsCellDelegate;
@interface GTravelTownsCell : GTTableViewCell
@property (nonatomic, weak) id<GTravelTownsCellDelegate> delegate;

- (void)setTownsItems:(NSArray *)items;

@end

@protocol GTravelTownsCellDelegate <NSObject>

- (void)townsCell:(GTravelTownsCell *)cell didClickTownAtIndex:(NSInteger)index;

@end