//
//  GTRouteHeaderCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTRouteHeaderCell.h"
#import "RYCommon.h"

@interface GTRouteHeaderCell ()
@property (nonatomic, weak) id<GTRouteHeaderCellDelegate> delegate;

- (IBAction)onMoreButton:(UIButton *)sender;
@end

@implementation GTRouteHeaderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onMoreButton:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(routeHeaderCell:didClickMoreButton:))) {
        [self.delegate routeHeaderCell:self didClickMoreButton:sender];
    }
}

- (void)setDelegate:(id<GTRouteHeaderCellDelegate>)delegate title:(NSString *)title
{
    self.titleLabel.text = title;
    self.delegate = delegate;
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.y += 20;
//    [super setFrame:frame];
//}

@end
