//
//  DTWebViewController.h
//  GTravel
//
//  Created by Raynay Yue on 5/18/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTRootViewController.h"

@interface DTWebViewController : DTRootViewController
@property (nonatomic, copy) NSString *strURL;
@property (strong, nonatomic) UIWebView *webView;

- (void)onBackButton:(UIBarButtonItem *)button;
- (BOOL)shouldStartLoadWithReqeust:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewControllerDidStartLoadWebView:(UIWebView *)webView;
- (void)webViewControllerDidFinishLoadWebView:(UIWebView *)webView;
- (void)webViewControllerDidFailLoadWithError:(NSError *)error;
@end
