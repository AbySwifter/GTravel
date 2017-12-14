//
//  UserViewController.m
//  GTravel
//
//  Created by Raynay Yue on 4/30/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "UserViewController.h"
#import "AppDelegate.h"
#import "RYCommon.h"
#import "GTCommonStrings.h"
#import "GTUserTableCell.h"
#import "GTImageTableCell.h"
#import "GTravelUserItem.h"
#import "GTravelRouteItem.h"
#import "RouteDetailViewController.h"
#import "MineHotelController.h"
#import "GTravelNetDefinitions.h"
#import "NewRouteViewController.h"
#import "SendImageViewController.h"
#import "GTNavigationController.h"
#import "GTToolsSet.h"
#import "GTToolsItem.h"
#import "GTToolsWebViewController.h"
#import "GTUserCardsCell.h"

#define kCellTitle @"kCellTitle"
#define kCellImage @"kCellImage"
#define kCellType @"kCellType"

typedef NS_ENUM(NSInteger, GTCellType) {
    GTCellUserInfo,
    GTCellFavorite,
    GTCellMessage,
    GTCellLogout,
    //    GTCellHotel,
    //    GTCellCar,
    //    GTCellTax,
    GTCellCards
};

@interface UserViewController () <UITableViewDataSource, UITableViewDelegate, NewRouteViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *categories;

@property (nonatomic, strong) NSArray *arrTableData;

@property (nonatomic, strong) NSArray *itemsArray;

@property (nonatomic, copy) NSString *userRouteChangeTitle;

- (IBAction)onLogoutButton:(id)sender;
- (void)onRightBarButtonItem:(UIBarButtonItem *)sender;

- (void)initializedNavigationBarItems;

- (void)initializedTableData;

- (void)gotoUserRoute;
- (void)gotoFavorite;
- (void)gotoMessage;
- (void)gotoLogout;
- (void)gotoHotel;
- (void)gotoCar;
- (void)gotoTax;
- (void)gotoCards;

@end

@implementation UserViewController
#pragma mark - IBAction Methods
- (IBAction)onLogoutButton:(id)sender
{
    [self.model loginout];
    [self.navigationController popViewControllerAnimated:NO];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate showLoginViewAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAuto" object:nil];
}

- (void)onRightBarButtonItem:(UIBarButtonItem *)sender
{
}

#pragma mark - Non-Public Methods
- (void)initializedNavigationBarItems
{
    self.navigationItem.title = @"个人中心";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button addTarget:self action:@selector(onRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"bt_settings"];
    [button setImage:image forState:UIControlStateNormal];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}

- (void)initializedTableData
{
    NSDictionary *dictFavorite = @{ kCellTitle : TitleFavorite,
                                    kCellImage : IconNameFavorite,
                                    kCellType : @(GTCellFavorite) };
    NSDictionary *dictMessage = @{ kCellTitle : TitleMessage,
                                   kCellImage : IconNameMessage,
                                   kCellType : @(GTCellMessage) };
    NSArray *arr0 = @[ @{ kCellType : @(GTCellUserInfo) }, dictFavorite, dictMessage ];


    //    NSDictionary *dictHotel = @{kCellTitle : TitleHotel,
    //                                kCellImage : IconNameHotel,
    //                                kCellType : @(GTCellHotel)};
    //    NSDictionary *dictCar = @{kCellTitle : TitleCar,
    //                              kCellImage : IconNameCar,
    //                              kCellType : @(GTCellCar)};
    //    NSDictionary *dictTax = @{kCellTitle : TitleTax,
    //                              kCellImage : IconNameTax,
    //                              kCellType : @(GTCellTax)};

    NSDictionary *dictCard = @{ kCellTitle : TitleCards,
                                kCellImage : IconNameCards,
                                kCellType : @(GTCellCards) };
    NSArray *arr1 = @[ dictCard ];

    NSDictionary *dictLogout = @{ kCellTitle : TitleLogout,
                                  kCellImage : IconNameLogout,
                                  kCellType : @(GTCellLogout) };

    NSArray *arr2 = @[ dictLogout ];

    self.arrTableData = @[ arr0, arr1, arr2 ];
}

- (void)gotoUserRoute
{
    if (RYIsValidString(self.cacheUnit.lineID)) {
        RouteDetailViewController *controller = [[RouteDetailViewController alloc] init];
        controller.routeItem = self.model.userItem.routeBase;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        NewRouteViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewRouteViewController class])];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark--- newRouteViewControllerDelegte
- (void)newRouteViewControllerDidCreateNewRoute:(NewRouteViewController *)controller
{
}


- (void)gotoFavorite
{
    NSString *str = [NSString stringWithFormat:@"%@?userid=%@", self.model.userItem.userID, self.model.userItem.userID];

    GTWebViewController *vc = [[GTWebViewController alloc] init];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", GetAPIUrl(kUsersFavorite), str];
    vc.strURL = strURL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoMessage
{
    NSString *str = [NSString stringWithFormat:@"%@?userid=%@", self.model.userItem.userID, self.model.userItem.userID];

    GTWebViewController *vc = [[GTWebViewController alloc] init];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", GetAPIUrl(kUsersMessage), str];
    vc.strURL = strURL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoLogout
{
    [self onLogoutButton:nil];
}

- (void)gotoHotel
{
    RYCONDITIONLOG(DEBUG, @"");
}

- (void)gotoCar
{
    RYCONDITIONLOG(DEBUG, @"");
}

- (void)gotoTax
{
    RYCONDITIONLOG(DEBUG, @"");
}

- (void)gotoCards
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?userid=%@", GetAPIUrl(kUsersCards), self.model.userItem.userID, self.model.userItem.userID];
    GTWebViewController *cardsVC = [[GTWebViewController alloc] init];
    cardsVC.strURL = urlString;
    [self.navigationController pushViewController:cardsVC animated:YES];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化所有数据
    [self initializedNavigationBarItems];
    [self initializedTableData];
    [self requestTableData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserRouteDesc:) name:@"didChangeUserRouteDesc" object:nil];
}
- (void)updateUserRouteDesc:(NSNotification *) not
{
    NSString *title = not.userInfo[@"title"];
    self.userRouteChangeTitle = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)requestTableData
{
    if (!self.model.categories.count) {
        [self.model requestCategoryWithCompletion:^(NSError *error, NSArray *items) {
          if (RYIsValidArray(items)) {
              self.categories = items;
          }
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrTableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.arrTableData[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSArray *arr = self.arrTableData[indexPath.section];
    NSDictionary *dict = arr[indexPath.row];
    NSNumber *cellType = dict[kCellType];
    switch ([cellType integerValue]) {
        case GTCellUserInfo: {
            GTravelUserItem *userItem = self.model.userItem;
            GTUserTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"GTUserTableCell" forIndexPath:indexPath];
            UIImage *image = nil;
            if (RYIsValidString(userItem.localImageURL)) {
                image = [UIImage imageWithContentsOfFile:[userItem.localImageURL absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
                image = [UIImage circleImage:image withParam:0];
                if (self.userRouteChangeTitle) {
                    [tableCell setImage:image title:userItem.nickName subTitle:self.userRouteChangeTitle];
                }
                else {
                    [tableCell setImage:image title:userItem.nickName subTitle:userItem.routeBase.title];
                }
            }
            else {

                [self.model downloadUserItem:userItem
                                  completion:^(NSError *error, NSData *data) {
                                    UIImage *dataImage = [UIImage circleImage:[UIImage imageWithData:data] withParam:0];
                                    if (self.userRouteChangeTitle) {
                                        [tableCell setImage:dataImage title:userItem.nickName subTitle:self.userRouteChangeTitle];
                                    }
                                    else {
                                        [tableCell setImage:dataImage title:userItem.nickName subTitle:userItem.routeBase.title];
                                    }
                                  }];
            }


            cell = tableCell;
            break;
        }
        case GTCellCards: {
            GTUserCardsCell *cardsCell = [GTUserCardsCell cardsCellWithTableView:tableView];
            [cardsCell setImage:[UIImage imageNamed:dict[kCellImage]] title:dict[kCellTitle]];
            cell = cardsCell;

            break;
        }
        case GTCellLogout: {
            GTUserCardsCell *cardsCell = [GTUserCardsCell cardsCellWithTableView:tableView];
            [cardsCell setImage:[UIImage imageNamed:dict[kCellImage]] title:dict[kCellTitle]];
            cell = cardsCell;

            break;
        }
        default: {
            GTImageTableCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"GTImageTableCell" forIndexPath:indexPath];
            UIImage *image = [UIImage imageNamed:dict[kCellImage]];
            [imageCell setImage:image title:dict[kCellTitle]];
            cell = imageCell;
            break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSArray *arr = self.arrTableData[indexPath.section];
    NSDictionary *dict = arr[indexPath.row];
    NSNumber *cellType = dict[kCellType];
    switch ([cellType integerValue]) {
        case GTCellUserInfo:
            height = 100;
            break;
        default:
            height = 50;
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.arrTableData[indexPath.section];
    NSDictionary *dict = arr[indexPath.row];
    NSNumber *cellType = dict[kCellType];
    switch ([cellType integerValue]) {
        case GTCellUserInfo:
            [self gotoUserRoute];
            break;
        case GTCellFavorite:
            [self gotoFavorite];
            break;
        case GTCellMessage:
            [self gotoMessage];
            break;
        case GTCellLogout:
            [self gotoLogout];
            break;
        //        case GTCellHotel:
        //            [self gotoHotel];
        //            break;
        //        case GTCellCar:
        //            [self gotoCar];
        //            break;
        //        case GTCellTax:
        //            [self gotoTax];
        //            break;
        case GTCellCards:
            [self gotoCards];
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSMutableArray *itemsArray = [NSMutableArray array];
    for (int i = 0; i < self.toolsSetArray.count; i++) {
        GTToolsSet *set = self.toolsSetArray[i];
        for (GTToolsItem *item in set.toolsItemsArray) {
            [itemsArray addObject:item];
        }
    }
    self.itemsArray = itemsArray;
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendImage:) name:@"DIDCHOOSEIMAGECOMPLETION" object:nil];
}

- (void)sendImage:(NSNotification *)nt
{
    NSDictionary *info = nt.userInfo;
    SendImageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SendImageViewController class])];
    controller.image = info[UIImagePickerControllerEditedImage];
    controller.metadata = info[UIImagePickerControllerMediaMetadata];
    GTNavigationController *navController = [[GTNavigationController alloc] initWithRootViewController:controller];
    navController.navigationBar.barTintColor = [UIColor colorWithRed:204 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0];
    navController.navigationBar.tintColor = [UIColor whiteColor];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self.navigationController presentViewController:navController animated:YES completion:nil];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoUserRoute) name:@"DIDCOMPLECTIONNEWIMAGE" object:nil];
}

@end
