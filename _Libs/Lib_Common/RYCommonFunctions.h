//
//  RYCommonFunctions.h
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

extern const unichar RYVersioniOS7;
extern const unichar RYVersioniOS8;

/**
 * @brief return iOS systerm version number.example:return '7' if systerm version is 7.0.x
 */
unichar RYSystemVersion();

/**
 * @brief return bounds of current device's window
 * @return bound of window
 */
CGRect RYWinRect();

/**
 * @brief return height of status bar
 */
CGFloat RYStatusBarHeight();

/**
 * @brief create a string from data by a date format string.
 * @param date date which final string is created by.
 * @param dateFormat date format of final string.
 * @return a NSString which is created by date.
 */
NSString *RYDateString(NSDate *date, NSString *dateFormat);

/**
 * @brief same lick RYDateString except NSDateFormatterStyle parameter 'style' instead of 'dateFormat'.
 * @param date date which final string is created by.
 * @param style NSDateFormatterStyle of final string.
 * @return a NSString which is created by date.
 */
NSString *RYDateStringFromStyle(NSDate *date, NSDateFormatterStyle style);

/**
 * @brief create a NSDate object from dateString and dateFormat
 * @param dateString a NSString object which date is created by.
 * @param dateFormat describe date format.
 * @return final date created by dateString,nil if creation failed.
 */
NSDate *RYDate(NSString *dateString, NSString *dateFormat);

typedef NS_ENUM(NSUInteger, RYDirectoryType) {
    RYDirectoryTypeDocuments, //Directory at '/Documents'
    RYDirectoryTypeTemporary //Directory at '/tmp'
};

/**
 * @brief return a file path string in app sandbox as 'RYDirectoryTypeDocuments'
 * @param fileName whole name of file contained file extension name.
 * @return a path string of fileName
 */
NSString *RYFilePathOfName(NSString *fileName);

/**
 * @brief return a whole file path string in app sandbox root directory.
 * @param fileName whole name of file contained file extension name.
 * @param type indicated the file location.
 * @return a path string of fileName
 */
NSString *RYFilePath(NSString *fileName, RYDirectoryType type);

/**
 * @brief same like UIAlertView's creation methods except a parameter 'tag' was added.
 */
void RYShowAlertView(NSString *title, NSString *message, id<UIAlertViewDelegate> delegate, NSInteger tag, NSString *cancelButtonTitle, NSString *otherButtonTitle, ...) NS_REQUIRES_NIL_TERMINATION;

/**
 * @brief Safety checking if a delegate can response to selector.
 * @param delegate delegate which will be checked.
 * @param selector the selector which the delegate can response or not.
 * @return YES if delegate can response to selector and can use it safely,or NO it can't be.
 */
BOOL RYDelegateCanResponseToSelector(id delegate, SEL selector);

/**
 * @brief Checking a string is valid or not
 * @param string the string will be checked.
 * @return return YES if string is NSString object and it's not nil and also its length is bigger than 0,return NO if not.
 */
BOOL RYIsValidString(NSString *string);

/**
 * @brief Checking a array is valid or not
 * @param array the array will be checked.
 * @return return YES if array is a subclass of NSArray and it's not nil and also its count is bigger than 0,return NO if not.
 */
BOOL RYIsValidArray(NSArray *array);

/**
 * @brief run the block on main thread
 * @param block the block will be run.
 */
void RunOnMainThread(dispatch_block_t block);

/**
 * @brief Returns whether an app can open a given URL resource.
 * This method guarantees that if RYOpenAppWithURL() is called, another app will be launched to handle it.
 * It does not guarantee that the full URL is valid.
 * @return NO if no app is available that will accept the URL; otherwise, returns YES.
 */
BOOL RYCanOpenAppWithUrlString(NSString *strURL);

/**
 * @brief Opens the resource at the specified URL.The URL can locate a resource in the same or other app.
 * If the resource is another app, invoking this method may cause the calling app to quit so the other one can be launched.
 * @return YES if the resource located by the URL was successfully opened; otherwise NO.
 */
BOOL RYOpenAppWithURL(NSString *strURL);
