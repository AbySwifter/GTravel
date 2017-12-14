//
//  GTravelToolItems.m
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTToolItemsView.h"
#import "RYCommon.h"
#import "GTravelToolItem.h"
#import "GTModel.h"
#import "GTCategory.h"
#import "GTToolsSet.h"
#import "UIImageView+AFNetworking.h"

#define TagSubViewBase 10
#define TagButton 0
#define TagLabel 1

#define MaxItemCount 3

CGFloat const fToolItemsViewRatio = (640.0 / 200.0);

typedef NS_ENUM(NSInteger, GTToolItemsViewType) {
    GTToolItemsViewTypeDefault,
    GTToolItemsViewTypeCategory
};

@interface GTToolItemsView ()
@property (nonatomic, weak) id<GTToolItemsViewDelegate> delegate;
@property (nonatomic, strong) NSArray *tipItems;
@property (nonatomic, assign) GTToolItemsViewType type;

- (IBAction)onToolItemButton:(UIButton *)sender;
- (void)toolItemDidLoadNotification:(NSNotification *)notification;
@end

@implementation GTToolItemsView
#pragma mark - IBAction Methods
- (IBAction)onToolItemButton:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(toolItems:clickButtonAtIndex:))) {
        [self.delegate toolItems:self clickButtonAtIndex:sender.superview.tag % TagSubViewBase];
    }
}

//-(void)startObserver
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolItemDidLoadNotification:) name:GTravelNotificationToolItemImageDidLoad object:nil];
//}

- (void)toolItemDidLoadNotification:(NSNotification *)notification
{
    if (self.type == GTToolItemsViewTypeDefault) {
        GTravelToolItem *item = [notification object];
        for (int i = 0; i < MaxItemCount; i++) {
            GTravelToolItem *toolItem = self.tipItems[i];
            if ([item isEqual:toolItem]) {
                UIView *subView = [self viewWithTag:i + TagSubViewBase];
                UIButton *button = (UIButton *)[subView viewWithTag:TagButton];
                UIImage *image = [UIImage imageWithContentsOfFile:[item.localImage absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
                [button setImage:image forState:UIControlStateNormal];
                break;
            }
        }
    }
    else {
        GTCategory *item = [notification object];
        for (int i = 0; i <= MaxItemCount; i++) {
            GTCategory *categoryItem = self.tipItems[i];
            if ([item isEqual:categoryItem]) {
                UIView *subView = [self viewWithTag:i + TagSubViewBase];
                UIButton *button = (UIButton *)[subView viewWithTag:TagButton];
                UIImage *image = [UIImage imageWithContentsOfFile:[item.localImage absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
                [button setImage:image forState:UIControlStateNormal];
                break;
            }
        }
    }
}

//-(void)stopObserver
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//-(void)dealloc
//{
//    [self stopObserver];
//}

#pragma mark - Public Methods
+ (GTToolItemsView *)itemsWithFrame:(CGRect)frame delegate:(id<GTToolItemsViewDelegate>)delegate
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    GTToolItemsView *itemsView = nibs[0];
    itemsView.frame = frame;
    itemsView.delegate = delegate;
    itemsView.type = GTToolItemsViewTypeDefault;
    return itemsView;
}

- (void)setToolsSetArray:(NSMutableArray *)toolsSetArray
{
    self.type = GTToolItemsViewTypeDefault;
    _toolsSetArray = toolsSetArray;

    for (int i = 0; i < self.toolsSetArray.count; i++) {
        GTToolsSet *toolsSet = self.toolsSetArray[i];

        UIView *subView = [self viewWithTag:i + TagSubViewBase];

        UIButton *button = (UIButton *)[subView viewWithTag:TagButton];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          // 处理耗时操作的代码块...

          NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:toolsSet.tools_image]];
          UIImage *image = [UIImage imageWithData:data];
          //通知主线程刷新
          dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，


            [button setImage:image forState:UIControlStateNormal];
            UILabel *label = (UILabel *)[subView viewWithTag:TagLabel];

            label.text = toolsSet.tools_title;

          });

        });
    }
    //    UIView *subView = [self viewWithTag:MaxItemCount+TagSubViewBase];
    //    UIButton *button = (UIButton*)[subView viewWithTag:TagButton];
    //    [button setImage:[UIImage imageNamed:@"bt_more"] forState:UIControlStateNormal];
    //    }
}

- (void)setToolItems:(NSArray *)items
{
    self.type = GTToolItemsViewTypeDefault;
    if (items.count >= MaxItemCount) {
        self.tipItems = items;
        for (int i = 0; i < MaxItemCount; i++) {
            GTravelToolItem *item = items[i];
            UIView *subView = [self viewWithTag:i + TagSubViewBase];
            UIButton *button = (UIButton *)[subView viewWithTag:TagButton];
            if (RYIsValidString(item.localImage)) {
                [button setImage:[UIImage imageWithContentsOfFile:[item.localImage absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]] forState:UIControlStateNormal];
            }
            UILabel *label = (UILabel *)[subView viewWithTag:TagLabel];
            label.text = item.title;
        }
        UIView *subView = [self viewWithTag:MaxItemCount + TagSubViewBase];
        UIButton *button = (UIButton *)[subView viewWithTag:TagButton];
        [button setImage:[UIImage imageNamed:@"bt_more"] forState:UIControlStateNormal];
    }
    else {
        RYCONDITIONLOG(DEBUG, @"Tool item'count is less than %d.", MaxItemCount);
    }
}

- (void)setCategoryItems:(NSArray *)items
{
    self.type = GTToolItemsViewTypeCategory;
    if (items.count >= MaxItemCount + 1) {
        self.tipItems = items;
        for (int i = 0; i <= MaxItemCount; i++) {
            GTCategory *category = items[i];
            UIView *subView = [self viewWithTag:i + TagSubViewBase];
            UIButton *button = (UIButton *)[subView viewWithTag:TagButton];
            if (RYIsValidString(category.localImage)) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  UIImage *image = [UIImage imageWithContentsOfFile:[category.localImage absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
                  dispatch_async(dispatch_get_main_queue(), ^{
                    [button setImage:image forState:UIControlStateNormal];
                  });
                });
            }
            else {
                [[GTModel sharedModel] downloadCategory:category
                                             completion:^(NSError *error, NSData *data) {
                                               [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                             }];
            }
            UILabel *label = (UILabel *)[subView viewWithTag:TagLabel];
            label.text = category.title;
        }
    }
    else {
        RYCONDITIONLOG(DEBUG, @"There aren't enough category items to be set!");
    }
}

@end
