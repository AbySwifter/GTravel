//
//  DTMainPartnerView.h
//  GTravel
//
//  Created by Ray Yueh on 7/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTPartner;
@protocol DTMainPartnerDelegate;
@interface DTMainPartnerView : UIView

+ (CGFloat)mainPartnerViewHeight;
+ (DTMainPartnerView *)mainPartnerViewWithFrame:(CGRect)frame partners:(NSArray *)partners delegate:(id<DTMainPartnerDelegate>)delegate;

@end

@protocol DTMainPartnerDelegate <NSObject>

- (void)mainPartnerView:(DTMainPartnerView *)partnerView didClickPartner:(DTPartner *)parnter;

@end
