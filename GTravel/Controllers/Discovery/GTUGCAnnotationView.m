//
//  GTUGCAnnotationView.m
//  GTravel
//
//  Created by Raynay Yue on 6/11/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTUGCAnnotationView.h"
#import "GTAnnotation.h"
#import "GTPoint.h"
#import "GTravelUserItem.h"
#import "UIImageView+AFNetworking.h"
#import "RYCommon.h"
#import "GTUserPoints.h"
#import "UIImageView+WebCache.h"
#import "GTCityOrTownPoints.h"

@interface GTUGCPointView ()
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) UIImage *head;

@end

@implementation GTUGCPointView
+ (GTUGCPointView *)ugcPointViewWithPoint:(GTUGCPoint *)point
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    GTUGCPointView *pointView = [nibs firstObject];
    pointView.point = point;
    return pointView;
}

+ (GTUGCPointView *)userPointViewWithPoint:(GTUserPoints *)point
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    GTUGCPointView *pointView = [nibs firstObject];
    pointView.userPoints = point;
    return pointView;
}

+ (GTUGCPointView *)cityOrTownPointViewWithPoint:(GTCityOrTownPoints *)point
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    GTUGCPointView *pointView = [nibs firstObject];
    pointView.cityOrTownPoints = point;
    return pointView;
}


- (UIImage *)loadImageWithPoint:(GTUserPoints *)point
{
    if (self.head) {
        return self.head;
    }
    else {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:point.head_image]];
        UIImage *image = [UIImage imageWithData:data];
        UIImage *circleImage = [UIImage circleImage:image withParam:0];
        self.head = circleImage;
        return circleImage;
    }
}

- (void)setCityOrTownPoints:(GTCityOrTownPoints *)cityOrTownPoints
{
    [self.userIconImageView setImageWithURL:[NSURL URLWithString:cityOrTownPoints.head_image]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                      UIImage *circleImage = [UIImage circleImage:image withParam:0];
                                      self.userIconImageView.image = circleImage;
                                    });
                                  }];

    self.favoriteImageView.hidden = !cityOrTownPoints.favorite;
    _cityOrTownPoints = cityOrTownPoints;
}

- (void)setUserPoints:(GTUserPoints *)userPoints
{
    NSLog(@"%@", userPoints.head_image);
    [self.userIconImageView setImageWithURL:[NSURL URLWithString:userPoints.head_image]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                      UIImage *circleImage = [UIImage circleImage:image withParam:0];
                                      self.userIconImageView.image = circleImage;
                                    });
                                  }];
    NSLog(@"%d", userPoints.favorite);

    self.favoriteImageView.hidden = !userPoints.favorite;
    _userPoints = userPoints;
}

- (void)setPoint:(GTUGCPoint *)point
{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:point.user.headImageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [self.userIconImageView setImageWithURLRequest:request
        placeholderImage:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
          UIImage *circleImage = [UIImage circleImage:image withParam:0];
          self.userIconImageView.image = circleImage;
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){

        }];
    NSLog(@"%d", point.isFavorite);

    self.favoriteImageView.hidden = !point.isFavorite;
    _point = point;
}

@end

@interface GTUGCAnnotationView ()


@end

@implementation GTUGCAnnotationView
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        if ([[annotation class] isSubclassOfClass:[GTAnnotation class]]) {
            GTAnnotation *anno = (GTAnnotation *)annotation;
            GTUGCPointView *pointView;
            if (anno.userPoint) {
                pointView = [GTUGCPointView userPointViewWithPoint:(GTUserPoints *)anno.userPoint];
            }
            else if (!anno.cityOrTownPoint) {
                pointView = [GTUGCPointView cityOrTownPointViewWithPoint:(GTCityOrTownPoints *)anno.cityOrTownPoint];
            }
            else {
                pointView = [GTUGCPointView ugcPointViewWithPoint:(GTUGCPoint *)anno.point];
            }
            [self addSubview:pointView];
            self.pointView = pointView;
        }
    }
    return self;
}


- (void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    if ([[annotation class] isSubclassOfClass:[GTAnnotation class]]) {
        GTAnnotation *anno = (GTAnnotation *)annotation;
        self.pointView.point = (GTUGCPoint *)anno.point;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.pointView.backgroundImageView.highlighted = selected;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:nil];
}

@end
