//
//  SYSelfGoodViewController.m
//  MicroShop
//
//  Created by siyue on 15/7/16.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYSelfGoodViewController.h"
#import "CHTabScrollView.h"
#import "SYSelfGoodListViewController.h"

@interface SYSelfGoodViewController ()

@end

@implementation SYSelfGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"自营商品";
    self.automaticallyAdjustsScrollViewInsets = NO;//避免tableview自动下移
    [self initTabScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabScrollView
{
    CGFloat y = 64;
    CHTabScrollView *tabScrollView = [[CHTabScrollView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight-y) withHeadLeftSpace:ScreenWidth/3];
    [self.view addSubview:tabScrollView];
    tabScrollView.headBackColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    tabScrollView.fontColor = [UIColor colorWithWhite:0.263 alpha:1.000];
    
    NSArray *headList = @[@"在售商品",@"已下架商品"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelfGood" bundle:nil];
    
    //全部
    SYSelfGoodListViewController *orderListVC = [storyboard instantiateViewControllerWithIdentifier:@"SelfGoodListViewController"];
    orderListVC.state = @"1";
    [self addChildViewController:orderListVC];
    UIView *firstView = orderListVC.view;
    
    //下架
    SYSelfGoodListViewController *waitPayOrderListVC = [storyboard instantiateViewControllerWithIdentifier:@"SelfGoodListViewController"];
    waitPayOrderListVC.state = @"0";
    [self addChildViewController:waitPayOrderListVC];
    UIView *secondView = waitPayOrderListVC.view;
    
    NSArray *viewList = [NSArray arrayWithObjects:firstView,secondView,nil];
    tabScrollView.headNum = 2;
    tabScrollView.headNameList = [NSMutableArray arrayWithArray:headList];
    tabScrollView.viewList = [NSMutableArray arrayWithArray:viewList];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*2/3, 0, ScreenWidth/3, 44)];
    [button setTitle:@"分类" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.263 alpha:1.000] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [tabScrollView addSubview:button];
}


@end
