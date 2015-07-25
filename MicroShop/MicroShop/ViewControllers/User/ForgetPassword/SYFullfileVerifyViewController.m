//
//  SYFullfileVerifyViewController.m
//  MicroShop
//
//  Created by siyue on 15/7/13.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYFullfileVerifyViewController.h"
#import "CHLayout.h"
#import "CHFileManager.h"
#import "SYChangePasswordViewController.h"

@interface SYFullfileVerifyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UIButton *reGetButton;
- (IBAction)nextBtnClick:(id)sender;
- (IBAction)reGetBtnClick:(id)sender;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYFullfileVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"填写验证码";
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
    NSString *phoneNumLabelText = [NSString stringWithFormat:@"%@%@",self.phoneNumLabel.text,self.phoneNum];
    self.phoneNumLabel.text = phoneNumLabelText;
    
    [[CHLayout sharedManager] setView:self.textBackView withCornerRadius:3];
    [[CHLayout sharedManager] setView:self.nextButton withCornerRadius:3];
    [[CHLayout sharedManager] setView:self.reGetButton withCornerRadius:3];
}

#pragma mark - request

- (void)requestSendMessage
{
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    NSString *phoneNum = [NSString stringWithFormat:@"&tel=%@",self.phoneNum];
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    NSString *timeSTR = [NSString stringWithFormat:@"&s_time=%li",(long)time];
    NSString *ciphertext = [NSString stringWithFormat:@"%li%@",(long)time,@"1ba0a83f4ce42ae93b1fc0c05f77322c"];
    NSString *ciphertextMd5 = [[CHFileManager shareInstance] md5:ciphertext];
    NSString *ciphertextSTR = [NSString stringWithFormat:@"&ciphertext=%@",ciphertextMd5];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,Send_Password_Message,phoneNum,timeSTR,ciphertextSTR];
    [[NetworkInterface shareInstance] requestNoCacheGet:url complete:^(NSDictionary *result) {
        [self didRequestSendMessage:result];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestSendMessage:(NSDictionary *)result
{
    //NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    NSString *message = [NSString stringWithFormat:@"%@",result[@"message"]];
    [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
}

- (void)requestCheckVerify
{
    self.progressHUD.labelText = @"验证中";
    [self.progressHUD show:YES];
    
    NSString *phoneNum = [NSString stringWithFormat:@"&tel=%@",self.phoneNum];
    NSString *verify = [NSString stringWithFormat:@"&verify=%@",self.verifyTextField.text];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Check_Verify_Message,phoneNum,verify];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ForgetPassword" bundle:nil];
        SYChangePasswordViewController *changePasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
        changePasswordVC.verify = self.verifyTextField.text;
        changePasswordVC.phoneNum = self.phoneNum;
        [self.navigationController pushViewController:changePasswordVC animated:YES];
        [[DialogUtil sharedInstance] showDlg:changePasswordVC.view textOnly:message];
    }
    else {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }

}


- (IBAction)nextBtnClick:(id)sender {
    [self.verifyTextField resignFirstResponder];
    
    if ([self.verifyTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入验证码"];
        return;
    }
    [self requestCheckVerify];
}

- (IBAction)reGetBtnClick:(id)sender {
    [self requestSendMessage];
}
@end
