//
//  GTTagsCollectionCell.h
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTTagsCollectionCell : UICollectionViewCell
+ (CGSize)sizeForTagsCollectionCell;
- (void)setNameOfCell:(NSString *)name;
@end
