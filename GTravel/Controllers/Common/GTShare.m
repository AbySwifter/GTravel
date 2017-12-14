//
//  GTShare.m
//  GTravel
//
//  Created by QisMSoM on 15/7/23.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

//设备物理大小
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale [UIScreen mainScreen].bounds.size.width / 375.0f

#import "GTShare.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
//#import <sharesdk sharesdk.h>

@implementation GTShare

static id _publishContent; //类方法中的全局变量这样用（类型前面加static）

/*
 自定义的分享类，使用的是类方法，其他地方只要 构造分享内容publishContent就行了
 */

+ (void)shareWithContent:(id)publishContent
/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/
{
    _publishContent = publishContent;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //
    //    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //    blackView.backgroundColor = [UIColor colorWithString:@"000000" Alpha:0.85f];
    //    blackView.tag = 440;
    //    [window addSubview:blackView];
    //
    //    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-300*KWidth_Scale)/2.0f, (kScreenHeight-270*KWidth_Scale)/2.0f, 300*KWidth_Scale, 270*KWidth_Scale)];
    //    shareView.backgroundColor = [UIColor colorWithString:@"f6f6f6"];
    //    shareView.tag = 441;
    //    [window addSubview:shareView];

    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, shareView.width, 45*KWidth_Scale)];
    //    titleLabel.text = @"分享到";
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.font = [UIFont systemFontOfSize:15*KWidth_Scale];
    //    titleLabel.textColor = [UIColor colorWithString:@"2a2a2a"];
    //    titleLabel.backgroundColor = [UIColor clearColor];
    //    [shareView addSubview:titleLabel];
    //
    //    NSArray *btnImages = @[@"IOS-微信@2x.png", @"IOS-朋友圈@2x.png", @"IOS-qq@2x.png", @"IOS-空间@2x.png", @"IOS-微信收藏@2x.png", @"IOS-微博@2x.png", @"IOS-豆瓣@2x.png", @"IOS-短信@2x.png"];
    //    NSArray *btnTitles = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"微信收藏", @"新浪微博", @"豆瓣", @"短信"];
    //    for (NSInteger i=0; i<8; i++) {
    //        CGFloat top = 0.0f;
    //        if (i<4) {
    //            top = 10*KWidth_Scale;
    //
    //        }else{
    //            top = 90*KWidth_Scale;
    //        }
    //        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10*KWidth_Scale+(i%4)*70*KWidth_Scale, titleLabel.bottom+top, 70*KWidth_Scale, 70*KWidth_Scale)];
    //        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
    //        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
    //        button.titleLabel.font = [UIFont systemFontOfSize:11*KWidth_Scale];
    //        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    //        [button setTitleColor:[UIColor colorWithString:@"2a2a2a"] forState:UIControlStateNormal];
    //
    //        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    //        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15*KWidth_Scale, 30*KWidth_Scale, 15*KWidth_Scale)];
    //        if (SYSTEM_VERSION >= 8.0f) {
    //            [button setTitleEdgeInsets:UIEdgeInsetsMake(45*KWidth_Scale, -40*KWidth_Scale, 5*KWidth_Scale, 0)];
    //        }else{
    //            [button setTitleEdgeInsets:UIEdgeInsetsMake(45*KWidth_Scale, -90*KWidth_Scale, 5*KWidth_Scale, 0)];
    //        }
    //
    //        button.tag = 331+i;
    //        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [shareView addSubview:button];
    //    }
    //
    //    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake((shareView.width-40*KWidth_Scale)/2.0f, shareView.height-40*KWidth_Scale-18*KWidth_Scale, 40*KWidth_Scale, 40*KWidth_Scale)];
    //    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"IOS-取消@2x.png"] forState:UIControlStateNormal];
    //    cancleBtn.tag = 339;
    //    [cancleBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [shareView addSubview:cancleBtn];


    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 - 100, [UIScreen mainScreen].bounds.size.width, 100)];
    shareView.tag = 441;
    shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:shareView];

    CGFloat width = 81;
    CGFloat height = 81;
    CGFloat y = (100 - height) / 2;
    CGFloat spacing = ([UIScreen mainScreen].bounds.size.width - width * 3) / 4;
    //    CGFloat x = spacing + i * (width + spacing);

    UIButton *wx = [UIButton buttonWithType:UIButtonTypeCustom];
    wx.frame = CGRectMake(spacing, y, width, height);
    wx.tag = 10;
    [wx setImage:[UIImage imageNamed:@"share_wechat_normal"] forState:UIControlStateNormal];
    [wx setImage:[UIImage imageNamed:@"share_wechat_pressed"] forState:UIControlStateHighlighted];
    [shareView addSubview:wx];

    UIButton *wxFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    wxFriend.frame = CGRectMake(spacing + width + spacing, y, width, height);
    wxFriend.tag = 11;
    [wxFriend setImage:[UIImage imageNamed:@"share_moment_normal"] forState:UIControlStateNormal];
    [wxFriend setImage:[UIImage imageNamed:@"share_moment_pressed"] forState:UIControlStateHighlighted];
    [shareView addSubview:wxFriend];

    UIButton *sina = [UIButton buttonWithType:UIButtonTypeCustom];
    sina.frame = CGRectMake(spacing + 2 * (width + spacing), y, width, height);
    sina.tag = 12;
    [sina setImage:[UIImage imageNamed:@"share_sina_normal"] forState:UIControlStateNormal];
    [sina setImage:[UIImage imageNamed:@"share_sina_pressed"] forState:UIControlStateHighlighted];
    [shareView addSubview:sina];


    //为了弹窗不那么生硬，这里加了个简单的动画
    //    shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    //    blackView.alpha = 0;
    //    [UIView animateWithDuration:0.35f animations:^{
    //        shareView.transform = CGAffineTransformMakeScale(1, 1);
    //        blackView.alpha = 1;
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

//+(void)shareBtnClick:(UIButton *)btn
//{
//    //    NSLog(@"%@",[ShareSDK version]);
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    UIView *shareView = [window viewWithTag:441];
//
//    //为了弹窗不那么生硬，这里加了个简单的动画
//    shareView.transform = CGAffineTransformMakeScale(1, 1);
//    [UIView animateWithDuration:0.35f animations:^{
//        shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
//    } completion:^(BOOL finished) {
//
//        [shareView removeFromSuperview];
//    }];
//
//    id publishContent = _publishContent;
//
//
//    /*
//     调用shareSDK的无UI分享类型，
//     链接地址：http://bbs.mob.com/forum.php?mod=viewthread&tid=110&extra=page%3D1%26filter%3Dtypeid%26typeid%3D34
//     */
//    [ShareSDK showShareViewWithType:shareType container:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<issplatformshareinfo> statusInfo, id<icmerrorinfo> error, BOOL end) {
//        if (state == SSResponseStateSuccess)
//        {
//            //            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//        }
//        else if (state == SSResponseStateFail)
//        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"未检测到客户端 分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            //            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//        }
//    }];
//
//
//
//}


@end
