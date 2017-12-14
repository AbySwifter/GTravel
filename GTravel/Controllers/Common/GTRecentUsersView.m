//
//  GTRecentUsersView.m
//  GTravel
//
//  Created by Raynay Yue on 5/27/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTRecentUsersView.h"
#import "RYCommon.h"
#import "GTravelUserItem.h"
#import "GTModel.h"

#define SubViewBaseTag 100
#define ImageViewTag 10
#define LabelTag 11

#define iUsersCount 5

#define fHeightLabel 20
#define fImageViewMarginTop 0
#define fLabelMarginLeft 2

CGFloat const fRecentUsersViewRatio = (500.0 / 100.0);

@interface GTRecentUsersView ()
@property (nonatomic, weak) id<GTRecentUsersViewDelegate> delegate;

- (void)onUserButtons:(UIButton *)sender;

@end

@implementation GTRecentUsersView
#pragma mark - IBAction Methods
- (void)onUserButtons:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(recentUsersView:didClickUserAtIndex:))) {
        [self.delegate recentUsersView:self didClickUserAtIndex:sender.tag];
    }
}

#pragma mark - Non-Public Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat fHeightSubView = frame.size.height;
        CGFloat fHeightImageView = fHeightSubView - fHeightLabel - 2 * fImageViewMarginTop;
        for (int i = 0; i < iUsersCount; i++) {
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(i * fHeightSubView, 0, fHeightSubView, fHeightSubView)];
            //            subView.backgroundColor = i%2==0 ? [UIColor lightGrayColor] :[UIColor purpleColor];
            subView.tag = SubViewBaseTag + i;

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(fLabelMarginLeft, fHeightSubView - fHeightLabel, fHeightSubView - 2 * fLabelMarginLeft, fHeightLabel)];
            //            label.backgroundColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12.0];
            label.adjustsFontSizeToFitWidth = YES;
            label.tag = LabelTag;
            [subView addSubview:label];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((fHeightSubView - fHeightImageView) * 0.5, fImageViewMarginTop, fHeightImageView, fHeightImageView)];
            //            [imageView setBackgroundColor:[UIColor greenColor]];
            imageView.tag = ImageViewTag;

            [subView addSubview:imageView];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, fHeightSubView, fHeightSubView)];
            [button addTarget:self action:@selector(onUserButtons:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [subView addSubview:button];

            [self addSubview:subView];
        }
    }
    return self;
}

#pragma mark - Public Methods
+ (GTRecentUsersView *)recentUsersViewWithFrame:(CGRect)frame delegate:(id<GTRecentUsersViewDelegate>)delegate
{
    GTRecentUsersView *view = [[GTRecentUsersView alloc] initWithFrame:frame];
    view.delegate = delegate;
    return view;
}

- (void)setRecentUsers:(NSArray *)users
{
    if (users.count >= iUsersCount) {
        for (int i = 0; i < iUsersCount; i++) {
            GTUserBase *item = users[i];
            UIView *subView = [self viewWithTag:i + SubViewBaseTag];
            UILabel *label = (UILabel *)[subView viewWithTag:LabelTag];
            label.text = item.nickName;
            UIImageView *imageView = (UIImageView *)[subView viewWithTag:ImageViewTag];
            if (RYIsValidString(item.localImageURL)) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  UIImage *image = [UIImage imageWithContentsOfFile:[item.localImageURL absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
                  image = [UIImage circleImage:image withParam:0];
                  dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                  });
                });
            }
            else {
                [[GTModel sharedModel] downloadRecentUser:item
                                               completion:^(NSError *error, NSData *data) {
                                                 if (!error) {
                                                     UIImage *image = [UIImage imageWithData:data];
                                                     image = [UIImage circleImage:image withParam:0];
                                                     imageView.image = image;
                                                 }
                                               }];
            }
        }
    }
    else {
        RYCONDITIONLOG(DEBUG, @"Thera aren't enough users to be set!");
    }
}
@end
