//
//  RYDebug.h
//
//  Created by Raynay Yue on 01/23/2015.
//  Copyright (c) 2010-2015 Raynay Studio. All rights reserved.
//

#if RELEASE
#define RYCONDITIONLOG(CONDITION, xx, ...) ((void)0)
#else
#define RYCONDITIONLOG(CONDITION, xx, ...)                                       \
    {                                                                            \
        if ((CONDITION)) {                                                       \
            NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
        }                                                                        \
    }                                                                            \
    ((void)0)

#endif