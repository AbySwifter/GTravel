//
//  CityMapViewController.h
//  GTravel
//
//  Created by Raynay Yue on 6/10/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTRootViewController.h"

@class GTravelCityItem;
@class GTravelTownItem;
@interface CityMapViewController : DTRootViewController
@property (nonatomic, strong) GTravelCityItem *cityItem;
@property (nonatomic, strong) GTravelTownItem *townItem;

@end
