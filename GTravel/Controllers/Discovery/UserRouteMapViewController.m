//
//  UserRouteMapViewController.m
//  GTravel
//
//  Created by QisMSoM on 15/8/3.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "UserRouteMapViewController.h"
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "RYCommon.h"
#import "GTAnnotation.h"
#import "GTPoint.h"
#import "GTRecommendAnnotationView.h"
#import "GTUGCAnnotationView.h"
#import "MKMapView+ZoomLevel.h"
#include "GTTagsCollectionCell.h"
#import "GTCategory.h"
#import "UserRouteCollectionCell.h"
#import "FilterViewController.h"
#import "PointDetailViewController.h"
#import "AFNetworking.h"
#import "GTravelRouteItem.h"
#import "GTravelNetDefinitions.h"
#import "GTUserPoints.h"


#define PointsPerRequest -1

#define MAP_ZOOM_LEVEL_MAX 20
#define MAP_ZOOM_LEVEL_MIN 0

@interface UserRouteMapViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FilterViewControllerDelegate, MKMapViewDelegate>
//<MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//{
//    NSUInteger          iZoomLevel;
//    GTFilterPointType   requestPointType;
//}


@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *pointTitleLabel;
@property (nonatomic, weak) UILabel *pointDistanceLabel;
@property (nonatomic, weak) UIButton *pointDetailButton;
@property (nonatomic, weak) UIButton *pointNavButton;


@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) GTUserPoints *selectedPoint;
@property (nonatomic, strong) NSArray *arrCategories;

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UserRouteCollectionCell *selectedCell;
@end

@implementation UserRouteMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 初始化
    [self setupView];
    [self initializedCategories];
}

- (void)setupView
{
    // 1.地图
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView = mapView;
    //    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.delegate = self;
    [self.view addSubview:mapView];

    // 2.底部详情
    [self setUpBottomView];

    //    NSLog(@"%@",[self.mapView currentZoomLevel]);

    // 3. 顶部视图
    //    [self setUpTopView];
}
/**
 *  底部详情
 */
- (void)setUpBottomView
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 55, width, 55)];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.6;
    [self.view addSubview:bottomView];

    UILabel *pointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, bottomView.bounds.size.height / 2)];
    self.pointTitleLabel = pointTitleLabel;
    //    self.pointTitleLabel.numberOfLines = 0;
    self.pointTitleLabel.textColor = [UIColor whiteColor];
    self.pointTitleLabel.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:pointTitleLabel];

    UILabel *pointDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, bottomView.bounds.size.height / 2 - 7, 100, bottomView.bounds.size.height / 2)];
    self.pointDistanceLabel = pointDistanceLabel;
    self.pointDistanceLabel.textColor = [UIColor whiteColor];
    self.pointDistanceLabel.contentMode = UIViewContentModeTop;
    self.pointDistanceLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:pointDistanceLabel];

    UIButton *pointDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pointDetailButton setTitle:@"详情" forState:UIControlStateNormal];
    pointDetailButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.pointDetailButton = pointDetailButton;
    pointDetailButton.frame = CGRectMake(width / 2, bottomView.bounds.size.height / 3, width / 5, bottomView.bounds.size.height / 3);
    [bottomView addSubview:pointDetailButton];
    [pointDetailButton addTarget:self action:@selector(didClickedPointDetailButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *pointNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pointNavButton setTitle:@"到这去" forState:UIControlStateNormal];
    pointNavButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.pointNavButton = pointNavButton;
    pointNavButton.frame = CGRectMake(width / 4 * 3, bottomView.bounds.size.height / 3, width / 5, bottomView.bounds.size.height / 3);
    [bottomView addSubview:pointNavButton];
    [pointNavButton addTarget:self action:@selector(didClickedPointNavButton:) forControlEvents:UIControlEventTouchUpInside];

    self.pointDetailButton.layer.borderWidth = 1.0;
    self.pointDetailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pointDetailButton.layer.cornerRadius = 3.0;
    self.pointNavButton.layer.borderWidth = 1.0;
    self.pointNavButton.layer.cornerRadius = 3.0;
    self.pointNavButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didClickedPointNavButton:(id)sender
{
    MKMapItem *startItem = [MKMapItem mapItemForCurrentLocation];

    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([self.selectedPoint.latitude doubleValue], [self.selectedPoint.longitude doubleValue]);

    MKPlacemark *placeMarkDestination = [[MKPlacemark alloc] initWithCoordinate:coordinate2D addressDictionary:nil];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:placeMarkDestination];

    [MKMapItem openMapsWithItems:@[ startItem, endItem ]
                   launchOptions:@{ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                    MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                    MKLaunchOptionsShowsTrafficKey : @(YES) }];
}

- (void)didClickedPointDetailButton:(id)sender
{
    PointDetailViewController *controller = [[PointDetailViewController alloc] init];
    controller.userPoint = self.selectedPoint;
    [self.navigationController pushViewController:controller animated:YES];
}


/****************************************************/

/**
 *  顶部视图
 */
- (void)setUpTopView
{
    CGFloat w = self.view.frame.size.width;
    CGFloat h = 44 + 2;
    CGFloat y = 0;
    CGFloat x = 0;

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    topView.backgroundColor = [UIColor colorWithRed:215 / 255.0 green:217 / 255.0 blue:219 / 255.0 alpha:1.0];
    [self.view addSubview:topView];


    // 顶部collectionView
    // 1.流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 2.每个cell的尺寸
    layout.itemSize = CGSizeMake(w / 5, h - 2);
    // 6.设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 1, w / 5 * 4, 44) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor clearColor];
    self.collectionView = collection;
    collection.delegate = self;
    collection.dataSource = self;
    // 7.取消显示滚动条
    collection.showsHorizontalScrollIndicator = NO;
    [topView addSubview:collection];

    // 8.注册cell，告诉collectionview将来显示怎样的cell
    UINib *nib = [UINib nibWithNibName:@"UserRouteCollectionCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"UserRouteCollectionCell"];

    // 9.筛选菜单按钮
    UIView *filterMenu = [[UIView alloc] initWithFrame:CGRectMake(w * 4 / 5 + 1, 1, w / 5 - 1, h - 2)];
    filterMenu.backgroundColor = [UIColor whiteColor];
    [topView addSubview:filterMenu];

    UIButton *filter = [UIButton buttonWithType:UIButtonTypeCustom];
    filter.backgroundColor = [UIColor clearColor];
    [filter setBackgroundImage:[UIImage imageNamed:@"bt_filter@2x"] forState:UIControlStateNormal];
    filter.imageView.contentMode = UIViewContentModeCenter;
    [filter addTarget:self action:@selector(onFilterButton:) forControlEvents:UIControlEventTouchUpInside];
    filter.frame = CGRectMake((filterMenu.frame.size.width - 20) / 2, (filterMenu.frame.size.height - 20) / 2, 20, 20);
    [filterMenu addSubview:filter];
}
- (void)onFilterButton:(UIButton *)button
{
    FilterViewController *controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FilterViewController class])];
    controller.filter = self.filter;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.categories.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserRouteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserRouteCollectionCell" forIndexPath:indexPath];


    //
    //    if(cell.selectedBackgroundView == nil)
    //    {
    //        CGSize cellSize = [GTTagsCollectionCell sizeForTagsCollectionCell];
    //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
    //        view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    //        cell.selectedBackgroundView = view;
    //    }
    //
    if (indexPath.row > 0) {
        GTCategory *category = self.model.categories[indexPath.row - 1];
        cell.category = category;
    }
    else {
        [cell setFirstAll];
    }
    cell.contentView.backgroundColor = cell.selected ? [UIColor clearColor] : [UIColor whiteColor];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    UserRouteCollectionCell *cell = (UserRouteCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.selectedCell isEqual:cell]) {
    }
    else {
        self.selectedCell.contentView.backgroundColor = [UIColor whiteColor];

        self.selectedCell = cell;

        cell.contentView.backgroundColor = [UIColor clearColor];
    }


    //    cell.selected = !cell.selected;

    //    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    //
    //    GTCategory *cate = indexPath.row > 0 ? self.model.categories[indexPath.row - 1] : nil;
    //    self.category = cate;
    //    self.filter = nil;
    //    self.selectedPoint = nil;
    //    [self showBottomDetailView:NO animated:YES];
    //    [self loadPointsOfCategory:self.category filter:self.filter];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 1, 0, 1);
}
#pragma mark - FilterViewControllerDelegate
- (void)filterViewController:(FilterViewController *)controller didSelectFilter:(GTFilter *)filter
{
    self.filter = filter;
    //    [self loadPointsOfCategory:self.category filter:self.filter];
}
/*************************************************/


- (void)initializedCategories
{
    [self loadPoints];
}


- (void)loadPoints
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";

    NSDictionary *param = @{ @"line_user_id" : self.line_user_id,
                             @"user_id" : @([self.model.userItem.userID longLongValue]),
                             @"latitude" : @(self.model.userLocation.coordinate.latitude),
                             @"longitude" : @(self.model.userLocation.coordinate.longitude)
    };
    [self.model requestUserPointsWithDictionary:param
                                     completion:^(NSError *error, NSArray *points) {

                                       NSLog(@"%@", points);


                                       hud.mode = MBProgressHUDModeText;
                                       if (error) {
                                           hud.labelText = @"加载失败，请稍后再试!";
                                           [hud hide:YES afterDelay:1.0];
                                       }
                                       else {
                                           if (RYIsValidArray(points)) {
                                               [self addAnnotationsOfUserPoints:points];
                                               [hud hide:YES afterDelay:0];
                                           }
                                           else {
                                               hud.labelText = @"没有数据!";
                                               [hud hide:YES afterDelay:1.0];
                                           }
                                       }
                                     }];
}

- (void)addAnnotationsOfUserPoints:(NSArray *)points
{
    NSMutableArray *annotations = [NSMutableArray array];
    GTUserPoints *point = [points firstObject];
    CLLocationDegrees minLatitude = [point.latitude doubleValue];
    CLLocationDegrees minLongitude = [point.longitude doubleValue];

    CLLocationDegrees maxLatitude = [point.latitude doubleValue];
    CLLocationDegrees maxLongitude = [point.longitude doubleValue];

    //    CLLocationCoordinate2D maxLocation = CLLocationCoordinate2DMake([point.latitude doubleValue], [point.longitude doubleValue]);
    //    CLLocationCoordinate2D minLocation = CLLocationCoordinate2DMake([point.latitude doubleValue], [point.longitude doubleValue]);

    if (RYIsValidArray(points)) {
        for (GTUserPoints *point in points) {
            [annotations addObject:[GTAnnotation annotationWithUserPoint:point]];

            minLatitude = MIN(minLatitude, [point.latitude doubleValue]);
            minLongitude = MIN(minLongitude, [point.longitude doubleValue]);


            maxLatitude = MAX(maxLatitude, [point.latitude doubleValue]);
            maxLongitude = MAX(maxLongitude, [point.longitude doubleValue]);

            NSLog(@"%f---%f", maxLongitude, minLongitude);
        }
        double centerX = (maxLatitude + minLatitude) / 2;
        double centerY = (maxLongitude + minLongitude) / 2;
        double zoomLevel = ((maxLongitude - minLongitude) / self.mapView.bounds.size.width);
        double count = log2(zoomLevel) * -1;
        NSLog(@"%f", fabs(floor(count)));
        NSLog(@"%f", count);

        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(centerX, centerY);

        [self.mapView setCenterCoordinate:center zoomLevel:fabs(floor(count - 1)) animated:YES];
    }

    [self.mapView addAnnotations:annotations];
}


#pragma mark - MKMapViewDelegate
/**
 *  每给地图添加一个annotation就调用一次，类似于cellforrow
 *
 *  @param mapView    地图
 *  @param annotation 大头针
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    if ([[annotation class] isSubclassOfClass:[GTAnnotation class]]) {
        static NSString *identifier = @"GTUGCAnnotationView";
        GTUGCAnnotationView *ugcAnnotationView = (GTUGCAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (ugcAnnotationView == nil) {
            ugcAnnotationView = [[GTUGCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        //            ugcAnnotationView.annotation = annotation;
        GTAnnotation *anno = (GTAnnotation *)annotation;
        ugcAnnotationView.pointView.userPoints = (GTUserPoints *)anno.userPoint;
        annotationView = ugcAnnotationView;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //    iZoomLevel = [mapView currentZoomLevel];
    //    [self setMapControlButtonEnableStateWithZoomLevel:iZoomLevel];
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

/**
 *  显示底部详情视图
 *
 *  @param show     是否显示
 *  @param animated 动画
 */
- (void)showBottomDetailView:(BOOL)show animated:(BOOL)animated
{
    //    self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - 64, self.view.frame.size.width, 64);
    if (show) {
        [UIView animateWithDuration:0.25
                         animations:^{
                           self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - 55, self.view.frame.size.width, 55);
                         }];
    }
    else {
        [UIView animateWithDuration:0.25
                         animations:^{
                           self.bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 55);
                         }];
    }
}

/**
 *  放大缩小地图
 *
 *  @param level 级别
 */
- (void)setMapControlButtonEnableStateWithZoomLevel:(NSUInteger)level
{
    //    self.mapZoomMinusButton.enabled = level != MAP_ZOOM_LEVEL_MIN;
    //    self.mapZoomPlusButton.enabled = level != MAP_ZOOM_LEVEL_MAX;
}

/**
 *  点击了大头针调用的方法
 *
 *  @param mapView 地图
 *  @param view    大头针
 */
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

    GTAnnotation *annotation = (GTAnnotation *)view.annotation;
    self.selectedPoint = annotation.userPoint;
    CLLocationCoordinate2D currentLocation = CLLocationCoordinate2DMake([annotation.userPoint.latitude doubleValue], [annotation.userPoint.longitude doubleValue]);
    [self.mapView setCenterCoordinate:currentLocation zoomLevel:14 animated:YES];

    dispatch_async(dispatch_get_main_queue(), ^{

      self.pointTitleLabel.text = annotation.userPoint.title;
      NSString *distanceString = annotation.userPoint.distance;
      self.pointDistanceLabel.text = [NSString stringWithFormat:@"距离:%@m", distanceString];
    });

    [self showBottomDetailView:YES animated:YES];
}

/**
 *  取消选中大头针时调用的方法
 *
 *  @param mapView 地图
 *  @param view    大头针
 */
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([[view class] isSubclassOfClass:[GTUGCAnnotationView class]] || [[view class] isSubclassOfClass:[GTRecommendAnnotationView class]]) {
        self.selectedPoint = nil;
        [self showBottomDetailView:NO animated:YES];
    }
}

@end
