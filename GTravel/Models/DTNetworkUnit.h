//
//  DTNetworkUnit.h
//  GTravel
//
//  Created by Raynay Yue on 5/7/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DTCompletionBlock)(NSError *error, id responseObject);

@interface DTNetworkUnit : NSObject

- (void)requestToURL:(NSURL *)url timeout:(NSTimeInterval)timeout completion:(DTCompletionBlock)handler;
- (void)sendParams:(NSDictionary *)params toURL:(NSURL *)url timeout:(NSTimeInterval)timeout completion:(DTCompletionBlock)handler;

@end
