//
//  GTToolItemsCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTToolItemsCell.h"
#import "GTravelToolItem.h"
#import "GTToolsSet.h"
#import "RYCommon.h"

#define TagSubViewBase 10
#define TagButton 0
#define TagLabel 1

#define MaxItemCount 4

@interface GTToolItemsCell ()
@property (nonatomic, weak) id<GTToolItemsCellDelegate> delegate;
@property (nonatomic, strong) NSArray *toolItems;


- (IBAction)onToolItemButtons:(UIButton *)sender;
//- (IBAction)onMoreButton:(UIButton *)sender;

//-(void)toolItemDidLoadNotification:(NSNotification*)notification;

@end

@implementation GTToolItemsCell

#pragma mark - IBAction Methods
- (IBAction)onToolItemButtons:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(itemsCell:didSelectItemAtIndex:))) {
        [self.delegate itemsCell:self didSelectItemAtIndex:sender.superview.tag % TagSubViewBase];
    }
}
//
//- (IBAction)onMoreButton:(UIButton *)sender
//{
//    if(RYDelegateCanResponseToSelector(self.delegate, @selector(itemsCell:didClickMoreButton:)))
//    {
//        [self.delegate itemsCell:self didClickMoreButton:sender];
//    }
//}

//-(void)startObserver
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolItemDidLoadNotification:) name:GTravelNotificationToolItemImageDidLoad object:nil];
//}
//
//-(void)toolItemDidLoadNotification:(NSNotification*)notification
//{
//    GTravelToolItem *item = [notification object];
//    for(int i=0;i<MIN(MaxItemCount, self.toolItems.count);i++)
//    {
//        GTravelToolItem *toolItem = self.toolItems[i];
//        if([toolItem isEqual:item])
//        {
//            UIView *subView = [self.contentView viewWithTag:i+TagSubViewBase];
//            UIButton *button = (UIButton*)[subView viewWithTag:TagButton];
//            UIImage *image = [UIImage imageWithContentsOfFile:[item.localImage absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
//            NSLog(@"%@",image);
//            [button setImage:image forState:UIControlStateNormal];
//            break;
//        }
//    }
//}
//
//-(void)stopObserver
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

//-(void)dealloc
//{
//    [self stopObserver];
//}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)heightOfToolItemsCellWithRatio:(CGFloat)ratio
{
    CGSize winSize = RYWinRect().size;
    CGFloat fHeight = winSize.width / ratio;
    return fHeight;
}

- (void)setContentWithToolsSetArray:(NSMutableArray *)toolsSetArray delegate:(id<GTToolItemsCellDelegate>)delegate
{
    self.delegate = delegate;

    self.toolsSetArray = toolsSetArray;

    for (int i = 0; i < toolsSetArray.count; i++) {
        GTToolsSet *toolsSet = toolsSetArray[i];
        UIView *subView = [self.contentView viewWithTag:i + TagSubViewBase];
        UIButton *button = (UIButton *)[subView viewWithTag:TagButton];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          // 处理耗时操作的代码块...
          NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:toolsSet.tools_image]];
          UIImage *image = [UIImage imageWithData:data];
          //通知主线程刷新
          dispatch_async(dispatch_get_main_queue(), ^{

            //回调或者说是通知主线程刷新，
            UILabel *label = (UILabel *)[subView viewWithTag:TagLabel];
            label.font = [UIFont systemFontOfSize:14];

            label.text = toolsSet.tools_title;

            [button setImage:image forState:UIControlStateNormal];
          });
        });
    }
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    for (int i = 0; i < self.toolsSetArray.count; i++) {
//        UIView *subView = [self.contentView viewWithTag:i+TagSubViewBase];
//        UIButton *button = (UIButton*)[subView viewWithTag:TagButton];
//        button.frame = CGRectMake(0, 0, 65, 65);
//    }
//}

- (void)setCellContentWithItems:(NSArray *)items delegate:(id<GTToolItemsCellDelegate>)delegate
{
}
@end
