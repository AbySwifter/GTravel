//
//  GTInGermanyHeaderCell.m
//  GTravel
//
//  Created by Raynay Yue on 5/26/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTInGermanyHeaderCell.h"
#import "RYCommon.h"
#import "GTModel.h"
#import "GTravelUserItem.h"

@interface GTInGermanyHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserHead;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelWelcome;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) id<GTInGermanyHeaderCellDelegate> delegate;
@property (nonatomic, weak) UIButton *button;

- (IBAction)onUserHeadImage:(UIButton *)sender;
- (IBAction)onCameraButton:(UIButton *)sender;

@end

@implementation GTInGermanyHeaderCell {
    BOOL bIsDisplay;
}

- (void)awakeFromNib
{
    // Initialization code

    self.cameraButton.hidden = YES;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.tag = 77;
    button.layer.cornerRadius = 6.0;
    button.backgroundColor = [UIColor whiteColor];
    button.alpha = 0.5;
    [button setImage:[UIImage imageNamed:@"bt_camera@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];

    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_camera@2x"]];
    image.tag = 78;

    [self.contentView addSubview:image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBAction Methods
- (IBAction)onUserHeadImage:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(headerCell:didClickUserHeadImage:))) {
        [self.delegate headerCell:self didClickUserHeadImage:sender];
    }
}

- (IBAction)onCameraButton:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(headerCell:didClickCameraButton:))) {
        [self.delegate headerCell:self didClickCameraButton:sender];
    }
}

- (void)click:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(headerCell:didClickCameraButton:))) {
        [self.delegate headerCell:self didClickCameraButton:sender];
    }
}

#pragma mark - Public Methods
- (void)setUserItem:(GTravelUserItem *)item welcomeMessage:(NSString *)message delegate:(id<GTInGermanyHeaderCellDelegate>)delegate
{
    bIsDisplay = YES;
    self.cameraButton.layer.cornerRadius = 6.0;
    self.delegate = delegate;
    self.labelWelcome.text = message;
    self.labelUserName.text = item.nickName;
    if (RYIsValidString(item.localImageURL)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          UIImage *image = [UIImage imageWithContentsOfFile:[item.localImageURL absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments]];
          image = [UIImage circleImage:image withParam:0];
          dispatch_async(dispatch_get_main_queue(), ^{
            self.imageViewUserHead.image = image;
          });
        });
    }
    else {
        UIImage *image = [UIImage imageNamed:@"default_user_icon"];
        image = [UIImage circleImage:image withParam:0];
        self.imageViewUserHead.image = image;
        [[GTModel sharedModel] downloadUserItem:item
                                     completion:^(NSError *error, NSData *data) {
                                       if (!error) {
                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                             UIImage *image = [UIImage imageWithData:data];
                                             image = [UIImage circleImage:image withParam:0];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                               self.imageViewUserHead.image = image;
                                             });
                                           });
                                       }
                                     }];
    }
}

- (void)resetCell
{
    bIsDisplay = NO;
    self.imageViewUserHead.image = nil;
    self.labelUserName.text = nil;
    self.labelWelcome.text = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIButton *button = (UIButton *)[self.contentView viewWithTag:77];
    button.frame = CGRectMake(20, self.contentView.frame.size.height - 20 - 44, [UIScreen mainScreen].bounds.size.width - 40, 44);
    UIImageView *image = (UIImageView *)[self.contentView viewWithTag:78];
    //    (view.frame.size.height - 14) / 3 * 4;
    image.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40) / 2, self.contentView.frame.size.height - 20 - 44 + 7, 40, 30);
}

@end
