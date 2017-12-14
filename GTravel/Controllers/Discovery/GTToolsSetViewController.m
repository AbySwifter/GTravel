//
//  GTToolsSetViewController.m
//  GTravel
//
//  Created by QisMSoM on 15/7/16.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTToolsSetViewController.h"
#import "GTToolsItem.h"
#import "DTWebViewController.h"
#import "GTToolsWebViewController.h"
#import "GTToolsSet.h"
#import "GTTablePartnerFoot.h"
#import "DTLogoViewController.h"

#define PartnerLogoHeight 120

@interface GTToolsSetViewController () <GTTablePartnerFootDelegate>

@end

@implementation GTToolsSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:239.0 / 255.0 green:239.0 / 255.0 blue:239.0 / 255.0 alpha:1];
    //    footer.backgroundColor = [UIColor clearColor];
    //
    //
    GTTablePartnerFoot *footer = [[GTTablePartnerFoot alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - PartnerLogoHeight - 44, [UIScreen mainScreen].bounds.size.width, PartnerLogoHeight)];
    footer.delegate = self;
    [self.view addSubview:footer];

    UIView *tableFoot = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = tableFoot;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.toolsItemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID = @"TOOLSITEMCELL";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    // 取出当前模型
    GTToolsItem *toolsItem = self.toolsItemsArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.text = toolsItem.title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    //    [cell.imageView setImageWithURL:[NSURL URLWithString:toolsItem.image]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTToolsItem *toolsItem = self.toolsItemsArray[indexPath.row];

    GTToolsWebViewController *vc = [[GTToolsWebViewController alloc] init];
    vc.detail = toolsItem.detail;
    if ([toolsItem.title isEqualToString:@"机票预订"]) {
        [self setBarChange];
    }
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

- (void)setBarChange
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebarbg01_ios"]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:3 / 255.0 green:34 / 255.0 blue:95 / 255.0 alpha:1.0]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:3 / 255.0 green:34 / 255.0 blue:95 / 255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
}

- (void)setBarNormal
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:204 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
