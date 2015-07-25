//
//  SYSpreadViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYSpreadViewController.h"
#import "CHTabScrollView.h"
#import "SYAllDynamicViewController.h"

@interface SYSpreadViewController ()

@end

@implementation SYSpreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"动态";

    [self initTabScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)initTabScrollView
{
    CGFloat y = 64;
    CHTabScrollView *tabScrollView = [[CHTabScrollView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight-y-50)];
    [self.view addSubview:tabScrollView];
    tabScrollView.headBackColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    tabScrollView.fontColor = [UIColor colorWithWhite:0.263 alpha:1.000];
    
    NSArray *headList = @[@"全部动态",@"热门动态",@"我的代销"];
    
    //全部动态
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Spread" bundle:nil];
    SYAllDynamicViewController *allDynamicVC = [storyboard instantiateViewControllerWithIdentifier:@"allDynamicVC"];
    allDynamicVC.type = @"1";
    [self addChildViewController:allDynamicVC];
    UIView *firstView = allDynamicVC.view;
    
    //热门动态
    SYAllDynamicViewController *hotDynamicVC = [storyboard instantiateViewControllerWithIdentifier:@"allDynamicVC"];
    hotDynamicVC.type = @"2";
    [self addChildViewController:hotDynamicVC];
    UIView *secondView = hotDynamicVC.view;
    
    //我的代销
    SYAllDynamicViewController *myDaixiaoVC = [storyboard instantiateViewControllerWithIdentifier:@"allDynamicVC"];
    myDaixiaoVC.type = @"3";
    [self addChildViewController:myDaixiaoVC];
    UIView *thirdView = myDaixiaoVC.view;
    
    NSArray *viewList = [NSArray arrayWithObjects:firstView,secondView,thirdView, nil];
    tabScrollView.headNum = 3;
    tabScrollView.headNameList = [NSMutableArray arrayWithArray:headList];
    tabScrollView.viewList = [NSMutableArray arrayWithArray:viewList];
}

#pragma mark - net

- (void)requestStudyList
{
    /*NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *page = [NSString stringWithFormat:@"&p=%i",self.currentPage];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Study_List,key,page];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestStudyList:result];
        [self endRefresh];
    } error:^(NSError *error) {
        [self endRefresh];
    }];*/
}

- (void)didRequestStudyList:(NSDictionary *)result {
    /*if (self.isHeadRefresh) {
        [self.dataS removeAllObjects];
        self.isHeadRefresh = NO;
    }*/
    
    if ([result[@"code"] integerValue]==1) {
        NSArray *dataS = result[@"data"];
        for (NSDictionary *data in dataS) {
            /*SYStudyModel *studyModel = [[SYStudyModel alloc] init];
            studyModel.imgURL = [NSString stringWithFormat: @"%@",data[@"article_image"]];
            studyModel.userName = [NSString stringWithFormat: @"%@",data[@"article_title"]];
            studyModel.commentNum = [NSString stringWithFormat: @"%@",data[@"comment_count"]];
            studyModel.timeStr = [NSString stringWithFormat: @"%@",data[@"inputtime"]];
            [self.dataS addObject:studyModel];*/
        }
    }
    //[self.tableView reloadData];
}

- (void)endRefresh
{
    //[self.tableView reloadData];
    //[self.tableView headerEndRefreshing];
    //[self.tableView footerEndRefreshing];
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
