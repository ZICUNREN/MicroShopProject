//
//  SYFindPasswordViewController.m
//  MicroShop
//
//  Created by siyue on 15/7/11.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYFindPasswordViewController.h"
#import "CHLayout.h"
#import "CHFileManager.h"
#import "SYFullfileVerifyViewController.h"

@interface SYFindPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
- (IBAction)clrPhoneNumClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
- (IBAction)verifyClick:(id)sender;

@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"找回密码";
    
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
    [[CHLayout sharedManager] setView:self.textBackView withCornerRadius:3];
    [[CHLayout sharedManager] setView:self.verifyButton withCornerRadius:3];
}

#pragma mark - request

- (void)requestSendMessage
{
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    NSString *phoneNum = [NSString stringWithFormat:@"&tel=%@",self.phoneNumTextField.text];
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
    NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    NSString *message = [NSString stringWithFormat:@"%@",result[@"message"]];
    if ([code isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ForgetPassword" bundle:nil];
        SYFullfileVerifyViewController *fullfillVerifyVC = [storyboard instantiateViewControllerWithIdentifier:@"FullfileVerifyViewController"];
        fullfillVerifyVC.phoneNum = self.phoneNumTextField.text;
        [self.navigationController pushViewController:fullfillVerifyVC animated:YES];
        [[DialogUtil sharedInstance] showDlg:fullfillVerifyVC.view textOnly:message];
    }
    else {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clrPhoneNumClick:(id)sender {
    self.phoneNumTextField.text = @"";
}

- (IBAction)verifyClick:(id)sender {
    
    [self.phoneNumTextField resignFirstResponder];
    
    if ([self.phoneNumTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入手机号码"];
        return;
    }
    
    if (![self checkPhoneNumInputWithStr:self.phoneNumTextField.text]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入正确的手机号码"];
        return;
    }

    
    [self requestSendMessage];
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
