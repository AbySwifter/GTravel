//
//  DTScrollView.h
//  GTravel
//
//  Created by Raynay Yue on 5/11/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTPageControlPosition) {
    DTPageControlPositionNone,
    DTPageControlPositionLeft,
    DTPageControlPositionCenter,
    DTPageControlPositionRight
};

@protocol DTScrollViewDelegate;
@interface DTScrollView : UIView

+ (DTScrollView *)scrollViewWithFrame:(CGRect)frame delegate:(id<DTScrollViewDelegate>)delegate scrollForever:(BOOL)forever;
- (void)setImageWithPaths:(NSArray *)paths pageIndicatorPosition:(DTPageControlPosition)position;
- (void)setImageWithPaths:(NSArray *)paths defaultImage:(UIImage *)image pageIndicatorPosition:(DTPageControlPosition)position;
- (void)setAutoScrollEnabled:(BOOL)enabled;

@end

@protocol DTScrollViewDelegate <NSObject>
- (void)scrollViewDidScrollToEnd:(DTScrollView *)scrollView;
- (void)scrollView:(DTScrollView *)scrollView didClickImageAtIndex:(NSInteger)index;
- (void)scrollView:(DTScrollView *)scrollView didUpdateImageData:(NSData *)data atIndex:(NSInteger)index;
@end