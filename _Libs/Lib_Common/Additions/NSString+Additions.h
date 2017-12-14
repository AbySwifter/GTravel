//
//  NSString+Additions.h
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYCommonFunctions.h"

@interface NSString (Additions)

/**
 * @brief trimed receiver with the given string list.
 * @param str ... string which will be trimed.
 * @retrun string which the given string list have been trimed.
 */
- (instancetype)trimedByRemoveStrings:(NSString *)str, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * @brief get receiver's file name.
 * @retrun file name of receiver.e: return 'hello' of 'hello.txt'
 */
- (NSString *)pathFileName;

/**
 * @brief trimed receiver's html label string.
 * @retrun the string with html string was removed.
 */
- (instancetype)trimingHtmlTag;

/**
 * @brief return a string which is not nil.return itself if receiver is not nil,return @"" if not
 */
- (instancetype)nonNilString;

/**
 * @brief get relative path string with app sandbox part was removed.
 * @retrun a relative path string.
 */
- (NSString *)relativePathString;

/**
 * @brief get an absolute path string with app sandbox part was added.
 * @param type directory type to be added.
 * @retrun an absolute path string.
 */
- (NSString *)absolutePathStringWithDirectoryPathType:(RYDirectoryType)type;
@end
