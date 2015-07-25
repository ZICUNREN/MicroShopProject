//
//  SYInviteDetailViewController.m
//  MicroShop
//
//  Created by siyue on 15/7/6.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYInviteDetailViewController.h"
#import "UIViewController+Share.h"
#import "CHLayout.h"

@interface SYInviteDetailViewController ()
- (IBAction)shareClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareURLLabel;
- (IBAction)copyShareURLClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UITextView *shareTextView;

@end

@implementation SYInviteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"邀请赚钱";
    [self setView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setView
{
    NSString *invite = UserInvite;
    NSString *shareSTR = [NSString stringWithFormat:@"%@%@",Share_URL,invite];
    self.inviteLabel.text = invite;
    self.shareURLLabel.text = shareSTR;
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:self.textBackView withCornerRadius:3];
    [layout setView:self.shareTextView withCornerRadius:3];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareClick:(id)sender {
    NSString *key = UserToken;
    NSArray *keyArray = [key componentsSeparatedByString:@"_"];
    NSString *invite = keyArray.lastObject;
    NSString *shareSTR = [NSString stringWithFormat:@"%@%@",Share_URL,invite];
    [self shareAllButtonClickHandler:self.shareTextView.text withTitle:@"乐享" url:shareSTR image:nil withId:@""];
}
- (IBAction)copyShareURLClick:(id)sender {
    NSString *key = UserToken;
    NSArray *keyArray = [key componentsSeparatedByString:@"_"];
    NSString *invite = keyArray.lastObject;
    NSString *shareSTR = [NSString stringWithFormat:@"%@：%@%@",self.shareTextView.text,Share_URL,invite];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:shareSTR];
    [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"已复制"];
}
@end
