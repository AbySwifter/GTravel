//
//  GTAnnotation.h
//  GTravel
//
//  Created by Raynay Yue on 6/11/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class GTPoint;
@class GTUserPoints;
@class GTCityOrTownPoints;
@interface GTAnnotation : NSObject <MKAnnotation>
@property (nonatomic, strong) GTPoint *point;
@property (nonatomic, strong) GTUserPoints *userPoint;
@property (nonatomic, strong) GTCityOrTownPoints *cityOrTownPoint;

+ (GTAnnotation *)annotationWithPoint:(GTPoint *)point;
+ (GTAnnotation *)annotationWithUserPoint:(GTUserPoints *)point;
+ (GTAnnotation *)annotationWithCityOrTownPoints:(GTCityOrTownPoints *)point;

@end
