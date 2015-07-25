//
//  SYDoneAardDetailViewController.m
//  MicroShop
//
//  Created by siyue on 15/6/10.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYDoneAardDetailViewController.h"
#import "SYDoneAwardModel.h"

@interface SYDoneAardDetailViewController ()

@property (strong,nonatomic)SYDoneAwardModel *doneAwardModel;
@property (weak, nonatomic) IBOutlet UILabel *checkStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;

@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYDoneAardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"领奖详情";
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    
    [self requestAwardDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - net

- (void)requestAwardDetail
{
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    
    NSString *record_id = [NSString stringWithFormat:@"&record_id=%@",self.record_id];
    
    NSString *subUrl = Award_Done_Detail;
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,subUrl,key,record_id];
    
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
        self.doneAwardModel = [SYDoneAwardModel objectWithKeyValues:data];
        
        self.checkStateLabel.text = self.doneAwardModel.a_state_txt;
        self.consigneeLabel.text = self.doneAwardModel.name;
        self.phoneLabel.text = self.doneAwardModel.tel;
        self.addressLabel.text = self.doneAwardModel.address;
        self.inputTimeLabel.text = [self timeToStr:self.doneAwardModel.create_time];//领奖
        self.getTimeLabel.text = [self timeToStr:self.doneAwardModel.inputtime];//抽奖
        self.expressLabel.text = self.doneAwardModel.express_name;
        self.expressNumLabel.text = self.doneAwardModel.express_id;
        self.postNumLabel.text = self.doneAwardModel.postcode;
    }

}

- (NSString *)timeToStr:(NSString *)time
{
    //NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time.integerValue];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

@end
