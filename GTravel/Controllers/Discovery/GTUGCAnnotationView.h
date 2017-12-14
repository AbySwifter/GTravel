//
//  GTUGCAnnotationView.h
//  GTravel
//
//  Created by Raynay Yue on 6/11/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>

@class GTUGCPoint;
@class GTUserPoints;
@class GTCityOrTownPoints;
@interface GTUGCPointView : UIView
@property (nonatomic, strong) GTUGCPoint *point;
@property (nonatomic, strong) GTUserPoints *userPoints;
@property (nonatomic, strong) GTCityOrTownPoints *cityOrTownPoints;

+ (GTUGCPointView *)ugcPointViewWithPoint:(GTUGCPoint *)point;
+ (GTUGCPointView *)userPointViewWithPoint:(GTUserPoints *)point;
+ (GTUGCPointView *)cityOrTownPointViewWithPoint:(GTCityOrTownPoints *)point;

@end

@interface GTUGCAnnotationView : MKPinAnnotationView
@property (nonatomic, strong) GTUGCPointView *pointView;
@end
