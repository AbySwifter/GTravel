//
//  DTUserProfile.h
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*用户的性别*/
typedef NS_ENUM(NSUInteger, DTSex) {
    DTSexUnkown, //未知
    DTSexMale, //男
    DTSexFemale //女
};

@protocol DTUserProfileDelegate;

/*用户Profile的基类*/
@interface DTUserProfile : NSObject
/*当下载用户的头像时,该对象会收到DTUserProfileDelegate的消息.*/
@property (nonatomic, weak) id<DTUserProfileDelegate> delegate;

/*用户昵称*/
@property (nonatomic, copy) NSString *nickName;

/*用户头像的URL*/
@property (nonatomic, copy) NSString *headImageURL;

/*用户头像在本地的存储路径.*/
@property (nonatomic, copy) NSString *headImageLocalPath;

/*性别*/
@property (nonatomic, assign) DTSex sex;

/*开始下载用户的头像图片.*/
- (void)startDownloadingUserHeadImageFile;

@end

/*当下载用户头像的图片时,DTUserProfileDelegate的方法会被调用.*/
@protocol DTUserProfileDelegate <NSObject>

/**
 * @brief  在成功下载了用户的头像,并且保存到本地时调用.
 * @param profile 所下载的用户.
 * @param image 下载好的用户头像.
 */
- (void)userProfile:(DTUserProfile *)profile didDownloadUserHeadImage:(UIImage *)image;

/**
 * @brief 在下载用户头像失败时调用.
 * @param profile 所下载的用户.
 * @param error 出错时生成的NSError对象,包含错误的原因及错误代码.
 */
- (void)userProfile:(DTUserProfile *)profile downloadUserHeadImageDidFailWithError:(NSError *)error;
@end