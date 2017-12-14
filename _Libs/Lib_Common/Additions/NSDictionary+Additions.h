//
//  NSDictionary+Additions.h
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)
/**
 * @brief return a NSString value for key which is not nil.
 * @param key key for value
 * @retrun if value of key is a NSString object and not nil,return it,else return @"".
 */
- (NSString *)nonNilStringValueForKey:(NSString *)key;
@end
