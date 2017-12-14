//
//  PointDetailViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/12/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "PointDetailViewController.h"
#import "GTPoint.h"
#import "MBProgressHUD.h"
#import "RYCommon.h"
#import <ShareSDK/ShareSDK.h>
#import "GTShareView.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "DTWeChatManager.h"
#import "DTWeChatShareMessage.h"
#import "GTUserPoints.h"
#import "GTCityOrTownPoints.h"

@interface PointDetailViewController () <ISSShareViewDelegate, GTShareViewDelegate, UIWebViewDelegate>

@property (nonatomic, weak) GTShareView *shareview;
@property (nonatomic, weak) UIButton *bottom;
@property (nonatomic, copy) NSString *show_title;
@property (nonatomic, copy) NSString *show_desc;
@property (nonatomic, copy) NSString *show_pic;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, assign) int clickCount;

- (void)initializedNavigationItems;
- (void)onBackButton:(UIButton *)sender;
- (void)onShareButton:(UIButton *)sender;
@end

@implementation PointDetailViewController
#pragma mark - Non-Public Methods
- (void)initializedNavigationItems
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(10, 20, 40, 40)];
    [button setImage:[UIImage imageNamed:@"bt_back2"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"bt_back2_hl"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(RYWinRect().size.width - 50, 20, 40, 40)];
    [button setImage:[UIImage imageNamed:@"bt_share"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"bt_share_hl"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onBackButton:(UIButton *)sender
{
    NSLog(@"%d", self.clickCount);
    if (self.clickCount % 2 == 1) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEDTAIL" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    //    viewController.view.backgroundColor = [UIColor clearColor];
}


- (void)onShareButton:(UIButton *)sender
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
    NSString *string = self.model.userItem.userID;
    NSString *url = [self.strURL stringByReplacingOccurrencesOfString:string withString:@""];
    self.shareURL = url;


    self.bottom.hidden = NO;
    self.shareview.hidden = NO;
    self.bottom.alpha = 0.0;
    [UIView animateWithDuration:0.5
                     animations:^{
                       self.shareview.frame = CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100);
                       self.bottom.alpha = 0.7;
                     }];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.webView.delegate = self;

    if (self.userPoint) {
        self.strURL = self.userPoint.detail;
    }
    else if (self.cityOrTownPoints) {
        self.strURL = self.cityOrTownPoints.detail;
    }
    else {
        self.strURL = self.point.detailURL;
    }


    [self initializedNavigationItems];

    UIButton *bottom = [[UIButton alloc] initWithFrame:self.view.bounds];
    [bottom addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
    bottom.hidden = YES;
    self.bottom = bottom;
    bottom.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottom];

    GTShareView *view = [[GTShareView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    self.shareview = view;
    self.shareview.delegate = self;
    view.hidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.clickCount = 0;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartLoadWithReqeust:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString isEqualToString:@"collection://?res=1"]) {
        self.clickCount++;
    }

    return [super shouldStartLoadWithReqeust:request navigationType:navigationType];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)webViewControllerDidStartLoadWebView:(UIWebView *)webView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    hud.labelText = @"加载中...";
}

- (void)webViewControllerDidFinishLoadWebView:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}

- (void)webViewControllerDidFailLoadWithError:(NSError *)error
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.webView];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"加载失败,请稍后再试!";
    [hud hide:YES afterDelay:2.0];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenShareView];
}


// 微信好友
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
// 微信朋友圈
- (void)didClickedWeiXinTimelineBtn:(UIButton *)btn
{
    DTWeChatManager *manager = [DTWeChatManager sharedManager];

    if ([DTWeChatManager isWeChatAppInstalled]) {
        DTWeChatShareMessage *shareMessage = [[DTWeChatShareMessage alloc] init];
        shareMessage.title = self.show_title;
        shareMessage.url = self.shareURL;
        shareMessage.messageDesc = self.show_desc;
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
}
// 新浪微博
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
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                [alert show];
                            }
                          }];
}

- (void)hiddenShareView
{
    [UIView animateWithDuration:0.5
        animations:^{
          self.shareview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 100);
          self.bottom.alpha = 0.0;

        }
        completion:^(BOOL finished) {
          self.bottom.hidden = YES;
          self.shareview.hidden = YES;

        }];
}
@end
