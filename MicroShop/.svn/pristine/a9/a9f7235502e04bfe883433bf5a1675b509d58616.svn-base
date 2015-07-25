//
//  SYWinAwardDetailViewController.m
//  MicroShop
//
//  Created by siyue on 15/6/9.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYWinAwardDetailViewController.h"
#import "SYWinAwardDetailHeadTableViewCell.h"
#import "SYWinAddressModel.h"
#import "SYActivityAwardListModel.h"
#import "SYWinAwardDetailTableViewCell.h"
#import "SYActiveHtmlViewController.h"
#import "SYGettingWebURLData.h"

@interface SYWinAwardDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@property (strong,nonatomic)NSArray *addressArray;
@property (strong,nonatomic)SYActivityAwardListModel *activityAwardListModel;
@property (strong,nonatomic)NSString *add_URL;

@property (nonatomic)NSInteger selectAddress;

@end

@implementation SYWinAwardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"领取奖品";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.selectAddress = 0;
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    
    [self initHeadView];
    [self initFootView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
    
    NSString *subUrl = Award_Win_Detail;
    
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
        NSArray *addressArray = result[@"data"][@"address"];
        NSDictionary *data = result[@"data"][@"info"];
        self.add_URL = result[@"data"][@"add_url"];
        self.activityAwardListModel = [SYActivityAwardListModel objectWithKeyValues:data];
        self.addressArray = [SYWinAddressModel objectArrayWithKeyValuesArray:addressArray];
    }
    
    [self initHeadView];
    [self.tableView reloadData];
}

- (void)requestAddPrice
{
    self.progressHUD.labelText = @"领取中";
    [self.progressHUD show:YES];
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *record_id = [NSString stringWithFormat:@"&record_id=%@",self.record_id];
    NSString *subUrl = Award_Add_Price;
    NSString *address_id = @"";
    if (self.addressArray.count>self.selectAddress) {
        SYWinAddressModel *addressModel = self.addressArray[self.selectAddress];
        address_id = [NSString stringWithFormat:@"&address_id=%@",addressModel.address_id];
    }
    if ([address_id isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"尚未选择收货地址"];
        [self.progressHUD hide:YES afterDelay:0];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,subUrl,key,record_id,address_id];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestAddPrice:result];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestAddPrice:(NSDictionary *)result {
    NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    if ([code isEqualToString:@"1"]) {
        NSString *message = result[@"message"];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.didAddPrice!=nil) {
            self.didAddPrice();
        }
    }
}


- (void)initHeadView
{
    SYWinAwardDetailHeadTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SYWinAwardDetailHeadTableViewCell" owner:nil options:nil].lastObject;
    UIView *headView = cell.contentView;
    
    CGFloat height = 100;
    
    cell.activeLabel.text = self.activityAwardListModel.activity.title;
    cell.detailLabel.text = self.activityAwardListModel.activity.remarks;
    cell.regularLabel.text = self.activityAwardListModel.activity.regulation;
    
    NSString *addressName = @"尚未选择地址";
    if (self.addressArray.count>self.selectAddress) {
        SYWinAddressModel *addressModel = self.addressArray[self.selectAddress];
        addressName = addressModel.address;
    }
    cell.selectedAddressLabel.text = addressName;
    
    [cell.getAardBtn addTarget:self action:@selector(addPrice:) forControlEvents:UIControlEventTouchUpInside];
    
    height = height+[self heightForString:self.activityAwardListModel.activity.title andWidth:ScreenWidth-62 andFontsize:14];
    height = height+[self heightForString:self.activityAwardListModel.activity.remarks andWidth:ScreenWidth-62 andFontsize:14];
    height = height+[self heightForString:self.activityAwardListModel.activity.regulation andWidth:ScreenWidth-62 andFontsize:14];
    height = height+[self heightForString:addressName andWidth:ScreenWidth-62 andFontsize:14];
    
    CGRect frame = headView.frame;
    frame.size.height = height;
    headView.frame = frame;
    
    
    self.tableView.tableHeaderView = headView;
}

- (void)initFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 44)];
    [button addTarget:self action:@selector(addressMaster:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"地址管理" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:button];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addressArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"SYAwardListTableViewCell";
    SYWinAwardDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYWinAwardDetailTableViewCell" owner:nil options:nil].firstObject;
        [cell setValue:cellIdentifier forKey:@"reuseIdentifier"];
    }
    if ([self.addressArray count] == 0) {
        return cell;
    }
    NSInteger row = indexPath.row;
    SYWinAddressModel *model = self.addressArray[row];
    cell.considerneeLabel.text = model.name;
    cell.phoneLabel.text = model.tel;
    cell.addressLabel.text = model.address;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 10;
    NSInteger row = indexPath.row;
    
    SYWinAddressModel *model = self.addressArray[row];
    
    height = height+[self heightForString:model.name andWidth:ScreenWidth-80 andFontsize:14];
    height = height+[self heightForString:model.tel andWidth:ScreenWidth-90 andFontsize:14];
    height = height+[self heightForString:model.address andWidth:ScreenWidth-90 andFontsize:14];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    self.selectAddress = row;
    [self initHeadView];
}

/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(NSString *)text andWidth:(float)width andFontsize:(CGFloat)fontsize
{
    UITextView *textView = [[UITextView alloc] init];
    textView.text = text;
    //textView.font = [UIFont systemFontOfSize:fontsize];
    textView.font = [UIFont boldSystemFontOfSize:fontsize];
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

#pragma mark - Click

- (void)addressMaster:(id)sender
{
    if (self.add_URL!=nil) {
        SYActiveHtmlViewController *generalHtmlVC = [[SYActiveHtmlViewController alloc] init];
        NSString *url = self.add_URL;
        generalHtmlVC.url = url;
        generalHtmlVC.navTitle = @"收货地址";
        [self.navigationController pushViewController:generalHtmlVC animated:YES];
    }

}

- (void)addPrice:(id)sender
{
    [self requestAddPrice];
}

@end
