//
//  SYStudyDetialViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/29.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYStudyDetialViewController.h"
#import "SYStudyDetialHeadTableViewCell.h"
//#import "MJRefresh.h"
#import "UITableView+CHRefresh.h"
#import "SYStudyArticleModel.h"
#import "CHLayout.h"
#import "SYStudyCommentModel.h"
#import "SYStudyCommentTableViewCell.h"
#import "SYShareModel.h"
#import "UIViewController+Share.h"

@interface SYStudyDetialViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)SYStudyArticleModel *studyArticleModel;
@property(strong,nonatomic)SYStudyDetialHeadTableViewCell *studyDetialHeadTableViewCell;

@property (assign,nonatomic)NSInteger currentPage;
@property(strong,nonatomic)NSMutableArray *dataS;
@property (assign,nonatomic) BOOL isHeadRefresh;
@property (assign,nonatomic) NSInteger endRefreshMark;
@end

@implementation SYStudyDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"文章详情";
    
    self.studyArticleModel = [[SYStudyArticleModel alloc] init];
    self.dataS = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.isHeadRefresh = YES;
    self.endRefreshMark = 0;
    
    self.studyDetialHeadTableViewCell = [[NSBundle mainBundle] loadNibNamed:@"SYStudyDetialHeadTableViewCell" owner:nil options:nil].firstObject;
    self.tableView.tableHeaderView = self.studyDetialHeadTableViewCell.contentView;
    
    //上啦下拉刷新
    __block SYStudyDetialViewController *blockSelf = self;
    [self.tableView addHeaderWithCallback:^{
        blockSelf.currentPage = 1;
        blockSelf.isHeadRefresh = YES;
        [blockSelf requestStudyDetial];
        [blockSelf requestCommentList];
    }];
    
    // 进入上拉加载状态就会调用这个方法
    /*[self.tableView addFooterWithCallback:^{
        blockSelf.currentPage++;
        blockSelf.endRefreshMark = 2;
        [blockSelf requestCommentList];
    }];*/
    
    [self.tableView headerBeginRefreshing];
    
    [self loadRightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

#pragma mark - net

- (void)requestStudyDetial
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *text_id = [NSString stringWithFormat:@"&article_id=%@",self.textId];
    
    NSString *subURL = Study_Article_Content;//推广
    if (self.studyDetialURL!=nil) {//学习
        subURL = self.studyDetialURL;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,subURL,key,text_id];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestStudyDetial:result];
    } error:^(NSError *error) {
        self.endRefreshMark++;
        if (self.endRefreshMark>=2) {
            self.endRefreshMark = 0;
            [self endRefresh];
        }
    }];
}

- (void)didRequestStudyDetial:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSDictionary *article = result[@"data"][@"article"];
            NSDictionary *comment = result[@"data"][@"comment"];
            self.studyArticleModel.content_url = [NSString stringWithFormat:@"%@",article[@"content_url"]];
            self.studyArticleModel.article_title = [NSString stringWithFormat:@"%@",article[@"article_title"]];
            self.studyArticleModel.inputtime = [NSString stringWithFormat:@"%@",article[@"inputtime"]];
            self.studyArticleModel.commentCount = [NSString stringWithFormat:@"%@",comment[@"count"]];
            
            [self initTableViewHead];

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

- (void)requestAddComment
{
    if ([self.studyDetialHeadTableViewCell.commentTextfield.text isEqual:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"评论不能为空"];
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *text_id = [NSString stringWithFormat:@"&article_id=%@",self.textId];
    NSString *commentStr = [NSString stringWithFormat:@"&comment_content=%@",self.studyDetialHeadTableViewCell.commentTextfield.text];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,Study_Add_Comment,key,text_id,commentStr];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestAddComment:result];
    } error:^(NSError *error) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"网络异常"];
    }];
}

- (void)didRequestAddComment:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"评论成功"];
        [self.tableView headerBeginRefreshing];
    }
    else {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:[NSString stringWithFormat:@"%@",result[@"message"]]];
    }
}

- (void)requestCommentList
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *text_id = [NSString stringWithFormat:@"&article_id=%@",self.textId];
    NSString *page = [NSString stringWithFormat:@"&p=%li",(long)self.currentPage];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,Study_Comment_List,key,text_id,page];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestCommentList:result];
        self.endRefreshMark++;
        if (self.endRefreshMark>=2) {
            self.endRefreshMark = 0;
            [self endRefresh];
        }
    } error:^(NSError *error) {
        self.endRefreshMark++;
        if (self.endRefreshMark>=2) {
            self.endRefreshMark = 0;
            [self endRefresh];
        }
    }];
}

- (void)didRequestCommentList:(NSDictionary *)result {
    if (self.isHeadRefresh) {
        [self.dataS removeAllObjects];
        self.isHeadRefresh = NO;
    }
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSArray *dataS = [result[@"data"] isKindOfClass:[NSArray class]]?result[@"data"]:[[NSArray alloc] init];
            for (NSDictionary *data in dataS) {
                SYStudyCommentModel *studyCommentModel = [[SYStudyCommentModel alloc] init];
                NSDictionary *member_info = [studyCommentModel formatDic:data[@"member_info"]];
                studyCommentModel.userImgURL = [NSString stringWithFormat:@"%@",member_info[@"avatar"]];
                studyCommentModel.userName = [NSString stringWithFormat:@"%@",member_info[@"username"]];
                studyCommentModel.inputtime = [NSString stringWithFormat:@"%@",data[@"inputtime"]];
                studyCommentModel.content = [NSString stringWithFormat:@"%@",data[@"comment_content"]];
                [self.dataS addObject:studyCommentModel];
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
    //[self.tableView footerEndRefreshing];
}

- (void)initTableViewHead
{
    NSURL *url = [NSURL URLWithString:self.studyArticleModel.content_url];
    self.studyDetialHeadTableViewCell.webView.delegate = self;
    [self.studyDetialHeadTableViewCell.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.studyDetialHeadTableViewCell.webView.scrollView.scrollEnabled = NO;
    
    self.studyDetialHeadTableViewCell.userNameLabel.text = self.studyArticleModel.article_title;
    self.studyDetialHeadTableViewCell.timeLabel.text = self.studyArticleModel.inputtime;
    self.studyDetialHeadTableViewCell.commentNumLabel.text = self.studyArticleModel.commentCount;
    
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:self.studyDetialHeadTableViewCell.commentTextfield withCornerRadius:3];
    self.studyDetialHeadTableViewCell.commentTextfield.layer.borderColor = [UIColor colorWithWhite:0.839 alpha:1.000].CGColor;
    self.studyDetialHeadTableViewCell.commentTextfield.layer.borderWidth = 1;
    
    [layout drawDashLineIn:self.studyDetialHeadTableViewCell.userInfoView withRect:CGRectMake(10, self.studyDetialHeadTableViewCell.userInfoView.frame.size.height-1, self.studyDetialHeadTableViewCell.userInfoView.frame.size.width-20, 1) withColor:[UIColor colorWithWhite:0.835 alpha:1.000] withSolidWidth:3 withHollowWidth:3];
    
    [self.studyDetialHeadTableViewCell.commentBtn addTarget:self action:@selector(addCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.studyDetialURL==nil) {
        [self.studyDetialHeadTableViewCell.shareBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        self.studyDetialHeadTableViewCell.shareViewHeightContrant.constant = 0;
        self.studyDetialHeadTableViewCell.shareBtn.hidden = YES;
    }
}

//加载左右按钮
- (void) loadRightItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.tag = 100;
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"Btn_share_write"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - web delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.endRefreshMark++;
    if (self.endRefreshMark>=2) {
        self.endRefreshMark = 0;
        [self endRefresh];
    }
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+20;//20为修正值
    //修改约束并显示tableview
    self.studyDetialHeadTableViewCell.webViewHeightConstraint.constant = height;
    CGRect frame = self.studyDetialHeadTableViewCell.contentView.frame;
    if (self.studyDetialURL==nil) {
        frame.size.height = height+130;
    }
    else {
        frame.size.height = height+70;
    }
    
    self.studyDetialHeadTableViewCell.contentView.frame = frame;
    //CHLayout *layout = [CHLayout sharedManager];
    //[layout drawLineIn:self.studyDetialHeadTableViewCell.contentView withRect:CGRectMake(0, self.studyDetialHeadTableViewCell.contentView.frame.size.height-10, ScreenWidth, 1) withColor:[UIColor colorWithWhite:0.835 alpha:1.000]];
    self.tableView.tableHeaderView = self.studyDetialHeadTableViewCell.contentView;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.endRefreshMark++;
    if (self.endRefreshMark>=2) {
        self.endRefreshMark = 0;
        [self endRefresh];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.studyDetialURL!=nil) {//学习
        return [self.dataS count];
    }
    else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"tableViewCellIdentify";
    SYStudyCommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYStudyCommentTableViewCell" owner:nil options:nil].firstObject;
    }
    if ([self.dataS count] == 0) {
        return cell;
    }
    NSInteger row = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.userNameLabel.text = [self.dataS[row] userName];
    cell.timeLabel.text = [self.dataS[row] inputtime];
    [cell.userImgView sd_setImageWithURL:[NSURL URLWithString:[self.dataS[row] userImgURL]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    cell.contentLabel.text = [self.dataS[row] content];
    
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:cell.userImgView withCornerRadius:cell.userImgView.frame.size.width/2];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    SYStudyCommentModel *studyCommentModel = self.dataS[row];
    CHLayout *layout = [CHLayout sharedManager];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-90, 0)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = studyCommentModel.content;
    [layout fitsize:label];
    CGFloat cellHeight = label.frame.size.height+90;
    
    
    return cellHeight;
}

#pragma mark - Click

- (void)addCommentClick:(id)sender
{
    [self requestAddComment];
}

//右边按钮响应方法
- (void) rightBtnAction
{
    SYShareModel *shareModel = self.shareModel;
    
    id<ISSCAttachment>image = [ShareSDK imageWithUrl:shareModel.article_image];
    
    //NSString *content = [NSString stringWithFormat:@"%@\n%@",shareModel.article_title,shareModel.article_content];
    //[self shareAllButtonClickHandler:content url:shareModel.article_url image:image];
    
    NSString *content = [NSString stringWithFormat:@"%@",self.shareModel.article_content];
    NSString *titleStr = [NSString stringWithFormat:@"%@",self.shareModel.article_title];
    [self shareAllButtonClickHandler:content withTitle:titleStr url:self.shareModel.article_url image:image withId:self.textId];
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
