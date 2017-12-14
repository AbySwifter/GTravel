//
//  DTLocationUnit.h
//  GTravel
//
//  Created by Raynay Yue on 5/22/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const kDTNotificationDidUpdateUserLocation;

@protocol DTLocationUnitDelegate;
@interface DTLocationUnit : NSObject
@property (nonatomic, weak) id<DTLocationUnitDelegate> delegate;
@property (nonatomic, strong) CLLocation *userLocation;

+ (DTLocationUnit *)sharedLocationUnit;
- (void)startUpdatingUserLocation;
- (void)stopUpdatingUserLocation;

@end


@protocol DTLocationUnitDelegate <NSObject>

- (void)locationUnit:(DTLocationUnit *)unit didUpdateUserLocation:(CLLocation *)location;

@end