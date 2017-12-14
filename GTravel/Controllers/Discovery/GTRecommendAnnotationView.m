//
//  GTRecommendAnnotationView.m
//  GTravel
//
//  Created by Raynay Yue on 6/11/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTRecommendAnnotationView.h"
#import "GTPoint.h"
#import "GTAnnotation.h"
#import "GTCityOrTownPoints.h"

@implementation GTRecommendPointView
+ (GTRecommendPointView *)recommendPointViewWithPoint:(GTRecommendPoint *)point
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    GTRecommendPointView *pointView = [nibs firstObject];
    pointView.favoriteImageView.hidden = !point.isFavorite;
    return pointView;
}

+ (GTRecommendPointView *)recommendPointViewWithCityOrTownPoint:(GTCityOrTownPoints *)point
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    GTRecommendPointView *pointView = [nibs firstObject];
    pointView.favoriteImageView.hidden = !point.favorite;
    return pointView;
}

@end


@interface GTRecommendAnnotationView ()
@property (nonatomic, strong) GTRecommendPointView *pointView;

@end

@implementation GTRecommendAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        if ([[annotation class] isSubclassOfClass:[GTAnnotation class]]) {
            GTAnnotation *anno = (GTAnnotation *)annotation;
            GTRecommendPointView *pointView;
            if (!anno.cityOrTownPoint) {
                pointView = [GTRecommendPointView recommendPointViewWithPoint:(GTRecommendPoint *)anno.point];
            }
            else {
                pointView = [GTRecommendPointView recommendPointViewWithCityOrTownPoint:(GTCityOrTownPoints *)anno.cityOrTownPoint];
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
        if (!anno.cityOrTownPoint) {
            self.pointView.favoriteImageView.hidden = !anno.point.isFavorite;
        }
        else {
            self.pointView.favoriteImageView.hidden = !anno.cityOrTownPoint.favorite;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.pointView.backgroundView.highlighted = selected;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:nil];
}
@end
