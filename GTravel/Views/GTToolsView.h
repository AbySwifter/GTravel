//
//  GTToolsView.h
//  GTravel
//
//  Created by Ray Yueh on 7/5/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTToolItem;
@protocol GTToolsViewDelegate;
@interface GTToolsView : UIView

@end

@protocol GTToolsViewDelegate <NSObject>

- (void)toolsView:(GTToolsView *)toolsView didClickToolItem:(GTToolItem *)toolItem;

@end