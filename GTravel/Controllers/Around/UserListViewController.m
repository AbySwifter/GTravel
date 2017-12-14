//
//  UserListViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "UserListViewController.h"
#import "GTUserCell.h"
#import "GTravelUserItem.h"
#import "GTravelNetDefinitions.h"
#import "RouteDetailViewController.h"
#import "GTUserRouteViewController.h"

@interface UserListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.showTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GTUserCell";
    GTUserCell *cell = (GTUserCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell resetCell];
    if (self.cellType) {
        [cell setDistanceUser:self.users[indexPath.row]];
    }
    else {
        [cell setUser:self.users[indexPath.row]];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTDistanceUser *user = self.users[indexPath.row];
    NSLog(@"%@%@", user.userID, self.model.userItem.userID);

    GTUserRouteViewController *controller = [[GTUserRouteViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"/profiles/%@?userid=%@", user.userID, self.model.userItem.userID];
    controller.strURL = GetAPIUrl(url);

    [self.navigationController pushViewController:controller animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
