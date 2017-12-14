//
//  RouteDetailViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/10/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "RouteDetailViewController.h"
#import "RYCommon.h"
#import "GTravelRouteItem.h"
#import "SendImageViewController.h"
#import "GTNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import "GTShareView.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "DTWeChatManager.h"
#import "DTWeChatShareMessage.h"
#import "GTravelNetDefinitions.h"
#import "CityMapViewController.h"
#import "AroundMapViewController.h"
#import "UserRouteMapViewController.h"


#define TagTakePhotoFromCameraButton 0
#define TagTakePhotoFromAlbumButton 1
#define ImageSizeWidth 100
#define ImageDistance 40
#define HeightButtonContainer 140
#define HeightLabel 0

@interface RouteDetailViewController () <UIWebViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GTShareViewDelegate>

@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, weak) UIView *buttonContainerView;
@property (nonatomic, weak) GTShareView *shareView;
@property (nonatomic, weak) UIButton *bottom;

@property (nonatomic, copy) NSString *show_title;
@property (nonatomic, copy) NSString *show_desc;
@property (nonatomic, copy) NSString *show_pic;
@property (nonatomic, copy) NSString *shareURL;

@end

@implementation RouteDetailViewController
#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.strURL = [self.routeItem.detail stringByAppendingFormat:@"&userid=%@", self.model.userItem.userID];
    self.webView.delegate = self;

    [self setupRightShare];

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


    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView = maskView;
    self.maskView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.maskView];
    self.maskView.alpha = 0;
    self.maskView.hidden = YES;

    UIView *buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, RYWinRect().size.height, RYWinRect().size.width, HeightButtonContainer)];
    self.buttonContainerView = buttonContainerView;
    self.buttonContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonContainerView];

    CGFloat fX = RYWinRect().size.width * 0.5 - ImageSizeWidth - ImageDistance * 0.5;
    CGFloat fY = (HeightButtonContainer - ImageSizeWidth) * 0.5;

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(fX, fY, ImageSizeWidth, ImageSizeWidth);
    leftBtn.tag = TagTakePhotoFromCameraButton;
    [leftBtn addTarget:self action:@selector(takePhotoFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"bt_camera2"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"bt_camera2_hl"] forState:UIControlStateHighlighted];
    [self.buttonContainerView addSubview:leftBtn];


    CGFloat fX1 = fX + ImageDistance + ImageSizeWidth;

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(fX1, fY, ImageSizeWidth, ImageSizeWidth);
    rightBtn.tag = TagTakePhotoFromAlbumButton;
    [rightBtn addTarget:self action:@selector(takePhotoFromAlbum) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"bt_album"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"bt_album_hl"] forState:UIControlStateHighlighted];
    [self.buttonContainerView addSubview:rightBtn];
}

- (void)setupRightShare
{
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(0, 0, 25, 25);
    [share setImage:[UIImage imageNamed:@"line_share_normal"] forState:UIControlStateNormal];
    [share setImage:[UIImage imageNamed:@"line_share_pressed"] forState:UIControlStateHighlighted];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:share];

    [share addTarget:self action:@selector(shareView:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItems = @[ shareItem ];
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

- (void)showPhotosChoosingView:(BOOL)show animated:(BOOL)animated
{
    //    self.layoutBottomButtonContainerView.constant = show ? 0 : - self.buttonContainerView.frame.size.height;
    if (show) {
        self.maskView.hidden = NO;
        self.maskView.alpha = show ? 0.0 : 0.7;
        [UIView animateWithDuration:0.5
            animations:^{
              self.maskView.alpha = show ? 0.7 : 0.0;
              self.buttonContainerView.frame = CGRectMake(0, RYWinRect().size.height - 64 - HeightButtonContainer, RYWinRect().size.width, HeightButtonContainer);
            }
            completion:^(BOOL finished) {
              self.maskView.hidden = !show;
            }];
    }
    else {

        [UIView animateWithDuration:0.5
            animations:^{
              self.buttonContainerView.frame = CGRectMake(0, RYWinRect().size.height - 64, RYWinRect().size.width, HeightButtonContainer);
            }
            completion:^(BOOL finished) {
              self.maskView.hidden = !show;
            }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartLoadWithReqeust:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    RYCONDITIONLOG(DEBUG, @"URL:%@", request.URL.absoluteString);

    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString isEqualToString:@"personalcenter://?res=1"]) {

        [self.cacheUnit setLineID:nil];
        self.model.userItem.routeBase = nil;

        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString isEqualToString:@"takephotos://"]) {

        [self showPhotosChoosingView:YES animated:YES];
        return NO;
    }
    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString isEqualToString:@"collection://?res=1"]) {

        NSLog(@"%@", request.URL.absoluteString);
        return NO;
    }
    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString rangeOfString:@"edit"].length) {
        [self updateRightBarButton];
        return YES;
    }
    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString rangeOfString:@"line/detail"].length) {

        [self setupRightShare];
        return YES;
    }
    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString rangeOfString:@"locationmap://?res="].length > 0) {
        NSString *absoluteString = request.URL.absoluteString;
        NSUInteger index = [request.URL.absoluteString rangeOfString:@"="].location + 1;
        NSString *line_user_id = [absoluteString substringFromIndex:index];

        [self gotoMapWithLineUserId:line_user_id];
        return NO;
    }
    if (RYIsValidString(request.URL.absoluteString) && [request.URL.absoluteString isEqualToString:@"http://germany.dragontrail.com/profiles/desc"]) {

        NSString *changeTitle = @"document.getElementById('title').value";
        //        NSString *changeDesc = @"document.getElementById('description').value";

        NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:changeTitle];
        //        NSString *desc = [self.webView stringByEvaluatingJavaScriptFromString:changeDesc];

        //        NSLog(@"%@",title);
        // 改按钮
        [self setupRightShare];
        // 发通知
        NSDictionary *dict = @{ @"title" : title };
        NSNotification *not = [[NSNotification alloc] initWithName:@"didChangeUserRouteDesc" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:not];
    }

    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        NSLog(@"submit");
    }

    return [super shouldStartLoadWithReqeust:request navigationType:navigationType];
}

- (void)gotoMapWithLineUserId:(NSString *)lineUserId
{
    UserRouteMapViewController *vc = [[UserRouteMapViewController alloc] init];
    vc.line_user_id = lineUserId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateRightBarButton
{
    [self.navigationItem setRightBarButtonItem:nil animated:YES];

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchDown:)];
    [self.navigationItem setRightBarButtonItem:done];
}

- (void)touchDown:(id)sender
{
    NSString *changeTitle = @"document.getElementById('title').value";
    NSString *changeDesc = @"document.getElementById('description').value";

    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:changeTitle];
    NSString *desc = [self.webView stringByEvaluatingJavaScriptFromString:changeDesc];

    NSString *stringTitle = [NSString stringWithFormat:@"document.getElementById('title').value = '%@';", title];
    NSString *stringDesc = [NSString stringWithFormat:@"document.getElementById('description').value = '%@';", desc];

    [self.webView stringByEvaluatingJavaScriptFromString:stringTitle];
    [self.webView stringByEvaluatingJavaScriptFromString:stringDesc];

    NSString *stringc = @"document.forms[0].submit()";
    [self.webView stringByEvaluatingJavaScriptFromString:stringc];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    [self.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

      [[NSNotificationCenter defaultCenter] postNotificationName:@"DIDCHOOSEIMAGECOMPLETION" object:nil userInfo:info];
    });

    //    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    //
    //        [self gotoSendImageViewWithImageInfo:info];
    //    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hiddenShareView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = self.routeItem.title;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showPhotosChoosingView:NO animated:YES];
}

- (void)shareView:(UIButton *)share
{
    //    NSString *stringc = @"document.getElementsByTagName('html')[0].innerHTML";
    //    NSString *htmlString = [self.webView stringByEvaluatingJavaScriptFromString:stringc];
    //    NSLog(@"%@",htmlString);
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
    NSRange range = [self.strURL rangeOfString:string];
    NSString *url = [self.strURL substringToIndex:range.location];
    self.shareURL = url;

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hiddenShareView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebView) name:@"RELOADWEBVIEW" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadWebView
{
    [self.webView reload];
}


@end
