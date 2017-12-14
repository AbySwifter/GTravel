//
//  InGermanyViewController.m
//  GTravel
//
//  Created by Raynay Yue on 4/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "InGermanyViewController.h"
#import "RYCommon.h"
#import "GTTipsView.h"
#import "GTInGermanyHeaderCell.h"
#import "GTAroundTableCell.h"
//#import "GTRecentUserCell.h"
#import "MBProgressHUD.h"
#import "NewRouteViewController.h"
#import "TipListViewController.h"
#import "AroundViewController.h"
#import "SendImageViewController.h"
#import "GTNavigationController.h"
#import "UserListViewController.h"
#import "GTAroundUsersCell.h"
#import "AFNetworking.h"
#import "GTravelNetDefinitions.h"
#import "GTToolsSet.h"
#import "GTToolsItem.h"
#import "GTEightToolCell.h"
#import "GTTipsView.h"
#import "GTTablePartnerFoot.h"
#import "GTEightToolBtnView.h"
#import "GTToolsWebViewController.h"
#import "GTFourSetViewController.h"
#import "DTLogoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UserViewController.h"
#import "RouteDetailViewController.h"
#import "GTUserRouteViewController.h"

#define DefaultRequestCount 3

#define TagTakePhotoFromCameraButton 0
#define TagTakePhotoFromAlbumButton 1

typedef NS_ENUM(NSInteger, GTAroundCellType) {
    GTAroundCellTypeUserHead = 0,
    GTAroundCellTypeCategory,
    //    GTAroundCellTypeRecentUsers,
    GTAroundCellTypeAroundUsers,
    //    GTAroundCellTypeTips
    GTAroundCellTypeEightTool

};

@interface InGermanyViewController () <UITableViewDataSource, UITableViewDelegate, GTInGermanyHeaderCellDelegate, GTAroundTableCellDelegate, NewRouteViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GTEightToolCellDelegate, GTAroundUsersCellDelegate, GTTablePartnerFootDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomCameraView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomButtonContainerView;
@property (weak, nonatomic) IBOutlet UIView *cameraViewContainer;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (nonatomic, strong) NSMutableArray *tableCellTypes;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *fourSets;

@property (nonatomic, strong) NSArray *recentUsers;
@property (nonatomic, strong) NSArray *tips;


@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;


@property (nonatomic, strong) NSArray *aroundUsers;
@property (nonatomic, strong) NSArray *toolsTempArray;
@property (nonatomic, strong) NSMutableArray *toolsSetArray;
@property (nonatomic, strong) NSMutableArray *eightTool;

@property (nonatomic, weak) UIView *bottomView;

- (IBAction)onCameraButton:(UIButton *)sender;
- (IBAction)onMaskBackgroundButton:(UIButton *)sender;

- (void)initializedTableView;
- (void)initializedTableData;
- (void)initializedMaskView;
- (void)requestTableData;
- (void)updateTableViewDataAfterRequestCompletion:(NSNumber *)num;

- (void)showBottomCameraView:(BOOL)show animated:(BOOL)animated;
- (void)showPhotosChoosingView:(BOOL)show animated:(BOOL)animated;

- (void)takePhotoFromCamera;
- (void)takePhotoFromAlbum;
- (void)gotoUserCenter;
- (void)gotoUserRoute;
- (void)gotoAroundWithCategory:(GTCategory *)category;
- (void)gotoSendImageViewWithImageInfo:(NSDictionary *)info;

@end

@implementation InGermanyViewController

- (NSMutableArray *)eightTool
{
    if (!_eightTool) {
        _eightTool = [NSMutableArray array];
    }
    return _eightTool;
}

- (NSMutableArray *)toolsSetArray
{
    if (!_toolsSetArray) {
        _toolsSetArray = [NSMutableArray array];
    }
    return _toolsSetArray;
}

- (NSArray *)toolsTempArray
{
    if (!_toolsTempArray) {
        _toolsTempArray = [NSArray array];
    }
    return _toolsTempArray;
}
#pragma mark - IBAction Methods
- (IBAction)onCameraButton:(UIButton *)sender
{
    if (RYIsValidString(self.cacheUnit.lineID)) {
        [self showPhotosChoosingView:YES animated:YES];
    }
    else {
        NewRouteViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewRouteViewController class])];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didClickRedBottom:(UIButton *)button
{
    self.bottomView.hidden = YES;
    if (RYIsValidString(self.cacheUnit.lineID)) {
        [self showPhotosChoosingView:YES animated:YES];
    }
    else {
        NewRouteViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewRouteViewController class])];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 点击照相后，点击背景图案片取消调用
- (IBAction)onMaskBackgroundButton:(UIButton *)sender
{
    [self showPhotosChoosingView:NO animated:YES];
}

#pragma mark - Non-Public Methods
- (void)initializedTableView
{
}

- (void)initializedTableData
{
    self.tableCellTypes = [NSMutableArray arrayWithObject:@(GTAroundCellTypeUserHead)];
    [self.tableView reloadData];
    [self requestTableData];
}

#define ImageSizeWidth 100
#define ImageDistance 40
#define HeightButtonContainer 140
#define HeightLabel 0
#define PartnerLogoHeight 120

- (void)initializedMaskView
{
    self.maskView.frame = self.view.bounds;

    CGFloat fX = RYWinRect().size.width * 0.5 - ImageSizeWidth - ImageDistance * 0.5;
    CGFloat fY = (HeightButtonContainer - HeightLabel - ImageSizeWidth) * 0.5;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(fX, fY, ImageSizeWidth, ImageSizeWidth);
    button.tag = TagTakePhotoFromCameraButton;
    [button addTarget:self action:@selector(takePhotoFromCamera) forControlEvents:UIControlEventTouchUpInside];

    UIImage *image = [UIImage imageNamed:@"bt_camera2"];
    [button setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"bt_camera2_hl"];
    [button setImage:image forState:UIControlStateHighlighted];

    [self.buttonContainerView addSubview:button];

    CGFloat fX1 = fX + ImageDistance + ImageSizeWidth;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(fX1, fY, ImageSizeWidth, ImageSizeWidth);
    button.tag = TagTakePhotoFromAlbumButton;
    [button addTarget:self action:@selector(takePhotoFromAlbum) forControlEvents:UIControlEventTouchUpInside];

    image = [UIImage imageNamed:@"bt_album"];
    [button setImage:image forState:UIControlStateNormal];

    image = [UIImage imageNamed:@"bt_album_hl"];
    [button setImage:image forState:UIControlStateHighlighted];
    [self.buttonContainerView addSubview:button];
}

- (void)requestTableData
{
    [self.model requestCategoryWithCompletion:^(NSError *error, NSArray *items) {
      if (RYIsValidArray(items)) {
          self.categories = items;
          [self updateTableViewDataAfterRequestCompletion:@(GTAroundCellTypeCategory)];
      }
    }];
    //    [self.model requestRecentUsersWithCompletion:^(NSError *error, NSArray *users) {
    //        if(RYIsValidArray(users)){
    //
    //            NSLog(@"%@",users);
    //
    //            self.aroundUsers = users;
    //            [self updateTableViewDataAfterRequestCompletion:@(GTAroundCellTypeAroundUsers)];
    //        }
    //    }];

    [self.model requestAroundUsersWithFiler:nil
                                        sex:GTFilterSexAll
                                 completion:^(NSError *error, NSArray *users) {
                                   if (RYIsValidArray(users)) {
                                       self.aroundUsers = users;
                                       [self updateTableViewDataAfterRequestCompletion:@(GTAroundCellTypeAroundUsers)];
                                   }
                                 }];

    [self.model requestFourSetsWithCompletion:^(NSError *error, NSArray *fourSets) {
      if (RYIsValidArray(fourSets)) {

          self.fourSets = fourSets;

          [self updateTableViewDataAfterRequestCompletion:@(GTAroundCellTypeEightTool)];
      }
    }];
}

- (void)updateTableViewDataAfterRequestCompletion:(NSNumber *)num
{
    int iIndex = 0;
    for (int i = 0; i < self.tableCellTypes.count; i++) {
        NSNumber *n = self.tableCellTypes[i];
        if ([n integerValue] == [num integerValue]) {
            iIndex = i;
            break;
        }
    }

    if (iIndex > 0) {
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:iIndex inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        iIndex = (int)[num integerValue];
        if (self.tableCellTypes.count > iIndex) {
            [self.tableCellTypes insertObject:num atIndex:iIndex];
        }
        else {
            iIndex = (int)self.tableCellTypes.count;
            [self.tableCellTypes addObject:num];
        }
        [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:iIndex inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
    }

    [self.refreshView endRefresh];
}

- (void)showBottomCameraView:(BOOL)show animated:(BOOL)animated
{
    self.bottomView.hidden = show ? 0 : -self.cameraViewContainer.frame.size.height;

    self.cameraViewContainer.layer.cornerRadius = 3.0;
    self.layoutBottomCameraView.constant = show ? 0 : -self.cameraViewContainer.frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{
                           [self.cameraViewContainer layoutIfNeeded];
                         }];
    }
    else
        [self.cameraViewContainer layoutIfNeeded];
}

- (void)showPhotosChoosingView:(BOOL)show animated:(BOOL)animated
{
    self.layoutBottomButtonContainerView.constant = show ? 0 : -self.buttonContainerView.frame.size.height;
    if (animated) {
        self.maskView.hidden = NO;
        self.maskView.alpha = show ? 0.0 : 0.7;
        [UIView animateWithDuration:0.5
            animations:^{
              self.maskView.alpha = show ? 0.7 : 0.0;
              [self.buttonContainerView layoutIfNeeded];
            }
            completion:^(BOOL finished) {
              self.maskView.hidden = !show;
            }];
    }
    else {
        self.maskView.hidden = !show;
        [self.buttonContainerView layoutIfNeeded];
    }
}

- (void)takePhotoFromCamera
{
    [self showPhotosChoosingView:NO animated:YES];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        imagePicker.navigationBar.barTintColor = [UIColor colorWithRed:204 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0];
        imagePicker.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
    }
    else {
        RYShowAlertView(@"错误", @"相机不可用!", nil, 0, @"我知道了.", nil, nil);
    }
}
// 使用照相机拍摄照片上传
- (void)takePhotoFromAlbum
{
    [self showPhotosChoosingView:NO animated:YES];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        imagePicker.navigationBar.barTintColor = [UIColor colorWithRed:204 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0];
        imagePicker.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
    }
    else {
        RYShowAlertView(@"错误", @"相簿不可用!", nil, 0, @"我知道了.", nil, nil);
    }
}
// 跳转个人中心
- (void)gotoUserCenter
{
    UserViewController *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];

    vc.toolsSetArray = self.fourSets;

    [self.navigationController pushViewController:vc animated:YES];
}

// 跳转周边的人数据页
- (void)gotoAroundWithCategory:(GTCategory *)category
{
    AroundViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AroundViewController class])];
    controller.category = category;
    [self.navigationController pushViewController:controller animated:YES];
}

// 跳转去过该城市的人列表
- (void)gotoUsersWithTitle:(NSString *)title cellType:(BOOL)cellType
{
    UserListViewController *controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserListViewController class])];
    controller.users = self.aroundUsers;
    controller.cellType = cellType;
    controller.showTitle = title;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoSendImageViewWithImageInfo:(NSDictionary *)info
{
    SendImageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SendImageViewController class])];
    controller.image = info[UIImagePickerControllerEditedImage];
    controller.metadata = info[UIImagePickerControllerMediaMetadata];
    GTNavigationController *navController = [[GTNavigationController alloc] initWithRootViewController:controller];
    navController.navigationBar.barTintColor = [UIColor colorWithRed:204 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController presentViewController:navController animated:YES completion:NULL];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"在德国";
    self.view.backgroundColor = [UIColor colorWithRed:239.0 / 255.0 green:239.0 / 255.0 blue:239.0 / 255.0 alpha:1];
    [self initializedRefreshViewForView:self.tableView];
    [self initializedTableData];
    [self initializedMaskView];
    [self showBottomCameraView:NO animated:NO];
    [self showPhotosChoosingView:NO animated:NO];
    [self setupPartnerFoot];
    [self setupRedBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoUserRoute) name:@"DIDCOMPLECTIONNEWIMAGE" object:nil];
}

//跳转个人行程页
- (void)gotoUserRoute
{
    RouteDetailViewController *controller = [[RouteDetailViewController alloc] init];
    controller.routeItem = self.model.userItem.routeBase;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  底部logo
 */
- (void)setupPartnerFoot
{
    GTTablePartnerFoot *foot = [[GTTablePartnerFoot alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, PartnerLogoHeight)];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, PartnerLogoHeight + 44)];
    foot.delegate = self;
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:foot];

    self.tableView.tableFooterView = footerView;
}

/**
 *  底部红色相机
 */
- (void)setupRedBottomView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44 - 64, [UIScreen mainScreen].bounds.size.width, 44)];
    view.layer.cornerRadius = 3.0;
    view.backgroundColor = [UIColor colorWithRed:201.0 / 255.0 green:0 blue:15.0 / 255.0 alpha:1];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat w = (view.frame.size.height - 14) / 3 * 4;
    CGFloat h = view.frame.size.height - 14;
    btn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - w) / 2, 7, w, h);
    btn.imageView.contentMode = UIViewContentModeCenter;
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_camera"] forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn addTarget:self action:@selector(didClickRedBottom:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:view];
    self.bottomView = view;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, view.frame.size.height, 0);
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
    switch ([num integerValue]) {
        case GTAroundCellTypeUserHead: {

            GTInGermanyHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"GTInGermanyHeaderCell" forIndexPath:indexPath];
            NSLog(@"%@", self.model.currentPlaceMark.country);
            NSLog(@"%@", self.model.currentPlaceMark.locality);

            NSString *location = [NSString stringWithFormat:@"%@  %@", self.model.currentPlaceMark.country, self.model.currentPlaceMark.locality];

            if (RYIsValidString(location) && location != nil && !([location rangeOfString:@"null"].length > 0)) {
                [headerCell setUserItem:self.model.userItem welcomeMessage:location delegate:self];
            }
            else {
                [headerCell setUserItem:self.model.userItem welcomeMessage:nil delegate:self];
            }
            cell = headerCell;
            break;
        }
        case GTAroundCellTypeCategory: {
            GTAroundTableCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"GTAroundTableCell" forIndexPath:indexPath];
            [tableCell setCategoryItems:self.categories delegate:self];
            cell = tableCell;
            break;
        }
        //        case GTAroundCellTypeRecentUsers:{
        //            GTRecentUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"GTRecentUserCell" forIndexPath:indexPath];
        //            [userCell setUserItems:self.recentUsers delegate:self];
        //            cell = userCell;
        //            break;
        //        }
        case GTAroundCellTypeAroundUsers: {
            GTAroundUsersCell *aroundUsersCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GTAroundUsersCell class]) forIndexPath:indexPath];
            aroundUsersCell.delegate = self;
            [aroundUsersCell setAroundUsers:self.aroundUsers];
            cell = aroundUsersCell;
            break;
        }
        case GTAroundCellTypeEightTool: {
            GTEightToolCell *eightCell = [tableView dequeueReusableCellWithIdentifier:@"GTEightToolCell" forIndexPath:indexPath];
            NSMutableArray *eightTool = [NSMutableArray array];
            for (GTToolsSet *toolsSet in self.fourSets) {

                NSArray *toolsItemArray = toolsSet.toolsItemsArray;

                for (GTToolsItem *toolsItem in toolsItemArray) {

                    if (RYIsValidString(toolsItem.isindex) && ([toolsItem.isindex intValue] <= 7) && ([toolsItem.isindex intValue] >= 1)) {

                        [eightTool addObject:toolsItem];
                    }
                }
            }
            [eightCell setToolsArray:eightTool];
            eightCell.cellDelegate = self;
            cell = eightCell;
            //            break;
        }
    }
    return cell;
}

#pragma mark--- GTEightToolCellDelegate

- (void)didClickBtnView:(GTEightToolBtnView *)view
{
    GTToolsWebViewController *vc = [[GTToolsWebViewController alloc] init];
    vc.detail = view.item.detail;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickMoreBtnView:(GTEightToolBtnView *)view
{
    GTFourSetViewController *vc = [[GTFourSetViewController alloc] init];
    vc.fourSetArray = self.fourSets;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fHeight = 0;
    NSNumber *num = self.tableCellTypes[indexPath.row];
    switch ([num integerValue]) {
        case GTAroundCellTypeUserHead:
            fHeight = 230;
            break;
        case GTAroundCellTypeCategory:
            fHeight = [GTAroundTableCell cellHeight];
            break;
        //        case GTAroundCellTypeRecentUsers:
        //            fHeight = [GTRecentUserCell cellHeight];
        //            break;
        case GTAroundCellTypeAroundUsers:
            fHeight = 150;
            break;
        case GTAroundCellTypeEightTool:
            fHeight = [UIScreen mainScreen].bounds.size.width / 2;
            break;
    }
    return fHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.tableCellTypes[indexPath.row];
    if ([num integerValue] == GTAroundCellTypeCategory) {
        [self gotoAroundWithCategory:nil];
    }
    else if ([num integerValue] == GTAroundCellTypeAroundUsers) {
        [self gotoUsersWithTitle:@"Ta们最近来过" cellType:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.tableCellTypes[indexPath.row];
    if ([num integerValue] == GTAroundCellTypeUserHead) {
        [self showBottomCameraView:NO animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.tableCellTypes[indexPath.row];
    if ([num integerValue] == GTAroundCellTypeUserHead) {
        [self showBottomCameraView:YES animated:YES];
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

#pragma mark - SRRefreshDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self requestTableData];
}

#pragma mark - GTInGermanyHeaderCellDelegate
- (void)headerCell:(GTInGermanyHeaderCell *)cell didClickCameraButton:(UIButton *)button
{
    [self onCameraButton:button];
}
- (void)headerCell:(GTInGermanyHeaderCell *)cell didClickUserHeadImage:(UIButton *)button
{
    [self gotoUserCenter];
}

#pragma mark - GTAroundTableCellDelegate
- (void)aroundTableCell:(GTAroundTableCell *)cell didClickCategoryAtIndex:(NSInteger)index
{
    if (7 == index) {
        [self gotoUsersWithTitle:@"周边的人" cellType:YES];
    }
    else {
        [self gotoAroundWithCategory:self.categories[index]];
    }
}

#pragma mark - GTRecentUserCellDelegate
//-(void)recentUserCell:(GTRecentUserCell *)cell didClickUserAtIndex:(NSInteger)index
//{
//    RYCONDITIONLOG(DEBUG, @"%d",(int)index);
//}

#pragma mark - NewRouteViewControllerDelegate
- (void)newRouteViewControllerDidCreateNewRoute:(NewRouteViewController *)controller
{
    [self showPhotosChoosingView:YES animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:^{
                                                    [self gotoSendImageViewWithImageInfo:info];
                                                  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)DidClickedUserImage:(GTDistanceUser *)user
{
    NSLog(@"%@---%@", user.userID, self.model.userItem.userID);

    GTUserRouteViewController *controller = [[GTUserRouteViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"/profiles/%@?userid=%@", user.userID, self.model.userItem.userID];
    controller.strURL = GetAPIUrl(url);

    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark--- DTPartnerLogoDelegate
- (void)showLogoDetail:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    [self.navigationController pushViewController:vc animated:YES];
}

// 汉莎
- (void)showLogoDetailWithLeftButton:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    vc.setBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWelcomeMessage) name:@"DIDRECIEVELOCATION" object:nil];

    [super viewWillAppear:animated];
}

- (void)updateWelcomeMessage
{
    NSString *location = [NSString stringWithFormat:@"%@  %@", self.model.currentPlaceMark.country, self.model.currentPlaceMark.locality];
    NSLog(@"%@", location);
    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:GTAroundCellTypeUserHead inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
