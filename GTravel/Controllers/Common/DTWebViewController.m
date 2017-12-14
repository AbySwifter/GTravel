//
//  DTWebViewController.m
//  GTravel
//
//  Created by Raynay Yue on 5/18/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTWebViewController.h"
#import "MBProgressHUD.h"
#import "GTCommonStrings.h"

@interface DTWebViewController () <UIWebViewDelegate, UIScrollViewDelegate> {
    BOOL isLoaded;
}

- (void)initWebView;

- (void)onCloseButton:(UIBarButtonItem *)button;
- (void)backToPreviousView;
- (void)setLeftNavigationItemsWithCloseButton:(BOOL)boolValue;

- (void)startToLoadContent;

@end

@implementation DTWebViewController

- (void)initWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.delegate = self;
    webView.scrollView.delegate = self;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.dataDetectorTypes = UIDataDetectorTypeAddress | UIDataDetectorTypeCalendarEvent | UIDataDetectorTypeLink;
    [self.view addSubview:webView];
    self.webView = webView;

    isLoaded = NO;
}

- (void)onBackButton:(UIBarButtonItem *)button
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        //        [self.webView reload];
        [self setLeftNavigationItemsWithCloseButton:YES];
    }
    else {
        [self backToPreviousView];
    }
}

- (void)onCloseButton:(UIBarButtonItem *)button
{
    [self backToPreviousView];
}

- (void)backToPreviousView
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setLeftNavigationItemsWithCloseButton:(BOOL)boolValue
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:backItem];
    if (boolValue) {
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseButton:)];
        [items addObject:closeButton];
    }
    self.navigationItem.leftBarButtonItems = items;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWebView];
    [self initializedRefreshViewForView:self.webView.scrollView];
    [self setLeftNavigationItemsWithCloseButton:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isLoaded) {
        [self startToLoadContent];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startToLoadContent
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0]];
}

- (BOOL)shouldStartLoadWithReqeust:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewControllerDidStartLoadWebView:(UIWebView *)webView
{
}

- (void)webViewControllerDidFinishLoadWebView:(UIWebView *)webView
{
}

- (void)webViewControllerDidFailLoadWithError:(NSError *)error
{
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.navigationItem setTitle:@"加载中..."];
    [self.refreshView endRefresh];
    [self webViewControllerDidStartLoadWebView:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [self shouldStartLoadWithReqeust:request navigationType:navigationType];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:JSStringGetWebTitle];
    self.navigationItem.title = str;
    isLoaded = YES;
    [self webViewControllerDidFinishLoadWebView:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.navigationItem setTitle:@"加载失败，请重试!"];
    [self webViewControllerDidFailLoadWithError:error];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView scrollViewDidEndDraging];
}

#pragma mark - SRRefreshDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self.webView reload];
}
@end
