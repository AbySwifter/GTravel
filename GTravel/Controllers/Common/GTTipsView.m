//
//  GTTipsView.m
//  GTravel
//
//  Created by Raynay Yue on 5/26/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTTipsView.h"
#import "RYCommon.h"
#import "GTravelToolItem.h"
#import "GTModel.h"
#import "UIImageView+AFNetworking.h"

#define SubViewBaseTag 100
#define LabelTag 10
#define ImageViewTag 11

#define fHeightLabel 21
#define fMarginImageViewTop 5

#define iTipsCount 5

CGFloat const fTipsViewRatio = (300.0 / 200.0);

@interface GTTipsView ()
@property (nonatomic, weak) id<GTTipsViewDelegate> delegate;

- (void)onTipItemButton:(UIButton *)sender;

@end

@implementation GTTipsView

- (void)onTipItemButton:(UIButton *)sender
{
    RYCONDITIONLOG(DEBUG, @"%d", (int)sender.tag);
    switch (sender.tag) {
        case iTipsCount: {
            if (RYDelegateCanResponseToSelector(self.delegate, @selector(tipsViewDidClickMoreTips:))) {
                [self.delegate tipsViewDidClickMoreTips:self];
            }
            break;
        }
        default: {
            if (RYDelegateCanResponseToSelector(self.delegate, @selector(tipsView:didClickTipAtIndex:))) {
                [self.delegate tipsView:self didClickTipAtIndex:sender.tag];
            }
            break;
        }
    }
}

#pragma mark - Non-Public Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat fHeightSubView = frame.size.height * 0.5;
        CGFloat fHeightImageView = fHeightSubView - fHeightLabel - fMarginImageViewTop * 2;

        for (int i = 0; i <= iTipsCount; i++) {
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake((i % 3) * fHeightSubView, (i / 3) * fHeightSubView, fHeightSubView, fHeightSubView)];
            subView.backgroundColor = [UIColor clearColor];
            subView.tag = SubViewBaseTag + i;

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, fHeightSubView - fHeightLabel, fHeightSubView, fHeightLabel)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15.0];
            label.textColor = [UIColor grayColor];
            label.tag = LabelTag;
            [subView addSubview:label];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((fHeightSubView - fHeightImageView) * 0.5, fMarginImageViewTop, fHeightImageView, fHeightImageView)];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.clipsToBounds = YES;
            imageView.tag = ImageViewTag;

            if (i == iTipsCount) {
                imageView.image = [UIImage imageNamed:@"bt_more_thumbnail"];
                label.text = @"更多";
            }

            [subView addSubview:imageView];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, fHeightSubView, fHeightSubView)];
            [button addTarget:self action:@selector(onTipItemButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [subView addSubview:button];

            [self addSubview:subView];
        }
        UIImage *image = [UIImage imageNamed:@"bg_line"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(fHeightSubView, 0, 1, frame.size.height);
        [self addSubview:imageView];

        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(2 * fHeightSubView, 0, 1, frame.size.height);
        [self addSubview:imageView];

        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(0, fHeightSubView, frame.size.width, 1);
        [self addSubview:imageView];

        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(0, 2 * fHeightSubView, frame.size.width, 1);
        [self addSubview:imageView];

        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark - Public Methods
+ (GTTipsView *)tipsViewWithFrame:(CGRect)frame delegate:(id<GTTipsViewDelegate>)delegate
{
    GTTipsView *view = [[GTTipsView alloc] initWithFrame:frame];
    view.delegate = delegate;
    return view;
}

- (void)setTips:(NSArray *)tips
{
    if (tips.count >= iTipsCount) {
        for (int i = 0; i < iTipsCount; i++) {
            GTravelToolItem *item = tips[i];
            UIView *subView = [self viewWithTag:i + SubViewBaseTag];
            UILabel *label = (UILabel *)[subView viewWithTag:LabelTag];
            label.text = item.title;
            UIImageView *imageView = (UIImageView *)[subView viewWithTag:ImageViewTag];
            if (RYIsValidString(item.localImage)) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  UIImage *image = [UIImage imageWithContentsOfFile:[item.localImage absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
                  dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                  });
                });
            }
            else {
                [[GTModel sharedModel] downloadToolItem:item
                                             completion:^(NSError *error, NSData *data) {
                                               if (!error) {
                                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                     UIImage *img = [UIImage imageWithData:data];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       imageView.image = img;
                                                     });
                                                   });
                                               }
                                             }];
            }
        }
    }
    else {
        RYCONDITIONLOG(DEBUG, @"There aren't enough tips to be set!");
    }
}

@end
