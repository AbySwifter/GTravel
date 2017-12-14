//
//  NSURL+Additions.h
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Additions)
/**
 * @brief converting query string to NSDictionary.
 * @retrun a dictionary converted from query string.
 */
- (NSDictionary *)queryDictionary;
@end
