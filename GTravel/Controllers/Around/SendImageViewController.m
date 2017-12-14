//
//  SendImageViewController.m
//  GTravel
//
//  Created by Raynay Yue on 6/4/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "SendImageViewController.h"
#import "RYCommon.h"
#import "TagListViewController.h"
#import "GTCategory.h"
#import "MBProgressHUD.h"

@interface SendImageViewController () <UITextViewDelegate, TagListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttongDone;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageViewTop;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@property (nonatomic, strong) GTCategory *category;

- (IBAction)onBackButton:(id)sender;
- (IBAction)onDoneButton:(id)sender;
- (IBAction)onImageViewButton:(id)sender;
- (IBAction)onAddTagButton:(id)sender;

- (void)pushImageViewToTop:(BOOL)push animated:(BOOL)animated;
- (void)setTagButtonWithTitle:(NSString *)title;
@end

@implementation SendImageViewController
#pragma mark - IBAction Methods
- (IBAction)onBackButton:(id)sender
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDoneButton:(id)sender
{
    [self.textView resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"发布中...";
    NSData *data = UIImageJPEGRepresentation(self.image, 1.0);
    [self.model uploadImageData:data
        description:self.textView.text
        category:self.category
        completion:^(NSError *error, BOOL success) {
          hud.mode = MBProgressHUDModeText;
          hud.labelText = success ? @"发布成功!" : @"发布失败,请稍后再试!";
          [hud hide:YES afterDelay:2.0];
          if (success) {
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                sleep(2);
                dispatch_async(dispatch_get_main_queue(), ^{
                  [self onBackButton:nil];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"DIDCOMPLECTIONNEWIMAGE" object:nil];
                });
              });
          }
        }
        uploadProgressBlock:^(float fProgress) {
          hud.progress = fProgress;
        }];
}
- (IBAction)onImageViewButton:(id)sender
{
    [self pushImageViewToTop:NO animated:YES];
}

- (IBAction)onAddTagButton:(id)sender
{
    TagListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TagListViewController class])];
    controller.delegate = self;
    controller.selectedCategory = self.category;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Non-Public Methods
- (void)pushImageViewToTop:(BOOL)push animated:(BOOL)animated
{
    if (!push)
        [self.textView resignFirstResponder];
    self.constraintImageViewTop.constant = push ? self.textView.frame.size.height - self.imageView.frame.size.height : 0;
    if (animated) {
        [UIView animateWithDuration:0.5
                         animations:^{
                           [self.view layoutIfNeeded];
                         }];
    }
    else
        [self.view layoutIfNeeded];
}

- (void)setTagButtonWithTitle:(NSString *)title
{
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};


    CGSize fontSize = [title sizeWithAttributes:dict];

    NSLog(@"%f---%f", fontSize.width, fontSize.height);
    //    [title boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:dict context:nil]
    for (NSLayoutConstraint *contraint in self.tagButton.constraints) {
        if (contraint.firstItem == self.tagButton) {
            if (contraint.firstAttribute == NSLayoutAttributeWidth)
                contraint.constant = fontSize.width + 10;
            else if (contraint.firstAttribute == NSLayoutAttributeHeight)
                contraint.constant = fontSize.height + 10;
        }
    }
    self.tagButton.layer.cornerRadius = 3.0;
    [self.tagButton setTitle:title forState:UIControlStateNormal];
    [self.tagButton layoutIfNeeded];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = self.image;
    RYCONDITIONLOG(DEBUG, @"%@", self.metadata);
    self.labelAddress.text = [self.model getCurrentUserAddress];

    NSLog(@"%@", self.labelAddress.text);

    [self setTagButtonWithTitle:@"添加标签"];
    self.title = @"发布图文";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!RYIsValidString(self.textView.text))
        [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self pushImageViewToTop:YES animated:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *str = [[textView.text stringByReplacingCharactersInRange:range withString:text] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.labelDescription.hidden = RYIsValidString(str);
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self pushImageViewToTop:NO animated:YES];
    return YES;
}


#pragma mark - TagListViewControllerDelegate
- (void)tagListViewController:(TagListViewController *)controller didSelectedCategory:(GTCategory *)category
{
    self.category = category;
    [self setTagButtonWithTitle:category.title];
}

@end
