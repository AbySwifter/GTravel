//
//  GTAroundUsersCell.m
//  GTravel
//
//  Created by Raynay Yue on 6/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTAroundUsersCell.h"
#import "GTravelUserItem.h"
#import "UIImageView+AFNetworking.h"
#import "RYCommon.h"
#import "GTModel.h"

#define TagBaseImageView 10
#define TagBaseNameLabel 100
#define TagBaseDistanceLabel 1000

#define MaxUsersCount 5

@interface GTAroundUsersCell ()
@property (nonatomic, strong) NSArray *userAction;
@end

@implementation GTAroundUsersCell

- (void)awakeFromNib
{
    // Initialization code
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];

    top.backgroundColor = [UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1];

    [self.contentView addSubview:top];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setAroundUsers:(NSArray *)users
{
    //    UILabel *tempLabel = (UILabel*)[self.contentView viewWithTag:TagBaseDistanceLabel + 1];

    self.userAction = users;

    for (int i = 0; i < MIN(MaxUsersCount, users.count); i++) {
        GTDistanceUser *user = users[i];
        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:TagBaseImageView + i];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClicked:)];
        [imageView addGestureRecognizer:tap];


        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:user.headImageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        [imageView setImageWithURLRequest:request
                         placeholderImage:nil
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                      UIImage *circleImage = [UIImage circleImage:image withParam:0];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:TagBaseImageView + i];
                                        imageView.image = circleImage;
                                      });
                                    });

                                  }
                                  failure:NULL];

        UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:TagBaseNameLabel + i];
        nameLabel.text = user.nickName;

        UILabel *distanceLabel = (UILabel *)[self.contentView viewWithTag:TagBaseDistanceLabel + i];
        distanceLabel.text = [[GTModel sharedModel] distanceDisplayStringOfValue:user.distance];
    }
    //    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tempLabel.frame) + 3, self.frame.size.width, 1)];
    //    bottom.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
    //    [self.contentView addSubview:bottom];
}

//- (void)dealloc
//{
//
//}

- (void)imageViewDidClicked:(UITapGestureRecognizer *)sender
{
    NSLog(@"%@", sender.view);

    NSInteger i = sender.view.tag - TagBaseImageView;
    GTDistanceUser *user = self.userAction[i];
    //    NSLog(@"%@",user.userID);
    if ([self.delegate respondsToSelector:@selector(DidClickedUserImage:)]) {
        [self.delegate DidClickedUserImage:user];
    }
}
@end
