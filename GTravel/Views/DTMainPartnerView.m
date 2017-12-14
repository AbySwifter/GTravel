//
//  DTMainPartnerView.m
//  GTravel
//
//  Created by Ray Yueh on 7/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTMainPartnerView.h"
#import "RYCommon.h"
#import "UIImageView+AFNetworking.h"
#import "DTPartner.h"
#import "DTViewCommon.h"

@interface DTMainPartnerView ()
@property (nonatomic, weak) id<DTMainPartnerDelegate> delegate;
@property (nonatomic, strong) NSArray *partners;

- (void)onPartnerLogoButton:(UIButton *)sender;

@end

@implementation DTMainPartnerView
#pragma mark - Non-Public Methods
- (void)onPartnerLogoButton:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(mainPartnerView:didClickPartner:))) {
        [self.delegate mainPartnerView:self didClickPartner:self.partners[sender.tag]];
    }
}

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame partners:(NSArray *)partners delegate:(id<DTMainPartnerDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        NSAssert(RYIsValidArray(partners) && partners.count >= 2, @"Partners is not avaliable.");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, frame.size.width * 0.5, frame.size.height);
        [button addTarget:self action:@selector(onPartnerLogoButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0;
        [self addSubview:button];

        DTPartner *partner = partners[0];
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:button.frame];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([partner.image rangeOfString:@"http"].location != NSNotFound) {
            [logoImageView setImageWithURL:[NSURL URLWithString:partner.image]];
        }
        else {
            logoImageView.image = [UIImage imageNamed:partner.image];
        }
        [self addSubview:logoImageView];

        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(frame.size.width * 0.5, 0, frame.size.width * 0.5, frame.size.height);
        [button addTarget:self action:@selector(onPartnerLogoButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        [self addSubview:button];

        partner = partners[1];
        logoImageView = [[UIImageView alloc] initWithFrame:button.frame];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([partner.image rangeOfString:@"http"].location != NSNotFound) {
            [logoImageView setImageWithURL:[NSURL URLWithString:partner.image]];
        }
        else {
            logoImageView.image = [UIImage imageNamed:partner.image];
        }
        [self addSubview:logoImageView];

        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 0.5, 0, 1, frame.size.height)];
        lineImageView.contentMode = UIViewContentModeScaleToFill;
        lineImageView.image = [UIImage imageNamed:@"bg_line"];
        [self addSubview:lineImageView];

        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
        lineImageView.contentMode = UIViewContentModeScaleToFill;
        lineImageView.image = [UIImage imageNamed:@"bg_line"];
        [self addSubview:lineImageView];

        self.partners = partners;
        self.delegate = delegate;
    }
    return self;
}

+ (CGFloat)mainPartnerViewHeight
{
    return 130.0 * ScreenScale;
}

+ (DTMainPartnerView *)mainPartnerViewWithFrame:(CGRect)frame partners:(NSArray *)partners delegate:(id<DTMainPartnerDelegate>)delegate
{
    return [[DTMainPartnerView alloc] initWithFrame:frame partners:partners delegate:delegate];
}

@end
