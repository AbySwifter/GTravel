//
//  DTPartnerLogo.h
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTLogoButton;

@protocol DTPartnerLogoDelegate <NSObject>
- (void)showLogoViewDetail:(DTLogoButton *)button;
- (void)showLogoViewDetailWithLeftBtn:(DTLogoButton *)button;
@end

@interface DTPartnerLogo : UIView

@property (nonatomic, weak) id<DTPartnerLogoDelegate> delegate;

- (void)launchLogo;

@end
