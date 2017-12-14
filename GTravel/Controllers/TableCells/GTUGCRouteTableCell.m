//
//  GTUGCRouteTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTUGCRouteTableCell.h"
#import "GTravelRouteItem.h"
#import "GTModel.h"
#import "RYCommon.h"
#import "GTravelUserItem.h"

#define MarginTopAndBottom 5
#define MarginLeftAndRight 10

#define HeightBottomView 50
#define ImageViewRatio (600.0 / 388.0)

@interface GTUGCRouteTableCell () {
    BOOL isDisplay;
}
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation GTUGCRouteTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightOfUGCRouteTableCell
{
    CGFloat fWidth = RYWinRect().size.width - MarginLeftAndRight * 2;
    CGFloat fContentView = fWidth / ImageViewRatio;
    return fContentView + MarginTopAndBottom * 2 + HeightBottomView;
}

- (void)setRouteItem:(GTravelRouteItem *)item
{
    isDisplay = YES;
    self.titleLabel.text = item.title;
    self.daysLabel.text = [item.days stringValue];
    self.photosLabel.text = [item.photos stringValue];
    self.nickNameLabel.text = item.userItem.nickName;
    self.thumbnailImageView.layer.cornerRadius = 3.0;
    self.bottomView.layer.cornerRadius = 3.0;

    if (RYIsValidString(item.localThumbnail)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          UIImage *image = [UIImage imageWithContentsOfFile:[item.localThumbnail absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
          dispatch_async(dispatch_get_main_queue(), ^{
            if (isDisplay) {
                self.thumbnailImageView.image = image;
            }
          });
        });
    }
    else {
        [[GTModel sharedModel] downloadRouteItem:item
                                      completion:^(NSError *error, NSData *data) {
                                        if (error) {
                                            RYCONDITIONLOG(DEBUG, @"%@", error);
                                        }
                                        else {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                              if (isDisplay) {
                                                  self.thumbnailImageView.image = [UIImage imageWithData:data];
                                              }
                                            });
                                        }
                                      }];
    }
    if (RYIsValidString(item.userItem.localImageURL)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          UIImage *image = [UIImage imageWithContentsOfFile:[item.userItem.localImageURL absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
          image = [UIImage circleImage:image withParam:5];
          dispatch_async(dispatch_get_main_queue(), ^{
            self.userHeadImageView.image = image;
          });
        });
    }
    else {
        [[GTModel sharedModel] downloadRouteUserItem:item.userItem
                                          completion:^(NSError *error, NSData *data) {
                                            if (error) {
                                                RYCONDITIONLOG(DEBUG, @"%@", error);
                                            }
                                            else {
                                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                  UIImage *image = [UIImage imageWithData:data];
                                                  image = [UIImage circleImage:image withParam:5];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                    if (isDisplay) {
                                                        self.userHeadImageView.image = image;
                                                    }
                                                  });
                                                });
                                            }
                                          }];
    }
}

- (void)resetCell
{
    isDisplay = NO;
    self.titleLabel.text = nil;
    self.daysLabel.text = nil;
    self.photosLabel.text = nil;
    self.thumbnailImageView.image = nil;
    self.userHeadImageView.image = nil;
    self.nickNameLabel.text = nil;
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.y += 20;
//    [super setFrame:frame];
//}

@end
