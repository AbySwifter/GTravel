//
//  DTWeChatUserProfile.m
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTWeChatUserProfile.h"
#import "DTWeChatDefinitions.h"

@implementation DTWeChatUserProfile

+ (DTWeChatUserProfile *)weChatUserProfileWithDictionary:(NSDictionary *)dict
{
    DTWeChatUserProfile *weChatUserProfile = [[DTWeChatUserProfile alloc] init];
    weChatUserProfile.openID = dict[kResOpenID];
    weChatUserProfile.nickName = dict[kResNickName];
    NSInteger sex = [dict[kResSex] integerValue];
    weChatUserProfile.sex = sex == 1 ? DTSexMale : DTSexFemale;
    weChatUserProfile.province = dict[kResProvince];
    weChatUserProfile.city = dict[kResCity];
    weChatUserProfile.country = dict[kResCountry];
    weChatUserProfile.headImageURL = dict[kResHeadImgURL];
    weChatUserProfile.privilege = dict[kResPrivilege];
    weChatUserProfile.unionID = dict[kResUnionID];
    return weChatUserProfile;
}

@end
