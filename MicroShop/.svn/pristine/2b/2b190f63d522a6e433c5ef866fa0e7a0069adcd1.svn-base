//
//  SYStudyViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYStudyViewController.h"
#import "SYStudyTableViewCell.h"
#import "BaseModel.h"
//#import "MJRefresh.h"
#import "UITableView+CHRefresh.h"
#import "SYStudyModel.h"
#import "SYStudyDetialViewController.h"
#import "CHTabScrollView.h"
#import "SYStudyClassModel.h"
#import "SYStudyListViewController.h"

#define CellHeight 100

@interface SYStudyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标
@property (strong,nonatomic)NSMutableArray *dataS;
@property (assign,nonatomic)NSInteger currentPage;
@property (assign,nonatomic) BOOL isHeadRefresh;
@property (strong,nonatomic)NSMutableArray *articleClassList;
@end

@implementation SYStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.studyListURl==nil) {
        self.navigationItem.title = @"文章推广";
    }
    else {
        self.navigationItem.title = @"微店学院";
    }
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.clipsToBounds = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1.000];
    
    self.dataS = [[NSMutableArray alloc] init];
    self.articleClassList = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.isHeadRefresh = YES;
    
    //上啦下拉刷新
    __block SYStudyViewController *blockSelf = self;
    [self.tableView addHeaderWithCallback:^{
        blockSelf.currentPage = 1;
        blockSelf.isHeadRefresh = YES;
        [blockSelf requestStudyClass];
    }];
    
    // 进入上拉加载状态就会调用这个方法
    [self.tableView addFooterWithCallback:^{
        blockSelf.currentPage++;
        [blockSelf requestStudyClass];
    }];
    [self requestStudyClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabScrollView
{
    NSMutableArray *headList = [[NSMutableArray alloc] init];
    NSMutableArray *viewList = [[NSMutableArray alloc] init];
    
    CGFloat h = 114;
    if (self.studyListURl!=nil) {
        h = 64;
    }
    CHTabScrollView *tabScrollView = [[CHTabScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-h)];
    [self.view addSubview:tabScrollView];
    tabScrollView.headBackColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    tabScrollView.fontColor = [UIColor colorWithWhite:0.263 alpha:1.000];
    for (SYStudyClassModel *studyClassModel in self.articleClassList) {
        [headList addObject:studyClassModel.class_name];
    }
    
    for (NSInteger i=0; i<headList.count; i++) {
        SYStudyClassModel *studyClassModel = self.articleClassList[i];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Study" bundle:nil];
        SYStudyListViewController *studyListVC = [storyboard instantiateViewControllerWithIdentifier:@"studyListVC"];
        studyListVC.ac_id = studyClassModel.ac_id;
        if (self.studyListURl!=nil) {
            studyListVC.studyListURl = self.studyListURl;
        }
        [self addChildViewController:studyListVC];
        UIView *view = studyListVC.view;
        [viewList addObject:view];
    }
    
    tabScrollView.headNameList = headList;
    tabScrollView.viewList = viewList;
}

#pragma mark - net

- (void)requestStudyClass
{
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *page = [NSString stringWithFormat:@"&p=%li",(long)self.currentPage];
    
    NSString *subUrl = Study_List;
    if (self.studyListURl!=nil) {
        subUrl = self.studyListURl;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,subUrl,key,page];
    
    [[NetworkInterface shareInstance] requestCacheFirstForGet:url complete:^(NSDictionary *result) {
        [self didRequestStudyClass:result];
        [self endRefresh];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self endRefresh];
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestStudyClass:(NSDictionary *)result {
    if (self.isHeadRefresh) {
        [self.dataS removeAllObjects];
        self.isHeadRefresh = NO;
    }
    
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSArray *class_list = result[@"data"][@"class_list"];
            for (NSDictionary *class in class_list) {
                SYStudyClassModel *studyClassModel = [[SYStudyClassModel alloc] init];
                studyClassModel.ac_id = [NSString stringWithFormat:@"%@",class[@"ac_id"]];
                studyClassModel.class_name = [NSString stringWithFormat:@"%@",class[@"class_name"]];
                [self.articleClassList addObject:studyClassModel];
            }
            [self initTabScrollView];
            /*NSArray *dataS = result[@"data"];
             if ([dataS isKindOfClass:[NSNull class]]) {//如果当前页数据为空，则回到上一页
             if (self.currentPage>1) {
             self.currentPage--;
             }
             return;
             }
             for (NSDictionary *data in dataS) {
             SYStudyModel *studyModel = [[SYStudyModel alloc] init];
             studyModel.imgURL = [NSString stringWithFormat: @"%@",data[@"article_image"]];
             studyModel.userName = [NSString stringWithFormat: @"%@",data[@"article_title"]];
             studyModel.commentNum = [NSString stringWithFormat: @"%@",data[@"comment_count"]];
             studyModel.timeStr = [NSString stringWithFormat: @"%@",data[@"inputtime"]];
             studyModel.text_id = [NSString stringWithFormat: @"%@",data[@"id"]];
             [self.dataS addObject:studyModel];
             }*/

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    //[self.tableView reloadData];
}

- (void)endRefresh
{
    [self.tableView reloadData];
    [self.tableView endRefreshing];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"tableViewCellIdentify";
    SYStudyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYStudyTableViewCell" owner:nil options:nil].firstObject;
    }
    if ([self.dataS count] == 0) {
        return cell;
    }
    NSInteger row = indexPath.row;
    
    cell.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    cell.userNameLabel.text = [self.dataS[row] userName];
    cell.timeLabel.text = [self.dataS[row] timeStr];
    [cell.userImgView sd_setImageWithURL:[NSURL URLWithString:[self.dataS[row] imgURL]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    NSString *commentNum = [NSString stringWithFormat:@"%@条评论",[self.dataS[row] commentNum]];
    cell.commentNumLabel.text = commentNum;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Study" bundle:nil];
    SYStudyDetialViewController *studyDetialVC = [storyboard instantiateViewControllerWithIdentifier:@"studyDetialVC"];
    studyDetialVC.textId = [self.dataS[row] text_id];
    studyDetialVC.hidesBottomBarWhenPushed = YES;
    
    if (self.studyListURl!=nil) {
        studyDetialVC.studyDetialURL = Study_Article_Content_Index;
    }
    
    [self.navigationController pushViewController:studyDetialVC animated:YES];
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
