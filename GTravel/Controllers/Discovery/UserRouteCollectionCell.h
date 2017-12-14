//
//  UserRouteCollectionCell.h
//  GTravel
//
//  Created by QisMSoM on 15/8/4.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTCategory;

@interface UserRouteCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@property (nonatomic, strong) GTCategory *category;

- (void)setFirstAll;

@end
