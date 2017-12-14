//
//  GTRecentUserCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/26/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTRecentUserCell.h"
#import "RYCommon.h"
#import "GTModel.h"
#import "GTRecentUsersView.h"

#define TitleHeight 30
#define fMarginTop 5
#define fMarginLeft 10

#define RecentUsersViewTag 100
#define TotalUserItemCount 4

@interface GTRecentUserCell () <GTRecentUsersViewDelegate>
@property (nonatomic, weak) id<GTRecentUserCellDelegate> delegate;
- (void)initializedCell;
- (void)resetCell;
@end

@implementation GTRecentUserCell
- (void)initializedCell
{
    UIView *view = [self.contentView viewWithTag:RecentUsersViewTag];
    if (view == nil) {
        CGFloat fWidth = RYWinRect().size.width - fMarginLeft * 2;
        CGFloat fHeight = fWidth / fRecentUsersViewRatio;
        CGRect rect = CGRectMake(fMarginLeft, TitleHeight + fMarginTop, fWidth, fHeight);
        GTRecentUsersView *usersView = [GTRecentUsersView recentUsersViewWithFrame:rect delegate:self];
        usersView.tag = RecentUsersViewTag;
        [self.contentView addSubview:usersView];
    }
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    CGFloat fHeightRecentUsersView = (RYWinRect().size.width - fMarginLeft * 2) / fRecentUsersViewRatio;
    return fHeightRecentUsersView + TitleHeight + fMarginTop * 2;
}

- (void)setUserItems:(NSArray *)items delegate:(id<GTRecentUserCellDelegate>)delegate
{
    [self initializedCell];
    self.delegate = delegate;
    if (items.count >= TotalUserItemCount) {
        GTRecentUsersView *userView = (GTRecentUsersView *)[self.contentView viewWithTag:RecentUsersViewTag];
        [userView setRecentUsers:items];
    }
    else {
        RYCONDITIONLOG(DEBUG, @"There aren't enough user items to be set!");
    }
}

- (void)resetCell
{
    GTRecentUsersView *userView = (GTRecentUsersView *)[self.contentView viewWithTag:RecentUsersViewTag];
    [userView removeFromSuperview];
}

#pragma mark - GTRecentUsersViewDelegate
- (void)recentUsersView:(GTRecentUsersView *)view didClickUserAtIndex:(NSInteger)index
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(recentUserCell:didClickUserAtIndex:))) {
        [self.delegate recentUserCell:self didClickUserAtIndex:index];
    }
}
@end
