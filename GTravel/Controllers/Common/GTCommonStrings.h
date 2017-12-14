//
//  GTCommonStrings.h
//  GTravel
//
//  Created by Raynay Yue on 5/20/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//


#define JSStringGetWebTitle @"function getWebTitle()\
                                                {\
                                                    var title = document.title; \
                                                    return title;\
                                                } getWebTitle();"

#define JSStringGetThumbnailImageFormat @"function getWebThumbnail()\
                                                {\
                                                    var imgs = document.getElementsByTagName(\"img\");\
                                                    var imgURL = null;\
                                                    for(var i = 0;i<imgs.length;i++)\
                                                    {\
                                                        var img = imgs[i];\
                                                        if(img.width >= %d && img.height >= %d)\
                                                        {\
                                                            imgURL = img.src;\
                                                            break;\
                                                        }\
                                                    }\
                                                    return imgURL;\
                                                } getWebThumbnail();"


//User View

#define TitleFavorite @"收藏"
#define TitleMessage @"消息"
#define TitleLogout @"登出"
#define TitleHotel @"酒店"
#define TitleCar @"租车"
#define TitleTax @"退税"
#define TitleCards @"优惠券"

#define IconNameFavorite @"icon_favorite"
#define IconNameMessage @"icon_messages"
#define IconNameLogout @"personalLogout"
#define IconNameHotel @"default_head_icon"
#define IconNameCar @"default_head_icon"
#define IconNameTax @"default_head_icon"
#define IconNameCards @"aide_12"
