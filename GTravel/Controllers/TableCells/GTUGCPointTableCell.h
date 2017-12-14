//
//  GTUGCPointTableCell.h
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTPoint;
@class GTUGCPoint;
@protocol GTUGCPointTableCellDelegate;

@interface GTUGCPointTableCell : UITableViewCell
@property (nonatomic, strong) GTUGCPoint *point;

+ (CGFloat)heightOfUGCPointCellWithPoint:(GTPoint *)point;
- (void)setUGCPoint:(GTUGCPoint *)point delegate:(id<GTUGCPointTableCellDelegate>)delegate;
- (void)setFavorite:(BOOL)favorite;

@end

@protocol GTUGCPointTableCellDelegate <NSObject>

- (void)UGCPointCell:(GTUGCPointTableCell *)cell didClickFavoriteButton:(id)sender;

@end
