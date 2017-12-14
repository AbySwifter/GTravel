//
//  AroundViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "AroundViewController.h"
#import "GTCategory.h"
#import "AroundMapViewController.h"
#import "RYCommon.h"
#import "GTAroundUsersCell.h"
#import "GTAroundTagsTableCell.h"
#import "GTUGCPointTableCell.h"
#import "GTRecommendTableCell.h"
#import "GTPoint.h"
#import "FilterViewController.h"
#import "PointDetailViewController.h"
#import "UserListViewController.h"
#import "MBProgressHUD.h"
#import "GTNavigationController.h"
#import "RouteDetailViewController.h"
#import "GTravelNetDefinitions.h"
#import "MJRefresh.h"
#import "GTUserRouteViewController.h"

#define iCountPerRequest 20

typedef NS_ENUM(NSInteger, GTAroundViewTableCellType) {
    GTAroundViewTableCellTypeUsers,
    GTAroundViewTableCellTypeCategories,
    GTAroundViewTableCellTypePoints
};

@interface AroundViewController () <UITableViewDataSource, UITableViewDelegate, GTAroundTagsTableCellDelegate, GTRecommendTableCellDelegate, GTUGCPointTableCellDelegate, FilterViewControllerDelegate, GTAroundUsersCellDelegate, MJRefreshBaseViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSArray *aroundUsers;
@property (nonatomic, strong) NSMutableArray *tableCellTypes;

@property (nonatomic, strong) GTFilter *selectFilter;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, weak) MJRefreshFooterView *footer;

- (void)initializedNavigationBarItem;
- (void)onMapViewButton:(UIButton *)button;
- (void)initializedTableViewData;
- (void)loadMorePoints;
- (void)reloadPoints;
- (void)gotoUsers;
- (void)gotoFilters;
- (void)openDetailOfPoint:(GTPoint *)point;
- (void)addNavigationControllerNotificationObserver;
- (void)navigationControllerPopNotification:(NSNotification *)notification;
- (void)navigationControllerPushNotification:(NSNotification *)notification;
- (void)removeNavigationControllerNotificationObserver;

@end

@implementation AroundViewController
#pragma mark - Non-Public Methods
- (void)initializedNavigationBarItem
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_map"] style:UIBarButtonItemStylePlain target:self action:@selector(onMapViewButton:)];
    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
}

- (void)onMapViewButton:(UIButton *)button
{
    AroundMapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AroundMapViewController class])];
    controller.category = self.category;
    controller.filter = self.selectFilter;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:NULL];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initializedTableViewData
{
    self.tableCellTypes = [NSMutableArray array];
    [self.model requestAroundUsersWithFiler:nil
                                        sex:GTFilterSexAll
                                 completion:^(NSError *error, NSArray *users) {
                                   if (RYIsValidArray(users)) {
                                       [self.tableCellTypes insertObject:@(GTAroundViewTableCellTypeUsers) atIndex:0];
                                       self.aroundUsers = users;
                                       [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
                                   }
                                 }];
    [self.model requestCategoryWithCompletion:^(NSError *error, NSArray *items) {
      if (RYIsValidArray(items)) {
          [self.tableCellTypes addObject:@(GTAroundViewTableCellTypeCategories)];
          [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:self.tableCellTypes.count - 1 inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
          [self loadMorePoints];
      }
    }];
    self.points = [NSMutableArray array];
}

- (void)loadMorePoints
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [self.model requestAroundPointsWithFilter:self.selectFilter
                                     category:self.category
                                    pointType:GTFilterPointTypeAll
                                      atIndex:self.points.count
                                        count:iCountPerRequest
                                   completion:^(NSError *error, NSArray *points) {
                                     if (error) {
                                         hud.mode = MBProgressHUDModeText;
                                         hud.labelText = @"加载失败，请稍后再试!";
                                         [hud hide:YES afterDelay:2.0];
                                         [self.footer endRefreshing];
                                     }
                                     else if (RYIsValidArray(points)) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         NSInteger iStartIndex = self.aroundUsers == nil ? self.points.count + 1 : self.points.count + 2;
                                         NSMutableArray *indexPaths = [NSMutableArray array];
                                         for (int i = 0; i < points.count; i++) {
                                             [indexPaths addObject:[NSIndexPath indexPathForRow:iStartIndex + i inSection:0]];
                                             [self.tableCellTypes addObject:@(GTAroundViewTableCellTypePoints)];
                                         }
                                         [self.points addObjectsFromArray:points];
                                         [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                                         [self.refreshView endRefresh];
                                         [self.footer endRefreshing];
                                     }
                                     else {
                                         hud.mode = MBProgressHUDModeText;
                                         hud.labelText = @"没有数据!";
                                         [hud hide:YES afterDelay:2.0];
                                         [self.footer endRefreshing];
                                     }
                                   }];
}

- (void)reloadPoints
{
    NSInteger iStartIndex = RYIsValidArray(self.aroundUsers) ? 2 : 1;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < self.points.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:iStartIndex + i inSection:0]];
        [self.tableCellTypes removeLastObject];
    }
    [self.points removeAllObjects];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self loadMorePoints];
}

- (void)gotoUsers
{
    UserListViewController *controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserListViewController class])];
    controller.users = self.aroundUsers;
    controller.cellType = YES;
    controller.showTitle = @"周边的人";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoFilters
{
    FilterViewController *controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FilterViewController class])];
    controller.filter = self.selectFilter;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)openDetailOfPoint:(GTPoint *)point
{
    PointDetailViewController *controller = [[PointDetailViewController alloc] init];
    controller.point = point;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addNavigationControllerNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationControllerPopNotification:) name:kGTNotificationNavigationControllerWillPopViewController object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationControllerPushNotification:) name:kGTNotificationNavigationControllerWillPushViewController object:nil];
}

- (void)navigationControllerPopNotification:(NSNotification *)notification
{
    UIViewController *controller = [notification.userInfo objectForKey:kGTNotificationViewController];
    if ([[controller class] isSubclassOfClass:[AroundMapViewController class]]) {
        AroundMapViewController *mapController = (AroundMapViewController *)controller;
        self.category = mapController.category;
        self.selectFilter = mapController.filter;
        NSInteger index = -1;
        for (NSNumber *num in self.tableCellTypes) {
            if (num.integerValue == GTAroundViewTableCellTypeCategories) {
                index = [self.tableCellTypes indexOfObject:num];
                break;
            }
        }
        if (index > -1) {
            GTAroundTagsTableCell *cell = (GTAroundTagsTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell selectCategory:self.category];
        }
        [self reloadPoints];
    }
}

- (void)navigationControllerPushNotification:(NSNotification *)notification
{
}

- (void)removeNavigationControllerNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGTNotificationNavigationControllerWillPopViewController object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGTNotificationNavigationControllerWillPushViewController object:nil];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSelectedRow) name:@"CHANGEDTAIL" object:nil];
    // Do any additional setup after loading the view.
    self.title = @"周边";
    self.index = 0;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    self.footer = footer;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);

    [self initializedRefreshViewForView:self.tableView];
    [self initializedNavigationBarItem];
    [self initializedTableViewData];
    [self addNavigationControllerNotificationObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_footer free];

    [self removeNavigationControllerNotificationObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  刷新控件进入开始刷新状态的时候调用
 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) { // 上拉刷新
        [self loadMorePoints];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)reloadSelectedRow
{
    // 更改模型数据
    NSInteger iStartIndex = RYIsValidArray(self.aroundUsers) ? 2 : 1;
    GTPoint *p = self.points[self.selectedRow - iStartIndex];
    p.isFavorite = !p.isFavorite;

    // 刷新
    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:self.selectedRow inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableCellTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSNumber *num = self.tableCellTypes[indexPath.row];


    if ([num integerValue] == GTAroundViewTableCellTypeUsers) {
        GTAroundUsersCell *usersCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GTAroundUsersCell class]) forIndexPath:indexPath];
        usersCell.delegate = self;
        [usersCell setAroundUsers:self.aroundUsers];
        cell = usersCell;
    }
    else if ([num integerValue] == GTAroundViewTableCellTypeCategories) {
        GTAroundTagsTableCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GTAroundTagsTableCell class]) forIndexPath:indexPath];
        [tagsCell setCategories:self.model.categories delegate:self];
        [tagsCell selectCategory:self.category];
        cell = tagsCell;
    }
    else {
        NSInteger iStartIndex = RYIsValidArray(self.aroundUsers) ? 2 : 1;
        GTPoint *p = self.points[indexPath.row - iStartIndex];
        if (p.isUGC) {
            GTUGCPoint *ugcPoint = (GTUGCPoint *)p;
            static NSString *ugcCellIdentifier = @"GTUGCPointTableCell";
            GTUGCPointTableCell *ugcCell = [tableView dequeueReusableCellWithIdentifier:ugcCellIdentifier forIndexPath:indexPath];
            [ugcCell setUGCPoint:ugcPoint delegate:self];
            cell = ugcCell;
        }
        else {
            GTRecommendPoint *recommendPoint = (GTRecommendPoint *)p;
            static NSString *recommendCellIdentifier = @"GTRecommendTableCell";
            GTRecommendTableCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:recommendCellIdentifier forIndexPath:indexPath];
            [recommendCell setRecomendPoint:recommendPoint delegate:self];
            cell = recommendCell;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fHeight = 0;
    NSNumber *num = self.tableCellTypes[indexPath.row];
    switch ([num integerValue]) {
        case GTAroundViewTableCellTypeUsers:
            fHeight = 150;
            break;
        case GTAroundViewTableCellTypeCategories:
            fHeight = 44;
            break;
        case GTAroundViewTableCellTypePoints: {
            NSInteger iStartIndex = RYIsValidArray(self.aroundUsers) ? 2 : 1;
            GTPoint *p = self.points[indexPath.row - iStartIndex];
            fHeight = p.isUGC ? [GTUGCPointTableCell heightOfUGCPointCellWithPoint:p] : [GTRecommendTableCell heightOfRecommendTableCellWithPoint:p];
            break;
        }
    }
    return fHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.tableCellTypes[indexPath.row];
    if ([num integerValue] == GTAroundViewTableCellTypeUsers) {
        [self gotoUsers];
    }
    else if ([num integerValue] == GTAroundViewTableCellTypePoints) {
        NSInteger iStartIndex = RYIsValidArray(self.aroundUsers) ? 2 : 1;
        [self openDetailOfPoint:self.points[indexPath.row - iStartIndex]];
    }
    self.selectedRow = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView scrollViewDidEndDraging];
}

#pragma mark -
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadPoints];
}

#pragma mark - FilterViewControllerDelegate
- (void)filterViewController:(FilterViewController *)controller didSelectFilter:(GTFilter *)filter
{
    self.selectFilter = filter;
    [self reloadPoints];
}

#pragma mark - GTAroundTagsTableCellDelegate
- (void)tagsTableCell:(GTAroundTagsTableCell *)cell didClickCategory:(GTCategory *)category
{
    self.category = category;
    self.selectFilter = nil;
    [self reloadPoints];
}

- (void)tagsTableCellFilterButtonDidClick:(GTAroundTagsTableCell *)cell
{
    [self gotoFilters];
}

#pragma mark - GTUGCPointTableCellDelegate
- (void)UGCPointCell:(GTUGCPointTableCell *)cell didClickFavoriteButton:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍候...";
    [self.model changeFavorteStateOfPoint:cell.point
                               completion:^(NSError *error) {
                                 hud.mode = MBProgressHUDModeText;
                                 if (error) {
                                     hud.labelText = @"操作失败,请稍后再试!";
                                 }
                                 else {
                                     hud.labelText = cell.point.isFavorite ? @"已取消" : @"已收藏";
                                     cell.point.isFavorite = !cell.point.isFavorite;
                                     [cell setFavorite:cell.point.isFavorite];
                                 }
                                 [hud hide:YES afterDelay:1.0];
                               }];
}

#pragma mark - GTRecommendTableCellDelegate
- (void)recommendTableCell:(GTRecommendTableCell *)cell didClickFavoriteButton:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍候...";
    [self.model changeFavorteStateOfPoint:cell.point
                               completion:^(NSError *error) {
                                 hud.mode = MBProgressHUDModeText;
                                 if (error) {
                                     hud.labelText = @"操作失败,请稍后再试!";
                                 }
                                 else {
                                     hud.labelText = cell.point.isFavorite ? @"已取消" : @"已收藏";
                                     cell.point.isFavorite = !cell.point.isFavorite;
                                     [cell setFavorite:cell.point.isFavorite];
                                 }
                                 [hud hide:YES afterDelay:1.0];
                               }];
}

- (void)DidClickedUserImage:(GTDistanceUser *)user
{
    NSLog(@"%@---%@", user.userID, self.model.userItem.userID);

    GTUserRouteViewController *controller = [[GTUserRouteViewController alloc] init];

    NSString *url = [NSString stringWithFormat:@"/profiles/%@?userid=%@", user.userID, self.model.userItem.userID];
    controller.strURL = GetAPIUrl(url);

    [self.navigationController pushViewController:controller animated:YES];
}


@end
