//
//  RegisterViewController.m
//  GTravel
//
//  Created by QisMSoM on 15/8/17.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "RegisterViewController.h"
#import "RYCommonFunctions.h"
#import "WXApi.h"
#import "RYCommon.h"
#import "MBProgressHUD.h"
#import "GTravel-Swift.h"

@interface RegisterViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *reviewTextFiled;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseLoginType;
@property (weak, nonatomic) IBOutlet UIView *weChatLoginView;
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginButton;
@property (weak, nonatomic) UITextField *firstResponser;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIButton *sexMan;
@property (weak, nonatomic) IBOutlet UIButton *sexWoman;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end

@implementation RegisterViewController
- (IBAction)arrowDown:(UIButton *)sender
{

    self.sexView.hidden = !self.sexView.hidden;
}
- (IBAction)sexManButton:(id)sender
{
    self.sexView.hidden = YES;
    self.sexLabel.text = @" 男";
}
- (IBAction)sexWomanButton:(id)sender
{
    self.sexView.hidden = YES;
    self.sexLabel.text = @" 女";
}



#pragma mark - 视图生命周期函数
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.weChatLoginView.hidden = ![WXApi isWXAppInstalled] ? YES : NO;

    self.registerView.layer.cornerRadius = 6.0;
    self.checkView.layer.cornerRadius = 6.0;
    self.sexView.hidden = YES;
    self.sexView.layer.cornerRadius = 6.0;

    self.weChatLoginView.layer.cornerRadius = 6.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(putEnded)];
    [self.view addGestureRecognizer:tap];

    UITapGestureRecognizer *tapSex = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSex)];
    [self.checkView addGestureRecognizer:tapSex];
    //    [self.sexLabel addGestureRecognizer:tapSex];
	
}

- (void)touchSex
{
    self.sexView.hidden = !self.sexView.hidden;
}

- (void)putEnded
{
    self.sexView.hidden = YES;
    [self.firstResponser endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    [textField becomeFirstResponder];
    self.firstResponser = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 注册
- (IBAction)registerButtonDidClicked:(UIButton *)sender
{

    if (!RYIsValidString(self.nameTextFiled.text) || self.nameTextFiled.text == nil || [self.nameTextFiled.text rangeOfString:@" "].length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称不合法,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![self.passWordTextFiled.text isEqualToString:self.reviewTextFiled.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码必须一致,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (!RYIsValidString(self.passWordTextFiled.text) || self.passWordTextFiled.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不合法,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在注册";
        // 注册
        // 判断注册返回的状态,如果返回结果为1成功,提示注册成功,让用户去登录
        //        NSString *stringSex = nil;
        //        if ([self.sexLabel.text isEqualToString:@"男"]) {
        //            stringSex = @"1";
        //        }else
        //        {
        //            stringSex = @"2";
        //        }

        [self.networkUnit registerUserWithNickName:self.nameTextFiled.text
                                          passWord:self.passWordTextFiled.text
                                               sex:1
                                        completion:^(NSError *error, id responseObject) {
                                          if (error) {
											  NSLog(@"%@", error);
											  hud.hidden = YES;
                                          }
                                          else {
                                              // 注册成功
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"去登录", nil];
                                              alert.delegate = self;
                                              [alert show];
                                              NSLog(@"%@", [responseObject[@"user_id"] stringValue]);
                                              //                self.cacheUnit.userID = [responseObject[@"user_id"] stringValue];
                                              hud.hidden = YES;
                                          }
                                        }];
    }
}

#pragma mark--- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 取消
- (IBAction)cancleButtonDidClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 微信登录
- (IBAction)weChatButtonDidClicked:(UIButton *)sender
{
    // 系统没有存储的userid和用户名密码
    // 只有安装了微信的时候才显示
    [self dismissViewControllerAnimated:NO
                             completion:^{
                               [self.model startWeChatAuthentication];
                             }];
}

// 切换到登录界面
- (IBAction)moveToLoginView:(UIButton *)sender
{
    [self cancleButtonDidClicked:nil];
}
@end
