//
//  GTShare.h
//  GTravel
//
//  Created by QisMSoM on 15/7/23.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTShare : NSObject

/*
 自定义的分享类，使用的是类方法，其他地方只要 构造分享内容publishContent就行了
 */

+ (void)shareWithContent:(id)publishContent; //自定义分享界面

@end
