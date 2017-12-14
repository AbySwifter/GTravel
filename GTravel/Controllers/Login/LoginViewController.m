//
//  LoginViewController.m
//  GTravel
//
//  Created by Raynay Yue on 4/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "RYCommon.h"
#import "DTScrollView.h"
#import "GTravelImageItem.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "DTPartnerLogo.h"

@interface LoginViewController () <GTModelDelegate, DTScrollViewDelegate, WXApiDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonSkip;
//@property (weak, nonatomic) IBOutlet UIButton       *buttonLogin;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContainter;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;
@property (weak, nonatomic) IBOutlet UIView *advertiseView;
@property (nonatomic, strong) DTScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageItems;
@property (nonatomic, assign) BOOL autoLogin;
@property (weak, nonatomic) IBOutlet UIView *bottomLogoView;
@property (weak, nonatomic) UIImageView *adImageView;

//- (IBAction)onWeiXinAuthenticationButton:(UIButton *)sender;
- (IBAction)onSkipButton:(UIButton *)sender;


/********************************/
@property (weak, nonatomic) IBOutlet UIView *textFiledView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextFiled;

@property (weak, nonatomic) IBOutlet UIView *loginButtonView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *chooseLoginType;

@property (weak, nonatomic) IBOutlet UIView *weChatLoginView;
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginButton;
/********************************/


/********************************/

/********************************/


- (void)initializedAdvertisementImages;
- (void)startLogin;
- (void)skipAdvertisementView;

- (void)initializedButtonRoundCorner;

@end

@implementation LoginViewController
#pragma mark - IBAction Methods
- (IBAction)weChatLoginButtonDidClicked:(UIButton *)sender
{
    // 可以点击这个按钮代表着安装了微信,并且系统中没有存储过账号密码/userid
    // 授权
    [self.model startWeChatAuthentication];
}
- (IBAction)loginButtonDidClicked:(UIButton *)sender
{

    //    [self startLogin];

    if ((RYIsValidString(self.nameTextFiled.text) && !self.nameTextFiled.text) || self.passWordTextFiled.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {

        /**
     /api/my_login  登录
     参数
     nick_name
     pwd
     */

        // 普通登录,验证账号密码
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"登录中...";
        NSDictionary *params = @{ @"nick_name" : self.nameTextFiled.text,
                                  @"pwd" : self.passWordTextFiled.text
        };
        [self.model startNormalLoginWithReviewWithParams:params];
    }
}

//- (IBAction)onWeiXinAuthenticationButton:(UIButton *)sender
//{
//    if(TARGET_IPHONE_SIMULATOR)
//    {
//        [self showLoginView:NO animated:YES];
//    }
//    else{
////        [self.model startWeChatAuthentication];
//    }
//
//    if (![WXApi isWXAppInstalled]) { // 未安装微信
////        [self.model startNormalLogin];
//    }else{ // 已安装微信
//        [self.model startWeChatAuthentication];
//    }
//}

- (IBAction)onSkipButton:(UIButton *)sender
{
    [self skipAdvertisementView];
}
#pragma mark - Non-Public Methods
- (void)initializedAdvertisementImages
{
    //    self.foregroundImageView.hidden = NO;
    //    [self.view bringSubviewToFront:self.advertiseView];
    //    [self.model requestLaunchImagesWithCompletion:^(NSArray *images) {
    //        self.foregroundImageView.hidden = YES;
    //        DTScrollView *scrollView = [DTScrollView scrollViewWithFrame:self.scrollViewContainter.bounds delegate:self scrollForever:NO];
    //        [self.scrollViewContainter addSubview:scrollView];
    //        self.scrollView = scrollView;
    //
    //        self.imageItems = images;
    //
    //        NSMutableArray *paths = [NSMutableArray array];
    //        for(GTLaunchImage *item in images)
    //        {
    //            NSString *path = RYIsValidString(item.localImagePath) ? [item.localImagePath absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] : item.imageURL;
    //            [paths addObject:path];
    //        }
    //        if(RYIsValidArray(paths))
    //        {
    //            [self.scrollView setImageWithPaths:paths pageIndicatorPosition:DTPageControlPositionCenter];
    //            [self.scrollView setAutoScrollEnabled:YES];
    //        }
    //        else
    //            [self skipAdvertisementView];
    //    }];


    [self.view bringSubviewToFront:self.advertiseView];
    UIImage *localImage = [UIImage imageNamed:@"ad02"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollViewContainter.bounds];
    self.adImageView = imageView;
    [self.scrollViewContainter addSubview:imageView];
    imageView.image = localImage;
}

- (void)startLogin
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中...";
}

- (void)skipAdvertisementView
{
    [self showAdvertisementView:NO animated:YES];
    [self.scrollView setAutoScrollEnabled:NO];
    NSLog(@"%d", !self.model.bNeedWeChatAuthentication);
    //    if(!self.model.bNeedWeChatAuthentication)
    //    {
    //        [self startLogin];
    //    }
    //    else{
    ////        [self onWeiXinAuthenticationButton:nil];
    //    }
    //    [self.cacheUnit]
    //    if (!self.model.beNeedRegister) { // 用户登录过,自动登录
    //        [self startLogin];
    //    }else{ // 用户没有登录过
    //
    //    }
    if (self.autoLogin) {
        if (RYIsValidString(self.cacheUnit.userID)) { // 有userid
            // 根据userid去自动登录
            [self startLogin];
            NSLog(@"%@", self.cacheUnit.userNickName);
            //            self.nameTextFiled.text = self.cacheUnit.userNickName;
            self.passWordTextFiled.text = @"********";
            [self.model startToLogin];
        }
        else { // 没有userid, 判断是否有账号密码
            if (RYIsValidString(self.cacheUnit.passWord) && RYIsValidString(self.cacheUnit.userNickName)) { // 有账号密码去自动登录
                self.nameTextFiled.text = self.cacheUnit.userNickName;
                self.passWordTextFiled.text = @"********";
                [self startLogin];
                [self.model startNormalAutoLogin];
            }
            // 没有userid,也没有账号密码。等待用户操作
        }
    }
}

- (void)initializedButtonRoundCorner
{
    self.buttonSkip.layer.cornerRadius = 6.0;
    self.textFiledView.layer.cornerRadius = 6.0;
    self.loginButtonView.layer.cornerRadius = 6.0;
    self.weChatLoginView.layer.cornerRadius = 6.0;
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    DTPartnerLogo *partnerLogo = [[DTPartnerLogo alloc] init];
    partnerLogo.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, width, 100);
    //    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
    //    line.backgroundColor = [UIColor lightGrayColor];
    //    [partnerLogo addSubview:line];
    [self.advertiseView addSubview:partnerLogo];
    [partnerLogo launchLogo];

    self.autoLogin = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(putEnded)];
    [self.view addGestureRecognizer:tap];
    [self initializedButtonRoundCorner];
    self.weChatLoginView.hidden = ![WXApi isWXAppInstalled] ? YES : NO;
    NSLog(@"%@", self.cacheUnit.userID);
    // Do any additional setup after loading the view.
    [self initializedAdvertisementImages];
}

- (void)changeAuto
{
    self.autoLogin = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAuto) name:@"changeAuto" object:nil];
    NSLog(@"%d", self.loginButton.enabled);
    self.model.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //    self.headImageView.transform=CGAffineTransformScale(self.headImageView.transform, 1.5, 1.6)
    self.adImageView.transform = CGAffineTransformScale(self.adImageView.transform, 2, 2);
    [UIView animateWithDuration:2
                     animations:^{
                       self.adImageView.transform = CGAffineTransformScale(self.adImageView.transform, 0.5, 0.5);
                     }];


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      sleep(4);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self skipAdvertisementView];
      });
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showAdvertisementView:(BOOL)show animated:(BOOL)animated
{
    //    if(animated)
    //    {
    if (show) {
        //            RYIsValidString(<#NSString *string#>)
        self.advertiseView.alpha = 0.0;
        [self.view bringSubviewToFront:self.advertiseView];
        [UIView animateWithDuration:0.5
            animations:^{
              self.advertiseView.alpha = 1.0;
            }
            completion:^(BOOL finished){

            }];
    }
    else {
        self.advertiseView.alpha = 1.0;
        [self.view bringSubviewToFront:self.advertiseView];
        [UIView animateWithDuration:0.5
            animations:^{
              self.advertiseView.alpha = 0.0;
            }
            completion:^(BOOL finished) {
              [self.view sendSubviewToBack:self.advertiseView];
              [self.advertiseView removeFromSuperview];
            }];
    }
    //    }
    //    else
    //    {
    //        self.advertiseView.alpha = 1.0;
    //        if(show)
    //            [self.view bringSubviewToFront:self.advertiseView];
    //        else
    //            [self.view sendSubviewToBack:self.advertiseView];
    //    }
}

#pragma mark - DTModelDelegate
- (void)weChatAuthenticationDidSucceedWithModel:(GTModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
      MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      hud.labelText = @"正在登陆...";
    });
}

- (void)model:(GTModel *)model didLoginWithUserItem:(GTravelUserItem *)userItem
{
    [self showLoginView:NO animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)model:(GTModel *)model operationDidFailedWithError:(NSError *)error
{
    RYCONDITIONLOG(DEBUG, @"%@", error);
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"登陆失败，请稍后再试!";
    [hud hide:YES afterDelay:2.0];
}

#pragma mark - DTScrollViewDelegate
- (void)scrollViewDidScrollToEnd:(DTScrollView *)scrollView
{
    //    if (self.advertiseView) {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      sleep(3);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self skipAdvertisementView];
      });
    });
    //    }
}

- (void)scrollView:(DTScrollView *)scrollView didClickImageAtIndex:(NSInteger)index
{
    if (index < self.imageItems.count) {
        GTravelImageItem *item = self.imageItems[index];
        RYCONDITIONLOG(1, @"%d,%@", (int)index, item.detailURL);
        if (self.model.bNeedWeChatAuthentication) {
            [self.scrollView setAutoScrollEnabled:NO];
            [self openWebDetailViewOfURL:item.detailURL];
        }
        else {
            [self skipAdvertisementView];
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate openDetailViewOfImageItem:item];
        }
    }
}

- (void)scrollView:(DTScrollView *)scrollView didUpdateImageData:(NSData *)data atIndex:(NSInteger)index
{
    GTLaunchImage *item = self.imageItems[index];
    [self.cacheUnit saveImageData:data forImageItem:item];
}

#pragma mark--- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [textField endEditing:YES];
        [self.passWordTextFiled becomeFirstResponder];
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField endEditing:YES];
    }
    NSLog(@"%d", self.loginButton.enabled);
    return YES;
}

- (void)putEnded
{
    [self.nameTextFiled endEditing:YES];
    [self.passWordTextFiled endEditing:YES];
}
@end
