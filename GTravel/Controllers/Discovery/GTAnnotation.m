//
//  GTAnnotation.m
//  GTravel
//
//  Created by Raynay Yue on 6/11/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTAnnotation.h"
#import "GTPoint.h"
#import "GTUserPoints.h"
#import "GTCityOrTownPoints.h"

@interface GTAnnotation ()

@end

@implementation GTAnnotation

+ (GTAnnotation *)annotationWithPoint:(GTPoint *)point
{
    GTAnnotation *annotation = [[GTAnnotation alloc] init];
    annotation.point = point;
    return annotation;
}

+ (GTAnnotation *)annotationWithUserPoint:(GTUserPoints *)point
{
    GTAnnotation *annotation = [[GTAnnotation alloc] init];
    annotation.userPoint = point;
    return annotation;
}

+ (GTAnnotation *)annotationWithCityOrTownPoints:(GTCityOrTownPoints *)point
{
    GTAnnotation *annotation = [[GTAnnotation alloc] init];
    annotation.cityOrTownPoint = point;
    return annotation;
}

#pragma mark - MKAnnotation
- (CLLocationCoordinate2D)coordinate
{
    if (self.userPoint) {
        return CLLocationCoordinate2DMake([self.userPoint.latitude doubleValue], [self.userPoint.longitude doubleValue]);
    }
    else if (self.cityOrTownPoint) {
        return CLLocationCoordinate2DMake([self.cityOrTownPoint.latitude doubleValue], [self.cityOrTownPoint.longitude doubleValue]);
    }
    else {
        return CLLocationCoordinate2DMake(self.point.latitude, self.point.longitude);
    }
}
@end
