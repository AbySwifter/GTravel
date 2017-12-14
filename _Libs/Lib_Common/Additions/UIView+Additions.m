//
//  UIView+Additions.m
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import "UIView+Additions.h"

#define TimeShowLoadingView 3
#define TagLoadingView -199
#define TagLoadingInfoLabel -201

NSTimer *timer = nil;
NSInteger iShowTimeCount = 0;
@implementation UIView (Additions)
#pragma mark - Private Methods
- (void)timerAction
{
    iShowTimeCount--;
    if (iShowTimeCount == 0) {
        [self hideLoadingView:YES];
    }
}

#pragma mark - Public Methods
- (void)showLoadingViewWithInfo:(NSString *)info hiddenAutomatic:(BOOL)hidden
{
    iShowTimeCount = TimeShowLoadingView;
    UIView *loadingView = [self viewWithTag:TagLoadingView];
    if (loadingView == nil) {
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.tag = TagLoadingView;

        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.hidden = NO;
        indicator.center = CGPointMake(20, 20);
        indicator.hidesWhenStopped = YES;
        [loadingView addSubview:indicator];
        [indicator startAnimating];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 20)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14.0];
        label.backgroundColor = [UIColor blackColor];
        label.tag = TagLoadingInfoLabel;
        [loadingView addSubview:label];

        [self addSubview:loadingView];

        loadingView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        loadingView.alpha = 0.0;

        [UIView animateWithDuration:0.25
            animations:^{
              loadingView.alpha = 1.0;
            }
            completion:^(BOOL finished) {
              if (hidden) {
                  if (timer == nil) {
                      timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                      [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                      [timer fire];
                  }
              }
            }];
    }
    UILabel *label = (UILabel *)[self viewWithTag:TagLoadingInfoLabel];
    label.text = info;
}

- (void)showLoadingViewWithInfo:(NSString *)info atPoint:(CGPoint)point hiddenAutomatic:(BOOL)hidden
{
    iShowTimeCount = 0;
    UIView *loadingView = [self viewWithTag:TagLoadingView];
    if (loadingView == nil) {
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.tag = TagLoadingView;

        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.hidden = NO;
        indicator.center = CGPointMake(20, 20);
        indicator.hidesWhenStopped = YES;
        [loadingView addSubview:indicator];
        [indicator startAnimating];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 20)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14.0];
        label.backgroundColor = [UIColor blackColor];
        label.tag = TagLoadingInfoLabel;
        [loadingView addSubview:label];

        [self addSubview:loadingView];

        loadingView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        loadingView.alpha = 0.0;

        [UIView animateWithDuration:0.25
            animations:^{
              loadingView.alpha = 1.0;
            }
            completion:^(BOOL finished) {
              if (hidden) {
                  if (timer == nil) {
                      timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                      [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                      [timer fire];
                  }
              }
            }];
    }
    UILabel *label = (UILabel *)[self viewWithTag:TagLoadingInfoLabel];
    label.text = info;
    loadingView.center = CGPointMake(point.x, point.y);
}

- (void)hideLoadingView:(BOOL)animated
{
    UIView *loadingView = [self viewWithTag:TagLoadingView];
    if (loadingView) {
        if (animated) {
            [UIView animateWithDuration:0.25
                animations:^{
                  loadingView.alpha = 0.0;
                }
                completion:^(BOOL finished) {
                  [loadingView removeFromSuperview];
                }];
        }
        else {
            loadingView.alpha = 0.0;
            [loadingView removeFromSuperview];
        }
    }
}

- (void)hideAllLoadingView
{
    UIView *view = [self viewWithTag:TagLoadingView];
    while (view) {
        [view removeFromSuperview];
        view = nil;
        view = [self viewWithTag:TagLoadingView];
    }
}

@end