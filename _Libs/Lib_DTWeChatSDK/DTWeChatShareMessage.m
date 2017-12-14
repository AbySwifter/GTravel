//
//  DTWeChatShareMessage.m
//
//  Created by Raynay Yue on 5/6/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTWeChatShareMessage.h"

@implementation DTWeChatShareMessage
- (instancetype)init
{
    if (self = [super init]) {
        self.type = DTWeChatShareTypeMoments;
    }
    return self;
}

@end
