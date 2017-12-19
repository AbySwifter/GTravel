//
//  NewRouteViewController.m
//  GTravel
//
//  Created by Raynay Yue on 5/29/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "NewRouteViewController.h"
#import "RYCommon.h"
#import "MBProgressHUD.h"

@interface NewRouteViewController () <UITextFieldDelegate, UITextViewDelegate> {
    BOOL bIsTextViewEditing;
    CGRect keyboardRect;
    CGFloat keyboardAnimationDuration;
    NSInteger keyboardAnimationCurve;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
- (void)initializedNavigationBar;
- (void)onDoneButton:(id)sender;

- (void)addKeyboardObserver;
- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification;
- (void)removeKeyboardObserver;
- (void)changeTextViewFrameForEditing:(BOOL)shouldChange;
@end

@implementation NewRouteViewController
#pragma mark - Non-Public Methods
- (void)initializedNavigationBar
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneButton:)];
    [self.navigationItem setRightBarButtonItem:barButton];
}

- (void)onDoneButton:(id)sender
{
    [self.textViewDescription resignFirstResponder];
    [self.textFieldTitle resignFirstResponder];
    if (RYIsValidString(self.textFieldTitle.text)) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"创建中...";
        [self.model createLine:self.textFieldTitle.text
                   description:self.textViewDescription.text
                    completion:^(NSError *error) {
                      if (error) {
                          hud.mode = MBProgressHUDModeText;
                          hud.label.text= @"创建失败，请稍后再试！";
						  [hud hideAnimated:YES afterDelay:3.0];
                      }
                      else {
                          hud.mode = MBProgressHUDModeText;
                          hud.label.text = @"创建成功！";
                          [hud hideAnimated:YES afterDelay:3.0];
                          if (RYDelegateCanResponseToSelector(self.delegate, @selector(newRouteViewControllerDidCreateNewRoute:))) {
                              [self.delegate newRouteViewControllerDidCreateNewRoute:self];
                          }
                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            sleep(3);
                            dispatch_async(dispatch_get_main_queue(), ^{
                              [self.navigationController popViewControllerAnimated:YES];
                            });
                          });
                      }
                    }];
    }
    else {
        RYShowAlertView(nil, @"标题不能为空!", nil, 0, @"我知道了!", nil, nil);
    }
}

- (void)addKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrameNotification:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification
{
    keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardAnimationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardAnimationCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    keyboardRect = [self.view.window convertRect:keyboardRect fromWindow:nil];
    keyboardRect = [self.view convertRect:keyboardRect fromView:self.view.window];
    if (bIsTextViewEditing) {
        CGRect textViewRect = self.textViewDescription.frame;
        CGFloat fTextViewHeight = MIN(textViewRect.size.height, keyboardRect.origin.y);
        CGFloat fConstantTextViewToplayout = keyboardRect.origin.y - fTextViewHeight;
        self.textViewHeightConstraint.constant = fTextViewHeight;
        self.textViewTopConstraint.constant = fConstantTextViewToplayout;
        [UIView animateWithDuration:keyboardAnimationDuration
                              delay:0.0
                            options:keyboardAnimationCurve
                         animations:^{
                           [self.textViewDescription layoutIfNeeded];
                         }
                         completion:NULL];
    }
}

- (void)removeKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)changeTextViewFrameForEditing:(BOOL)shouldChange
{
    CGRect textViewRect = self.textViewDescription.frame;
    CGFloat fTextViewHeight = shouldChange ? MIN(textViewRect.size.height, keyboardRect.origin.y) : 139;
    CGFloat fConstantTextViewToplayout = shouldChange ? MIN(keyboardRect.origin.y - fTextViewHeight, 144) : 144;
    self.textViewHeightConstraint.constant = fTextViewHeight;
    self.textViewTopConstraint.constant = fConstantTextViewToplayout;
    [UIView animateWithDuration:keyboardAnimationDuration
                          delay:0.0
                        options:keyboardAnimationCurve
                     animations:^{
                       [self.textViewDescription layoutIfNeeded];
                     }
                     completion:NULL];
}

#pragma mark - Public Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializedNavigationBar];
    [self.textFieldTitle becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyboardObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardObserver];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    bIsTextViewEditing = YES;
    [self changeTextViewFrameForEditing:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    NSString *str = [[textView.text stringByReplacingCharactersInRange:range withString:text] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.labelDescription.hidden = RYIsValidString(str);
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    bIsTextViewEditing = NO;
    [self changeTextViewFrameForEditing:NO];
    return YES;
}
@end
