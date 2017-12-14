//
//  GTTablePartnerFoot.h
//  GTravel
//
//  Created by QisMSoM on 15/7/17.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTTablePartnerFootDelegate <NSObject>

- (void)showLogoDetail:(UIButton *)button;

- (void)showLogoDetailWithLeftButton:(UIButton *)button;

@end

@interface GTTablePartnerFoot : UICollectionReusableView

@property (nonatomic, weak) id<GTTablePartnerFootDelegate> delegate;

@end
