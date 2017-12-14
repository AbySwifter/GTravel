//
//  GTravelCitiesCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTableViewCell.h"

@protocol GTravelCitiesCellDelegate;
@interface GTravelCitiesCell : GTTableViewCell
@property (nonatomic, weak) id<GTravelCitiesCellDelegate> delegate;

- (void)setCityItems:(NSArray *)items;

@end

@protocol GTravelCitiesCellDelegate <NSObject>

- (void)citiesCell:(GTravelCitiesCell *)cell didClickCityAtIndex:(NSInteger)index;

@end