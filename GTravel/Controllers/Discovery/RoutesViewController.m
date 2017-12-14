//
//  RoutesViewController.m
//  GTravel
//
//  Created by Raynay Yue on 5/21/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "RoutesViewController.h"
#import "RYCommon.h"
#import "GTRouteTableCell.h"
#import "GTUGCRouteTableCell.h"
#import "GTravelRouteItem.h"
#import "GTTablePartnerFoot.h"
#import "DTLogoViewController.h"

#define iCountRoutesPerRequest 20
#define RouteCellImageRatio (600.0 / 300.0)
#define PaternerLogoHeight 120


@interface RoutesViewController () <UITableViewDataSource, UITableViewDelegate, GTTablePartnerFootDelegate> {
    NSInteger iIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *routes;

- (void)reloadRoutes;
- (void)loadRoutesAtIndex:(NSInteger)index count:(NSInteger)count;
- (void)refreshMoreRoutes;

@end

@implementation RoutesViewController
#pragma mark - Non-Public Methods
- (void)reloadRoutes
{
    iIndex = 0;
    [self loadRoutesAtIndex:iIndex count:iCountRoutesPerRequest];
}

- (void)refreshMoreRoutes
{
    iIndex = self.routes.count;
    [self loadRoutesAtIndex:iIndex count:iCountRoutesPerRequest];
}

- (void)loadRoutesAtIndex:(NSInteger)index count:(NSInteger)count
{
    [self.model requestRouteListAtIndex:index
                                  count:count
                             completion:^(NSError *error, NSString *title, NSArray *routes) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                               }
                               else {
                                   self.title = title;
                                   NSMutableArray *indexesRemove = [NSMutableArray array];
                                   if (index == 0) {
                                       for (int iRow = 0; iRow < self.routes.count; iRow++) {
                                           [indexesRemove addObject:[NSIndexPath indexPathForRow:iRow inSection:0]];
                                       }
                                       self.routes = [NSMutableArray array];
                                   }
                                   else {
                                       UITableViewCell *refreshMoreCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.routes.count inSection:0]];
                                       refreshMoreCell.textLabel.text = RYIsValidArray(routes) ? @"加载成功!" : @"没有更多!";
                                   }
                                   NSMutableArray *indexesInsert = [NSMutableArray array];
                                   for (int i = 0; i < routes.count; i++) {
                                       [indexesInsert addObject:[NSIndexPath indexPathForRow:i + self.routes.count inSection:0]];
                                   }
                                   [self.routes addObjectsFromArray:routes];
                                   [self.tableView beginUpdates];
                                   [self.tableView deleteRowsAtIndexPaths:indexesRemove withRowAnimation:UITableViewRowAnimationFade];
                                   [self.tableView insertRowsAtIndexPaths:indexesInsert withRowAnimation:UITableViewRowAnimationFade];
                                   [self.tableView endUpdates];
                               }
                               [self.refreshView endRefresh];
                             }];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializedRefreshViewForView:self.tableView];
    [self reloadRoutes];

    GTTablePartnerFoot *footer = [[GTTablePartnerFoot alloc] init];
    footer.delegate = self;
    footer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, PaternerLogoHeight);
    self.tableView.tableFooterView = footer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routes.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row < self.routes.count) {
        GTravelRouteItem *routeItem = self.routes[indexPath.row];
        switch (routeItem.type) {
            case GTravelRouteTypeRecommend: {
                static NSString *cellIdentifier = @"GTRouteTableCell";
                GTRouteTableCell *routeCell = (GTRouteTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                cell = routeCell;
                break;
            }
            case GTRavelRouteTypeUGC: {
                static NSString *cellIdentifier = @"GTUGCRouteTableCell";
                GTUGCRouteTableCell *ugcRouteCell = (GTUGCRouteTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                cell = ugcRouteCell;
                break;
            }
        }
    }
    else {
        static NSString *cellIdentifier = @"TableViewMoreCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == self.routes.count ? 44 : [GTUGCRouteTableCell heightOfUGCRouteTableCell];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.routes.count) {
        GTravelRouteItem *item = self.routes[indexPath.row];
        switch (item.type) {
            case GTravelRouteTypeRecommend: {
                GTRouteTableCell *routeCell = (GTRouteTableCell *)cell;
                [routeCell setRouteItem:item];
                break;
            }
            case GTRavelRouteTypeUGC: {
                GTUGCRouteTableCell *ugcRouteCell = (GTUGCRouteTableCell *)cell;
                [ugcRouteCell setRouteItem:item];
                break;
            }
        }
    }
    else {
        cell.textLabel.text = @"加载更多...";
        [self refreshMoreRoutes];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.routes.count) {
        [self openRouteDetailOfRouteItem:self.routes[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.routes.count) {
        if ([cell respondsToSelector:@selector(resetCell)]) {
            [cell performSelector:@selector(resetCell)];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView scrollViewDidEndDraging];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView scrollViewDidScroll];
}
#pragma mark - SRRefreshViewDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadRoutes];
}

#pragma mark--- DTPartnerLogoDelegate
- (void)showLogoDetail:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showLogoDetailWithLeftButton:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    vc.setBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
