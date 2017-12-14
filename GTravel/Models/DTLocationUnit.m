//
//  DTLocationUnit.m
//  GTravel
//
//  Created by Raynay Yue on 5/22/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTLocationUnit.h"
#import "RYCommon.h"


NSString *const kDTNotificationDidUpdateUserLocation = @"kDTNotificationDidUpdateUserLocation";

@interface DTLocationUnit () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation DTLocationUnit
#pragma mark - Public Methods
static DTLocationUnit *sharedInstance = nil;
+ (DTLocationUnit *)sharedLocationUnit
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
        return sharedInstance;
    }
    return nil;
}

- (void)startUpdatingUserLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 200.0;
        locationManager.activityType = CLActivityTypeFitness;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways && RYSystemVersion() >= RYVersioniOS8) {
            [locationManager requestAlwaysAuthorization];
        }
        [locationManager startUpdatingLocation];
        self.locationManager = locationManager;
    }
}


- (void)stopUpdatingUserLocation
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    RYCONDITIONLOG(DEBUG, @"%d", status);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    RYCONDITIONLOG(DEBUG, @"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    self.userLocation = location;
    RYCONDITIONLOG(DEBUG, @"lat:%f,lon:%f", location.coordinate.latitude, location.coordinate.longitude);
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(locationUnit:didUpdateUserLocation:))) {
        [self.delegate locationUnit:self didUpdateUserLocation:location];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDTNotificationDidUpdateUserLocation object:location];
}

@end
