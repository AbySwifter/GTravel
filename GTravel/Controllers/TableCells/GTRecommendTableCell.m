//
//  GTRecommendTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTRecommendTableCell.h"
#import "RYCommon.h"
#import "UIImageView+AFNetworking.h"
#import "GTPoint.h"
#import "GTModel.h"

#define fRatioImageView (400 / 280.0)

@interface GTRecommendTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteNoImageView;
@property (nonatomic, weak) id<GTRecommendTableCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)onFavoriteButton:(id)sender;

@end

@implementation GTRecommendTableCell

- (void)awakeFromNib
{
    // Initialization code
    self.bottomView.layer.cornerRadius = 3.0;
    self.bottomView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Public Methods
+ (CGFloat)heightOfRecommendTableCellWithPoint:(GTPoint *)point
{
    if (!RYIsValidString(point.imageURL)) {
        return 120;
    }
    return 280;
}

- (void)setRecomendPoint:(GTRecommendPoint *)point delegate:(id<GTRecommendTableCellDelegate>)delegate
{
    [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:point.imageURL]];

    if (!RYIsValidString(point.imageURL)) {
        self.thumbnailImageView.image = nil;
    }

    self.descriptionLabel.text = point.desc;
    self.descriptionLabel.numberOfLines = 2.0;
    self.distanceLabel.text = [[GTModel sharedModel] distanceDisplayStringOfValue:point.distance];
    self.addressLabel.text = point.address;
    self.favoriteNoImageView.hidden = point.isFavorite;
    self.delegate = delegate;
    self.point = point;
}

- (void)setFavorite:(BOOL)favorite
{
    self.favoriteNoImageView.hidden = favorite;
}

- (IBAction)onFavoriteButton:(id)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(recommendTableCell:didClickFavoriteButton:))) {
        [self.delegate recommendTableCell:self didClickFavoriteButton:sender];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect imageFrame = self.thumbnailImageView.frame;

    imageFrame.origin.x = 0;
    imageFrame.origin.y = 0;

    self.thumbnailImageView.frame = imageFrame;
}


@end
