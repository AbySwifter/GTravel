//
//  DiscoveryViewController.m
//  GTravel
//
//  Created by Raynay Yue on 4/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "RYCommon.h"
#import "DTScrollView.h"
#import "GTRouteHeaderCell.h"
#import "GTToolItemsView.h"
#import "GTToolItemsCell.h"
#import "GTravelToolItem.h"
#import "GTravelCitiesCell.h"
#import "GTravelTownsCell.h"
#import "GTravelImageItem.h"
#import "GTRouteTableCell.h"
#import "GTUGCRouteTableCell.h"
#import "GTravelRouteItem.h"
#import "GTravelCityItem.h"
#import "GTravelUserItem.h"
#import "DTPartnerLogo.h"
#import "DTSubLogo.h"
#import "DTLogoViewController.h"
#import "DTSubLogoImage.h"
#import "GTTableViewCell.h"
#import "AFNetworking.h"
#import "GTravelNetDefinitions.h"
#import "GTToolsSet.h"
#import "GTToolsSetViewController.h"
#import "GTTablePartnerFoot.h"
#import "GTTownsCell.h"
#import "GTCitiesCell.h"
#import "UserViewController.h"


#define BannerSizeRatio (640.0 / 140.0)
#define PartnerLogoRatio (640.0 / 160.0)
#define CitiesRatio (640.0 / 210.0)
#define TownsRatio (640.0 / 100.0)
#define RouteCellImageRatio (600.0 / 300.0)

#define CellIndexToolItems 0
#define CellIndexCityHeader 1
#define CellIndexCities 2
#define CellIndexRouteHeader 5
#define CellIndexTownHeader 3
#define CellIndexTowns 4

#define CellRefreshMoreIndexCount 6

#define RouteCountPerRequest 20
#define CityCountPerRequest 6
#define TownCountPerRequest 3

#define PartnerLogoHeight 120

@interface DiscoveryViewController () <UITableViewDataSource, UITableViewDelegate, DTScrollViewDelegate, GTRouteHeaderCellDelegate, GTToolItemsViewDelegate, GTToolItemsCellDelegate, GTravelCitiesCellDelegate, DTPartnerLogoDelegate, DTSubLogoDelegate, GTravelTownsCellDelegate, GTTownsCellDelegate, GTCitiesCellDelegate, GTTablePartnerFootDelegate> {
    BOOL isBannerLoad;
    BOOL isTipsLoad;
    BOOL isCitiesLoad;
    BOOL isTownsLoad;
    BOOL isRoutesLoad;

    NSInteger iRouteIndex;
    NSInteger iRouteCount;

    NSInteger iCityIndex;
    NSInteger iCityCount;

    NSInteger iTownIndex;
    NSInteger iTownCount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *userCenterButton;
@property (nonatomic, strong) GTToolItemsView *toolItemsView;
@property (nonatomic, strong) NSArray *toolItems;
@property (nonatomic, strong) NSArray *banners;

@property (nonatomic, strong) NSMutableArray *toolsItemsArray;
@property (nonatomic, strong) NSMutableArray *toolsSetArray;

@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, copy) NSString *citiesTitle;

@property (nonatomic, strong) NSArray *towns;
@property (nonatomic, copy) NSString *townsTitle;

@property (nonatomic, strong) NSMutableArray *routes;
@property (nonatomic, copy) NSString *routesTitle;

@property (nonatomic, weak) DTScrollView *scrollView;

- (IBAction)onInGermanyButton:(UIBarButtonItem *)sender;
- (IBAction)onUserCenterButton:(UIBarButtonItem *)sender;

- (void)initializeTableView;
- (void)resetBannerViewWithBanners:(NSArray *)banners;
- (void)initializeNavigationBarItems;
- (void)updateUserHeadImage;
- (void)updateTipItemsIcons;
- (void)reloadAllData;

- (void)loadBanners;
//-(void)loadTips;
- (void)loadCities;
- (void)loadTowns;
- (void)loadRoutes;

- (void)refreshMoreRoutes;

- (void)gotoMoreCitiesView;
- (void)gotoMoreTownsView;
- (void)gotoMoreRoutesView;
//-(void)gotoMoreToolItemsView;

@end

@implementation DiscoveryViewController

- (NSMutableArray *)toolsItemsArray
{
    if (!_toolsItemsArray) {
        _toolsItemsArray = [NSMutableArray array];
    }
    return _toolsItemsArray;
}

- (NSMutableArray *)toolsArray
{
    if (!_toolsSetArray) {
        _toolsSetArray = [NSMutableArray array];
    }
    return _toolsSetArray;
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializedRefreshViewForView:self.tableView];
    [self initializeTableView];
    //    [self reloadAllData];
    [self initializeNavigationBarItems];
    self.title = @"发现";
    [self.tableView reloadData];
}


#pragma mark - IBAction Methods
- (IBAction)onInGermanyButton:(UIBarButtonItem *)sender
{
    if ([self.model.currentPlaceMark.country isEqualToString:@"中国"]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能在德国才可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        UIViewController *controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"InGermanyViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)onUserCenterButton:(UIBarButtonItem *)sender
{
    UserViewController *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];

    vc.toolsSetArray = self.toolsSetArray;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Non-Public Methods
- (void)initializeTableView
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    iRouteIndex = 0;
    iRouteCount = RouteCountPerRequest;

    iCityIndex = 0;
    iCityCount = CityCountPerRequest;

    iTownIndex = 0;
    iTownCount = TownCountPerRequest;

    self.banners = self.cacheUnit.banners;
    //    self.toolItems = [self.cacheUnit.tipItems firstObject];
    self.cities = self.cacheUnit.cities;
    self.citiesTitle = self.cacheUnit.titleOfCities;

    self.towns = self.cacheUnit.towns;
    self.townsTitle = self.cacheUnit.titleOfTowns;

    self.routes = [NSMutableArray arrayWithArray:self.cacheUnit.routes];
    self.routesTitle = self.cacheUnit.titleOfRoutes;

    CGRect scrollRect = CGRectMake(0, 0, RYWinRect().size.width, RYWinRect().size.width / BannerSizeRatio);
    CGRect partnerLogoRect = CGRectMake(0, RYWinRect().size.width / BannerSizeRatio, RYWinRect().size.width, RYWinRect().size.width / PartnerLogoRatio);
    CGRect subLogoRect = CGRectMake(0, RYWinRect().size.width / BannerSizeRatio + RYWinRect().size.width / PartnerLogoRatio, RYWinRect().size.width, RYWinRect().size.width / BannerSizeRatio);

    CGRect headerRect = CGRectMake(0, 0, RYWinRect().size.width, RYWinRect().size.width / BannerSizeRatio * 2 + RYWinRect().size.width / PartnerLogoRatio);
    // 头部视图
    UIView *header = [[UIView alloc] initWithFrame:headerRect];
    // 滚动视图
    DTScrollView *scrollView = [DTScrollView scrollViewWithFrame:scrollRect delegate:self scrollForever:YES];
    // Partnerlogo
    DTPartnerLogo *partnerLogo = [[DTPartnerLogo alloc] initWithFrame:partnerLogoRect];
    partnerLogo.delegate = self;
    DTSubLogo *subLogo = [[DTSubLogo alloc] initWithFrame:subLogoRect];
    subLogo.delegate = self;

    [header addSubview:subLogo];
    [header addSubview:scrollView];
    [header addSubview:partnerLogo];
    self.scrollView = scrollView;
    self.tableView.tableHeaderView = header;

    GTTablePartnerFoot *footer = [[GTTablePartnerFoot alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - PartnerLogoHeight, [UIScreen mainScreen].bounds.size.width, PartnerLogoHeight)];
    footer.delegate = self;

    self.tableView.tableFooterView = footer;

    [self resetBannerViewWithBanners:self.banners];
    // 添加头部
    [self loadBanners];
//        [self loadTips];
    [self loadTools];
    [self loadCities];
    [self loadTowns];
    [self loadRoutes];
}

// pagecontrol
- (void)resetBannerViewWithBanners:(NSArray *)banners
{
    NSMutableArray *paths = [NSMutableArray array];
    for (GTBannerImage *item in banners) {
        NSString *path = RYIsValidString(item.localImagePath) ? [item.localImagePath absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] : item.imageURL;
        [paths addObject:path];
    }

    if (RYIsValidArray(paths)) {
        [self.scrollView setAutoScrollEnabled:NO];
        [self.scrollView setImageWithPaths:paths defaultImage:[UIImage imageNamed:@"bg_default_banner"] pageIndicatorPosition:DTPageControlPositionRight];
        [self.scrollView setAutoScrollEnabled:YES];
    }
}

- (void)initializeNavigationBarItems
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"bt_location"];
    imageView.contentMode = UIViewContentModeLeft;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"在德国";
    label.backgroundColor = [UIColor clearColor];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:imageView];
    [view addSubview:label];
    UIButton *bt = [[UIButton alloc] initWithFrame:view.bounds];
    [bt addTarget:self action:@selector(onInGermanyButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bt];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    [self.navigationItem setLeftBarButtonItem:barButton];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button addTarget:self action:@selector(onUserCenterButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"default_user_icon"];
    [button setImage:image forState:UIControlStateNormal];

    image = [UIImage imageNamed:@"default_user_icon_highlighted"];
    [button setImage:image forState:UIControlStateHighlighted];

    barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barButton];
    self.userCenterButton = button;
}

- (void)updateUserHeadImage
{
    if (RYIsValidString(self.model.userItem.localImageURL)) {
        UIImage *image = [UIImage imageWithContentsOfFile:[self.model.userItem.localImageURL absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
        image = [UIImage circleImage:image withParam:0];
        [self.userCenterButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)updateTipItemsIcons
{
    for (GTravelToolItem *item in self.toolItems) {
        [self.model downloadToolItem:item
                          completion:^(NSError *error, NSData *data) {
                            if (error) {
                                RYCONDITIONLOG(DEBUG, @"%@", error);
                            }
                            else
                                [[NSNotificationCenter defaultCenter] postNotificationName:GTravelNotificationToolItemImageDidLoad object:item];
                          }];
    }
}

- (void)reloadAllData
{
    [self loadBanners];
    //    [self loadTips];
    [self loadTools];
    [self loadCities];
#pragma mark--- copy
    [self loadTowns];
    iRouteIndex = 0;
    [self loadRoutes];

    [self.tableView reloadData];
}

- (void)loadBanners
{
    isBannerLoad = NO;
    [self.model requestBannersWithCompletion:^(NSArray *images) {
      self.banners = images;
      [self resetBannerViewWithBanners:images];
      isBannerLoad = YES;
      if (isTipsLoad) {
          [self.refreshView endRefresh];
      }
    }];
}

- (void)loadTools
{
    isTipsLoad = NO;

    NSString *URLString = GetAPIUrl(API_Tools);
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
		NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
			if (connectionError) {
				NSLog(@"请求失败,error = %@", connectionError);
			}
			else {
				NSError *error;
				NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
				if (error) {
					NSLog(@"解析出错, error = %@", error);
				}
				else {
					NSMutableArray *setDictArray = [dict objectForKey:kTools];
					NSMutableArray *array = [NSMutableArray array];
					for (NSDictionary *dict in setDictArray) {
						// 每一个字典转成tools集合模型（字典）,里面存放它的属性和toolsItem的数组
						GTToolsSet *toolsSet = [GTToolsSet toolsSetWithDict:dict];
						[array addObject:toolsSet];
					}
					self.toolsSetArray = array;
					dispatch_async(dispatch_get_main_queue(), ^{
						[self.tableView reloadData];
					});
				}
			}
		}];
		[task resume];
	}];
	[queue addOperation:operation];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:queue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if (connectionError) {
//                                 NSLog(@"请求失败,error = %@", connectionError);
//                             }
//                             else {
//                                 NSError *error;
//                                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//                                 if (error) {
//                                     NSLog(@"解析出错, error = %@", error);
//                                 }
//                                 else {
//                                     NSMutableArray *setDictArray = [dict objectForKey:kTools];
//                                     NSMutableArray *array = [NSMutableArray array];
//                                     for (NSDictionary *dict in setDictArray) {
//                                         // 每一个字典转成tools集合模型（字典）,里面存放它的属性和toolsItem的数组
//                                         GTToolsSet *toolsSet = [GTToolsSet toolsSetWithDict:dict];
//                                         [array addObject:toolsSet];
//                                     }
//                                     self.toolsSetArray = array;
//                                     [self.tableView reloadData];
//                                 }
//                             }
//                           }];
    isTipsLoad = YES;
    if (isBannerLoad) {
        [self.refreshView endRefresh];
    }
}

- (void)loadCities
{
    [self.model requestCityListAtIndex:iCityIndex
                                 count:iCityCount
                            completion:^(NSError *error, NSString *title, NSArray *cities) {
                              if (error) {
                                  RYCONDITIONLOG(DEBUG, @"%@", error);
                              }
                              else {
                                  self.cities = cities;
                                  self.citiesTitle = title;
                                  [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:CellIndexCityHeader inSection:0], [NSIndexPath indexPathForRow:CellIndexCities inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
                              }
                            }];
}

#pragma mark--- copy
- (void)loadTowns
{
    [self.model requestTownListAtIndex:iTownIndex
                                 count:iTownCount
                            completion:^(NSError *error, NSString *title, NSArray *towns) {
                              if (error) {
                                  RYCONDITIONLOG(DEBUG, @"%@", error);
                              }
                              else {
                                  self.towns = towns;
                                  self.townsTitle = title;
                                  [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:CellIndexTownHeader inSection:0], [NSIndexPath indexPathForRow:CellIndexTowns inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
                              }
                            }];
}

- (void)loadRoutes
{
    [self.model requestRouteListAtIndex:iRouteIndex
                                  count:iRouteCount
                             completion:^(NSError *error, NSString *title, NSArray *routes) {
                               if (error) {
                                   RYCONDITIONLOG(DEBUG, @"%@", error);
                               }
                               else {
                                   self.routesTitle = title;
                                   [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:CellIndexRouteHeader inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
                                   NSMutableArray *indexPathesRemove = [NSMutableArray array];
                                   if (iRouteIndex == 0) {
                                       for (int i = 0; i < self.routes.count; i++) {
                                           [indexPathesRemove addObject:[NSIndexPath indexPathForRow:CellIndexRouteHeader + 1 + i inSection:0]];
                                       }
                                       self.routes = [NSMutableArray array];
                                   }
                                   else {
                                       GTTableViewCell *moreCell = (GTTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.routes.count + CellRefreshMoreIndexCount inSection:0]];

                                       //                NSLog(@"%d",[NSThread currentThread]);
                                       moreCell.textLabel.text = RYIsValidArray(routes) ? @"加载成功!" : @"没有更多!";
                                   }
                                   NSInteger rowStartIndex = self.routes.count + CellIndexRouteHeader + 1;
                                   NSMutableArray *indexPathes = [NSMutableArray array];
                                   for (int i = 0; i < routes.count; i++) {
                                       [indexPathes addObject:[NSIndexPath indexPathForRow:rowStartIndex + i - 1 inSection:0]];
                                   }
                                   [self.routes addObjectsFromArray:routes];
                                   [self.tableView beginUpdates];
                                   [self.tableView deleteRowsAtIndexPaths:indexPathesRemove withRowAnimation:UITableViewRowAnimationFade];
                                   [self.tableView insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationFade];
                                   [self.tableView endUpdates];
                               }
                             }];
}

- (void)refreshMoreRoutes
{
    iRouteIndex = self.routes.count;
    RYCONDITIONLOG(DEBUG, @"%d", (int)self.routes.count);
    [self loadRoutes];
}
/**********************/

- (void)gotoMoreCitiesView
{
    [self performSegueWithIdentifier:@"PushToCities" sender:nil];
}
#pragma mark--- copy
- (void)gotoMoreTownsView
{
    [self performSegueWithIdentifier:@"PushToTowns" sender:nil];
}

- (void)gotoMoreRoutesView
{
    [self performSegueWithIdentifier:@"PushToRoutes" sender:nil];
}

//-(void)gotoMoreToolItemsView
//{
//    [self performSegueWithIdentifier:@"PushTipListView" sender:nil];
//}

- (void)userHeadImageDidUpdateNotification:(NSNotification *)notification
{
    NSData *data = (NSData *)[notification object];
    UIImage *image = [UIImage imageWithData:data];
    image = [UIImage circleImage:image withParam:0];
    [self.userCenterButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routes.count + CellRefreshMoreIndexCount + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case CellIndexToolItems: {
            static NSString *toolItemCellIdentifier = @"GTToolItemsCell";
            //            cell = [tableView dequeueReusableCellWithIdentifier:toolItemCellIdentifier forIndexPath:indexPath];
            //            [(GTToolItemsCell*)cell setCellContentWithItems:self.toolItems delegate:self];

            cell = [tableView dequeueReusableCellWithIdentifier:toolItemCellIdentifier forIndexPath:indexPath];
            [(GTToolItemsCell *)cell setContentWithToolsSetArray:self.toolsSetArray delegate:self];


            break;
        }
        case CellIndexCities: {
            //            static NSString *travelCitiesCellIdentifier = @"GTravelCitiesCell";
            //            cell = [tableView dequeueReusableCellWithIdentifier:travelCitiesCellIdentifier forIndexPath:indexPath];
            //            [(GTravelCitiesCell*)cell setCityItems:self.cities];
            //            [(GTravelCitiesCell*)cell setDelegate:self];
            //            break;
            cell = [[GTCitiesCell alloc] init];
            [(GTCitiesCell *)cell setCityItems:self.cities];
            [(GTCitiesCell *)cell setDelegate:self];
            break;
        }
#pragma mark--- copy
        case CellIndexTowns: {
            //            static NSString *travelTownsCellIdentifier = @"GTravelTownsCell";
            //            cell = [tableView dequeueReusableCellWithIdentifier:travelTownsCellIdentifier forIndexPath:indexPath];
            //            [(GTravelTownsCell*)cell setTownsItems:self.towns];
            //            [(GTravelTownsCell*)cell setDelegate:self];
            //            break;
            cell = [[GTTownsCell alloc] init];
            [(GTTownsCell *)cell setTownsItems:self.towns];
            [(GTTownsCell *)cell setDelegate:self];
            break;
        }
        case CellIndexCityHeader:
        case CellIndexTownHeader:
        case CellIndexRouteHeader: {
            static NSString *routeHeaderCellIdentifier = @"GTRouteHeaderCell";
            GTRouteHeaderCell *headerCell = (GTRouteHeaderCell *)[tableView dequeueReusableCellWithIdentifier:routeHeaderCellIdentifier forIndexPath:indexPath];

            if (indexPath.row == CellIndexCityHeader) {
                [headerCell setDelegate:self title:self.citiesTitle];
                [headerCell setBackgroundColor:[UIColor whiteColor]];
            }
            else if (indexPath.row == CellIndexTownHeader) {
                [headerCell setDelegate:self title:self.townsTitle];
                [headerCell setBackgroundColor:[UIColor whiteColor]];
            }
            else {
                [headerCell setDelegate:self title:self.routesTitle];
                [headerCell setBackgroundColor:[UIColor clearColor]];
            }
            cell = headerCell;
            break;
        }
        default: {
            if (indexPath.row == self.routes.count + CellRefreshMoreIndexCount) {
                static NSString *moreCelIdentifier = @"TableViewMoreCell";
                cell = [tableView dequeueReusableCellWithIdentifier:moreCelIdentifier];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
            }
            else {
                GTravelRouteItem *item = self.routes[indexPath.row - 6];

                if (item.type == GTravelRouteTypeRecommend) {
                    static NSString *routeTableCellIdentifier = @"GTRouteTableCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:routeTableCellIdentifier forIndexPath:indexPath];
                    GTRouteTableCell *routeCell = (GTRouteTableCell *)cell;
                    [routeCell setRouteItem:item];
                }
                else {
                    static NSString *ugcRouteCellIdentifier = @"GTUGCRouteTableCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:ugcRouteCellIdentifier forIndexPath:indexPath];
                    GTUGCRouteTableCell *routeCell = (GTUGCRouteTableCell *)cell;
                    [routeCell setRouteItem:item];
                }
                break;
            }
        }
    }
    return cell;
}
#pragma mark--- copy
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == CellIndexCityHeader) {
        [self gotoMoreCitiesView];
    }
    else if (indexPath.row == CellIndexTownHeader) {
        [self gotoMoreTownsView];
    }
    else if (indexPath.row == CellIndexRouteHeader) {
        [self gotoMoreRoutesView];
    }
    else if (indexPath.row >= 6 && indexPath.row < self.routes.count + CellRefreshMoreIndexCount) {
        GTravelRouteItem *item = self.routes[indexPath.row - 6];
        [self openRouteDetailOfRouteItem:item];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fHeight = 0;
    if (indexPath.row == self.routes.count + CellRefreshMoreIndexCount) {
        fHeight = 44;
    }
    else {
        switch (indexPath.row) {
            case CellIndexToolItems:
                fHeight = RYWinRect().size.width / fToolItemsViewRatio;
                break;
            case CellIndexCities:
                fHeight = RYWinRect().size.width / CitiesRatio;
                break;

            case CellIndexTowns:
                //                fHeight = RYWinRect().size.width/TownsRatio;
                fHeight = 70;
                break;
            case CellIndexCityHeader:
            case CellIndexTownHeader:
            case CellIndexRouteHeader:
                fHeight = 40;
                break;
            default:
                fHeight = [GTUGCRouteTableCell heightOfUGCRouteTableCell];
                break;
        }
    }
    return fHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.routes.count + CellRefreshMoreIndexCount) {
        cell.textLabel.text = @"加载更多...";
        [self refreshMoreRoutes];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 5 && indexPath.row < self.routes.count + CellRefreshMoreIndexCount) {
        if (RYIsValidArray(self.routes)) {
            if ([cell respondsToSelector:@selector(resetCell)]) {
                [cell performSelector:@selector(resetCell)];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.y < self.tableView.tableHeaderView.frame.size.height) {
        self.toolItemsView.hidden = NO;
    }
    else {
        self.toolItemsView.hidden = NO;
    }

    [self.refreshView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView scrollViewDidEndDraging];
}

#pragma mark - GTRouteHeaderCellDelegate
// 点击箭头跳转
- (void)routeHeaderCell:(GTRouteHeaderCell *)cell didClickMoreButton:(UIButton *)sender
{
    if ([cell.titleLabel.text isEqualToString:self.citiesTitle]) {
        [self gotoMoreCitiesView];
    }
    else if ([cell.titleLabel.text isEqualToString:self.townsTitle]) {
        [self gotoMoreTownsView];
    }
    else
        [self gotoMoreRoutesView];
}

#pragma mark - GTToolItemsCellDelegate
- (void)itemsCell:(GTToolItemsCell *)itemsCell didSelectItemAtIndex:(NSInteger)index
{
    GTToolsSetViewController *vc = [[GTToolsSetViewController alloc] init];
    // 将安排行程整个数组传过去，数组里装得都是toolsItem
    GTToolsSet *toolsSet = self.toolsSetArray[index];

    vc.toolsItemsArray = toolsSet.toolsItemsArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GTravelCitiesCellDelegate
- (void)citiesCell:(GTravelCitiesCell *)cell didClickCityAtIndex:(NSInteger)index
{
    if (index < self.cities.count) {
        [self openCityDetailOfCityItem:self.cities[index]];
    }
}

#pragma mark - GTravelTownsCellDelegate
- (void)townsCell:(GTravelTownsCell *)cell didClickTownAtIndex:(NSInteger)index
{
    if (index < self.towns.count) {
        [self openTownDetailOfTownItem:self.towns[index]];
    }
}

#pragma mark - GTCitiesCellDelegate
- (void)citiesCell:(GTCitiesCell *)cell didClickCityButton:(NSInteger)button
{
    [self openCityDetailOfCityItem:self.cities[button]];
}

#pragma mark - GTTownsCellDelegate
- (void)townsCell:(GTTownsCell *)cell didClickTownButton:(NSInteger)button
{
    [self openTownDetailOfTownItem:self.towns[button]];
}

#pragma mark - SRRefreshDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadAllData];
}

#pragma mark - DTScrollViewDelegate

- (void)scrollViewDidScrollToEnd:(DTScrollView *)scrollView
{
}

- (void)scrollView:(DTScrollView *)scrollView didClickImageAtIndex:(NSInteger)index
{
    RYCONDITIONLOG(DEBUG, @"%d", (int)index);
    GTravelImageItem *item = self.banners[index];
    [self openWebDetailViewOfURL:item.detailURL];
}

- (void)scrollView:(DTScrollView *)scrollView didUpdateImageData:(NSData *)data atIndex:(NSInteger)index
{
    GTBannerImage *item = self.banners[index];
    [self.cacheUnit saveImageData:data forImageItem:item];
}

#pragma mark--- DTPartnerLogoDelegate
- (void)showLogoViewDetail:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    [self.navigationController pushViewController:vc animated:YES];
}

// 汉莎
- (void)showLogoViewDetailWithLeftBtn:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    vc.setBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--- DTSubLogoDelegate
- (void)logoImageDidClicked:(DTSubLogoImage *)logoImage
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = logoImage.linkURL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:204 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    [super viewWillAppear:animated];
}

#pragma mark---
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
