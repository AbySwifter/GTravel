//
//  DTSubPartnersView.h
//  GTravel
//
//  Created by Ray Yueh on 7/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTPartner;
@protocol DTSubPartnersViewDelegate;
@interface DTSubPartnersView : UIView

+ (CGFloat)subPartnersViewHeight;
+ (DTSubPartnersView *)subPartnersViewWithFrame:(CGRect)frame partners:(NSArray *)partners delegate:(id<DTSubPartnersViewDelegate>)delegate;

@end

@protocol DTSubPartnersViewDelegate <NSObject>

- (void)subPartnersView:(DTSubPartnersView *)partnerView didClickPartner:(DTPartner *)partner;

@end