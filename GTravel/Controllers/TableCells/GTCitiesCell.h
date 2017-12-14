//
//  GTCitiesCell.h
//  GTravel
//
//  Created by QisMSoM on 15/7/28.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTTableViewCell.h"

@class GTCitiesCell;

@protocol GTCitiesCellDelegate <NSObject>

@optional
- (void)citiesCell:(GTCitiesCell *)cell didClickCityButton:(NSInteger)button;

@end

@interface GTCitiesCell : GTTableViewCell

@property (nonatomic, weak) id<GTCitiesCellDelegate> delegate;

- (void)setCityItems:(NSArray *)items;

@end
