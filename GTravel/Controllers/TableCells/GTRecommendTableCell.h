//
//  GTRecommendTableCell.h
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTPoint;
@class GTRecommendPoint;
@protocol GTRecommendTableCellDelegate;

@interface GTRecommendTableCell : UITableViewCell
@property (nonatomic, strong) GTRecommendPoint *point;

+ (CGFloat)heightOfRecommendTableCellWithPoint:(GTPoint *)point;

- (void)setRecomendPoint:(GTRecommendPoint *)point delegate:(id<GTRecommendTableCellDelegate>)delegate;
- (void)setFavorite:(BOOL)favorite;

@end

@protocol GTRecommendTableCellDelegate <NSObject>
- (void)recommendTableCell:(GTRecommendTableCell *)cell didClickFavoriteButton:(id)sender;
@end
