//
//  DTWeChatUserProfile.h
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTUserProfile.h"

/*微信用户信息类*/
@interface DTWeChatUserProfile : DTUserProfile

/*微信的openID,普通用户的标识，对当前开发者帐号唯一.*/
@property (nonatomic, copy) NSString *openID;

/*普通用户个人资料填写的省份.*/
@property (nonatomic, copy) NSString *province;

/*普通用户个人资料填写的城市.*/
@property (nonatomic, copy) NSString *city;

/*国家，如中国为CN.*/
@property (nonatomic, copy) NSString *country;

/*用户统一标识.针对一个微信开放平台帐号下的应用,同一用户的unionid是唯一的.*/
@property (nonatomic, copy) NSString *unionID;

/*用户特权信息,json数组,如微信沃卡用户为(chinaunicom).*/
@property (nonatomic, strong) NSArray *privilege;

/**
 * @brief 生成一个DTWeChatUserProfile对象.
 * @param dict 生成DTWeChatUserProfile对象所需的参数.
 * @retrun 生成的DTWeChatUserProfile对象.
 */
+ (DTWeChatUserProfile *)weChatUserProfileWithDictionary:(NSDictionary *)dict;

@end
