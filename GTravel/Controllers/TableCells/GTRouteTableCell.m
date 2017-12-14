//
//  GTRouteTableCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/13/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTRouteTableCell.h"
#import "GTravelRouteItem.h"
#import "GTModel.h"
#import "RYCommon.h"

@interface GTRouteTableCell () {
    BOOL isDisplay;
}

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation GTRouteTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRouteItem:(GTravelRouteItem *)item
{
    isDisplay = YES;
    self.titleLabel.text = item.title;
    self.dayLabel.text = [item.days stringValue];
    self.descriptionLabel.text = item.desc;
    self.descriptionLabel.numberOfLines = 2.0;
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
                                            UIImage *image = [UIImage imageWithData:data];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                              if (isDisplay) {
                                                  self.thumbnailImageView.image = image;
                                              }
                                            });
                                        }
                                      }];
    }
}

- (void)resetCell
{
    isDisplay = NO;
    self.titleLabel.text = nil;
    self.dayLabel.text = nil;
    self.descriptionLabel.text = nil;
    self.thumbnailImageView.image = nil;
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.y += 20;
//    [super setFrame:frame];
//}

@end
