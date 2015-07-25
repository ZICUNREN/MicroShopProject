//
//  SYSupplyViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYSupplyViewController.h"
#import "SYSupplyBrandTableViewCell.h"
#import "SYSupplyModel.h"
#import "CHLayout.h"
//#import "MJRefresh.h"
#import "UITableView+CHRefresh.h"
#import "SYGeneralHtmlViewController.h"
#import "SYSupplyHeadTableViewCell.h"
#import "SYGettingWebURLData.h"

#define CellHeight 200;
#define headHeight 64;

@interface SYSupplyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray *dataS;
@property (nonatomic,assign)NSInteger currentPage;
@property (assign,nonatomic) BOOL isHeadRefresh;
@property (strong,nonatomic)SYWebURLModel *webURLModel;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"货源市场";
    
    self.webURLModel = [[SYWebURLModel alloc] init];
    self.webURLModel = [[SYGettingWebURLData sharedManager] getWebURLData];
    
    [self initView];
    [self initHead];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.dataS = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.isHeadRefresh = YES;
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];

    
    //上啦下拉刷新
    __block SYSupplyViewController *blockSelf = self;
    [self.tableView addHeaderWithCallback:^{
        blockSelf.currentPage = 1;
        blockSelf.isHeadRefresh = YES;
        [blockSelf requestBrandStore];
    }];
    
    // 进入上拉加载状态就会调用这个方法
    [self.tableView addFooterWithCallback:^{
        blockSelf.currentPage++;
        [blockSelf requestBrandStore];
    }];

    [self requestBrandStore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- init

- (void)initView
{
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
}

- (void)initHead
{
    CHLayout *layout = [CHLayout sharedManager];
    SYSupplyHeadTableViewCell *supplyHeadTableView = [[NSBundle mainBundle] loadNibNamed:@"SYSupplyHeadTableViewCell" owner:nil options:nil].firstObject;
    [layout setView:supplyHeadTableView.brandView withCornerRadius:3];
    [layout setView:supplyHeadTableView.productView withCornerRadius:3];
    [supplyHeadTableView.brandBtn addTarget:self action:@selector(brandClick:) forControlEvents:UIControlEventTouchUpInside];
    [supplyHeadTableView.productBtn addTarget:self action:@selector(productClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *headView = supplyHeadTableView.contentView;
    self.tableView.tableHeaderView = headView;
}

#pragma mark - net

- (void)requestBrandStore
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *page = [NSString stringWithFormat:@"&p=%li",(long)self.currentPage];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Supply_URL,key,page];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestBrandStore:result];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self endRefresh];
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestBrandStore:(NSDictionary *)result {
    [self endRefresh];
    if (self.isHeadRefresh) {
        [self.dataS removeAllObjects];
        self.isHeadRefresh = NO;
    }
    
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSArray *dataS = result[@"data"];
            if ([dataS isKindOfClass:[NSNull class]]) {//如果当前页数据为空，则回到上一页
                if (self.currentPage>1) {
                    self.currentPage--;
                }
                [self.tableView loadAll];
                return;
            }
            for (NSDictionary *data in dataS) {
                SYSupplyModel *supplyModel = [[SYSupplyModel alloc] init];
                supplyModel.imgURL = [NSString stringWithFormat: @"%@",data[@"store_banner"]];
                supplyModel.storeName = [NSString stringWithFormat: @"%@",data[@"store_name"]];
                supplyModel.sellNum = [NSString stringWithFormat: @"%@",data[@"store_sell_count"]];
                supplyModel.storeId = [NSString stringWithFormat: @"%@",data[@"id"]];
                [self.dataS addObject:supplyModel];
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    [self.tableView reloadData];
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"tableViewCellIdentify";
    SYSupplyBrandTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYSupplyBrandTableViewCell" owner:nil options:nil].firstObject;
    }
    if ([self.dataS count] == 0) {
        return cell;
    }
    NSInteger row = indexPath.row;
    
    cell.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    cell.storeNameLabel.text = [self.dataS[row] storeName];
    cell.sellNumLabel.text = [self.dataS[row] sellNum];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[self.dataS[row] imgURL]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    SYSupplyModel *supplyModel = self.dataS[row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *storeId = [NSString stringWithFormat:@"&id=%@",supplyModel.storeId];
    NSString *url = [NSString stringWithFormat:@"%@%@",self.webURLModel.supply_brand_List,storeId];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = supplyModel.storeName;
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

- (void)endRefresh
{
    [self.tableView endRefreshing];
    //[self.tableView footerEndRefreshing];
}

#pragma mark - CLick

- (void)brandClick:(id)sender
{

}

- (void)productClick:(id)sender
{
    /*NSString *url = [NSString stringWithFormat:@"%@",self.webURLModel.supply_By_product];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"货源市场";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];*/
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GoodsSource" bundle:nil];
    GoodsViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"goodsView"];
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
