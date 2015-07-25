//
//  SYSelfGoodListViewController.m
//  MicroShop
//
//  Created by siyue on 15/7/16.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYSelfGoodListViewController.h"
#import "SYGoodClassModel.h"
#import "SYZYGoodInfoModel.h"
#import "SYSelfGoodListTableViewCell.h"
#import "MJRefresh.h"

@interface SYSelfGoodListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)shareClick:(id)sender;
- (IBAction)editClick:(id)sender;
- (IBAction)soldOutClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (nonatomic)NSInteger page;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标
@property (assign,nonatomic) BOOL isHeadRefresh;

@property (strong,nonatomic)NSMutableArray *goods_list;
@property (strong,nonatomic)NSArray *class_list;

@end

@implementation SYSelfGoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.isHeadRefresh = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    self.goodclass = @"0";
    self.goods_list = [[NSMutableArray alloc] init];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.progressHUD = [[MBProgressHUD alloc] initWithView:window];
    [self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    //上啦下拉刷新
    __block SYSelfGoodListViewController *blockSelf = self;
    [self.tableView addHeaderWithCallback:^{
        blockSelf.page = 1;
        blockSelf.isHeadRefresh = YES;
        [blockSelf requestGoodList];
    }];
    
    // 进入上拉加载状态就会调用这个方法
    [self.tableView addFooterWithCallback:^{
        blockSelf.isHeadRefresh = NO;
        blockSelf.page++;
        [blockSelf requestGoodList];
    }];

    [self requestGoodList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestGoodList
{
    NSString *authcode= [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *page = [NSString stringWithFormat:@"&p=%li",(long)self.page];
    NSString *goodclass = [NSString stringWithFormat:@"&class=%@",self.goodclass];
    NSString *state = [NSString stringWithFormat:@"&state=%@",self.state];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@",HomeURL,MySelf_Good_List,authcode,page,goodclass,state];
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestGoodList:result];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0];
        [self.tableView endRefreshing];
    }];
}

- (void)didRequestGoodList:(NSDictionary *)result
{
    [self.tableView endRefreshing];
    if (self.isHeadRefresh) {
        [self.goods_list removeAllObjects];
        self.isHeadRefresh = NO;
    }
    
    NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
    if ([code isEqualToString:@"1"]) {
        NSDictionary *goods_dic = result[@"goods_list"];
        NSDictionary *class_dic = result[@"class_list"];
        self.class_list = [SYGoodClassModel objectArrayWithKeyValuesArray:class_dic];
        NSArray *goods_list = [SYZYGoodInfoModel objectArrayWithKeyValuesArray:goods_dic];
        if ([goods_list isKindOfClass:[NSNull class]]||goods_list.count<=0) {//如果当前页数据为空，则回到上一页
            if (self.page>1) {
                self.page--;
            }
            [self.tableView loadAll];
            return;
        }
        for (SYZYGoodInfoModel *model in goods_list) {
            [self.goods_list addObject:model];
        }
    }
    else {
        
    }
    [self.tableView reloadData];
}

#pragma tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goods_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYSelfGoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodListTableViewCell"];
    NSInteger row = indexPath.row;
    SYZYGoodInfoModel *model = self.goods_list[row];
    cell.goodNameLabel.text = model.goods_name;
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    cell.priceLabel.text = model.goods_price;
    cell.saleNumLabel.text = model.goods_sales;
    cell.stockLabel.text = model.goods_storages;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)shareClick:(id)sender {
}

- (IBAction)editClick:(id)sender {
}

- (IBAction)soldOutClick:(id)sender {
}
@end
