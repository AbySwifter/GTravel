//
//  DTNetworkUnit.m
//  GTravel
//
//  Created by Raynay Yue on 5/7/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTNetworkUnit.h"
#import "RYCommon.h"

#define DTNetworkUnitDebug 0

@interface NSMutableURLRequest (DTNetwork)
+ (NSMutableURLRequest *)networkRequestGetToURL:(NSURL *)url timeout:(NSTimeInterval)timeout;
+ (NSMutableURLRequest *)networkRequestPostToURL:(NSURL *)url body:(NSData *)data timeout:(NSTimeInterval)timeout;
@end

@implementation NSMutableURLRequest (DTNetwork)
+ (NSMutableURLRequest *)networkRequestGetToURL:(NSURL *)url timeout:(NSTimeInterval)timeout
{
    RYCONDITIONLOG(DTNetworkUnitDebug, @"\nrequest URL:\n%@", url.absoluteString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    [request setHTTPMethod:@"GET"];
    return request;
}

+ (NSMutableURLRequest *)networkRequestPostToURL:(NSURL *)url body:(NSData *)data timeout:(NSTimeInterval)timeout
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    RYCONDITIONLOG(DTNetworkUnitDebug, @"\nrequest URL:\n%@,\nparams:\n%@", url.absoluteString, str);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    return request;
}

@end

@interface DTNetworkUnit ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
- (void)requestPostToURL:(NSURL *)url params:(NSDictionary *)params timeout:(NSTimeInterval)timeout completionBlock:(DTCompletionBlock)block;
@end

@implementation DTNetworkUnit
#pragma mark - Non-Public Methods
- (instancetype)init
{
    if (self = [super init]) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        self.operationQueue = queue;
    }
    return self;
}

- (void)dealloc
{
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
}

#pragma mark - Public Methods
- (void)requestToURL:(NSURL *)url timeout:(NSTimeInterval)timeout completion:(DTCompletionBlock)handler
{	
    NSMutableURLRequest *request = [NSMutableURLRequest networkRequestGetToURL:url timeout:timeout];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:self.operationQueue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if (connectionError) {
//                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                   handler(connectionError, nil);
//                                 });
//                             }
//                             else {
//                                 NSError *err = NULL;
//                                 id foundationObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
//                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                   handler(err, foundationObject);
//                                 });
//                             }
//                           }];
	NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
		if (connectionError) {
			dispatch_async(dispatch_get_main_queue(), ^{
				handler(connectionError, nil);
			});
		}
		else {
			NSError *err = NULL;
			id foundationObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
			dispatch_async(dispatch_get_main_queue(), ^{
				handler(err, foundationObject);
			});
		}
	}];
	[task resume];
}

- (void)sendParams:(NSDictionary *)params toURL:(NSURL *)url timeout:(NSTimeInterval)timeout completion:(DTCompletionBlock)handler
{
    NSError *error = NULL;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        handler(error, nil);
    }
    else {
        NSMutableURLRequest *request = [NSMutableURLRequest networkRequestPostToURL:url body:data timeout:timeout];
//        [NSURLConnection sendAsynchronousRequest:request
//                                           queue:self.operationQueue
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                                 if (connectionError) {
//                                     handler(connectionError, nil);
//                                 }
//                                 else {
//                                     NSError *err = NULL;
//                                     id foundationObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
//
//                                     handler(err, foundationObject);
//                                 }
//                               }];
		NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
			if (connectionError) {
				handler(connectionError, nil);
			}
			else {
				NSError *err = NULL;
				id foundationObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
				
				handler(err, foundationObject);
			}
		}];
		[task resume];
    }
}

- (void)requestPostToURL:(NSURL *)url params:(NSDictionary *)params timeout:(NSTimeInterval)timeout completionBlock:(DTCompletionBlock)block
{
    NSError *error = NULL;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          block(error, nil);
        });
    }
    else {
        NSMutableURLRequest *request = [NSMutableURLRequest networkRequestPostToURL:url body:data timeout:timeout];
//        [NSURLConnection sendAsynchronousRequest:request
//                                           queue:self.operationQueue
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                                 if (connectionError) {
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                       block(connectionError, nil);
//                                     });
//                                 }
//                                 else {
//                                     NSError *err = NULL;
//                                     id foundationObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                       block(err, foundationObject);
//                                     });
//                                 }
//                               }];
		NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
			if (connectionError) {
				dispatch_async(dispatch_get_main_queue(), ^{
					block(connectionError, nil);
				});
			}
			else {
				NSError *err = NULL;
				id foundationObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&err];
				dispatch_async(dispatch_get_main_queue(), ^{
					block(err, foundationObject);
				});
			}
		}];
		[task resume];
		
    }
}

@end
