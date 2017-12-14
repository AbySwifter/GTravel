//
//  GTTownsCell.h
//  GTravel
//
//  Created by QisMSoM on 15/7/27.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTableViewCell.h"
@class GTTownsCell;

@protocol GTTownsCellDelegate <NSObject>

@optional
- (void)townsCell:(GTTownsCell *)cell didClickTownButton:(NSInteger)button;

@end

@interface GTTownsCell : GTTableViewCell

@property (nonatomic, weak) id<GTTownsCellDelegate> delegate;
- (void)setTownsItems:(NSArray *)items;
@end
