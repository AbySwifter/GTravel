//
//  DTKeychain.h
//  SuzhouVillage
//
//  Created by Raynay Yue on 8/20/14.
//  Copyright (c) 2014 Xi'an Tripshow Information Technology Limited Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTKeychain : NSObject
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void) delete:(NSString *)service;
@end


@interface WQUserDataManager : NSObject

/**
 *  @brief  存储密码
 *
 *  @param  password    密码内容
 */
+ (void)savePassWord:(NSString *)password;

/**
 *  @brief  读取密码
 *
 *  @return 密码内容
 */
+ (id)readPassWord;

/**
 *  @brief  删除密码数据
 */
+ (void)deletePassWord;

@end