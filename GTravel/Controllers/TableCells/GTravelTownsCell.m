//
//  GTravelTownsCell.m
//  GTravel
//
//  Created by QisMSoM on 15/7/14.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTravelTownsCell.h"
#import "RYCommon.h"
#import "GTravelTownItem.h"

#define BaseSubViewTag 10
#define ButtonTag 1
#define LabelTag 2
#define MaxTownCount 6

@interface GTravelTownsCell ()
- (IBAction)onTownButtons:(id)sender;
@end

@implementation GTravelTownsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTownsItems:(NSArray *)items
{
    NSInteger iCount = MIN(items.count, MaxTownCount);
    for (int i = 0; i < iCount; i++) {
        UIView *subView = [self.contentView viewWithTag:BaseSubViewTag + i];
        UILabel *label = (UILabel *)[subView viewWithTag:LabelTag];
        UIButton *button = (UIButton *)[subView viewWithTag:ButtonTag];
        button.layer.cornerRadius = 3.0;
        label.layer.cornerRadius = 3.0;
        GTravelTownItem *townItem = items[i];
        label.text = townItem.name;
    }
}
- (IBAction)onTownButtons:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(townsCell:didClickTownAtIndex:))) {
        [self.delegate townsCell:self didClickTownAtIndex:sender.superview.tag % BaseSubViewTag];
    }
}

@end
