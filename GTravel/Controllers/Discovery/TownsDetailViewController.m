//
//  TownsDetailViewController.m
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "TownsDetailViewController.h"
#import "RYCommon.h"
#import "CityMapViewController.h"
#import "GTravelTownItem.h"
#import "GTShareView.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "DTWeChatManager.h"
#import "DTWeChatShareMessage.h"
#import <ShareSDK/ShareSDK.h>

@interface TownsDetailViewController () <GTShareViewDelegate>

- (void)initializedRightMapBarButton;
- (void)onMapBarButtonItem:(UIBarButtonItem *)item;
- (void)removeRightMapBarButton;

@property (nonatomic, weak) GTShareView *shareView;
@property (nonatomic, copy) NSString *show_title;
@property (nonatomic, copy) NSString *show_desc;
@property (nonatomic, copy) NSString *show_pic;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, weak) UIButton *bottom;

@end

@implementation TownsDetailViewController

#pragma mark - Non-Public Methods
- (void)initializedRightMapBarButton
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_map"] style:UIBarButtonItemStylePlain target:self action:@selector(onMapBarButtonItem:)];
    [self.navigationItem setRightBarButtonItem:barButton animated:YES];
}

- (void)onMapBarButtonItem:(UIBarButtonItem *)item
{
    CityMapViewController *mapViewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CityMapViewController class])];
    //    mapViewController.cityItem = self.townItem;
    mapViewController.townItem = self.townItem;
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)removeRightMapBarButton
{
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.townItem.name;
    self.strURL = [self.townItem.detailURL stringByAppendingFormat:@"?userid=%@", self.model.userItem.userID];

    UIButton *bottom = [[UIButton alloc] initWithFrame:self.view.bounds];
    [bottom addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
    bottom.hidden = YES;
    self.bottom = bottom;
    bottom.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottom];

    GTShareView *view = [[GTShareView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    self.shareView = view;
    self.shareView.delegate = self;
    view.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartLoadWithReqeust:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString rangeOfString:self.townItem.detailURL].location == NSNotFound) {
        [self removeRightMapBarButton];
    }
    else {
        [self initializedRightMapBarButton];
    }

    if ([request.URL.absoluteString rangeOfString:@"http://germany.dragontrail.com/image_screen/"].length) {
        [self initializedRightShareButton];
    }
    return [super shouldStartLoadWithReqeust:request navigationType:navigationType];
}

- (void)initializedRightShareButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setImage:[UIImage imageNamed:@"line_share_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"line_share_pressed"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onShareButton:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItems = @[ shareButton ];
}

- (void)onShareButton:(UIButton *)button
{
    NSString *JsToGetShowTitle = @"document.getElementById('show_title').value";
    NSString *show_title = [self.webView stringByEvaluatingJavaScriptFromString:JsToGetShowTitle];
    self.show_title = show_title;
    NSString *JsToGetShowDesc = @"document.getElementById('show_desc').value";
    NSString *show_desc = [self.webView stringByEvaluatingJavaScriptFromString:JsToGetShowDesc];
    NSString *str1 = [show_desc stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    self.show_desc = str2;
    NSString *JsToGetShowPic = @"document.getElementById('show_pic').value";
    NSString *show_pic = [self.webView stringByEvaluatingJavaScriptFromString:JsToGetShowPic];
    self.show_pic = show_pic;
    NSString *string1 = self.model.userItem.userID;
    NSRange range = [self.strURL rangeOfString:string1];
    NSString *url = [self.strURL substringToIndex:range.location];
    self.shareURL = url;

    NSLog(@"%@\n%@", self.strURL, self.shareURL);

    self.bottom.hidden = NO;
    self.bottom.alpha = 0.0;

    [UIView animateWithDuration:0.5
                     animations:^{
                       self.shareView.frame = CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100);
                       self.bottom.alpha = 0.7;
                       self.shareView.hidden = NO;
                     }
                     completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hiddenShareView];
}

- (void)hiddenShareView
{
    [UIView animateWithDuration:0.5
        animations:^{
          self.shareView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 100);
          self.bottom.alpha = 0.0;
        }
        completion:^(BOOL finished) {
          self.shareView.hidden = YES;
          self.bottom.hidden = YES;
        }];
}

- (void)didClickedWeiXinSessionBtn:(UIButton *)btn
{


    DTWeChatManager *weChatManager = [DTWeChatManager sharedManager];

    if ([DTWeChatManager isWeChatAppInstalled]) {

        DTWeChatShareMessage *shareMessage = [[DTWeChatShareMessage alloc] init];

        shareMessage.title = self.show_title;
        shareMessage.messageDesc = self.show_desc;
        shareMessage.url = self.shareURL;
        shareMessage.type = DTWeChatShareTypeNewSession;
        shareMessage.imageURL = self.show_pic;

        [weChatManager shareMessage:shareMessage
              withCompletionHandler:^(BOOL bSuccess, NSError *error) {
                if (bSuccess) {

                    dispatch_async(dispatch_get_main_queue(), ^{

                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:@"已经发送给好友了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                      [alert show];

                    });
                }
                else {
                    NSLog(@"分享失败");
                }
              }];
    }
}

- (void)didClickedWeiXinTimelineBtn:(UIButton *)btn
{
    DTWeChatManager *manager = [DTWeChatManager sharedManager];

    DTWeChatShareMessage *shareMessage = [[DTWeChatShareMessage alloc] init];
    shareMessage.title = self.show_title;
    shareMessage.messageDesc = self.show_desc;
    shareMessage.url = self.shareURL;
    shareMessage.type = DTWeChatShareTypeMoments;
    shareMessage.imageURL = self.show_pic;

    [manager shareMessage:shareMessage
        withCompletionHandler:^(BOOL bSuccess, NSError *error) {
          if (bSuccess) {
              NSLog(@"分享成功");
          }
          else {
              NSLog(@"分享失败");
          }
        }];
}

- (void)didClickedSinaWeiboBtn:(UIButton *)btn
{
    id<ISSContent> content =
        [ShareSDK content:self.show_desc
            defaultContent:self.show_desc
                     image:[ShareSDK imageWithUrl:self.show_pic]
                     title:self.show_title
                       url:self.shareURL
               description:self.show_desc
                 mediaType:SSPublishContentMediaTypeNews];

    [ShareSDK clientShareContent:content
                            type:ShareTypeSinaWeibo
                   statusBarTips:NO
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {

                            if (state == SSResponseStateBegan) {
                                NSLog(@"分享开始");
                            }
                            else if (state == SSResponseStateCancel) {
                                NSLog(@"分享取消");
                            }
                            else if (state == SSResponseStateFail) {
                                NSLog(@"发布失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
                            }
                            else {
                                NSLog(@"分享成功");
                            }
                          }];
}

@end
