//
//  SYLoginViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYLoginViewController.h"
#import "CHLayout.h"
#import "SYLoginIconManage.h"
#import "UIViewController+Share.h"
#import "JSONKit.h"
#import "SYGeneralHtmlViewController.h"
#import "SYRegisterViewController.h"
#import "SYAnalyzeInterface.h"
#import "SYFindPasswordViewController.h"

#define Register_URL @"http://weidian.gx.com/user/user/register.html?app=ios" //注册页面，暂时写死 已经改为原生

@interface SYLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *WXLoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;



@property (strong,nonatomic)NSString *currentUserName;

- (IBAction)loginClick:(id)sender;
- (IBAction)weixinLoginClick:(id)sender;
- (IBAction)registerClick:(id)sender;
- (IBAction)forgetPasswordClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *login_bg;


@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标
@end

@implementation SYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.userNameTextField.text = @"name";
    //self.passWordTextField.text = @"123456";
    self.userNameTextField.delegate = self;
    self.isLoginVC = YES;
    [self initView];
    
    UIImage *iconImage = [[SYLoginIconManage sharedManager] getUserIconWithUserName:self.userNameTextField.text];
    if (iconImage!=nil) {
        self.userImgView.image = iconImage;
    }
    else {
        self.userImgView.image = [UIImage imageNamed:@"use.png"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.userNameTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)initView
{
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:self.userImgView withCornerRadius:self.userImgView.frame.size.width/2];
    [layout setView:self.infoView withCornerRadius:3];
    [layout setView:self.loginBtn withCornerRadius:3];
    [layout setView:self.registerBtn withCornerRadius:3];
    [layout setView:self.WXLoginBtn withCornerRadius:3];
    
    BOOL isWXInstall =  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];

    if (!isWXInstall) {
        self.WXLoginBtn.hidden = YES;
        self.hintLabel.hidden = NO;
    }
    
    //UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //visualEffectView.alpha = 0.9;
    //visualEffectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //[self.login_bg insertSubview:visualEffectView atIndex:0];
    
}

#pragma mark - net

- (void)requestLogin
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"登录中";
    [self.progressHUD show:YES];
    [self.view addSubview:self.progressHUD];

    
    self.currentUserName = self.userNameTextField.text;
    NSString *url = [NSString stringWithFormat:@"%@%@",HomeURL,User_Login];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passWordTextField.text;
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:@"ios" forKey:@"app"];
    
    [[NetworkInterface shareInstance] requestForPost:url parms:params complete:^(NSDictionary *result) {
        [self didRequestLogin:result];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestLogin:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSString *token = [NSString stringWithFormat:@"%@",result[@"data"][@"authcode"]];
            SetUserToken(token);
            NSString *invite = [NSString stringWithFormat:@"%@",result[@"data"][@"inviter"]];//邀请码
            SetInvite(invite);
            NSString *member_id = [NSString stringWithFormat:@"%@",result[@"data"][@"member_id"]];//用户id
            SetMemberId(member_id);
            [[SYAnalyzeInterface sharedManager] addAlias:member_id type:AliasType response:^(id responseObject, NSError *error) {
                
            }];
            NSDictionary *webURLData = result[@"data"][@"href"];
            [[NSUserDefaults standardUserDefaults] setObject:webURLData forKey:@"webURLData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *lastUserName = [[SYLoginIconManage sharedManager] getCurentUserName];
            if (![lastUserName isEqualToString:self.currentUserName]) {
                [[SYLoginIconManage sharedManager] saveUserName:self.currentUserName];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ReloadAllView object:self];
                
                //清除缓存
                NSString *tmpDir = NSTemporaryDirectory();
                NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"catche.plist"];
                NSFileManager *fileManage = [NSFileManager defaultManager];
                [fileManage removeItemAtPath:savePath error:nil];
            }
            
            //[self.view removeFromSuperview];
            [self.navigationController popViewControllerAnimated:NO];
            
            isLogout = NO;
            if (self.didLogin) {
                self.didLogin();
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else {
        NSString *message = [NSString stringWithFormat:@"%@",result[@"message"]];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
        RemoveUserToken;
        
    }
    [self.progressHUD hide:YES afterDelay:0];
}

- (void)requestWeixinLogin:(NSDictionary *)userInfo
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"登录中";
    [self.progressHUD show:YES];
    [self.view addSubview:self.progressHUD];
    
    self.currentUserName = userInfo[@"nickname"];
    NSString *userInfoJsonStr = [userInfo JSONString];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HomeURL,Weixin_Login];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfoJsonStr forKey:@"user_info"];
    [params setObject:@"ios" forKey:@"app"];
    
    [[NetworkInterface shareInstance] requestForPost:url parms:params complete:^(NSDictionary *result) {
        [self didRequestWeixinLogin:result];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestWeixinLogin:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSString *token = [NSString stringWithFormat:@"%@",result[@"data"][@"authcode"]];
            SetUserToken(token);
            NSDictionary *webURLData = result[@"data"][@"href"];
            NSString *invite = [NSString stringWithFormat:@"%@",result[@"data"][@"inviter"]];
            SetInvite(invite);
            NSString *member_id = [NSString stringWithFormat:@"%@",result[@"data"][@"member_id"]];//用户id
            SetMemberId(member_id);
            [[SYAnalyzeInterface sharedManager] addAlias:member_id type:AliasType response:^(id responseObject, NSError *error) {
                
            }];
            
            [[NSUserDefaults standardUserDefaults] setObject:webURLData forKey:@"webURLData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *lastUserName = [[SYLoginIconManage sharedManager] getCurentUserName];
            if (![lastUserName isEqualToString:self.currentUserName]) {
                [[SYLoginIconManage sharedManager] saveUserName:self.currentUserName];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ReloadAllView object:self];
                
                //清除缓存
                NSString *tmpDir = NSTemporaryDirectory();
                NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"catche.plist"];
                NSFileManager *fileManage = [NSFileManager defaultManager];
                [fileManage removeItemAtPath:savePath error:nil];
            }
            
            self.fatherNavigationController.navigationBar.hidden = NO;
            [self.navigationController popViewControllerAnimated:NO];
            
            //[self.view removeFromSuperview];
            isLogout = NO;
            if (self.didLogin) {
                self.didLogin();
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    else {
        RemoveUserToken;
    }
    [self.progressHUD hide:YES afterDelay:0];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIImage *iconImage = [[SYLoginIconManage sharedManager] getUserIconWithUserName:textField.text];
    if (iconImage!=nil) {
        self.userImgView.image = iconImage;
    }
    else {
        self.userImgView.image = [UIImage imageNamed:@"use.png"];
    }
}

- (void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    UIImage *iconImage = [[SYLoginIconManage sharedManager] getUserIconWithUserName:textField.text];
    if (iconImage!=nil) {
        self.userImgView.image = iconImage;
    }
    else {
        self.userImgView.image = [UIImage imageNamed:@"use.png"];
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

- (IBAction)loginClick:(id)sender {
    if ([self.userNameTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"用户名不能为空"];
        return;
    }
    if ([self.passWordTextField.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"密码不能为空"];
        return;
    }
    [self requestLogin];
}

- (IBAction)weixinLoginClick:(id)sender {
    [self shareLoginWithType:ShareTypeWeixiTimeline result:^(NSDictionary *result) {
        [self requestWeixinLogin:result];
    }];
}

- (IBAction)registerClick:(id)sender {
    isLogout = NO;
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = Register_URL;
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"注册";
    generalHtmlVC.isRegister = YES;
    generalHtmlVC.isLoginVC = YES;*/
    
    SYRegisterViewController *registerVC = [[SYRegisterViewController alloc] init];
    
    /*[self.fatherViewController presentViewController:registerVC animated:YES completion:^{
        self.view.hidden = YES;
    }];*/
    [self.navigationController pushViewController:registerVC animated:YES];
    
    [registerVC setDidRegister:^(NSString *userName, NSString *passWord) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"注册成功"];
        self.userNameTextField.text = userName;
        self.passWordTextField.text = passWord;
        [self requestLogin];
    }];
    
    /*generalHtmlVC.didLogin = ^(NSDictionary *result) {
        self.view.hidden = NO;
        [self didRequestLogin:result];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"注册成功，正在登录..."];
    };*/
    registerVC.didBack = ^() {
        self.view.hidden = NO;
    };
}

- (IBAction)forgetPasswordClick:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ForgetPassword" bundle:nil];
    SYFindPasswordViewController *findPasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"FindPasswordViewController"];
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}
@end
