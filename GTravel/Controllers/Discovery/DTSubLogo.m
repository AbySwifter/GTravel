//
//  DTSubLogo.m
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTSubLogo.h"
#import "AFNetworking.h"
#import "GTravelNetDefinitions.h"
#import "DTSubLogoDetail.h"
#import "DTSubLogoImage.h"
#import "UIImage+ZH.h"

@interface DTSubLogo () <DTSubLogoImageDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation DTSubLogo

- (NSMutableArray *)subLogoArray
{
    if (!_subLogoArray) {
        _subLogoArray = [NSMutableArray array];
    }
    return _subLogoArray;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1];
        NSString *urlString = GetAPIUrl(API_Partners);
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
			NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
					if (connectionError) {
						NSLog(@"请求失败, error = %@", connectionError);
					}
					else {
						NSError *error;
						NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
						if (error) {
							NSLog(@"解析失败err : %@", error);
						}
						else {
							NSArray *list = [dict objectForKey:@"lists"];
							for (NSDictionary *dict in list) {
								dispatch_async(dispatch_get_main_queue(), ^{
									DTSubLogoDetail *subLogo = [DTSubLogoDetail subLogoDetailWithDict:dict];
									[self.subLogoArray addObject:subLogo];
									DTSubLogoImage *imgBtn = [[DTSubLogoImage alloc] init];
									imgBtn.delegate = self;
									[self addSubview:imgBtn];
									imgBtn.subLogo = subLogo;
								});
							}
						}
					}
			}];
			[task resume];
		}];
		[queue addOperation:operation];
//        [NSURLConnection sendAsynchronousRequest:request
//                                           queue:queue
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//
//                                 if (connectionError) {
//                                     NSLog(@"请求失败, error = %@", connectionError);
//                                 }
//                                 else {
//                                     NSError *error;
//                                     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//                                     if (error) {
//                                         NSLog(@"解析失败err : %@", error);
//                                     }
//                                     else {
//                                         NSArray *list = [dict objectForKey:@"lists"];
//                                         for (NSDictionary *dict in list) {
//                                             DTSubLogoDetail *subLogo = [DTSubLogoDetail subLogoDetailWithDict:dict];
//                                             [self.subLogoArray addObject:subLogo];
//                                             DTSubLogoImage *imgBtn = [[DTSubLogoImage alloc] init];
//                                             imgBtn.delegate = self;
//                                             [self addSubview:imgBtn];
//                                             dispatch_async(dispatch_get_main_queue(), ^{
//                                               imgBtn.subLogo = subLogo;
//                                             });
//                                         }
//                                     }
//                                 }
//                               }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat scrrenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat w = 55;
    CGFloat y = (self.frame.size.height - w) / 2;
    CGFloat h = w;
    CGFloat spacing = (scrrenW - self.subLogoArray.count * w) / (self.subLogoArray.count + 1);

    for (int i = 0; i < self.subLogoArray.count; i++) {
        DTSubLogoImage *imgBtn = self.subviews[i];
        CGFloat x = i * (w + spacing) + spacing;
        imgBtn.frame = CGRectMake(x, y, w, h);
    }
}

- (void)logoImageDidClicked:(DTSubLogoImage *)logoImage
{
    if ([self.delegate respondsToSelector:@selector(logoImageDidClicked:)]) {
        [self.delegate logoImageDidClicked:logoImage];
    }
}


@end
