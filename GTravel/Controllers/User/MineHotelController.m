//
//  MineHotelController.m
//  GTravel
//
//  Created by QisMSoM on 15/7/13.
//  Copyright (c) 2015年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "MineHotelController.h"
#import "MineTableView.h"
#import "GTHotelCell.h"

@interface MineHotelController () {
    IBOutlet UITableView *myTableView;
}

@property (nonatomic, strong) NSMutableArray *hotelArray;
@property (nonatomic, weak) UIView *footer;

@end

@implementation MineHotelController

- (NSMutableArray *)hotelArray
{
    if (nil == _hotelArray) {
        _hotelArray = [[NSMutableArray alloc] init];
    }
    return _hotelArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:230.0 / 255.0 green:230.0 / 255.0 blue:230.0 / 255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self setupFooterView];
}

- (void)setupFooterView
{
    UIView *footer = [[UIView alloc] init];
    self.footer = footer;
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.bounds = CGRectMake(0, 0, 50, 50);
    plus.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, 25);
    [plus setImage:[UIImage imageNamed:@"bt_map_plus@2x"] forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(plusClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.footer addSubview:plus];
    myTableView.tableFooterView = footer;
}

- (void)plusClicked:(UIButton *)plus
{
    NSLog(@"---");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initializedNavigationBarItems
{
    self.navigationItem.title = @"我的酒店";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!self.hotelArray.count) {
        return 2;
    }
    else {
        return self.hotelArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    GTHotelCell *cell = [GTHotelCell cellWithTableView:tableView];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 255 + 10;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSInteger count = self.hotelArray.count;
    if (!self.hotelArray.count) {
        count = 1;
    }
    CGFloat x = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = 50;
    CGFloat y = count * 245 + h;
    self.footer.frame = CGRectMake(x, y, w, h);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSomeVC) name:@"viewClicked" object:nil];
}

- (void)pushSomeVC
{
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
