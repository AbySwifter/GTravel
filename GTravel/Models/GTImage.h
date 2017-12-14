//
//  GTImage.h
//  GTravel
//
//  Created by Raynay Yue on 5/15/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kGTImageNotificationDidStartDownloadingImage;
extern NSString *const kGTImageNotificationDidDownloadImage;
extern NSString *const kGTImageNotificationDownloadFailed;

extern NSString *const kGTImageNotificationUserInfoError;
extern NSString *const kGTImageNotificationUserInfoMIMEType;
extern NSString *const kGTImageNotificationUserInfoImageData;

extern NSString *const kGTImageURL;
extern NSString *const kGTImageDetailURL;
extern NSString *const kGTImageLocalURL;
extern NSString *const kGTImageState;

typedef NS_ENUM(NSInteger, GTImageState)
{
    GTImageStateUnKnown,
    GTImageStateNotDownload,
    GTImageStateIsDownloading,
    GTImageStateDidDownload
};

@protocol GTImageDownloadDelegate;
@interface GTImage : NSObject
@property(nonatomic,copy)NSString       *url;
@property(nonatomic,copy)NSString       *detailURL;
@property(nonatomic,copy)NSString       *localURL;
@property(nonatomic,assign)GTImageState state;
@property(nonatomic,weak)id<GTImageDownloadDelegate>    delegate;

-(void)startDownloadingImage;

@end

@protocol GTImageDownloadDelegate <NSObject>

-(void)gtImageDidStartDownloading:(GTImage*)image;
-(void)gtImage:(GTImage*)image didDownloadImageWithData:(NSData*)imageData;
-(void)gtImage:(GTImage*)image downloadImageDidFailWithError:(NSError*)error;

@end