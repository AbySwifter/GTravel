//
//  GTCitiesCollectionCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/21/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTCitiesCollectionCell.h"
#import "GTravelCityItem.h"
#import "RYCommon.h"
#import "GTModel.h"
#import "GTravelTownItem.h"

@implementation GTCitiesCollectionCell {
    BOOL isCellDisplay;
}

- (void)setCityItem:(GTravelCityItem *)cityItem
{
    isCellDisplay = YES;
    self.label.text = cityItem.name;
    self.imageView.layer.cornerRadius = 3.0;
    self.graybackgroundImageView.layer.cornerRadius = 3.0;
    self.label.layer.cornerRadius = 3.0;

    if (RYIsValidString(cityItem.localThumbnail)) {
        self.imageView.image = [UIImage imageWithContentsOfFile:[cityItem.localThumbnail absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
    }
    else {
        [[GTModel sharedModel] downloadCityItem:cityItem
                                     completion:^(NSError *error, NSData *data) {
                                       if (error) {
                                           RYCONDITIONLOG(DEBUG, @"%@", error);
                                       }
                                       else {
                                           if (isCellDisplay) {
                                               UIImage *image = [UIImage imageWithData:data];
                                               self.imageView.image = image;
                                           }
                                       }
                                     }];
    }
}

- (void)setTownItem:(GTravelTownItem *)townItem
{
    isCellDisplay = YES;
    self.label.text = townItem.name;
    self.imageView.layer.cornerRadius = 3.0;
    self.graybackgroundImageView.layer.cornerRadius = 3.0;
    self.label.layer.cornerRadius = 3.0;

    if (RYIsValidString(townItem.localThumbnail)) {
        self.imageView.image = [UIImage imageWithContentsOfFile:[townItem.localThumbnail absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
    }
    else {
        [[GTModel sharedModel] downloadTownItem:townItem
                                     completion:^(NSError *error, NSData *data) {
                                       if (error) {
                                           RYCONDITIONLOG(DEBUG, @"%@", error);
                                       }
                                       else {
                                           if (isCellDisplay) {
                                               UIImage *image = [UIImage imageWithData:data];
                                               self.imageView.image = image;
                                           }
                                       }
                                     }];
    }
}

- (void)resetCell
{
    isCellDisplay = NO;
    self.label.text = nil;
    self.imageView.image = nil;
}

@end
