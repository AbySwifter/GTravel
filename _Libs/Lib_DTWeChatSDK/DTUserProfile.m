//
//  DTUserProfile.m
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTUserProfile.h"
#import "RYCommon.h"

@interface DTUserProfile ()
- (void)startDownloadingHeadImageOfURL:(NSURL *)url;
@end

@implementation DTUserProfile
#pragma mark - Non-Public Methods
- (void)startDownloadingHeadImageOfURL:(NSURL *)url
{
	__weak DTUserProfile* weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
	NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if ([response.MIMEType rangeOfString:@"image"].location != NSNotFound) {
				NSString *fileExtension = [response.MIMEType lastPathComponent];
				NSString *wholeFileName = [weakSelf.nickName stringByAppendingString:fileExtension];
				NSString *localFilePath = RYFilePath(wholeFileName, RYDirectoryTypeDocuments);
				if ([data writeToFile:localFilePath atomically:YES]) {
					weakSelf.headImageLocalPath = localFilePath;
					if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userProfile:didDownloadUserHeadImage:)]) {
						[weakSelf.delegate userProfile:weakSelf didDownloadUserHeadImage:[UIImage imageWithContentsOfFile:localFilePath]];
					}
				}
			}
			else {
				if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userProfile:downloadUserHeadImageDidFailWithError:)]) {
					[weakSelf.delegate userProfile:weakSelf downloadUserHeadImageDidFailWithError:[NSError errorWithDomain:@"Response data error!" code:-2 userInfo:nil]];
				}
			}
		});
	}];
	[task resume];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if ([response.MIMEType rangeOfString:@"image"].location != NSNotFound) {
//                                 NSString *fileExtension = [response.MIMEType lastPathComponent];
//                                 NSString *wholeFileName = [self.nickName stringByAppendingString:fileExtension];
//                                 NSString *localFilePath = RYFilePath(wholeFileName, RYDirectoryTypeDocuments);
//                                 if ([data writeToFile:localFilePath atomically:YES]) {
//                                     self.headImageLocalPath = localFilePath;
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                       if (self.delegate && [self.delegate respondsToSelector:@selector(userProfile:didDownloadUserHeadImage:)]) {
//                                           [self.delegate userProfile:self didDownloadUserHeadImage:[UIImage imageWithContentsOfFile:localFilePath]];
//                                       }
//                                     });
//                                 }
//                             }
//                             else {
//                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                   if (self.delegate && [self.delegate respondsToSelector:@selector(userProfile:downloadUserHeadImageDidFailWithError:)]) {
//                                       [self.delegate userProfile:self downloadUserHeadImageDidFailWithError:[NSError errorWithDomain:@"Response data error!" code:-2 userInfo:nil]];
//                                   }
//                                 });
//                             }
//
//                           }];
}

#pragma mark - Public Methods
- (instancetype)init
{
    if (self = [super init]) {
        self.sex = DTSexUnkown;
    }
    return self;
}

- (void)startDownloadingUserHeadImageFile
{
    if (RYIsValidString(self.headImageURL)) {
        [self startDownloadingHeadImageOfURL:[NSURL URLWithString:self.headImageURL]];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
          if (self.delegate && [self.delegate respondsToSelector:@selector(userProfile:downloadUserHeadImageDidFailWithError:)]) {
              [self.delegate userProfile:self downloadUserHeadImageDidFailWithError:[NSError errorWithDomain:@"Head image's url is nil!" code:-1 userInfo:nil]];
          }
        });
    }
}
@end
