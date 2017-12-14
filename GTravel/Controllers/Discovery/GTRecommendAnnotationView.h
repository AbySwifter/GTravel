//
//  GTRecommendAnnotationView.h
//  GTravel
//
//  Created by Raynay Yue on 6/11/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>

@class GTRecommendPoint;
@class GTCityOrTownPoints;
@interface GTRecommendPointView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

+ (GTRecommendPointView *)recommendPointViewWithPoint:(GTRecommendPoint *)point;
+ (GTRecommendPointView *)recommendPointViewWithCityOrTownPoint:(GTCityOrTownPoints *)point;

@end

@interface GTRecommendAnnotationView : MKPinAnnotationView


@end
