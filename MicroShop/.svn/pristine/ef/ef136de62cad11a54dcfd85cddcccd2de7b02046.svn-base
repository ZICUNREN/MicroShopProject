//
//  SYMyOrderViewController.m
//  MicroShop
//
//  Created by siyue on 15/7/15.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYMyOrderViewController.h"
#import "CHTabScrollView.h"
#import "SYOrderListViewController.h"

@interface SYMyOrderViewController ()

@end

@implementation SYMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;//避免tableview自动下移
    [self initTabScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - init

- (void)initTabScrollView
{
    CGFloat y = 64;
    CHTabScrollView *tabScrollView = [[CHTabScrollView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight-y)];
    [self.view addSubview:tabScrollView];
    tabScrollView.headBackColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    tabScrollView.fontColor = [UIColor colorWithWhite:0.263 alpha:1.000];
    
    NSArray *headList = @[@"全部",@"待付款",@"待发货",@"待评论"];
    
    //全部
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderMaster" bundle:nil];
    SYOrderListViewController *orderListVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    orderListVC.isMySelf = YES;
    orderListVC.type = 0;
    [self addChildViewController:orderListVC];
    UIView *firstView = orderListVC.view;
    
    //待付款
    SYOrderListViewController *waitPayOrderListVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    [self addChildViewController:waitPayOrderListVC];
    UIView *secondView = waitPayOrderListVC.view;
    
    //待发货
    SYOrderListViewController *waitSendOrderListVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    [self addChildViewController:waitSendOrderListVC];
    UIView *thirdView = waitSendOrderListVC.view;
    
    //待评论
    SYOrderListViewController *waitComOrderListVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    [self addChildViewController:waitComOrderListVC];
    UIView *fourView = waitComOrderListVC.view;
    
    NSArray *viewList = [NSArray arrayWithObjects:firstView,secondView,thirdView,fourView,nil];
     tabScrollView.headNum = 4;
    tabScrollView.headNameList = [NSMutableArray arrayWithArray:headList];
    tabScrollView.viewList = [NSMutableArray arrayWithArray:viewList];
}

@end
