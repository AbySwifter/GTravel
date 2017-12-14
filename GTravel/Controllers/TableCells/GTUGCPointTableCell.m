//
//  GTUGCPointTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTUGCPointTableCell.h"
#import "RYCommon.h"
#import "UIImageView+AFNetworking.h"
#import "GTPoint.h"
#import "GTravelUserItem.h"
#import "GTModel.h"

#define fRatioImageView (400 / 300.0)

@interface GTUGCPointTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteNoImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, weak) id<GTUGCPointTableCellDelegate> delegate;

- (IBAction)onFavoriteButton:(id)sender;

@end

@implementation GTUGCPointTableCell

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

- (IBAction)onFavoriteButton:(id)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(UGCPointCell:didClickFavoriteButton:))) {
        [self.delegate UGCPointCell:self didClickFavoriteButton:sender];
    }
}

+ (CGFloat)heightOfUGCPointCellWithPoint:(GTPoint *)point
{
    return 300;
}

- (void)setUGCPoint:(GTUGCPoint *)point delegate:(id<GTUGCPointTableCellDelegate>)delegate
{
    self.delegate = delegate;
    [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:point.imageURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:point.user.headImageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [self.userIconImageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             self.userIconImageView.image = [UIImage circleImage:image withParam:0];
                                           }
                                           failure:NULL];
    self.userNameLabel.text = point.user.nickName;
    self.timeLabel.text = point.ctime;
    self.descriptionLabel.text = point.desc;
    self.distanceLabel.text = [[GTModel sharedModel] distanceDisplayStringOfValue:point.distance];
    self.locationLabel.hidden = YES;
    self.favoriteNoImageView.hidden = point.isFavorite;
    self.point = point;
    self.contentView.layer.cornerRadius = 5.0;
    self.layer.cornerRadius = 5.0;
}

- (void)setFavorite:(BOOL)favorite
{
    self.favoriteNoImageView.hidden = favorite;
}
@end
