//
//  GTravelCitiesCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTravelCitiesCell.h"
#import "RYCommon.h"
#import "GTravelCityItem.h"

#define BaseSubViewTag 10
#define ButtonTag 1
#define LabelTag 2
#define MaxCityCount 6

@interface GTravelCitiesCell ()

- (IBAction)onCityButtons:(UIButton *)sender;

@end

@implementation GTravelCitiesCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCityItems:(NSArray *)items
{
    NSInteger iCount = MIN(items.count, MaxCityCount);
    for (int i = 0; i < iCount; i++) {
        UIView *subView = [self.contentView viewWithTag:BaseSubViewTag + i];
        UILabel *label = (UILabel *)[subView viewWithTag:LabelTag];
        UIButton *button = (UIButton *)[subView viewWithTag:ButtonTag];
        button.layer.cornerRadius = 3.0;
        label.layer.cornerRadius = 3.0;
        GTravelCityItem *cityItem = items[i];
        label.text = cityItem.name;
    }
}

- (IBAction)onCityButtons:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(citiesCell:didClickCityAtIndex:))) {
        [self.delegate citiesCell:self didClickCityAtIndex:sender.superview.tag % BaseSubViewTag];
    }
}

@end
