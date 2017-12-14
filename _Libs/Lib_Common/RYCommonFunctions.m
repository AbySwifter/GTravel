//
//  RYCommonFunctions.m
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import "RYCommonFunctions.h"

const unichar RYVersioniOS7 = '7';
const unichar RYVersioniOS8 = '8';

unichar RYSystemVersion()
{
    return [[UIDevice currentDevice].systemVersion characterAtIndex:0];
}

CGRect RYWinRect()
{
    return [UIScreen mainScreen].bounds;
}

CGFloat RYStatusBarHeight()
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

NSString *RYDateString(NSDate *date, NSString *dateFormat)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

NSString *RYDateStringFromStyle(NSDate *date, NSDateFormatterStyle style)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:style];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

NSString *RYFilePathOfName(NSString *fileName)
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[arr firstObject] stringByAppendingPathComponent:fileName];
}


NSString *RYFilePath(NSString *fileName, RYDirectoryType type)
{
    NSString *path = type == RYDirectoryTypeTemporary ? NSTemporaryDirectory() : [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:fileName];
}

NSDate *RYDate(NSString *dateString, NSString *dateFormat)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

void RYShowAlertView(NSString *title, NSString *message, id<UIAlertViewDelegate> delegate, NSInteger tag, NSString *cancelButtonTitle, NSString *otherButtonTitle, ...)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    alert.tag = tag;

    va_list args;
    va_start(args, otherButtonTitle);
    NSString *buttonTitle = otherButtonTitle;
    while (buttonTitle) {
        [alert addButtonWithTitle:buttonTitle];
        buttonTitle = va_arg(args, NSString *);
    }
    va_end(args);

    [alert show];
}

BOOL RYDelegateCanResponseToSelector(id delegate, SEL selector)
{
    return delegate && [delegate respondsToSelector:selector];
}

void RunOnMainThread(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

BOOL RYIsValidString(NSString *string)
{
    return [[string class] isSubclassOfClass:[NSString class]] && string && string.length;
}

BOOL RYIsValidArray(NSArray *array)
{
    return [[array class] isSubclassOfClass:[NSArray class]] && array && array.count;
}
/*
UIFont* RYFontWithSize(CGFloat fSize);
CGFloat RYTextHeightRestrainedToSizeWithFont(NSString *text, CGSize size, UIFont *font);


UIFont* RYFontWithSize(CGFloat fSize)
{
    UIFont *font = [[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontWithSize:fSize];
    return font;
}

CGFloat RYTextHeightRestrainedToSizeWithFont(NSString *text, CGSize size, UIFont *font)
{
    CGRect srectComputed = [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    CGFloat fHeightComputed = srectComputed.size.height;
    return fHeightComputed;
}
*/

BOOL RYCanOpenAppWithUrlString(NSString *strURL)
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strURL]];
}

BOOL RYOpenAppWithURL(NSString *strURL)
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
}