//
//  DTWeChatShareMessage.h
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DTWeChatShareType) {
    DTWeChatShareTypeMoments, //朋友圈
    DTWeChatShareTypeNewSession //微信好友
};

@interface DTWeChatShareMessage : NSObject

/*消息标题*/
@property (nonatomic, copy) NSString *title;

/*消息描述*/
@property (nonatomic, copy) NSString *messageDesc;

/*分享的图片数据.若该图片超过限制,会对其做压缩处理.以满足微信对分享的图片的要求.*/
@property (nonatomic, strong) NSData *imageData;

/*分享的URL连接*/
@property (nonatomic, copy) NSString *url;

/*分享的图片连接*/
@property (nonatomic, copy) NSString *imageURL;

/*分享类型,默认为DTWeChatShareTypeMoments*/
@property (nonatomic, assign) DTWeChatShareType type;

@end
