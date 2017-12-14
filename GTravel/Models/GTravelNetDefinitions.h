//
//  GTravelNetDefinitions.h
//  GTravel
//
//  Created by Raynay Yue on 5/8/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#define BaseURL @"http://germany.dragontrail.com" // http://shopndrive-germany-travel.cn
#define GetAPIUrl(url) [BaseURL stringByAppendingString:url]

#define NetworkTimeOut 30.0

#define RESPONSE_ERROR 0
#define RESPONSE_OK 1

#define SEX_MALE 1
#define SEX_FEMALE 2

#define UGC_FALSE 0
#define UGC_TRUE 1

#define TYPE_SYS 1
#define TYPE_UGC 2

#define kLocalImagePath @"kLocalImagePath"
#define kLocalThumbnailPath @"kLocalThumbnailPath"

//API URLs
#define API_LauchImages @"/api/launchimages"
#define API_BannerList @"/api/banners"
#define API_Register @"/api/register"
#define API_Login @"/api/login"
#define API_myLogin @"/api/my_login"
#define API_myregister @"/api/my_register"
#define API_Logout @"/api/logout"
#define API_Tools @"/api/tools"
#define API_Tags @"/api/tags"
#define API_AddTags @"/api/addtags"
#define API_Users @"/api/arounduser"
#define API_Points @"/api/points"
#define API_UserPoints @"/api/personalpoints"
#define API_Cities @"/api/cities"
#define API_Towns @"/api/townlists"
#define API_CityUsers @"/api/cityusers"
#define API_CityPoints @"/api/citypoints"
#define API_Lines @"/api/lines"
#define API_Comments @"/api/comments"
#define API_UserLocation @"/api/userlocation"
#define API_UploadImage @"/api/uploadimage"
#define API_CityIDs @"/api/cityids"
#define API_AddLine @"/api/addline"
#define API_ChangeFavorite @"/api/processcollect"
#define API_Partners @"/api/partner"
#define API_JsEdit @"description_form"
#define API_TownOrCityPoints @"/api/mapdata"

//Launch Images
#define kSize @"size"

#define kResult @"res"
#define kErrorMessage @"msg"
#define kVersion @"version"
#define kImages @"images"
#define kImageURL @"image"
#define kDetailURL @"detail"

//Banner List
#define kUserID @"user_id"
#define kBanners @"banners"

//Register
#define kCity @"city"
#define kHeadImageURL @"head_image"
#define kNickName @"nick_name"
#define kProvince @"province"
#define kSex @"sex"
#define kUnionID @"union_id"
#define kWeChatID @"wechat_id"
#define kLine @"line"

//Login
#define kDeviceToken @"token"
#define kUserNickName @"nick_name"
#define kPassWord @"pwd"

//Tools
#define kTools @"tools"
#define kTitle @"title"
#define kThumbnail @"thumbnail"

//Tools
#define kTools_id @"tools_id"
#define kTools_title @"tools_title"
#define kTools_image @"tools_image"
#define kTools_thumbnail @"tools_thumbnail"

//ToolsItem
#define kTools_item @"tools_item"
#define kTools_item_isindex @"isindex"
#define kTools_item_detail @"detail"
#define kTools_item_image @"image"
#define kTools_item_thumbnail @"thumbnail"
#define kTools_item_title @"title"


//Tags
#define kTags @"tags"
#define kCategoryID @"cat_id"
#define kFilters @"filters"
#define kFilterID @"filter_id"

//Add Tag
#define kTag @"tag"

//Users
#define kDistance @"distance"

//Points
#define kType @"type"
#define kIsUGC @"is_ugc"
#define kArea_id @"area_id"


//Cities
#define kIndex @"index"
#define kCount @"count"
#define kCities @"cities"
#define kCityID @"city_id"
#define kCityName @"name"
#define kDescription @"description"

// Towns
#define kIndex @"index"
#define kCount @"count"
#define kLists @"lists"
#define kTownID @"city_id"
#define kTownName @"name"

//City Users
#define kUsers @"users"
#define kUsersFavorite @"/collects/"
#define kUsersMessage @"/profiles/message/"
#define kUsersCards @"/profiles/coupons/"

//City Points
#define kPoints @"points"
#define kPointID @"poi_id"
#define kWPPostID @"wp_post_id"
#define kFavorite @"favorite"
#define kLongitude @"longitude"
#define kLatitude @"latitude"
#define kAddress @"address"
#define kCreateTime @"ctime"
#define kUser @"user"

//Lines
#define kLines @"lines"
#define kLineType @"line_type"
#define kLineID @"line_id"
#define kLineDays @"days"
#define kPhotos @"photos"

//Comments
#define kComment @"comment"

//City IDs
#define kCityList @"list"
#define kCityNameCN @"name_zh"
#define kCityWelcomeMessage @"wel_msg"

//Webview protocol keys
#define kWebNavigation @"navigation"
#define kWebFavorite @"collection"


//Partner
#define kPartnerName @"name"
#define kPartnerImage @"image"
#define kPartnerLinkURL @"link_url"
#define kPartnerList @"lists"
