//
//  GTUserCardsCell.h
//  GTravel
//
//  Created by QisMSoM on 15/7/31.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTUserCardsCell : UITableViewCell

+ (instancetype)cardsCellWithTableView:(UITableView *)tableView;
- (void)setImage:(UIImage *)image title:(NSString *)title;

@end
