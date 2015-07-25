//
//  SYActiveListViewController.m
//  MicroShop
//
//  Created by siyue on 15/6/11.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYActiveListViewController.h"
#import "SYActiveListModel.h"
#import "SYActiveListTableViewCell.h"
//#import "MJRefresh.h"
#import "UITableView+CHRefresh.h"
#import "SYAwardDetailViewController.h"
#import "SYAwardListViewController.h"

#define Scale (425.0/640.0)

@interface SYActiveListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (nonatomic)NSInteger page;
@property (assign,nonatomic) BOOL isHeadRefresh;
@property (strong,nonatomic)NSMutableArray *dataS;

@end

@implementation SYActiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"活动列表";
    self.page = 1;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.dataS = [[NSMutableArray alloc] init];
    self.page = 1;
    self.isHeadRefresh = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.tag = 100;
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    rightButton.titleLabel.numberOfLines = 2;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitle:@"领奖" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    //上啦下拉刷新
    __block SYActiveListViewController *blockSelf = self;
    [self.tableView addHeaderWithCallback:^{
        blockSelf.page = 1;
        blockSelf.isHeadRefresh = YES;
        [self requestAwardDetail];
    }];
    
    // 进入上拉加载状态就会调用这个方法
    [self.tableView addFooterWithCallback:^{
        blockSelf.isHeadRefresh = NO;
        blockSelf.page++;
        [self requestAwardDetail];
    }];

    
    [self.tableView headerBeginRefreshing];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnAction
{
    SYAwardListViewController *awardListVC = [[SYAwardListViewController alloc] init];
    [self.navigationController pushViewController:awardListVC animated:YES];
    
}

#pragma mark - net

- (void)requestAwardDetail
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *day = [NSString stringWithFormat:@"&day=%@",@"0"];
    NSString *p = [NSString stringWithFormat:@"&p=%li",(long)self.page];
    NSString *subUrl = Award_List_URL;
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,subUrl,key,p,day];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestAwardDetail:result];
        [self endRefresh];
    } error:^(NSError *error) {
        [self endRefresh];
    }];
}

- (void)didRequestAwardDetail:(NSDictionary *)result {
    if (self.isHeadRefresh) {
        [self.dataS removeAllObjects];
    }
    NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    if ([code isEqualToString:@"1"]) {
        NSString *array = result[@"data"];
        NSArray *datas = [SYActiveListModel objectArrayWithKeyValuesArray:array];
        for (SYActiveListModel *model in datas) {
            [self.dataS addObject:model];
        }
        [self.tableView reloadData];
    }
    if (self.dataS.count==0) {
        self.hintLabel.hidden = NO;
    }
    else {
        self.hintLabel.hidden = YES;
    }
}

- (void)endRefresh
{
    [self.tableView reloadData];
    //[self.tableView headerEndRefreshing];
    [self.tableView endRefreshing];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"SYAwardListTableViewCell";
    SYActiveListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYActiveListTableViewCell" owner:nil options:nil].firstObject;
        [cell setValue:cellIdentifier forKey:@"reuseIdentifier"];
    }
    if ([self.dataS count] == 0) {
        return cell;
    }
    NSInteger row = indexPath.row;
    SYActiveListModel *model = self.dataS[row];
    
    [cell.titleImgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    cell.imageHeightConstraint.constant = (ScreenWidth-10)*Scale;
    cell.titleLabel.text = model.title;
    cell.remarkLabel.text = model.remarks;
    if ([model.is_over isEqualToString:@"1"]) {
        cell.isStartLabel.text = @"活动已经结束";
    }
    else {
        if ([model.is_start isEqualToString:@"1"]) {
            cell.isStartLabel.text = @"活动正在进行";
        }
        else {
            cell.isStartLabel.text = @"活动尚未开始";
        }
    }
    
    cell.startLabel.text = [self timeToStr:model.starttime];
    cell.supplyLabel.text = model.surplus_win;
    cell.shareBtn.tag = row;
    [cell.shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 120;
    NSInteger row = indexPath.row;
    SYActiveListModel *model = self.dataS[row];
    height = height+[self heightForString:model.remarks andWidth:ScreenWidth-30 andFontsize:14];
    height = height+(ScreenWidth-10)*Scale;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    SYActiveListModel *model = self.dataS[row];
    SYAwardDetailViewController *awardDetailVC = [[SYAwardDetailViewController alloc] init];
    awardDetailVC.activeId = model.activeId;
    [self.navigationController pushViewController:awardDetailVC animated:YES];
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


- (void)shareClick:(id)sender
{
    //UIButton *button = (UIButton *)sender;
    //NSInteger row = button.tag;
    
    self.tabBarController.selectedIndex = Study_Tab;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
