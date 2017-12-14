//
//  PointDetailViewController.h
//  GTravel
//
//  Created by Raynay Yue on 6/12/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTWebViewController.h"

@class GTPoint;
@class GTUserPoints;
@class GTCityOrTownPoints;
@interface PointDetailViewController : GTWebViewController
@property (nonatomic, strong) GTPoint *point;
@property (nonatomic, strong) GTUserPoints *userPoint;
@property (nonatomic, strong) GTCityOrTownPoints *cityOrTownPoints;
@end
