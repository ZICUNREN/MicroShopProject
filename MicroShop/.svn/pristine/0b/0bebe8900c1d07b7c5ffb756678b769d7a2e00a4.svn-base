//
//  SYStudyListViewController.m
//  MicroShop
//
//  Created by siyue on 15/5/4.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYStudyListViewController.h"
//#import "MJRefresh.h"
#import "UITableView+CHRefresh.h"
#import "SYStudyModel.h"
#import "SYStudyTableViewCell.h"
#import "SYStudyDetialViewController.h"
#import "UIViewController+Share.h"
#import "SYShareModel.h"

#define CellHeight 75

@interface SYStudyListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *dataS;
@property (strong,nonatomic)NSMutableArray *shareS;
@property (assign,nonatomic)NSInteger currentPage;
@property (assign,nonatomic) BOOL isHeadRefresh;
//@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYStudyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.clipsToBounds = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1.000];
    
    self.dataS = [[NSMutableArray alloc] init];
    self.shareS = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.isHeadRefresh = YES;

    /*self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];*/
    
    //上啦下拉刷新
    __block SYStudyListViewController *blockSelf = self;
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
    
    [self.tableView headerBeginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.studyListURl==nil) {
        CGRect frame = self.view.frame;
        frame.size.height = ScreenHeight-64-44-50;
        frame.size.width = ScreenWidth;
        self.view.frame = frame;
    }
    else {
        CGRect frame = self.view.frame;
        frame.size.height = ScreenHeight-64-44;
        frame.size.width = ScreenWidth;
        self.view.frame = frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - net

- (void)requestStudyClass
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *page = [NSString stringWithFormat:@"&p=%li",(long)self.currentPage];
    NSString *ac_id = [NSString stringWithFormat:@"&ac_id=%@",self.ac_id];

    NSString *subURL = Study_List;
    if (self.studyListURl!=nil) {
        subURL = self.studyListURl;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,subURL,key,page,ac_id];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestStudyClass:result];
        //[self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self endRefresh];
        //[self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestStudyClass:(NSDictionary *)result {
    [self endRefresh];
    if (self.isHeadRefresh) {
        [self.dataS removeAllObjects];
        [self.shareS removeAllObjects];
        self.isHeadRefresh = NO;
    }
    
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSArray *dataS = result[@"data"][@"list"];
            if ([dataS isKindOfClass:[NSNull class]]) {//如果当前页数据为空，则回到上一页
                if (self.currentPage>1) {
                    self.currentPage--;
                }
                [self.tableView loadAll];
                return;
            }
            
            for (NSDictionary *data in dataS) {
                SYStudyModel *studyModel = [[SYStudyModel alloc] init];
                studyModel.imgURL = [NSString stringWithFormat: @"%@",data[@"article_image"]];
                studyModel.userName = [NSString stringWithFormat: @"%@",data[@"article_title"]];
                studyModel.commentNum = [NSString stringWithFormat: @"%@",data[@"share_num"]];
                studyModel.timeStr = [NSString stringWithFormat: @"%@",data[@"inputtime"]];
                studyModel.text_id = [NSString stringWithFormat: @"%@",data[@"id"]];
                [self.dataS addObject:studyModel];
                
                SYShareModel *shareModel = [[SYShareModel alloc] init];
                shareModel.article_content = [NSString stringWithFormat:@"%@",data[@"share"][@"article_content"]];
                shareModel.article_image = [NSString stringWithFormat:@"%@",data[@"share"][@"article_image"]];
                shareModel.article_title = [NSString stringWithFormat:@"%@",data[@"share"][@"article_title"]];
                shareModel.article_url = [NSString stringWithFormat:@"%@",data[@"share"][@"article_url"]];
                shareModel.article_id = [NSString stringWithFormat:@"%@",data[@"id"]];
                [self.shareS addObject:shareModel];
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    [self.tableView reloadData];
}

- (void)endRefresh
{
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
    NSString *commentNum = [NSString stringWithFormat:@"%@人分享",[self.dataS[row] commentNum]];
    cell.commentNumLabel.text = commentNum;
    
    if (self.studyListURl!=nil) {
        cell.commentNumLabel.hidden = YES;
    }
    
    cell.shareBtn.tag = row;
    [cell.shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    studyDetialVC.shareModel = self.shareS[row];
    studyDetialVC.hidesBottomBarWhenPushed = YES;
    if (self.studyListURl!=nil) {
        studyDetialVC.studyDetialURL = Study_Article_Content_Index;
    }
    [self.navigationController pushViewController:studyDetialVC animated:YES];
}

#pragma mark - Click

- (void)shareClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    SYShareModel *shareModel = self.shareS[row];
    
    id<ISSCAttachment>image = [ShareSDK imageWithUrl:shareModel.article_image];
    
    NSString *content = [NSString stringWithFormat:@"%@",shareModel.article_content];
    NSString *titleStr = [NSString stringWithFormat:@"%@",shareModel.article_title];
    NSString *articleId = shareModel.article_id;
    [self shareAllButtonClickHandler:content withTitle:titleStr url:shareModel.article_url image:image withId:articleId];

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
