//
//  GTUserCell.m
//  GTravel
//
//  Created by Raynay Yue on 6/16/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTUserCell.h"
#import "GTravelUserItem.h"
#import "GTModel.h"
#import "UIImageView+AFNetworking.h"
#import "RYCommon.h"

@interface GTUserCell ()
@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelUserGender;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;

@end

@implementation GTUserCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDistanceUser:(GTDistanceUser *)user
{
    self.cellBackgroundView.layer.cornerRadius = 3.0;
    self.labelUserName.text = user.nickName;
    self.labelUserGender.text = user.sex == GTravelUserSexMale ? @"男" : @"女";
    self.labelDistance.text = [[GTModel sharedModel] distanceDisplayStringOfValue:user.distance];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:user.headImageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [self.userIconImageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                               UIImage *circleImage = [UIImage circleImage:image withParam:0];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                 self.userIconImageView.image = circleImage;
                                               });
                                             });
                                           }
                                           failure:NULL];
}

- (void)setUser:(GTDistanceUser *)user
{
    self.cellBackgroundView.layer.cornerRadius = 3.0;
    self.labelUserName.text = user.nickName;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:user.headImageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [self.userIconImageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                               UIImage *circleImage = [UIImage circleImage:image withParam:0];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                 self.userIconImageView.image = circleImage;
                                               });
                                             });
                                           }
                                           failure:NULL];
}

- (void)resetCell
{
    self.labelDistance.text = nil;
    self.labelUserGender.text = nil;
    self.labelUserName.text = nil;
    self.userIconImageView.image = nil;
}

@end
