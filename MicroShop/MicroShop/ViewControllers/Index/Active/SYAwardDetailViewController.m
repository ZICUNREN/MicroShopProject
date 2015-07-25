//
//  SYAwardDetailViewController.m
//  MicroShop
//
//  Created by siyue on 15/6/4.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYAwardDetailViewController.h"
#import "SYAwardDetailModel.h"
#import "CHLayout.h"
#import "LZAudioTool.h"
#import "CHTextShow.h"
#import "SYAwardListViewController.h"

#define Scale (400.0/600.0)

@interface SYAwardDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *awardImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awardImgBackViewHeightConstraint;
- (IBAction)awardBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *awardBtn;
@property (weak, nonatomic) IBOutlet UILabel *regularLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *secLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginWordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigAwardImgView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *overLabel;

@property (strong,nonatomic)SYAwardDetailModel *awardDetailModel;
@property (nonatomic)BOOL isArrowAward;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标
@property (nonatomic)NSInteger coundownTime;
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic)BOOL isCheckTime;

@property (nonatomic)BOOL isArrowMotion;//是否允许摇一摇
@property (nonatomic)BOOL isShowTip;//是否正在弹出提示框

@end

@implementation SYAwardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"幸运抽奖";
    
    self.isArrowAward = NO;
    self.coundownTime = 0;
    self.isArrowMotion = YES;
    self.isShowTip = NO;
    self.isCheckTime = YES;
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.tag = 100;
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    rightButton.titleLabel.numberOfLines = 2;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitle:@"领奖" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self requestAwardDetail:YES];
    
    self.awardImgBackViewHeightConstraint.constant = Scale*ScreenWidth;
    [[CHLayout sharedManager] setView:self.awardBtn withCornerRadius:3];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)rightBtnAction
{
    SYAwardListViewController *awardListVC = [[SYAwardListViewController alloc] init];
    [self.navigationController pushViewController:awardListVC animated:YES];
    
}

#pragma mark - net

- (void)requestAwardDetail:(BOOL)isLoad
{
    if (isLoad) {
        self.progressHUD.labelText = @"加载中";
        [self.progressHUD show:YES];
    }
    
    NSString *activity_id = [NSString stringWithFormat:@"&activity_id=%@",self.activeId];
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Award_Detail_URL,key,activity_id];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestAwardDetail:result];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestAwardDetail:(NSDictionary *)result {
    NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    if ([code isEqualToString:@"1"]) {
        NSDictionary *data = result[@"data"];
        self.awardDetailModel = [SYAwardDetailModel objectWithKeyValues:data];
        
        self.titleLabel.text = self.awardDetailModel.title;
        [self.awardImgView sd_setImageWithURL:[NSURL URLWithString:self.awardDetailModel.pic] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
        //self.describeLabel.text = self.awardDetailModel.remarks; //简介，暂时隐藏
        
        NSString *code = [NSString stringWithFormat:@"%@",self.awardDetailModel.l_stats[@"code"]];
        if ([code isEqualToString:@"1"]) {
            //self.isArrowAward = YES;
            //self.isArrowMotion = YES;
        }
        else {
            //self.isArrowAward = NO;
            //self.isArrowMotion = NO;
        }
        
        if ([self.awardDetailModel.is_over isEqualToString:@"1"]) {
            self.isCheckTime = NO;
            self.overLabel.hidden = NO;
            self.timeView.hidden = YES;
            self.overLabel.text = @"活动已经结束";
        }
        else {
            if ([self.awardDetailModel.is_start isEqualToString:@"1"]) {
                self.coundownTime = self.awardDetailModel.surplus_time.integerValue/1000;
                self.overLabel.hidden = NO;
                self.timeView.hidden = YES;
                self.overLabel.text = @"活动正在进行中";
            }
            else {
                self.overLabel.hidden = YES;
                self.timeView.hidden = NO;
                self.coundownTime = self.awardDetailModel.start_countdown.integerValue/1000;
                self.beginWordLabel.text = @"开始";
            }

        }
        
        self.regularLabel.text = self.awardDetailModel.regulation;
        self.supplyNumLabel.text = self.awardDetailModel.user_all;
        
        if ([self.awardDetailModel.is_over isEqualToString:@"1"]) {
            self.isArrowAward = NO;
            self.isArrowMotion = NO;
            self.awardBtn.titleLabel.numberOfLines = 2;
            [self.awardBtn setTitle:[NSString stringWithFormat:@"活动已经结束，点击此处分享文章一边赚钱，一边赚抽奖机会"] forState:UIControlStateNormal];
        }
        else {
            if ([self.awardDetailModel.is_start isEqualToString:@"1"]) {
                if (self.awardDetailModel.l_ok.integerValue>0) {
                    [self.awardBtn setTitle:[NSString stringWithFormat:@"剩余%@次抽奖机会",self.awardDetailModel.l_ok] forState:UIControlStateNormal];
                    self.isArrowAward = YES;
                    self.isArrowMotion = YES;
                }
                else {
                    self.awardBtn.titleLabel.numberOfLines = 2;
                    [self.awardBtn setTitle:[NSString stringWithFormat:@"你已经无抽奖机会，你可以点击此处分享文章一边赚钱，一边赚抽奖机会"] forState:UIControlStateNormal];
                    self.isArrowAward = NO;
                    self.isArrowMotion = NO;
                }

            }
            else {
                self.awardBtn.titleLabel.numberOfLines = 2;
                [self.awardBtn setTitle:[NSString stringWithFormat:@"活动尚未开始,点击此处分享文章一边赚钱，一边赚抽奖机会"] forState:UIControlStateNormal];
                self.isArrowAward = NO;
                self.isArrowMotion = NO;
            }
        }
    }
    
    [self.timer setFireDate:[NSDate distantPast]];
}

//立即抽奖
- (void)requestAward
{
    [self shakeView:self.bigAwardImgView];

    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    NSString *activity_id = [NSString stringWithFormat:@"&activity_id=%@",self.activeId];
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Award_Submit_URL,key,activity_id];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestAward:result];
        [self.progressHUD hide:YES afterDelay:0];
        [LZAudioTool playMusic:@"lotter.mp3"];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestAward:(NSDictionary *)result {
    NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    if ([code isEqualToString:@"1"]) {
        NSString *is_win = [NSString stringWithFormat:@"%@",result[@"data"][@"is_win"]];
        
        if ([is_win isEqualToString:@"1"]) {
            NSString *message = result[@"data"][@"txt"];
            self.isShowTip = YES;
            [[CHTextShow sharedManager] showBtnText:message withImage:[UIImage imageNamed:@"zhongjiang.jpg"] inView:self.view delay:3];
            [[CHTextShow sharedManager] setDidClick:^{
                self.isShowTip = NO;
            }];
        }
        else {
            NSString *message = result[@"data"][@"txt"];
            self.isShowTip = YES;
            [[CHTextShow sharedManager] showBtnText:message withImage:[UIImage imageNamed:@"meizhongjiang.jpg"] inView:self.view delay:3];
            [[CHTextShow sharedManager] setDidClick:^{
                self.isShowTip = NO;
            }];
        }
    }
    else {
        NSString *message = result[@"message"];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
    
    
    [self requestAwardDetail:YES];
}

- (IBAction)awardBtnClick:(id)sender {
    if (self.isArrowAward) {
        
        if ([self.awardDetailModel.is_over isEqualToString:@"1"]) {//活动已经结束
            self.tabBarController.selectedIndex = Study_Tab;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            if ([self.awardDetailModel.is_start isEqualToString:@"1"]) {
                [self requestAward];
            }
            else {
                [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"活动尚未开始"];
            }
        }
        
    }
    else {
        self.tabBarController.selectedIndex = Study_Tab;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//timer调用函数
-(void)timerFired:(NSTimer *)timer{
    if (self.coundownTime<=0&&[self.awardDetailModel.is_over isEqualToString:@"0"]) {
        if (self.isCheckTime&&(self.coundownTime%10==0)) {
            [self requestAwardDetail:NO];
        }
        self.coundownTime--;
        return;
    }

    self.coundownTime--;
    NSInteger day = self.coundownTime/(24*60*60);
    NSInteger h = self.coundownTime%(24*60*60)/3600;
    NSInteger min = self.coundownTime%3600/60;
    NSInteger sec = self.coundownTime%60;
    
    self.dayLabel.text = [NSString stringWithFormat:@"%li",(long)day];
    self.hourLabel.text = [NSString stringWithFormat:@"%li",(long)h];
    self.minLabel.text = [NSString stringWithFormat:@"%li",(long)min];
    self.secLabel.text = [NSString stringWithFormat:@"%li",(long)sec];
}

#pragma mark motion

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ([self.awardDetailModel.is_start isEqualToString:@"0"]) {
        return;
    }
    [self shakeView:self.bigAwardImgView];
    if (!self.isArrowMotion||self.isShowTip) {
        return;
    }
    [LZAudioTool playMusic:@"yaoyiyao_voic.mp3"];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ([self.awardDetailModel.is_start isEqualToString:@"0"]) {
        return;
    }
    if (!self.isArrowMotion||self.isShowTip) {
        return;
    }
    self.isArrowMotion = NO;
    [self requestAward];
}

//抖动
-(void)shakeView:(UIView*)viewToShake
{
    CGFloat t =2.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
