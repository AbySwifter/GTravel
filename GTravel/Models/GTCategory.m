//
//  GTCategory.m
//  GTravel
//
//  Created by Raynay Yue on 5/27/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTCategory.h"
#import "GTravelNetDefinitions.h"
#import "RYCommon.h"

@implementation GTCategory
+ (GTCategory *)categoryFromDictionary:(NSDictionary *)dictionary
{
    GTCategory *category = [[GTCategory alloc] init];
    category.categoryID = dictionary[kCategoryID];
    category.title = [dictionary nonNilStringValueForKey:kTitle];
    category.thumbnail = [dictionary nonNilStringValueForKey:kThumbnail];
    category.userID = [dictionary[kUserID] description];
    category.localImage = [dictionary nonNilStringValueForKey:kLocalImagePath];
    return category;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dictionary = @{kCategoryID : self.categoryID,
                                 kTitle : self.title,
                                 kThumbnail : self.thumbnail,
                                 kLocalImagePath : self.localImage,
                                 kUserID : self.userID};
    return dictionary;
}

@end
