//
//  DTSubLogo.h
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//  用来存放合作商视图的视图

#import <UIKit/UIKit.h>
@class DTSubLogoImage;
@protocol DTSubLogoDelegate <NSObject>

- (void)logoImageDidClicked:(DTSubLogoImage *)logoImage;

@end

@interface DTSubLogo : UIView
@property (nonatomic, strong) NSMutableArray *subLogoArray;

@property (nonatomic, weak) id<DTSubLogoDelegate> delegate;
@end
