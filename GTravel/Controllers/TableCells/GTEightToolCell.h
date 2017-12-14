//
//  GTEightToolCell.h
//  GTravel
//
//  Created by QisMSoM on 15/7/20.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTEightToolButton;
@class GTEightToolBtnView;
@class GTEightToolCell;
@protocol GTEightToolCellDelegate <NSObject>

@optional
- (void)didClickBtnView:(GTEightToolBtnView *)view;
- (void)didClickMoreBtnView:(GTEightToolBtnView *)view;
@end

@interface GTEightToolCell : UITableViewCell

- (void)setToolsArray:(NSMutableArray *)array;

@property (nonatomic, weak) id<GTEightToolCellDelegate> cellDelegate;

@end
