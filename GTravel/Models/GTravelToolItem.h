//
//  GTravelToolItem.h
//  GTravel
//
//  Created by Raynay Yue on 5/8/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GTravelNotificationToolItemImageDidLoad;

@interface GTravelToolItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailURL;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *localImage;
@property (nonatomic, copy) NSString *localThumbnail;

+ (GTravelToolItem *)toolItemFromDictionary:(NSMutableDictionary *)dict;
- (NSMutableDictionary *)dictionaryFormat;

@end
