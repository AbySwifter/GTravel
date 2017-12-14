//
//  GTWebViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/18/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTWebViewController.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"
#import "MobClick.h"

@import MapKit;

@interface GTWebViewController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation GTWebViewController

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *pageTitle = NSStringFromClass([self class]);
    [MobClick beginLogPageView:pageTitle];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *pageTitle = NSStringFromClass([self class]);
    [MobClick endLogPageView:pageTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartLoadWithReqeust:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    RYCONDITIONLOG(DEBUG, @"URL:%@", request.URL.absoluteString);
    BOOL bShould = YES;
    if ([request.URL.scheme isEqualToString:kWebNavigation]) {
        bShould = NO;
        NSLog(@"%@", self.model.currentPlaceMark.country);
        if (![self.model.currentPlaceMark.country isEqualToString:@"德国"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能在德国才可用" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            bShould = NO;
        }
        else {
            [self navigationWithLocationDictionary:[request.URL queryDictionary]];
        }
    }


    return bShould;
}

- (void)navigationWithLocationDictionary:(NSDictionary *)dict
{
    RYCONDITIONLOG(DEBUG, @"%@", dict);
    NSLog(@"%@--%@--%@", self.model.currentPlaceMark.country, self.model.currentPlaceMark.locality, self.model.currentPlaceMark.ISOcountryCode);

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([dict[kLatitude] doubleValue], [dict[kLongitude] doubleValue]) addressDictionary:nil];
    NSLog(@"%@--%@", placemark.country, placemark.ISOcountryCode);
    MKMapItem *currentLocationItem = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [MKMapItem openMapsWithItems:@[ currentLocationItem, mapItem ]
                   launchOptions:@{ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                    MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                    MKLaunchOptionsShowsTrafficKey : @(YES) }];


    //    CLLocation *location = [[CLLocation alloc] initWithLatitude:[dict[kLatitude] doubleValue] longitude:[dict[kLongitude] doubleValue]];
    //
    //    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
    //        CLPlacemark *pm = [placemarks firstObject];
    //        NSLog(@"%@",pm.name);
    //
    //    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
