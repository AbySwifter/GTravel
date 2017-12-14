//
//  GTImage.m
//  GTravel
//
//  Created by Raynay Yue on 5/15/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTImage.h"
#import "RYCommon.h"


#define DownloadRequestTimeout  20

NSString *const kGTImageNotificationDidStartDownloadingImage = @"kGTImageNotificationDidStartDownloadingImage";
NSString *const kGTImageNotificationDidDownloadImage = @"kGTImageNotificationDidDownloadImage";
NSString *const kGTImageNotificationDownloadFailed = @"kGTImageNotificationDownloadFailed";

NSString *const kGTImageNotificationUserInfoError = @"kGTImageNotificationUserInfoError";
NSString *const kGTImageNotificationUserInfoMIMEType = @"kGTImageNotificationUserInfoMIMEType";
NSString *const kGTImageNotificationUserInfoImageData = @"kGTImageNotificationUserInfoImageData";

NSString *const kGTImageURL = @"kGTImageURL";
NSString *const kGTImageDetailURL =  @"kGTImageDetailURL";
NSString *const kGTImageLocalURL = @"kGTImageLocalURL";
NSString *const kGTImageState = @"kGTImageState";

@implementation GTImage
#pragma mark - Non-Public Methods
-(instancetype)init
{
    if(self = [super init])
    {
        self.state = GTImageStateUnKnown;
    }
    return self;
}

#pragma mark - Public Methods
+(GTImage*)gtImageFromDictionary:(NSDictionary*)dictionary
{
    GTImage *image = [[GTImage alloc] init];
    image.url = [dictionary nonNilStringValueForKey:kGTImageURL];
    image.detailURL = [dictionary nonNilStringValueForKey:kGTImageDetailURL];
    image.localURL = [dictionary nonNilStringValueForKey:kGTImageLocalURL];
    if([[dictionary allKeys] containsObject:kGTImageState])
    {
        image.state = [dictionary[kGTImageState] integerValue];
    }
    return image;
}

-(NSDictionary*)dictionaryInfo
{
    NSDictionary *dict = @{kGTImageURL : RYIsValidString(self.url) ? self.url : @"",
                           kGTImageDetailURL : RYIsValidString(self.detailURL) ? self.detailURL : @"",
                           kGTImageLocalURL : RYIsValidString(self.localURL) ? self.localURL : @"",
                           kGTImageState : @(self.state)
                           };
    return dict;
}

-(void)startDownloadingImage
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:DownloadRequestTimeout];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if(connectionError)
        {
            if(RYDelegateCanResponseToSelector(self.delegate, @selector(gtImage:downloadImageDidFailWithError:)))
            {
                [self.delegate gtImage:self downloadImageDidFailWithError:connectionError];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kGTImageNotificationDownloadFailed object:self userInfo:@{kGTImageNotificationUserInfoError : connectionError}];
        }
        else
        {
            if(RYDelegateCanResponseToSelector(self.delegate, @selector(gtImage:didDownloadImageWithData:)))
            {
                [self.delegate gtImage:self didDownloadImageWithData:data];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kGTImageNotificationDidDownloadImage object:self userInfo:@{kGTImageNotificationUserInfoMIMEType : response.MIMEType,kGTImageNotificationUserInfoImageData : data}];
        }
    }];
    if(RYDelegateCanResponseToSelector(self.delegate, @selector(gtImageDidStartDownloading:)))
    {
        [self.delegate gtImageDidStartDownloading:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTImageNotificationDidStartDownloadingImage object:self];
}

@end
