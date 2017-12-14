//
//  NSData+Additions.h
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)
/**
 * @brief compressed a image data to special length.
 * @param data image data will be compressed.
 * @param length final data length
 * @retrun compressed data if data.length > length,else return data.
 */
+ (NSData *)compressImageData:(NSData *)data toLength:(NSInteger)length;
@end
