//
//  GTravelToolItem.m
//  GTravel
//
//  Created by Raynay Yue on 5/8/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTravelToolItem.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"

NSString *const GTravelNotificationToolItemImageDidLoad = @"GTravelNotificationToolItemImageDidLoad";

@implementation GTravelToolItem
+ (GTravelToolItem *)toolItemFromDictionary:(NSMutableDictionary *)dict
{
    GTravelToolItem *item = [[GTravelToolItem alloc] init];
    item.title = [dict nonNilStringValueForKey:kTitle];
    item.detailURL = [dict nonNilStringValueForKey:kDetailURL];
    item.imageURL = [dict nonNilStringValueForKey:kImageURL];
    item.thumbnailURL = [dict nonNilStringValueForKey:kThumbnail];
    item.localImage = [dict nonNilStringValueForKey:kLocalImagePath];
    item.localThumbnail = [dict nonNilStringValueForKey:kLocalThumbnailPath];
    return item;
}

- (NSDictionary *)dictionaryFormat
{
    NSDictionary *dict = @{kTitle : self.title,
                           kDetailURL : self.detailURL,
                           kImageURL : self.imageURL,
                           kThumbnail : self.thumbnailURL,
                           kLocalImagePath : self.localImage,
                           kLocalThumbnailPath : self.localThumbnail};
    return dict;
}

@end
