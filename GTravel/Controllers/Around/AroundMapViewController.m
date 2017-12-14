//
//  AroundMapViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "AroundMapViewController.h"
#import "RYCommon.h"
#import "AroundViewController.h"
#import "FilterViewController.h"
#import "PointDetailViewController.h"
#import "GTPoint.h"
#import "MBProgressHUD.h"
#import "MKMapView+ZoomLevel.h"
#import "GTAnnotation.h"
#import "GTRecommendAnnotationView.h"
#import "GTUGCAnnotationView.h"
#import "PointDetailViewController.h"
#import "GTTagsCollectionCell.h"
#import "GTCategory.h"
#import "GTFilter.h"

@import MapKit;

#define PointsPerRequest -1

#define MAP_ZOOM_LEVEL_MAX 20
#define MAP_ZOOM_LEVEL_MIN 0

@interface AroundMapViewController () <FilterViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MKMapViewDelegate> {
    NSUInteger iZoomLevel;
    GTFilterPointType requestPointType;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *pointTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointDistanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonNavigation;
@property (weak, nonatomic) IBOutlet UIButton *buttonDetail;
@property (weak, nonatomic) IBOutlet UIButton *mapZoomPlusButton;
@property (weak, nonatomic) IBOutlet UIButton *mapZoomMinusButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomDetailView;

@property (nonatomic, strong) GTPoint *selectedPoint;
@property (nonatomic, strong) NSArray *arrCategories;

- (IBAction)onFilterButton:(UIButton *)sender;
- (IBAction)onMapControllButtons:(UIButton *)sender;
- (IBAction)onNavigationButton:(UIButton *)sender;
- (IBAction)onPointDetailButton:(UIButton *)sender;

- (void)showBottomDetailView:(BOOL)show animated:(BOOL)animated;
- (void)setMapControlButtonEnableStateWithZoomLevel:(NSUInteger)level;

- (void)initializedCategories;
- (void)loadPointsOfCategory:(GTCategory *)category filter:(GTFilter *)filter;
- (void)addAnnotationsOfPoints:(NSArray *)points;

@end

@implementation AroundMapViewController
#pragma mark - IBAction Methods
- (IBAction)onFilterButton:(UIButton *)sender
{
    FilterViewController *controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FilterViewController class])];
    controller.filter = self.filter;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onMapControllButtons:(UIButton *)sender
{
    MKCoordinateRegion currentRegion = self.mapView.region;
    iZoomLevel = sender.tag == 0 ? --iZoomLevel : ++iZoomLevel;
    iZoomLevel = iZoomLevel > MAP_ZOOM_LEVEL_MAX ? MAP_ZOOM_LEVEL_MAX : iZoomLevel;
    iZoomLevel = iZoomLevel < MAP_ZOOM_LEVEL_MIN ? MAP_ZOOM_LEVEL_MIN : iZoomLevel;
    [self setMapControlButtonEnableStateWithZoomLevel:iZoomLevel];
    [self.mapView setCenterCoordinate:currentRegion.center zoomLevel:iZoomLevel animated:YES];
}

- (IBAction)onNavigationButton:(UIButton *)sender
{
    MKMapItem *startItem = [MKMapItem mapItemForCurrentLocation];

    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(self.selectedPoint.latitude, self.selectedPoint.longitude);

    MKPlacemark *placeMarkDestination = [[MKPlacemark alloc] initWithCoordinate:coordinate2D addressDictionary:nil];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:placeMarkDestination];

    [MKMapItem openMapsWithItems:@[ startItem, endItem ]
                   launchOptions:@{ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                    MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                    MKLaunchOptionsShowsTrafficKey : @(YES) }];
}

- (IBAction)onPointDetailButton:(UIButton *)sender
{
    PointDetailViewController *controller = [[PointDetailViewController alloc] init];
    controller.point = self.selectedPoint;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Non-Public Methods
- (void)showBottomDetailView:(BOOL)show animated:(BOOL)animated
{
    self.constraintBottomView.constant = show ? 0 : -self.bottomDetailView.frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{
                           [self.view layoutIfNeeded];
                         }];
    }
    else
        [self.view layoutIfNeeded];
}

- (void)setMapControlButtonEnableStateWithZoomLevel:(NSUInteger)level
{
    self.mapZoomMinusButton.enabled = level != MAP_ZOOM_LEVEL_MIN;
    self.mapZoomPlusButton.enabled = level != MAP_ZOOM_LEVEL_MAX;
}

// 顶部刷选按钮
- (void)initializedCategories
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [self.model requestCategoryWithCompletion:^(NSError *error, NSArray *items) {
      if (RYIsValidArray(items)) {
          self.arrCategories = items;
          [self.collectionView reloadData];

          NSInteger iIndex = 0;
          if (self.category != nil) {
              for (GTCategory *cate in self.arrCategories) {
                  if ([cate.categoryID integerValue] == [self.category.categoryID integerValue]) {
                      iIndex = [self.arrCategories indexOfObject:cate] + 1;
                      break;
                  }
              }
          }
          [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:iIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

          requestPointType = GTFilterPointTypeAll;
          [self loadPointsOfCategory:self.category filter:self.filter];
      }
      else {
          hud.mode = MBProgressHUDModeText;
          hud.labelText = @"加载失败，请稍后再试!";
          [hud hide:YES afterDelay:1.0];
      }
    }];
}

- (void)loadPointsOfCategory:(GTCategory *)category filter:(GTFilter *)filter
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    [self.model requestAroundPointsWithFilter:filter
                                     category:category
                                    pointType:requestPointType
                                      atIndex:0
                                        count:PointsPerRequest
                                   completion:^(NSError *error, NSArray *points) {
                                     hud.mode = MBProgressHUDModeText;
                                     if (error) {
                                         hud.labelText = @"加载失败，请稍后再试!";
                                         [hud hide:YES afterDelay:1.0];
                                     }
                                     else {
                                         if (RYIsValidArray(points)) {
                                             [self addAnnotationsOfPoints:points];
                                             [hud hide:YES afterDelay:0];
                                         }
                                         else {
                                             hud.labelText = @"没有数据!";
                                             [hud hide:YES afterDelay:1.0];
                                         }
                                     }
                                   }];
}

- (void)addAnnotationsOfPoints:(NSArray *)points
{
    NSMutableArray *annotations = [NSMutableArray array];
    GTPoint *poi = [points firstObject];
    CLLocationDegrees minLatitude = poi.latitude;
    CLLocationDegrees minLongitude = poi.longitude;

    CLLocationDegrees maxLatitude = poi.latitude;
    CLLocationDegrees maxLongitude = poi.longitude;

    for (GTPoint *point in points) {
        [annotations addObject:[GTAnnotation annotationWithPoint:point]];

        minLatitude = MIN(minLatitude, point.latitude);
        minLongitude = MIN(minLongitude, point.longitude);

        maxLatitude = MAX(maxLatitude, point.latitude);
        maxLongitude = MAX(maxLongitude, point.longitude);
    }
    if (RYIsValidArray(self.mapView.annotations)) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    [self.mapView addAnnotations:annotations];


    iZoomLevel = 1;

    //    CLLocationDegrees midLatitude = minLatitude + (maxLatitude - minLatitude)*0.5;
    //    CLLocationDegrees midLongitude = minLongitude + (maxLongitude - minLongitude)*0.5;

    CLLocationCoordinate2D currentLocation = CLLocationCoordinate2DMake(self.model.userLocation.coordinate.latitude, self.model.userLocation.coordinate.longitude);

    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.mapView setCenterCoordinate:currentLocation zoomLevel:iZoomLevel animated:YES];
    //    });
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"周边";
    self.buttonDetail.layer.borderWidth = 1.0;
    self.buttonDetail.layer.borderColor = [UIColor whiteColor].CGColor;
    self.buttonDetail.layer.cornerRadius = 3.0;
    self.buttonNavigation.layer.borderWidth = 1.0;
    self.buttonNavigation.layer.cornerRadius = 3.0;
    self.buttonNavigation.layer.borderColor = [UIColor whiteColor].CGColor;

    [self showBottomDetailView:NO animated:NO];
    [self initializedCategories];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FilterViewControllerDelegate
- (void)filterViewController:(FilterViewController *)controller didSelectFilter:(GTFilter *)filter
{
    self.filter = filter;
    [self loadPointsOfCategory:self.category filter:self.filter];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrCategories.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTTagsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GTTagsCollectionCell class]) forIndexPath:indexPath];
    if (cell.selectedBackgroundView == nil) {
        CGSize cellSize = [GTTagsCollectionCell sizeForTagsCollectionCell];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
        view.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0];
        cell.selectedBackgroundView = view;
    }

    if (indexPath.row > 0) {
        GTCategory *cate = self.arrCategories[indexPath.row - 1];
        [cell setNameOfCell:cate.title];
    }
    else {
        [cell setNameOfCell:@"全部"];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

    GTCategory *cate = indexPath.row > 0 ? self.arrCategories[indexPath.row - 1] : nil;
    self.category = cate;
    self.filter = nil;
    self.selectedPoint = nil;
    [self showBottomDetailView:NO animated:YES];
    [self loadPointsOfCategory:self.category filter:self.filter];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [GTTagsCollectionCell sizeForTagsCollectionCell];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 1, 0, 1);
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    if ([[annotation class] isSubclassOfClass:[GTAnnotation class]]) {
        // 显示用户头像的大头针
        GTAnnotation *anno = (GTAnnotation *)annotation;
        if (anno.point.isUGC) {
            static NSString *identifier = @"GTUGCAnnotationView";
            GTUGCAnnotationView *ugcAnnotationView = (GTUGCAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (ugcAnnotationView == nil) {
                ugcAnnotationView = [[GTUGCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            }
            ugcAnnotationView.annotation = annotation;
            annotationView = ugcAnnotationView;
        }
        else { // 默认大头针
            static NSString *identifier = @"GTRecommendAnnotationView";
            GTRecommendAnnotationView *recommendAnnotationView = (GTRecommendAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (recommendAnnotationView == nil) {
                recommendAnnotationView = [[GTRecommendAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            }
            recommendAnnotationView.annotation = annotation;
            annotationView = recommendAnnotationView;
        }
    }
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    iZoomLevel = [mapView currentZoomLevel];
    [self setMapControlButtonEnableStateWithZoomLevel:iZoomLevel];
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *av in views) {
        if ([[av.annotation class] isSubclassOfClass:[MKUserLocation class]])
            continue;
        // Check if current annotation is inside visible map rect
        MKMapPoint point = MKMapPointForCoordinate(av.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }

        CGRect endFrame = av.frame;

        // Move annotation out of view
        av.frame = CGRectMake(av.frame.origin.x,
                              av.frame.origin.y - self.view.frame.size.height,
                              av.frame.size.width,
                              av.frame.size.height);

        // Animate drop
        [UIView animateWithDuration:0.5
            delay:0.04 * [views indexOfObject:av]
            options:UIViewAnimationOptionCurveEaseIn
            animations:^{

              av.frame = endFrame;

              // Animate squash
            }
            completion:^(BOOL finished) {
              if (finished) {
                  [UIView animateWithDuration:0.05
                      animations:^{
                        av.transform = CGAffineTransformMakeScale(1.0, 0.8);

                      }
                      completion:^(BOOL finished) {
                        if (finished) {
                            [UIView animateWithDuration:0.1
                                             animations:^{
                                               av.transform = CGAffineTransformIdentity;
                                             }];
                        }
                      }];
              }
            }];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([[view class] isSubclassOfClass:[GTUGCAnnotationView class]] || [[view class] isSubclassOfClass:[GTRecommendAnnotationView class]]) {
        GTAnnotation *annotation = (GTAnnotation *)view.annotation;
        self.selectedPoint = annotation.point;
        self.pointTitleLabel.text = annotation.point.desc;
        NSString *distanceString = [self.model distanceDisplayStringOfValue:annotation.point.distance];
        self.pointDistanceLabel.text = [NSString stringWithFormat:@"距离:%@", distanceString];
        [self showBottomDetailView:YES animated:YES];

        CLLocationCoordinate2D currentLocation = CLLocationCoordinate2DMake(annotation.point.latitude, annotation.point.longitude);
        [self.mapView setCenterCoordinate:currentLocation zoomLevel:14 animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([[view class] isSubclassOfClass:[GTUGCAnnotationView class]] || [[view class] isSubclassOfClass:[GTRecommendAnnotationView class]]) {
        self.selectedPoint = nil;
        [self showBottomDetailView:NO animated:YES];
    }
}

@end
