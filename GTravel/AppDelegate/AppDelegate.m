//
//  AppDelegate.m
//  GTravel
//
//  Created by Raynay Yue on 4/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "GTModel.h"
#import "RYCommon.h"
#import "DTWeChat.h"
#import "DTWebViewController.h"
#import "GTravelImageItem.h"
#import "GTCacheUnit.h"
#import "DTLocationUnit.h"
#import "InGermanyViewController.h"
#import "DiscoveryViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "MobClick.h"


#define WeChatAppID @"wx49df81aa4b755240"
#define WeChatSecret @"f1d7cb907ba7d23d496da98b6dff714b"
#define kPushNotificationDeviceToken @"kPushNotificationDeviceToken"

#define SinaAppKey @"334825083"
#define SinaAppSecret @"06896a14d62fd5d8bea1fa45132e3e41"

#define ShareSDKAppKey @"90ec23be7000"
#define ShareSDKAppSecret @"abc301287a30f9360f4814d233e53082"

//#define UMAppKey                            @"55f6299167e58eeb60001f02"
#define UMAppKey @"56cda76d67e58e34df0031a0"


@interface AppDelegate () <WXApiDelegate>
@property (nonatomic, strong) UIWindow *loginWindow;

- (void)navigationToAroundViewController;

- (void)registerAppToPushNotification;
- (void)remoteNotificationDidReceive:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
- (void)applicationDidRegisterForRemoteNotificationWithDeviceToken:(NSString *)deviceToken;

@end

@implementation AppDelegate
#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyBoard instantiateInitialViewController];
    self.window.rootViewController = controller;
    if (![WXApi isWXAppInstalled]) {
        // 如果用户没有安装微信，发送通知，更改按钮文字。
    }

    [self registerAppToWeChat:WeChatAppID secret:WeChatSecret];
    [self registerAppToPushNotification];
    [[DTLocationUnit sharedLocationUnit] startUpdatingUserLocation];
    [self.window makeKeyAndVisible];
    [self showLoginViewAnimated:YES];

    // ShareSDK
    [ShareSDK registerApp:ShareSDKAppKey];
    // 新浪
    [ShareSDK connectSinaWeiboWithAppKey:SinaAppKey appSecret:SinaAppSecret redirectUri:@"http://www.baidu.com" weiboSDKCls:[WeiboSDK class]];

    // UM
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:UMAppKey reportPolicy:BATCH channelId:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([GTModel sharedModel].bShouldDisplayInGermanyView) {
        [self navigationToAroundViewController];
        [GTModel sharedModel].bShouldDisplayInGermanyView = NO;
    }
    [[GTModel sharedModel] requestCityIDs];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - APNs Delegate
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    RYCONDITIONLOG(DEBUG, @"%@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    const unsigned *bytes = [deviceToken bytes];
    NSString *strDeviceTokenReceived = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                                                  ntohl(bytes[0]), ntohl(bytes[1]), ntohl(bytes[2]), ntohl(bytes[3]),
                                                                  ntohl(bytes[4]), ntohl(bytes[5]), ntohl(bytes[6]), ntohl(bytes[7])];
    //    RYCONDITIONLOG(DEBUG, @"device token:%@",strDeviceTokenReceived);
    [self applicationDidRegisterForRemoteNotificationWithDeviceToken:strDeviceTokenReceived];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self remoteNotificationDidReceive:userInfo fetchCompletionHandler:completionHandler];
}

#pragma mark - Non-Public Methods
- (void)navigationToAroundViewController
{
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    UIViewController *controller = nil;
    for (UIViewController *con in navController.viewControllers) {
        if ([[con class] isSubclassOfClass:[InGermanyViewController class]]) {
            controller = con;
            break;
        }
    }

    if (controller) {
        [navController popToViewController:controller animated:YES];
    }
    else {
        UIViewController *controller = [navController.storyboard instantiateViewControllerWithIdentifier:@"AroundViewController"];
        [navController pushViewController:controller animated:YES];
    }
}

- (void)registerAppToPushNotification
{
#if TARGET_IPHONE_SIMULATOR

#else
    if (RYSystemVersion() >= RYVersioniOS8) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert categories:nil]];
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#endif
}


- (void)remoteNotificationDidReceive:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
}

- (void)applicationDidRegisterForRemoteNotificationWithDeviceToken:(NSString *)deviceToken
{
    [GTCacheUnit sharedCache].deviceToken = deviceToken;
}

#pragma mark - Public Methods
- (void)showLoginViewAnimated:(BOOL)animated
{
    self.loginWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [navController setNavigationBarHidden:YES];
    self.loginWindow.rootViewController = navController;
    [self.loginWindow makeKeyAndVisible];
    self.loginWindow.alpha = 0.0;
    if (animated) {
        [UIView animateWithDuration:0.5
            animations:^{
              self.loginWindow.alpha = 1.0;
            }
            completion:^(BOOL finished){

            }];
    }
    else
        self.loginWindow.alpha = 1.0;
}

- (void)hiddenLoginViewAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.5
            animations:^{
              self.loginWindow.alpha = 0.0;
            }
            completion:^(BOOL finished) {
              self.loginWindow = nil;
              [self.window makeKeyAndVisible];
            }];
    }
    else {
        self.loginWindow.alpha = 0.0;
        [self.window makeKeyAndVisible];
    }
}

- (void)openDetailViewOfImageItem:(GTravelImageItem *)item
{
    DTWebViewController *controller = [[DTWebViewController alloc] init];
    controller.strURL = item.detailURL;
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    [navController pushViewController:controller animated:YES];
}


@end
