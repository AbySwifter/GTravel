//
//  DTSubLogoImage.h
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//  合作商视图

#import <UIKit/UIKit.h>
@class DTSubLogoImage;
@protocol DTSubLogoImageDelegate <NSObject>

- (void)logoImageDidClicked:(DTSubLogoImage *)logoImage;

@end


#import "DTSubLogoDetail.h"
@interface DTSubLogoImage : UIImageView
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *linkURL;
@property (nonatomic, strong) DTSubLogoDetail *subLogo;

@property (nonatomic, weak) id<DTSubLogoImageDelegate> delegate;
@end
