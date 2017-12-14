//
//  DTSubPartnersView.m
//  GTravel
//
//  Created by Ray Yueh on 7/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTSubPartnersView.h"
#import "RYCommon.h"
#import "DTPartner.h"
#import "DTViewCommon.h"
#import "UIImageView+AFNetworking.h"

#define fMargin 10

@interface DTSubPartnersView ()
@property (nonatomic, weak) id<DTSubPartnersViewDelegate> delegate;
@property (nonatomic, strong) NSArray *partners;
- (void)onPartnersLogoButtons:(UIButton *)sender;
@end

@implementation DTSubPartnersView
#pragma mark - Non-Public Methods
- (void)onPartnersLogoButtons:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(subPartnersView:didClickPartner:))) {
        [self.delegate subPartnersView:self didClickPartner:self.partners[sender.tag]];
    }
}
#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame partners:(NSArray *)partners delegate:(id<DTSubPartnersViewDelegate>)delegate;
{
    if (self = [super initWithFrame:frame]) {
        NSAssert(RYIsValidArray(partners) && partners.count >= 5, @"Partners is not available for %@", NSStringFromClass([self class]));
        CGFloat fHeight = [DTSubPartnersView subPartnersViewHeight];
        for (int i = 0; i < partners.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat fX = i == 0 ? fMargin + i * fHeight : fMargin + i * fHeight;
            button.frame = CGRectMake(fX, fMargin, fHeight, fHeight);
            button.tag = i;
            [button addTarget:self action:@selector(onPartnersLogoButtons:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];

            DTPartner *partner = partners[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:button.frame];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            if ([partner.image rangeOfString:@"http"].location != NSNotFound) {
                [imageView setImageWithURL:[NSURL URLWithString:partner.image]];
            }
            else {
                [imageView setImage:[UIImage imageNamed:partner.image]];
            }
            [self addSubview:imageView];

            UIImageView *seperateLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
            seperateLineImageView.contentMode = UIViewContentModeScaleToFill;
            seperateLineImageView.image = [UIImage imageNamed:@"bg_line"];
            [self addSubview:seperateLineImageView];

            self.partners = partners;
            self.delegate = delegate;
        }
    }
    return self;
}

+ (CGFloat)subPartnersViewHeight
{
    return (RYWinRect().size.width - 2 * fMargin) / 5;
}

+ (DTSubPartnersView *)subPartnersViewWithFrame:(CGRect)frame partners:(NSArray *)partners delegate:(id<DTSubPartnersViewDelegate>)delegate
{
    return [[DTSubPartnersView alloc] initWithFrame:frame partners:partners delegate:delegate];
}

@end
