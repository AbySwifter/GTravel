//
//  UIView+Additions.h
//
//  Created by Raynay Yue on 01/22/2015.
//  Copyright (c) 2015 Raynay Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)
- (void)showLoadingViewWithInfo:(NSString *)info hiddenAutomatic:(BOOL)hidden;
- (void)showLoadingViewWithInfo:(NSString *)info atPoint:(CGPoint)point hiddenAutomatic:(BOOL)hidden;
- (void)hideLoadingView:(BOOL)animated;
- (void)hideAllLoadingView;
@end
