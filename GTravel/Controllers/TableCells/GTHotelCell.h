//
//  GTHotelCell.h
//  GTravel
//
//  Created by QisMSoM on 15/7/13.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


//@protocol GTHotelCellDelegate <NSObject>
//
//- (void)viewClicked:(UIView *)view;
//
//@end


@interface GTHotelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topView;
// 酒店名称
@property (weak, nonatomic) IBOutlet UIView *hotelNameView;
// 所在城市
@property (weak, nonatomic) IBOutlet UIView *onCityName;
// 入住时间
@property (weak, nonatomic) IBOutlet UIView *inTime;
// 离店时间
@property (weak, nonatomic) IBOutlet UIView *outTIme;
// 联系电话
@property (weak, nonatomic) IBOutlet UIView *telephone;

//@property (weak, nonatomic) id<GTHotelCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
