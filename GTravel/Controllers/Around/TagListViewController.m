//
//  TagListViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "TagListViewController.h"
#import "RYCommon.h"
#import "GTCategory.h"
#import "MBProgressHUD.h"

@interface TagListViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *categories;

- (void)initializedRightNavigationItem;
- (void)addNewTag:(UIButton *)button;

@end

@implementation TagListViewController
#pragma mark - IBAction Methods
- (void)initializedRightNavigationItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNewTag:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barButton animated:YES];
}

- (void)addNewTag:(UIButton *)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入新标签" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializedRightNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if (RYIsValidString(textField.text)) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.model createTagWithTitle:textField.text
                                    completion:^(NSError *error, GTCategory *category) {
                                      hud.mode = MBProgressHUDModeText;
                                      hud.labelText = error == nil ? @"添加成功!" : @"添加失败，请稍后再试!";
                                      [hud hide:YES afterDelay:2.0];
                                      if (!error) {
                                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                            sleep(2);
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                              if (RYDelegateCanResponseToSelector(self.delegate, @selector(tagListViewController:didSelectedCategory:))) {
                                                  [self.delegate tagListViewController:self didSelectedCategory:category];
                                              }
                                              [self.navigationController popViewControllerAnimated:YES];
                                            });
                                          });
                                      }
                                    }];
            }
            else {
                RYShowAlertView(nil, @"名称不能为空!", self, 0, @"好的", nil, nil);
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", (unsigned long)self.model.categories.count);
    return self.model.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GTTagCell"];
    GTCategory *category = self.model.categories[indexPath.row];
    if ([self.selectedCategory.categoryID longLongValue] == [category.categoryID longLongValue])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = category.title;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GTCategory *category = self.model.categories[indexPath.row];
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(tagListViewController:didSelectedCategory:))) {
        [self.delegate tagListViewController:self didSelectedCategory:category];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.model.categories.count) {
        [self.model requestCategoryWithCompletion:^(NSError *error, NSArray *items) {
          if (RYIsValidArray(items)) {
              self.categories = items;
              //                [self updateTableViewDataAfterRequestCompletion:@(GTAroundCellTypeCategory)];
          }
        }];
    }

    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

@end
