//
//  GTEightToolCell.m
//  GTravel
//
//  Created by QisMSoM on 15/7/20.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTEightToolCell.h"
#import "GTToolsItem.h"
//#import "GTEightToolButton.h"
#import "GTEightToolBtnView.h"
#import "GTToolsSet.h"

@interface GTEightToolCell () <GTEightToolBtnViewDelegate>

@property (nonatomic, strong) NSArray *array;

@end

@implementation GTEightToolCell


- (void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor colorWithRed:208 / 255.0 green:208 / 255.0 blue:208 / 255.0 alpha:1];

    if (!self.array.count) {
        for (int i = 0; i < 7; i++) {
            //            GTEightToolButton *btn = [[GTEightToolButton alloc] init];
            //            btn.tag = i + 100;
            //            [btn setBackgroundColor:[UIColor whiteColor]];
            //            [self.contentView addSubview:btn];

            GTEightToolBtnView *view = [[GTEightToolBtnView alloc] init];
            view.tag = i + 100;
            [self.contentView addSubview:view];
        }
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:208 / 255.0 green:208 / 255.0 blue:208 / 255.0 alpha:1];
    [self.contentView addSubview:line];

    GTEightToolBtnView *more = [[GTEightToolBtnView alloc] init];
    more.delegate = self;
    more.imageView.image = [UIImage imageNamed:@"bt_more_thumbnail"];
    more.label.text = @"更多";
    more.tag = 10009;
    [self.contentView addSubview:more];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    for (int i = 0; i < 7; i++) {
        GTEightToolBtnView *view = self.contentView.subviews[i];

        CGFloat w = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
        CGFloat h = (self.frame.size.height - 2) / 2;
        CGFloat x = (i % 4) * (w + 1);
        CGFloat y = (i / 4) * (h + 1);

        view.frame = CGRectMake(x, y, w, h);

        //        btn.frame = CGRectMake(x, y, w, h);
    }

    GTEightToolBtnView *more = (GTEightToolBtnView *)[self viewWithTag:10009];
    more.frame = CGRectMake((([UIScreen mainScreen].bounds.size.width - 3) / 4 + 1) * 3, (self.frame.size.height - 2) / 2 + 1, ([UIScreen mainScreen].bounds.size.width - 3) / 4, (self.frame.size.height - 2) / 2);
}

- (void)setToolsArray:(NSMutableArray *)array
{
    NSArray *sortedArr = [NSArray array];

    // 对数组按isindex排序
    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"isindex" ascending:YES]];
    sortedArr = [array sortedArrayUsingDescriptors:sortDesc];

    if (!_array) {
        _array = sortedArr;
    }
    //    _array = sortedArr;
    NSLog(@"%lu", (unsigned long)_array.count);

    for (int i = 0; i < self.array.count; i++) {

        //        GTEightToolButton *btn = (GTEightToolButton *)[self viewWithTag:(i +100)];
        GTEightToolBtnView *view = (GTEightToolBtnView *)[self viewWithTag:(i + 100)];

        GTToolsItem *item = self.array[i];
        view.delegate = self;
        view.item = item;

        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            // 处理耗时操作的代码块...
        //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.image]];
        //            UIImage *image = [UIImage imageWithData:data];
        //            //通知主线程刷新
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //
        //                //回调或者说是通知主线程刷新
        //                [btn setImage:image forState:UIControlStateNormal];
        //                [btn setTitle:item.title forState:UIControlStateNormal];
        //            });
        //        });
    }
}

- (void)didClickMoreBtnView:(GTEightToolBtnView *)view
{
    if ([self.cellDelegate respondsToSelector:@selector(didClickMoreBtnView:)]) {
        [self.cellDelegate didClickMoreBtnView:view];
    }
}

- (void)didClickBtnView:(GTEightToolBtnView *)view
{
    if ([self.cellDelegate respondsToSelector:@selector(didClickBtnView:)]) {
        [self.cellDelegate didClickBtnView:view];
    }
}

#pragma mark - GTEightToolBtnViewDelegate

- (void)didClickEightToolBtnView:(GTEightToolBtnView *)view
{
    if ([view.label.text isEqualToString:@"更多"]) {
        [self didClickMoreBtnView:view];
    }
    else {
        [self didClickBtnView:view];
    }
}

@end
