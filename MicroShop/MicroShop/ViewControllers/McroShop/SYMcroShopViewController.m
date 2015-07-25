//
//  SYMcroShopViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYMcroShopViewController.h"
#import "SYMcroShopModel.h"
#import "CHLayout.h"
//#import "MJRefresh.h"
#import "UIScrollView+CHRefresh.h"
#import "SYGettingWebURLData.h"
#import "SYGeneralHtmlViewController.h"
#import "SYMcroEditStoreViewController.h"
#import "SYMicroAddGoodsViewController.h"
#import "SYMyOrderViewController.h"
#import "SYSelfGoodViewController.h"

@interface SYMcroShopViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ziyingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *daixiaoNumLabel;
@property (weak, nonatomic) IBOutlet UIView *nearBackView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)storeListClick:(id)sender;
- (IBAction)editStoreClick:(id)sender;
- (IBAction)sortClick:(id)sender;
- (IBAction)statisticsClick:(id)sender;
- (IBAction)storeSpreadClick:(id)sender;
- (IBAction)detialClick:(id)sender;
- (IBAction)zyAddGoodClick:(id)sender;
- (IBAction)zyGoodClick:(id)sender;
- (IBAction)zyOrderClick:(id)sender;
- (IBAction)dxAddGoodClick:(id)sender;
- (IBAction)dxGoodClick:(id)sender;
- (IBAction)dxOrderClick:(id)sender;

@property (strong,nonatomic)SYMcroShopModel *mcroShopModel;
@property (strong,nonatomic)SYWebURLModel *webURLModel;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYMcroShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的乐享";
    [self initView];
    self.webURLModel = [[SYWebURLModel alloc] init];
    self.webURLModel = [[SYGettingWebURLData sharedManager] getWebURLData];
    
    self.mcroShopModel = [[SYMcroShopModel alloc] init];
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    //上啦下拉刷新
    __block SYMcroShopViewController *blockSelf = self;
    [self.scrollView addHeaderWithCallback:^{
        [blockSelf requestMicroIndex];
    }];
    [self requestMicroIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)initView
{
    CHLayout *layout = [CHLayout sharedManager];
    [layout drawDashLineIn:self.nearBackView withRect:CGRectMake(10, self.nearBackView.frame.size.height-1, ScreenWidth-20, 1) withColor:[UIColor colorWithWhite:0.941 alpha:1.000] withSolidWidth:3 withHollowWidth:3];
    
    [layout setView:self.imageView withCornerRadius:3];
}

#pragma mark - net

- (void)requestMicroIndex
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,Micro_Index,key];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestMicroIndex:result];
        [self endRefresh];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self endRefresh];
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestMicroIndex:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            self.mcroShopModel.imgURL = [NSString stringWithFormat:@"%@",result[@"data"][@"store_label"]];
            self.mcroShopModel.storeName = [NSString stringWithFormat:@"%@",result[@"data"][@"store_name"]];
            self.mcroShopModel.income = [NSString stringWithFormat:@"%@",result[@"data"][@"income"]];
            self.mcroShopModel.ziyingNum = [NSString stringWithFormat:@"%@",result[@"data"][@"my_count"]];
            self.mcroShopModel.daixiaoNum = [NSString stringWithFormat:@"%@",result[@"data"][@"sell_count"]];
            self.mcroShopModel.shopId = [NSString stringWithFormat:@"%@",result[@"data"][@"shop_id"]];
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.mcroShopModel.imgURL] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
            self.storeNameLabel.text = self.mcroShopModel.storeName;
            self.incomeLabel.text = self.mcroShopModel.income;
            self.ziyingNumLabel.text = self.mcroShopModel.ziyingNum;
            self.daixiaoNumLabel.text = self.mcroShopModel.daixiaoNum;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
}

- (void)endRefresh
{
    [self.scrollView endRefreshing];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)storeListClick:(id)sender {//预览店铺
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@",self.webURLModel.micro_shopIndex_URL,self.mcroShopModel.shopId];
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"店铺详情";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

- (IBAction)editStoreClick:(id)sender {//编辑店铺
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"McroShop" bundle:nil];
    SYMcroEditStoreViewController *mcroEditStoreVC = [storyboard instantiateViewControllerWithIdentifier:@"mcroEditStoreVC"];
    mcroEditStoreVC.store_id = self.mcroShopModel.shopId;
    mcroEditStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mcroEditStoreVC animated:YES];
}

- (IBAction)sortClick:(id)sender {//商品分类
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.micro_goodsClass_URL;
    generalHtmlVC.url = url;
     generalHtmlVC.navTitle = @"商品分类";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

- (IBAction)statisticsClick:(id)sender {//店铺统计
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.micro_statistics_URL;
    generalHtmlVC.url = url;
     generalHtmlVC.navTitle = @"店铺统计";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

- (IBAction)storeSpreadClick:(id)sender {//店铺推广
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.micro_spread_URL;
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"店铺推广";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

- (IBAction)detialClick:(id)sender {//收入明细
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.micro_income_URL;
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"收入明细";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

- (IBAction)zyAddGoodClick:(id)sender {//添加商品
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"McroShop" bundle:nil];
    SYMicroAddGoodsViewController *microAddGoodsVC = [storyboard instantiateViewControllerWithIdentifier:@"microAddGoodsVC"];
    microAddGoodsVC.type = 0;
    microAddGoodsVC.subURL = Micro_Add_SelfGood;
    microAddGoodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:microAddGoodsVC animated:YES];
}

- (IBAction)zyGoodClick:(id)sender {//自营商品
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.micro_mySelf_URL;
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"自营商品";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];*/
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelfGood" bundle:nil];
    SYSelfGoodViewController *sselfGoodViewController = [storyboard instantiateViewControllerWithIdentifier:@"SelfGoodViewController"];
    sselfGoodViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sselfGoodViewController animated:YES];
}

- (IBAction)zyOrderClick:(id)sender {//自营订单
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.micro_orderSelf_URL;
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"自营订单";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
    
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderMaster" bundle:nil];
    SYMyOrderViewController *myOrderVC = [storyboard instantiateViewControllerWithIdentifier:@"MyOrderViewController"];
    myOrderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myOrderVC animated:YES];*/
}

- (IBAction)dxAddGoodClick:(id)sender {//新增代销订单
    self.tabBarController.selectedIndex = 1;
}

- (IBAction)dxGoodClick:(id)sender {//代销商品
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.micro_sellGoods_URL;
    generalHtmlVC.url = url;
     generalHtmlVC.navTitle = @"代销商品";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

- (IBAction)dxOrderClick:(id)sender {//代销订单
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.micro_orderIndex_URL;
    generalHtmlVC.url = url;
     generalHtmlVC.navTitle = @"代销订单";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}
@end
