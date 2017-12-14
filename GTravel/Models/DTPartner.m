//
//  DTPartner.m
//  GTravel
//
//  Created by Ray Yueh on 7/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTPartner.h"
#import "RYCommon.h"
#import "GTravelNetDefinitions.h"

@implementation DTPartner

+ (DTPartner *)partnerWithDictionary:(NSDictionary *)dictionary
{
    DTPartner *partner = [[DTPartner alloc] init];
    partner.name = [dictionary nonNilStringValueForKey:kPartnerName];
    partner.image = [dictionary nonNilStringValueForKey:kPartnerImage];
    partner.linkUrl = [dictionary nonNilStringValueForKey:kPartnerLinkURL];
    return partner;
}

@end
