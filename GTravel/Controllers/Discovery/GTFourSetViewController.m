//
//  GTFourSetViewController.m
//  GTravel
//
//  Created by QisMSoM on 15/7/22.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTFourSetViewController.h"
#import "GTToolsSet.h"
#import "UIImageView+WebCache.h"
#import "GTToolsSetViewController.h"
#import "GTTablePartnerFoot.h"
#import "DTLogoViewController.h"
#import "DTLogoButton.h"

#define PartnerLogoHeight 120

@interface GTFourSetViewController () <GTTablePartnerFootDelegate>

@end

@implementation GTFourSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:239.0 / 255.0 green:239.0 / 255.0 blue:239.0 / 255.0 alpha:1];

    GTTablePartnerFoot *footer = [[GTTablePartnerFoot alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - PartnerLogoHeight - 44, [UIScreen mainScreen].bounds.size.width, PartnerLogoHeight)];
    footer.delegate = self;
    [self.view addSubview:footer];

    UIView *tableFoot = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = tableFoot;

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.fourSetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"FOURSETCELL";

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    // 取出当前模型
    GTToolsSet *toolsSet = self.fourSetArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.text = toolsSet.tools_title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        // 处理耗时操作的代码块...
    //        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:toolsSet.tools_image]];
    //        UIImage *image = [UIImage imageWithData:data];
    //        //通知主线程刷新
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //
    //            //回调或者说是通知主线程刷新，
    //            cell.textLabel.text = toolsSet.tools_title;
    //
    //            cell.imageView.image = image;
    //        });
    //    });
    [cell.imageView setImageWithURL:[NSURL URLWithString:toolsSet.tools_image] placeholderImage:nil];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTToolsSet *toolsSet = self.fourSetArray[indexPath.row];

    GTToolsSetViewController *vc = [[GTToolsSetViewController alloc] init];
    // 将安排行程整个数组传过去，数组里装得都是toolsItem

    vc.toolsItemsArray = toolsSet.toolsItemsArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--- DTPartnerLogoDelegate
- (void)showLogoDetail:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showLogoDetailWithLeftButton:(DTLogoButton *)button
{
    DTLogoViewController *vc = [[DTLogoViewController alloc] init];
    vc.url = button.linkURL;
    vc.setBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
