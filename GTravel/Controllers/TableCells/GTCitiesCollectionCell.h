//
//  GTCitiesCollectionCell.h
//  GTravel
//
//  Created by Raynay Yue on 5/21/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTravelCityItem;
@class GTravelTownItem;
@interface GTCitiesCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *graybackgroundImageView;


- (void)setCityItem:(GTravelCityItem *)cityItem;
- (void)setTownItem:(GTravelTownItem *)townItem;
- (void)resetCell;

@end
