//
//  SYChangePasswordViewController.m
//  MicroShop
//
//  Created by siyue on 15/7/13.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYChangePasswordViewController.h"
#import "CHLayout.h"
#import "SYLoginViewController.h"

@interface SYChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *passwordBackView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTextField;

- (IBAction)sureBtnClick:(id)sender;

@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标
@end

@implementation SYChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改密码";
    [self instalView];
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)instalView
{
    self.passwordBackView.layer.borderColor = [UIColor colorWithWhite:0.910 alpha:1.000].CGColor;
    self.passwordBackView.layer.borderWidth = 1;
    [[CHLayout sharedManager] setView:self.passwordBackView withCornerRadius:5];
    
    [[CHLayout sharedManager] setView:self.sureButton withCornerRadius:3];
}

- (void)requestCheckVerify
{
    self.progressHUD.labelText = @"修改中";
    [self.progressHUD show:YES];
    
    NSString *password = [NSString stringWithFormat:@"&password=%@",self.passwordTextField.text];
    NSString *rePassword = [NSString stringWithFormat:@"&repassword=%@",self.repasswordTextField.text];
    NSString *phoneNum = [NSString stringWithFormat:@"&tel=%@",self.phoneNum];
    NSString *verify = [NSString stringWithFormat:@"&verify=%@",self.verify];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@",HomeURL,Change_Password_URL,phoneNum,verify,password,rePassword];
    [[NetworkInterface shareInstance] requestNoCacheGet:url complete:^(NSDictionary *result) {
        [self didRequestCheckVerify:result];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestCheckVerify:(NSDictionary *)result
{
    NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    NSString *message = [NSString stringWithFormat:@"%@",result[@"message"]];
    if ([code isEqualToString:@"1"]) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        for (UIViewController *vc in viewControllers) {
            if ([vc isKindOfClass:SYLoginViewController.class]) {
                [self.navigationController popToViewController:vc animated:YES];
                [[DialogUtil sharedInstance] showDlg:vc.view textOnly:message];
                return;
            }
        }
    }
    else {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
    
}

- (IBAction)sureBtnClick:(id)sender {
    
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入新密码"];
        return;
    }
    
    if ([self.repasswordTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请再次输入新密码"];
        return;
    }
    
    if (![self.repasswordTextField.text isEqualToString:self.passwordTextField.text]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"两次输入密码不一致"];
        return;
    }
    
    [self.passwordTextField resignFirstResponder];
    [self.repasswordTextField resignFirstResponder];
    
    [self requestCheckVerify];
}
@end
