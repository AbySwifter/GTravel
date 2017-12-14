//
//  DTWeChatDefinitions.h
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#define MaxLengthWeiXinShareTitle 512
#define MaxLengthWeiXinShareImageData 32000.0

#define URLFormatGetAccessToken @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"
#define URLFormatRefreshToken @"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@"
#define URLFormatCheckToken @"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@"
#define URLFormatGetUserInfo @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@"

#define kSAWeChatAuthScope @"snsapi_userinfo"
#define kSAWeChatAuthState @"9527"

#define kResErrCode @"errcode"
#define kResErrMsg @"errmsg"

#define kResAccessToken @"access_token"
#define kResExpiresIn @"expires_in"
#define kResRefreshToken @"refresh_token"
#define kResOpenID @"openid"
#define kResScope @"scope"
#define kResNickName @"nickname"
#define kResSex @"sex" //1:male,2:female
#define kResProvince @"province"
#define kResCity @"city"
#define kResCountry @"country"
#define kResHeadImgURL @"headimgurl"
#define kResPrivilege @"privilege"
#define kResUnionID @"unionid"
