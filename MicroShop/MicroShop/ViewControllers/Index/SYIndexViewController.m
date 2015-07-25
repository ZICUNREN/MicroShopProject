//
//  SYIndexViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYIndexViewController.h"
#import "SYInviteModel.h"
#import "syInviteTableViewCell.h"
#import "CHLayout.h"
#import "SYNewUserModel.h"
#import "SYIndexHeadViewController.h"
#import "SYStoryModel.h"
//#import "MJRefresh.h"
#import "UITableView+CHRefresh.h"
#import "SYGeneralHtmlViewController.h"
#import "SYGettingWebURLData.h"
#import "SYLoginIconManage.h"
#import "SYStudyDetialViewController.h"
#import "SYStudyViewController.h"
#import "SYShareModel.h"
#import "SYPersonalCenterViewController.h"
#import "SYIndexActivityListModel.h"
#import "MJExtension.h"
#import "SYActivityScrollView.h"
#import "SYAwardDetailViewController.h"
#import "SYActiveHtmlViewController.h"
#import "SYInviteDetailViewController.h"

#define CellHeight 60
#define HeadHeight 50

@interface SYIndexViewController () <UITableViewDataSource,UITableViewDelegate>
{
    SYIndexHeadViewController *indexHeadVC;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)SYActivityScrollView *activityScrollView;
@property (strong,nonatomic)SYNewUserModel *nUserModel;
@property (strong,nonatomic)SYNewUserModel *userModel;

@property (strong,nonatomic)NSMutableArray *storyS;
@property (strong,nonatomic)NSMutableArray *inviteS;
@property (strong,nonatomic)NSArray *activityList;

@property (strong,nonatomic)SYWebURLModel *webURLModel;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    
    self.webURLModel = [[SYWebURLModel alloc] init];
    self.webURLModel = [[SYGettingWebURLData sharedManager] getWebURLData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    self.tableView.tableFooterView = footView;
    
    self.inviteS = [[NSMutableArray alloc] init];
    self.nUserModel = [[SYNewUserModel alloc] init];
    self.userModel = [[SYNewUserModel alloc] init];
    self.storyS = [[NSMutableArray alloc] init];
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    
    [self initTableViewHead];
    
    //上啦下拉刷新
    __block SYIndexViewController *blockSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [blockSelf requestHome];
    }];
    
    [self requestHome];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - net

- (void)requestHome
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,Home_Index,key];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestHome:result];
        [self endRefresh];
        [self.progressHUD hide:YES afterDelay:0];
    } error:^(NSError *error) {
        [self endRefresh];
        [self.progressHUD hide:YES afterDelay:0];
    }];
}

- (void)didRequestHome:(NSDictionary *)result {
    [self.inviteS removeAllObjects];
    [self.storyS removeAllObjects];
    if ([result[@"code"] integerValue]==1) {
//        NSLog(@"不知道什么——————》%@",result);
        @try {
            //活动
            NSArray *activity = result[@"data"][@"activity"];
            self.activityList = [SYIndexActivityListModel objectArrayWithKeyValuesArray:activity];
            
            //head
            self.nUserModel.joinTime = [NSString stringWithFormat:@"%@",result[@"data"][@"invite"][@"new_user_addtime"]];
            self.nUserModel.userName = [NSString stringWithFormat:@"%@",result[@"data"][@"invite"][@"new_user_nickname"]];
            self.nUserModel.imgURL = [NSString stringWithFormat:@"%@",result[@"data"][@"invite"][@"new_user_avatar"]];
            
            self.userModel.userName = [NSString stringWithFormat:@"%@",result[@"data"][@"user"][@"nickname"]];
            self.userModel.uuserName = [NSString stringWithFormat:@"%@",result[@"data"][@"user"][@"username"]];
            self.userModel.imgURL = [NSString stringWithFormat:@"%@",result[@"data"][@"user"][@"avatar"]];
            self.userModel.shareMoney = [NSString stringWithFormat:@"%@",result[@"data"][@"member"][@"share_wallet_old"]];
            self.userModel.remainMoney = [NSString stringWithFormat:@"%@",result[@"data"][@"member"][@"wallet"]];
            
            //保存用户头像
            [[SYLoginIconManage sharedManager] saveUserIconWithURL:self.userModel.imgURL withUserName:self.userModel.uuserName];
            
            NSArray *inviteList = result[@"data"][@"invite"][@"list"];
            for (NSDictionary *invite in inviteList) {
                SYInviteModel *inviteModel = [[SYInviteModel alloc] init];
                inviteModel.imgURL = [NSString stringWithFormat:@"%@",invite[@"avatar"]];
                inviteModel.userName = [NSString stringWithFormat:@"%@",invite[@"nickname"]];
                inviteModel.storeName = [NSString stringWithFormat:@"%@",invite[@"shop_name"]];
                inviteModel.visitorNum = [NSString stringWithFormat:@"%@",invite[@"share_wallet_old"]];
                inviteModel.storeId = [NSString stringWithFormat:@"%@",invite[@"shop_id"]];
                [self.inviteS addObject:inviteModel];
            }
            
            //story
            NSArray *storys = result[@"data"][@"article"];
            for (NSDictionary *story in storys) {
                SYStoryModel *storyModel = [[SYStoryModel alloc] init];
                storyModel.imgURL = [NSString stringWithFormat:@"%@",story[@"article_image"]];
                storyModel.storyName = [NSString stringWithFormat:@"%@",story[@"article_title"]];
                storyModel.scanNum = [NSString stringWithFormat:@"%@",story[@"article_view_count"]];
                storyModel.commentNum = [NSString stringWithFormat:@"%@",story[@"share_num"]];
                storyModel.article_id = [NSString stringWithFormat:@"%@",story[@"id"]];
                
                NSDictionary *share = story[@"share"];
                storyModel.shareModel.article_content = [NSString stringWithFormat:@"%@",share[@"article_content"]];
                storyModel.shareModel.article_image = [NSString stringWithFormat:@"%@",share[@"article_image"]];
                storyModel.shareModel.article_url = [NSString stringWithFormat:@"%@",share[@"article_url"]];
                storyModel.shareModel.article_title = [NSString stringWithFormat:@"%@",share[@"article_title"]];
                
                [self.storyS addObject:storyModel];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        [self.tableView reloadData];
        [self initTableViewHead];
        [self initTableViewFoot];
    }
    else {
    }
}


#pragma mark - init

- (void)initTableViewHead
{
    UIStoryboard *mcroShopStoryboard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
    indexHeadVC = [mcroShopStoryboard instantiateViewControllerWithIdentifier:@"IndexHeadVC"];
    [self addChildViewController:indexHeadVC];
    indexHeadVC.userName = self.userModel.userName;
    UIView *headView = indexHeadVC.view;
    
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:indexHeadVC.userImgView withCornerRadius:indexHeadVC.userImgView.frame.size.width/2];
    [indexHeadVC.userImgView sd_setImageWithURL:[NSURL URLWithString:self.userModel.imgURL] placeholderImage:nil];
    
    [indexHeadVC.userBtn addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [layout setView:indexHeadVC.detailLabel withCornerRadius:3];
    
    [indexHeadVC.detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [indexHeadVC.shareIncomeBtn addTarget:self action:@selector(shareIncomeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [indexHeadVC.studyNewBtn addTarget:self action:@selector(studyNewClick:) forControlEvents:UIControlEventTouchUpInside];
    [indexHeadVC.shareWork addTarget:self action:@selector(shareWorkClick:) forControlEvents:UIControlEventTouchUpInside];
    [indexHeadVC.masterStoreBtn addTarget:self action:@selector(masterStoreClick:) forControlEvents:UIControlEventTouchUpInside];
    [indexHeadVC.inviteBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    indexHeadVC.detailMoneyLabel.text = self.userModel.shareMoney;
    indexHeadVC.shareIncomeMoneyLabel.text = self.userModel.remainMoney;
    
    //活动
    if (self.activityScrollView!=nil) {
        [self.activityScrollView removeFromSuperview];
    }
    self.activityScrollView = [[SYActivityScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, indexHeadVC.activityView.frame.size.height)];
    [indexHeadVC.activityView addSubview:self.activityScrollView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, indexHeadVC.activityView.frame.size.height-20, indexHeadVC.activityView.frame.size.width, 20)];
    self.activityScrollView.pageControl = pageControl;
    [indexHeadVC.activityView addSubview:pageControl];
    
    self.activityScrollView.activityList = self.activityList;
    __block SYIndexViewController *blockSelf = self;
    
    SYIndexActivityListModel *activityListModel = nil;
    
    CGRect frame = headView.frame;
    
    if (self.activityList.count>0) {//有活动
        indexHeadVC.adBackViewHeightConstraint.constant = 80;
        frame.size.height = 540;
        #pragma mark - What
        
//        activityListModel = blockSelf.activityList[0];
    }
    else {
        indexHeadVC.adBackViewHeightConstraint.constant = 8;
        frame.size.height = 468;
    }
    
    headView.frame = frame;
    self.tableView.tableHeaderView = headView;
    
    NSString *IOSMark1 = [NSString stringWithFormat:@"&app=%@",@"ios"];
    NSString *key1 = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *subURL1 = [NSString stringWithFormat:@"%@?",activityListModel.url];
    NSString *url1 = [NSString stringWithFormat:@"%@%@%@",subURL1,key1,IOSMark1];
    [[NSUserDefaults standardUserDefaults] setObject:url1 forKey:@"ActiveURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.activityScrollView setDidSelect:^(NSInteger row) {
        SYIndexActivityListModel *activityListModel = blockSelf.activityList[row];
        NSString *activity_id = activityListModel.activity_id;
        if ([activity_id isEqualToString:@"0"]) {
            NSString *subURL = [NSString stringWithFormat:@"%@?",activityListModel.url];
            SYActiveHtmlViewController *generalHtmlVC = [[SYActiveHtmlViewController alloc] init];
            NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
            NSString *IOSMark = [NSString stringWithFormat:@"&app=%@",@"ios"];
            NSString *url = [NSString stringWithFormat:@"%@%@%@",subURL,key,IOSMark];
            generalHtmlVC.url = url;
            generalHtmlVC.navTitle = @"活动详情";
            generalHtmlVC.hidesBottomBarWhenPushed = YES;
            [blockSelf.navigationController pushViewController:generalHtmlVC animated:YES];
        }
        else {
            SYAwardDetailViewController *awardDetailVC = [[SYAwardDetailViewController alloc] init];
            awardDetailVC.hidesBottomBarWhenPushed = YES;
            awardDetailVC.activeId = activity_id;
            [blockSelf.navigationController pushViewController:awardDetailVC animated:YES];
        }
    }];
}

- (void)initTableViewFoot
{
    CHLayout *layout = [CHLayout sharedManager];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    
    CGPoint point = CGPointMake(0, 0);
    CGSize size = CGSizeMake(footView.frame.size.width, footView.frame.size.height-8);
    //backView
    UIView *backView = [layout createViewIn:footView withOrigin:point withSize:size];
    backView.backgroundColor = [UIColor whiteColor];
    
    //image
    point = CGPointMake(10, 8);
    size = CGSizeMake(HeadHeight-20, HeadHeight-20);
    [layout createImageViewIn:backView withOrigin:point withSize:size withBackImg:@"inviteIco2"];
    
    //Label
    point = CGPointMake(point.x+size.width, point.y);
    size = CGSizeMake(80, size.height);
    UILabel *titleLabel = [layout createLabelIn:backView withOrigin:point withSize:size withText:@"热门分享" withTag:-1];
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    //更多
    point = CGPointMake(ScreenWidth-60, point.y);
    size = CGSizeMake(60, size.height);
    UIButton *joinBtn = [layout createButtonIn:backView withOrigin:point withSize:size withTitle:@"更多" withBackImg:nil withTag:-1];
    CGRect frame = joinBtn.frame;
    [joinBtn addTarget:self action:@selector(studyListClick:) forControlEvents:UIControlEventTouchUpInside];
    frame.origin.x = ScreenWidth-10-joinBtn.frame.size.width;
    joinBtn.frame = frame;
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [joinBtn setTitleColor:[UIColor colorWithWhite:0.529 alpha:1.000] forState:UIControlStateNormal];
    
    point = CGPointMake(0, point.y+size.height);
    size = CGSizeMake(ScreenWidth, ((ScreenWidth-30)/2+60)*2);
    UIView *storyView = [layout createViewIn:backView withOrigin:point withSize:size];
    
    NSInteger totalNum = self.storyS.count;
    NSInteger sumI = (totalNum+1)/2;
    NSInteger sumJ = 2;
    //story
    for (NSInteger i=0; i<sumI; i++) {
        for (NSInteger j=0; j<sumJ; j++) {
            NSInteger row = i*2+j;
            if (self.storyS.count<=row) {
                break;
            }
            point = CGPointMake(10+j*((ScreenWidth-30)/2+10), 10+i*((ScreenWidth-30)/2+60));
            size = CGSizeMake((ScreenWidth-30)/2, (ScreenWidth-30)/2+60);
            //NSLog(@"%i    %i",point.x,point.y);
            UIButton *storyBtn = [layout createButtonIn:storyView withOrigin:point withSize:size withTitle:@"" withBackImg:nil withTag:-1];
            UIImageView *storyImgView = [layout createImageViewIn:storyBtn withOrigin:CGPointMake(0, 0) withSize:CGSizeMake((ScreenWidth-30)/2, (ScreenWidth-30)/2) withBackImg:nil];
            [storyImgView sd_setImageWithURL:[NSURL URLWithString:[self.storyS[row] imgURL]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
            storyBtn.tag = i*2+j;
            [storyBtn addTarget:self action:@selector(studyDetailClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //Label
            CGPoint point1 = CGPointMake(0, (ScreenWidth-30)/2+4);
            CGSize size1 = CGSizeMake((ScreenWidth-30)/2, 20);
            UILabel *titleLabel = [layout createLabelIn:storyBtn withOrigin:point1 withSize:size1 withText:[self.storyS[row] storyName] withTag:-1];
            titleLabel.font = [UIFont systemFontOfSize:14];
            
            //浏览
            /*point1 = CGPointMake(point1.x, point1.y+size1.height+4);
            UILabel *scanLabel = [layout createLabelIn:storyBtn withOrigin:point1 withSize:size1 withText:[self.storyS[row] scanNum] withTag:-1];
            scanLabel.font = [UIFont systemFontOfSize:12];
            scanLabel.textColor = [UIColor colorWithWhite:0.529 alpha:1.000];
            [layout fitWidth:scanLabel];
            
            point1 = CGPointMake(point1.x+scanLabel.frame.size.width, point1.y);
            UILabel *scanTitleLabel = [layout createLabelIn:storyBtn withOrigin:point1 withSize:size1 withText:@"人浏览" withTag:-1];
            scanTitleLabel.font = [UIFont systemFontOfSize:12];
            scanTitleLabel.textColor = [UIColor colorWithWhite:0.529 alpha:1.000];
            [layout fitWidth:scanTitleLabel];*/
            
            //浏览
            //point1 = CGPointMake(point1.x+scanTitleLabel.frame.size.width+4, point1.y);
            point1 = CGPointMake(0, point1.y+size1.height+4);
            UILabel *commentLabel = [layout createLabelIn:storyBtn withOrigin:point1 withSize:size1 withText:[self.storyS[row] commentNum] withTag:-1];
            commentLabel.font = [UIFont systemFontOfSize:12];
            commentLabel.textColor = [UIColor colorWithRed:0.796 green:0.000 blue:0.184 alpha:1.000];
            [layout fitWidth:commentLabel];
            
            point1 = CGPointMake(point1.x+commentLabel.frame.size.width, point1.y);
            UILabel *commentTitleLabel = [layout createLabelIn:storyBtn withOrigin:point1 withSize:size1 withText:@"人分享" withTag:-1];
            commentTitleLabel.font = [UIFont systemFontOfSize:12];
            commentTitleLabel.textColor = [UIColor colorWithWhite:0.529 alpha:1.000];
            [layout fitWidth:commentTitleLabel];
            
            
        }
    }
    [layout viewToFit:storyView withSpaceX:10 withSpaceY:0];
    [layout viewToFit:backView withSpaceX:0 withSpaceY:0];
    [layout viewToFit:footView withSpaceX:0 withSpaceY:0];
    self.tableView.tableFooterView = footView;
}

- (void)endRefresh
{
    [self.tableView endRefreshing];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.inviteS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"tableViewCellIdentify";
    SYInviteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYInviteTableViewCell" owner:nil options:nil].firstObject;
    }
    if ([self.inviteS count] == 0) {
        return cell;
    }
    NSInteger row = indexPath.row;
    
    cell.userNameLabel.text = [self.inviteS[row] userName];
    cell.storeNameLabel.text = [self.inviteS[row] storeName];
    cell.visitorNumLabel.text = [self.inviteS[row] visitorNum];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[self.inviteS[row] imgURL]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:cell.imgView withCornerRadius:cell.imgView.frame.size.width/2];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYInviteModel *inviteModel = self.inviteS[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@",self.webURLModel.micro_shopIndex_URL,inviteModel.storeId];
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"店铺详情";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CHLayout *layout = [CHLayout sharedManager];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeadHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    
    //image
    CGPoint point = CGPointMake(10, 10);
    CGSize size = CGSizeMake(HeadHeight-20, HeadHeight-20);
    [layout createImageViewIn:headView withOrigin:point withSize:size withBackImg:@"inviteIco1"];
    
    //Label
    point = CGPointMake(point.x+size.width, point.y);
    size = CGSizeMake(120, size.height);
    UILabel *titleLabel = [layout createLabelIn:headView withOrigin:point withSize:size withText:@"收益排行榜" withTag:-1];
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    //加入
    /*point = CGPointMake(ScreenWidth, point.y);
    size = CGSizeMake(60, size.height);
    UILabel *joinLabel = [layout createLabelIn:headView withOrigin:point withSize:size withText:self.nUserModel.joinTime withTag:-1];
    joinLabel.font = [UIFont systemFontOfSize:14];
    [layout fitWidth:joinLabel];
    CGRect frame = joinLabel.frame;
    frame.origin.x = ScreenWidth-10-joinLabel.frame.size.width;
    joinLabel.frame = frame;
    joinLabel.textColor = [UIColor colorWithRed:0.529 green:0.529 blue:0.565 alpha:1.000];
    
    //用户名
    point = CGPointMake(ScreenWidth, point.y);
    size = CGSizeMake(60, size.height);
    UILabel *userLabel = [layout createLabelIn:headView withOrigin:point withSize:size withText:self.nUserModel.userName withTag:-1];
    userLabel.font = [UIFont systemFontOfSize:14];
    [layout fitWidth:userLabel];
    frame = userLabel.frame;
    frame.origin.x = joinLabel.frame.origin.x-userLabel.frame.size.width-4;
    userLabel.frame = frame;
    userLabel.textColor = [UIColor colorWithRed:0.255 green:0.498 blue:0.984 alpha:1.000];
    
    //image
    point = CGPointMake(userLabel.frame.origin.x-(HeadHeight-20), point.y);
    size = CGSizeMake(HeadHeight-20, HeadHeight-20);
    UIImageView *rightImgView = [layout createImageViewIn:headView withOrigin:point withSize:size withBackImg:nil];
    [rightImgView sd_setImageWithURL:[NSURL URLWithString:self.nUserModel.imgURL] placeholderImage:[UIImage imageNamed:@"userNopic2"]];
    [layout setView:rightImgView withCornerRadius:rightImgView.frame.size.width/2];*/
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeadHeight;
}

#pragma mark - Click

- (void)userClick:(id)sender
{
    SYPersonalCenterViewController *personalCenterVC = [[SYPersonalCenterViewController alloc] init];
    personalCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalCenterVC animated:YES];
    [personalCenterVC setDidEditImg:^(UIImage *image) {
        indexHeadVC.userImgView.image = image;
    }];
    
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = self.webURLModel.Index_UserCenter_URL;
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"我的账号";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];*/
    
    /*UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    ooViewController *vc = [stroy instantiateViewControllerWithIdentifier:@"kkll"];
    [self.navigationController pushViewController:vc animated:YES];*/
    
}

- (void)studyListClick:(id)sender
{
    self.tabBarController.selectedIndex = Study_Tab;
}

- (void)studyDetailClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    SYStoryModel *storyModel = self.storyS[row];
    NSString *storyId = storyModel.article_id;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Study" bundle:nil];
    SYStudyDetialViewController *studyDetialVC = [storyboard instantiateViewControllerWithIdentifier:@"studyDetialVC"];
    studyDetialVC.textId = storyId;
    studyDetialVC.shareModel = storyModel.shareModel;
    //studyDetialVC.studyDetialURL = Study_Article_Content_Index;
    studyDetialVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:studyDetialVC animated:YES];
}

- (void)detailBtnClick:(id)sender//分享收益
{

}

- (void)shareIncomeBtnClick:(id)sender//订单收益
{
    
}

- (void)studyNewClick:(id)sender//新手学堂
{
    //微店
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Study" bundle:nil];
    SYStudyViewController *StudyVC = [storyboard instantiateViewControllerWithIdentifier:@"StudyVC"];
    StudyVC.hidesBottomBarWhenPushed = YES;
    StudyVC.studyListURl = Study_List_Index;
    [self.navigationController pushViewController:StudyVC animated:YES];
}

- (void)shareWorkClick:(id)sender//分享赚钱
{
    self.tabBarController.selectedIndex = Study_Tab;
}

- (void)masterStoreClick:(id)sender//管理微店
{
    self.tabBarController.selectedIndex = Micro_Tab;
}

- (void)inviteBtnClick:(id)sender//邀请好友
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Invite" bundle:nil];
    SYInviteDetailViewController *inviteDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"InviteDetailViewController"];
    inviteDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteDetailVC animated:YES];
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
