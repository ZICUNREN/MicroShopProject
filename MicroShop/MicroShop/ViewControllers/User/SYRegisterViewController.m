//
//  SYRegisterViewController.m
//  MicroShop
//
//  Created by siyue on 15/5/30.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYRegisterViewController.h"
#import "CHLayout.h"

@interface SYRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firmPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *inviteTextField;

- (IBAction)backClick:(id)sender;
- (IBAction)registerClick:(id)sender;
- (IBAction)verifyBtnClick:(id)sender;

@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"免费注册";
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:self.verifyBtn withCornerRadius:3];
    [layout setView:self.registerBtn withCornerRadius:3];
}

#pragma mark - net

- (void)requestSendMSM
{
    if (self.progressHUD==nil) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.progressHUD];
    }
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    NSString *phone = [NSString stringWithFormat:@"&tel=%@",self.phoneTextField.text];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,Register_Send_MSM,phone];
    [[NetworkInterface shareInstance] requestNoCacheGet:url complete:^(NSDictionary *result) {
        [self didRequestSendMSM:result];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestSendMSM:(NSDictionary *)result
{
    if ([result[@"code"] integerValue]==1) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"已发送手机号"];
    }
    else {
        NSString *message = result[@"message"];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
}

- (void)requestRegister
{
    if (self.progressHUD==nil) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.progressHUD];
    }
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    
    NSString *phone = [NSString stringWithFormat:@"%@",self.phoneTextField.text];
    NSString *password = [NSString stringWithFormat:@"%@",self.passWordTextField.text];
    NSString *repassword = [NSString stringWithFormat:@"%@",self.firmPassWordTextField.text];
    NSString *nickname = [NSString stringWithFormat:@"%@",self.nickNameTextField.text];
    NSString *verify = [NSString stringWithFormat:@"%@",self.yanzhengTextField.text];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"tel"];
    [params setObject:password forKey:@"password"];
    [params setObject:repassword forKey:@"repassword"];
    [params setObject:nickname forKey:@"nickname"];
    [params setObject:verify forKey:@"verify"];
    
    NSString *invite = [NSString stringWithFormat:@"%@",self.inviteTextField.text];;
    if (invite!=nil) {
        [params setObject:invite forKey:@"inviter"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HomeURL,Register_New_User];
    
    [[NetworkInterface shareInstance] requestNoCachePost:url parms:params complete:^(NSDictionary *result) {
        [self didRequestREgister:result];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestREgister:(NSDictionary *)result
{
    if ([result[@"code"] integerValue]==1) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"注册成功"];
        
        if (self.didBack!=nil) {
            self.didBack();
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.didRegister!=nil) {
                self.didRegister(self.phoneTextField.text,self.passWordTextField.text);
            }
        }];
    }
    else {
        NSString *message = result[@"message"];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
}

- (IBAction)backClick:(id)sender {
    if (self.didBack!=nil) {
        self.didBack();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerClick:(id)sender {
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入手机号码"];
        return;
    }
    
    if (![self checkPhoneNumInputWithStr:self.phoneTextField.text]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入正确的手机号码"];
        return;
    }
    
    if ([self.passWordTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入密码"];
        return;
    }
    if ([self.firmPassWordTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请再次输入密码"];
        return;
    }
    if ([self.nickNameTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入昵称"];
        return;
    }
    if ([self.yanzhengTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入短信验证码"];
        return;
    }
    if (![self.passWordTextField.text isEqualToString:self.firmPassWordTextField.text]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"两次密码不一致"];
        return;
    }
    
    [self requestRegister];
}

- (IBAction)verifyBtnClick:(id)sender {
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入手机号码"];
        return;
    }
    
    if (![self checkPhoneNumInputWithStr:self.phoneTextField.text]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入正确的手机号码"];
        return;
    }

    [self requestSendMSM];
}

-(BOOL)checkPhoneNumInputWithStr:(NSString *)str{
    
    /*NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:str];
    BOOL res2 = [regextestcm evaluateWithObject:str];
    BOOL res3 = [regextestcu evaluateWithObject:str];
    BOOL res4 = [regextestct evaluateWithObject:str];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }*/
    
    if (str.length==11) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
