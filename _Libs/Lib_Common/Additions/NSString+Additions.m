//
//  NSString+Additions.m
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import "NSString+Additions.h"
#import "RYCommonFunctions.h"

@implementation NSString (Additions)

- (instancetype)trimedByRemoveStrings:(NSString *)str, ...
{
    va_list args;
    va_start(args, str);
    NSString *strTrimed = [self mutableCopy];
    NSString *strBeTrimed = str;
    while (strBeTrimed) {
        strTrimed = [strTrimed stringByReplacingOccurrencesOfString:strBeTrimed withString:@""];
        strBeTrimed = va_arg(args, NSString *);
    }
    va_end(args);
    return strTrimed;
}

- (NSString *)pathFileName
{
    NSString *name = nil;
    NSString *lastPathComponent = [self lastPathComponent];
    NSString *pathExtension = [lastPathComponent pathExtension];
    if (RYIsValidString(pathExtension)) {
        NSRange range = [lastPathComponent rangeOfString:@"."];
        name = [lastPathComponent substringToIndex:range.location];
    }
    else
        name = lastPathComponent;
    return name;
}

- (instancetype)trimingHtmlTag
{
    NSString *strTrimed = [self mutableCopy];
    NSRange rangeTagLeft = [strTrimed rangeOfString:@"<"];
    while (rangeTagLeft.location != NSNotFound) {
        NSRange rangeTagRight = [strTrimed rangeOfString:@">"];
        if (rangeTagRight.location != NSNotFound) {
            NSRange rangeRemoved = {rangeTagLeft.location, rangeTagRight.location + rangeTagRight.length - rangeTagLeft.location};
            NSString *strRemoved = [strTrimed substringWithRange:rangeRemoved];
            strTrimed = [strTrimed stringByReplacingOccurrencesOfString:strRemoved withString:@""];
        }
        else {
            strTrimed = [strTrimed stringByReplacingOccurrencesOfString:@"<" withString:@""];
        }
        rangeTagLeft = [strTrimed rangeOfString:@"<"];
    }
    return [strTrimed stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

- (instancetype)nonNilString
{
    return RYIsValidString(self) ? self : @"";
}

- (NSString *)relativePathString
{
    NSString *strTemporaryPath = NSTemporaryDirectory();
    NSString *strDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    NSString *strRelativePath = self;
    if ([self rangeOfString:strTemporaryPath].location != NSNotFound) {
        strRelativePath = [self stringByReplacingOccurrencesOfString:strTemporaryPath withString:@""];
    }
    else if ([self rangeOfString:strDocumentPath].location != NSNotFound) {
        strRelativePath = [self stringByReplacingOccurrencesOfString:strDocumentPath withString:@""];
    }
    return strRelativePath;
}

- (NSString *)absolutePathStringWithDirectoryPathType:(RYDirectoryType)type
{
    NSString *strAbsolutePath = nil;
    switch (type) {
        case RYDirectoryTypeDocuments: {
            NSString *strDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            strAbsolutePath = [strDocumentPath stringByAppendingPathComponent:self];
            break;
        }
        case RYDirectoryTypeTemporary:
        default: {
            NSString *strTemporaryPath = NSTemporaryDirectory();
            strAbsolutePath = [strTemporaryPath stringByAppendingPathComponent:self];
        }
    }
    return strAbsolutePath;
}

@end