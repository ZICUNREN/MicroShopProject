//
//  SYAwardListViewController.m
//  MicroShop
//
//  Created by siyue on 15/6/8.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYAwardListViewController.h"
//#import "MJRefresh.h"
#import "UITableView+CHRefresh.h"
#import "SYAwardListTableViewCell.h"
#import "SYActivityAwardListModel.h"
#import "SYDoneAardDetailViewController.h"
#import "SYWinAwardDetailViewController.h"

@interface SYAwardListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray *dataS;
@property (assign,nonatomic)NSInteger currentPage;
@property (assign,nonatomic) BOOL isHeadRefresh;
@property (strong,nonatomic)NSMutableDictionary *offscreenCells;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation SYAwardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"奖品列表";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.offscreenCells = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = [UIColor colorWithWhite:0.959 alpha:1.000];
     self.tableView.backgroundColor = [UIColor colorWithWhite:0.959 alpha:1.000];

    self.dataS = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.isHeadRefresh = YES;
    
    //上啦下拉刷新
    __block SYAwardListViewController *blockSelf = self;
    
    [self.tableView addHeaderWithCallback:^{
        blockSelf.currentPage = 1;
        blockSelf.isHeadRefresh = YES;
        [self requestAwardRecord];
    }];
    
    // 进入上拉加载状态就会调用这个方法
    [self.tableView addFooterWithCallback:^{
        blockSelf.isHeadRefresh = NO;
        blockSelf.currentPage++;
        [self requestAwardRecord];
    }];
    
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - net

- (void)requestAwardRecord
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *page = [NSString stringWithFormat:@"&p=%li",(long)self.currentPage];
    NSString *is_win = [NSString stringWithFormat:@"&is_win=%@",@"1"];
    
    NSString *subUrl = Award_Record_List;
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,subUrl,key,page,is_win];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestAwardRecord:result];
        [self endRefresh];
    } error:^(NSError *error) {
        [self endRefresh];
    }];
}

- (void)didRequestAwardRecord:(NSDictionary *)result {
    if (self.isHeadRefresh) {
        [self.dataS removeAllObjects];
    }
    NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    if ([code isEqualToString:@"1"]) {
        NSArray *array = result[@"data"];
        NSArray *datas = [SYActivityAwardListModel objectArrayWithKeyValuesArray:array];
        for (SYActivityAwardListModel *model in datas) {
            [self.dataS addObject:model];
        }
        if (self.dataS.count==0) {
            self.hintLabel.hidden = NO;
        }
        else {
            self.hintLabel.hidden = YES;
        }
    }
}

- (void)endRefresh
{
    [self.tableView reloadData];
    //[self.tableView headerEndRefreshing];
    //[self.tableView footerEndRefreshing];
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
    SYAwardListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYAwardListTableViewCell" owner:nil options:nil].firstObject;
        [cell setValue:cellIdentifier forKey:@"reuseIdentifier"];
    }
    if ([self.dataS count] == 0) {
        return cell;
    }
    NSInteger row = indexPath.row;
   
    SYActivityAwardListModel *model = self.dataS[row];
    
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.activity.pic] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    cell.titleLabel.text = model.activity.title;
    //cell.describLabel.text = model.activity.remarks;
    cell.timeLabel.text = [self timeToStr:model.inputtime];
    if ([model.is_getaward isEqualToString:@"1"]) {
        cell.isHaveGetLabel.text = @"已领取";
    }
    else {
        cell.isHaveGetLabel.text = @"未领取";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 56;
    NSInteger row = indexPath.row;
    
    SYActivityAwardListModel *model = self.dataS[row];
    
    height = height+[self heightForString:model.activity.title andWidth:ScreenWidth-150 andFontsize:14];
    //height = height+[self heightForString:model.activity.remarks andWidth:ScreenWidth-150 andFontsize:12];
    
    if (height<110) {
        height = 110;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    SYActivityAwardListModel *model = self.dataS[row];
    
    if ([model.is_getaward isEqualToString:@"1"]) {
        SYDoneAardDetailViewController *doneAwardDetailVC = [[SYDoneAardDetailViewController alloc] init];
        doneAwardDetailVC.record_id = model.award_id;
        [self.navigationController pushViewController:doneAwardDetailVC animated:YES];
    }
    else {
        SYWinAwardDetailViewController *winAwardDetailVC = [[SYWinAwardDetailViewController alloc] init];
        winAwardDetailVC.record_id = model.award_id;
        [self.navigationController pushViewController:winAwardDetailVC animated:YES];
        [winAwardDetailVC setDidAddPrice:^{
            [self requestAwardRecord];
        }];
    }
}

#pragma mark - 其他
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



@end
