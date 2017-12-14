//
//  CityMapViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/10/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "CityMapViewController.h"
#import <MapKit/MapKit.h>
#import "GTravelCityItem.h"
#import "GTPoint.h"
#import "GTTagsCollectionCell.h"
#import "GTCategory.h"
#import "FilterViewController.h"
#import "GTFilter.h"
#import "RYCommon.h"
#import "MBProgressHUD.h"
#import "MKMapView+ZoomLevel.h"
#import "GTAnnotation.h"
#import "GTRecommendAnnotationView.h"
#import "GTUGCAnnotationView.h"
#import "PointDetailViewController.h"
#import "GTravelTownItem.h"
#import "GTCityOrTownPoints.h"

#define PointsPerRequest -1

#define MAP_ZOOM_LEVEL_MAX 20
#define MAP_ZOOM_LEVEL_MIN 0

@interface CityMapViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, FilterViewControllerDelegate> {
    GTFilterPointType selectedPointType;
    NSUInteger iZoomLevel;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *bottomDetailView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomDetailView;
@property (weak, nonatomic) IBOutlet UIButton *mapControlButtonPlus;
@property (weak, nonatomic) IBOutlet UIButton *mapControlButtonMinus;

@property (nonatomic, strong) NSArray *arrCategories;
@property (nonatomic, strong) GTCategory *selectCategory;
@property (nonatomic, strong) GTFilter *selectFilter;

@property (nonatomic, strong) GTCityOrTownPoints *selectedPoint;

- (IBAction)onFilterButton:(id)sender;
- (IBAction)onMapZoomButtons:(UIButton *)sender;
- (IBAction)onPointDetailViewButton:(UIButton *)sender;

- (void)showBottomDetailView:(BOOL)show animated:(BOOL)animated;

- (void)initializedCityOrTownMapViewData;
- (void)loadPointsByCategory:(GTCategory *)category filter:(GTFilter *)filter;

- (void)addAnnotationsOfCityOrTownPoints:(NSArray *)pointsArray;
- (void)setMapControlButtonEnableStateWithZoomLevel:(NSUInteger)level;
@end

@implementation CityMapViewController

#pragma mark - IBAction Methods
- (IBAction)onFilterButton:(id)sender
{
    FilterViewController *controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FilterViewController class])];
    controller.filter = self.selectFilter;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onMapZoomButtons:(UIButton *)sender
{
    MKCoordinateRegion currentRegion = self.mapView.region;
    iZoomLevel = sender.tag == 0 ? --iZoomLevel : ++iZoomLevel;
    iZoomLevel = iZoomLevel > MAP_ZOOM_LEVEL_MAX ? MAP_ZOOM_LEVEL_MAX : iZoomLevel;
    iZoomLevel = iZoomLevel < MAP_ZOOM_LEVEL_MIN ? MAP_ZOOM_LEVEL_MIN : iZoomLevel;
    RYCONDITIONLOG(DEBUG, @"Level:%d", (int)iZoomLevel);
    [self setMapControlButtonEnableStateWithZoomLevel:iZoomLevel];
    [self.mapView setCenterCoordinate:currentRegion.center zoomLevel:iZoomLevel animated:YES];
}

- (IBAction)onPointDetailViewButton:(UIButton *)sender
{
    PointDetailViewController *controller = [[PointDetailViewController alloc] init];

    controller.cityOrTownPoints = self.selectedPoint;


    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Non-Public Methods
- (void)showBottomDetailView:(BOOL)show animated:(BOOL)animated
{
    self.constraintBottomDetailView.constant = show ? 0 : -self.bottomDetailView.frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{
                           [self.view layoutIfNeeded];
                         }];
    }
    else
        [self.view layoutIfNeeded];
}

- (void)initializedCityOrTownMapViewData
{
    selectedPointType = GTFilterPointTypeAll;

    self.arrCategories = self.model.categories;
    if (RYIsValidArray(self.arrCategories)) {
        [self loadPointsByCategory:self.selectCategory filter:self.selectFilter];
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        [self.model requestCategoryWithCompletion:^(NSError *error, NSArray *items) {
          if (error) {
              hud.mode = MBProgressHUDModeText;
              hud.labelText = @"加载失败,请稍后再试!";
              [hud hide:YES afterDelay:1.0];
          }
          else if (RYIsValidArray(items)) {

              self.arrCategories = items;
              [self.collectionView reloadData];
              [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              [self loadPointsByCategory:self.selectCategory filter:self.selectFilter];
          }
          else {
              hud.mode = MBProgressHUDModeText;
              hud.labelText = @"没有数据!";
              [hud hide:YES afterDelay:2.0];
          }
        }];
    }
}

- (void)loadPointsByCategory:(GTCategory *)category filter:(GTFilter *)filter
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

    NSString *cityOrTownID = nil;
    if (self.cityItem) {
        cityOrTownID = [self.cityItem.cityID description];
    }
    else {
        cityOrTownID = [self.townItem.townID description];
    }


    [self.model requestPointsWithTownOrCity:cityOrTownID
                                   category:category
                                   latitude:self.model.userLocation.coordinate.latitude
                                  longitude:self.model.userLocation.coordinate.longitude
                                 completion:^(NSError *error, NSArray *points) {

                                   if (error) {
                                       hud.mode = MBProgressHUDModeText;
                                       hud.labelText = @"加载失败,请稍后再试!";
                                       [hud hide:YES afterDelay:1.0];
                                   }
                                   else if (RYIsValidArray(points)) {
                                       [hud hide:YES afterDelay:0];
                                       [self addAnnotationsOfCityOrTownPoints:points];
                                   }
                                   else {
                                       hud.mode = MBProgressHUDModeText;
                                       hud.labelText = @"没有数据!";
                                       [hud hide:YES afterDelay:2.0];
                                   }
                                 }];
}

- (void)addAnnotationsOfCityOrTownPoints:(NSArray *)pointsArray
{
    NSMutableArray *annotations = [NSMutableArray array];
    GTCityOrTownPoints *poi = [pointsArray firstObject];
    CLLocationDegrees minLatitude = [poi.latitude doubleValue];
    CLLocationDegrees minLongitude = [poi.longitude doubleValue];

    CLLocationDegrees maxLatitude = [poi.latitude doubleValue];
    CLLocationDegrees maxLongitude = [poi.longitude doubleValue];

    for (GTCityOrTownPoints *point in pointsArray) {
        [annotations addObject:[GTAnnotation annotationWithCityOrTownPoints:point]];

        minLatitude = MIN(minLatitude, [point.latitude doubleValue]);
        minLongitude = MIN(minLongitude, [point.longitude doubleValue]);

        maxLatitude = MAX(maxLatitude, [point.latitude doubleValue]);
        maxLongitude = MAX(maxLongitude, [point.longitude doubleValue]);
    }

    if (RYIsValidArray(self.mapView.annotations)) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }

    [self.mapView addAnnotations:annotations];

    iZoomLevel = 10;

    CLLocationDegrees midLatitude = minLatitude + (maxLatitude - minLatitude) * 0.5;
    CLLocationDegrees midLongitude = minLongitude + (maxLongitude - minLongitude) * 0.5;

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(midLatitude, midLongitude) zoomLevel:iZoomLevel animated:YES];
}

//-(void)addAnnotationsOfPoints:(NSArray*)points
//{
//    NSMutableArray *annotations = [NSMutableArray array];
//    GTPoint *poi = [points firstObject];
//    CLLocationDegrees minLatitude = poi.latitude;
//    CLLocationDegrees minLongitude = poi.longitude;
//
//    CLLocationDegrees maxLatitude = poi.latitude;
//    CLLocationDegrees maxLongitude = poi.longitude;
//
//    for(GTPoint *point in points)
//    {
//        [annotations addObject:[GTAnnotation annotationWithPoint:point]];
//
//        minLatitude = MIN(minLatitude, point.latitude);
//        minLongitude = MIN(minLongitude, point.longitude);
//
//        maxLatitude = MAX(maxLatitude, point.latitude);
//        maxLongitude = MAX(maxLongitude, point.longitude);
//    }
//    NSLog(@"%d",RYIsValidArray(self.mapView.annotations));
//    if(RYIsValidArray(self.mapView.annotations))
//    {
//        [self.mapView removeAnnotations:self.mapView.annotations];
//    }
//    [self.mapView addAnnotations:annotations];
//
//    iZoomLevel = 10;
//
//    CLLocationDegrees midLatitude = minLatitude + (maxLatitude - minLatitude)*0.5;
//    CLLocationDegrees midLongitude = minLongitude + (maxLongitude - minLongitude)*0.5;
//
//    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(midLatitude,midLongitude) zoomLevel:iZoomLevel animated:NO];
//}

- (void)setMapControlButtonEnableStateWithZoomLevel:(NSUInteger)level
{
    self.mapControlButtonMinus.enabled = level != MAP_ZOOM_LEVEL_MIN;
    self.mapControlButtonPlus.enabled = level != MAP_ZOOM_LEVEL_MAX;
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBottomDetailView:NO animated:NO];
    //    if (!self.townItem) {
    //        self.title = self.cityItem.name;
    //        [self initializedCityMapViewData];
    //    }else{
    //        self.title = self.townItem.name;
    //        [self initializedTownMapViewData];
    //    }
    [self initializedCityOrTownMapViewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FilterViewControllerDelegate
- (void)filterViewController:(FilterViewController *)controller didSelectFilter:(GTFilter *)filter
{
    self.selectFilter = filter;
    [self loadPointsByCategory:self.selectCategory filter:self.selectFilter];
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
    self.selectCategory = cate;
    self.selectFilter = nil;
    self.selectedPoint = nil;
    [self showBottomDetailView:NO animated:YES];
    [self loadPointsByCategory:self.selectCategory filter:self.selectFilter];
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
        GTAnnotation *anno = (GTAnnotation *)annotation;
        if (anno.cityOrTownPoint.is_ugc) {
            static NSString *identifier = @"GTUGCAnnotationView";
            GTUGCAnnotationView *ugcAnnotationView = (GTUGCAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (ugcAnnotationView == nil) {
                ugcAnnotationView = [[GTUGCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            }
            ugcAnnotationView.annotation = annotation;
            ugcAnnotationView.pointView.cityOrTownPoints = anno.cityOrTownPoint;
            annotationView = ugcAnnotationView;
        }
        else {
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
    RYCONDITIONLOG(DEBUG, @"%d", (int)iZoomLevel);
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
        self.selectedPoint = annotation.cityOrTownPoint;

        self.detailTitleLabel.text = annotation.cityOrTownPoint.title;
        [self showBottomDetailView:YES animated:YES];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([annotation.cityOrTownPoint.latitude doubleValue], [annotation.cityOrTownPoint.longitude doubleValue]);
        [self.mapView setCenterCoordinate:location zoomLevel:14 animated:YES];
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
