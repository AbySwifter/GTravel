//
//  GTEightToolBtnView.m
//  GTravel
//
//  Created by QisMSoM on 15/7/21.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#define IMAGEVIEW_TAG 777
#define LABEL_TAG 778

#import "GTEightToolBtnView.h"
#import "GTToolsItem.h"

@interface GTEightToolBtnView ()

@end

@implementation GTEightToolBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];

        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        imageView.tag = IMAGEVIEW_TAG;
        //        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];

        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        label.tag = LABEL_TAG;
        [self addSubview:label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIImageView *imageView = (UIImageView *)[self viewWithTag:IMAGEVIEW_TAG];

    CGFloat w = self.frame.size.width / 4;
    CGFloat h = w;
    CGFloat x = (self.frame.size.width - w) / 2;
    CGFloat y = self.frame.size.height / 4;

    imageView.frame = CGRectMake(x, y, w, h);

    UILabel *label = (UILabel *)[self viewWithTag:LABEL_TAG];

    CGFloat labelw = self.frame.size.width;
    CGFloat labelh = self.frame.size.width / 4;
    CGFloat labelx = 0;
    CGFloat labely = self.frame.size.height / 2;
    label.frame = CGRectMake(labelx, labely, labelw, labelh);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(didClickEightToolBtnView:)]) {
        [self.delegate didClickEightToolBtnView:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    self.backgroundColor = [UIColor whiteColor];
}

- (void)setItem:(GTToolsItem *)item
{
    _item = item;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      // 处理耗时操作的代码块...
      NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.image]];

      NSLog(@"%@--- %@", item.image, item.thumbnail);

      UIImage *image = [UIImage imageWithData:data];
      //通知主线程刷新
      dispatch_async(dispatch_get_main_queue(), ^{

        //回调或者说是通知主线程刷新
        self.imageView.image = image;
        self.label.text = item.title;
      });
    });
}

@end
