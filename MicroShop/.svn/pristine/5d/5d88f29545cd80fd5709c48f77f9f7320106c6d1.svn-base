//
//  SYAllDynamicViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/27.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYAllDynamicViewController.h"
#import "SYAllDynamicTableViewCell.h"
//#import "MJRefresh.h"
#import "UITableView+CHRefresh.h"
#import "SYAllDynamicModel.h"
#import "CHLayout.h"
#import "SYSpreadHeadTableViewCell.h"
#import "SYGeneralHtmlViewController.h"
#import "SYGettingWebURLData.h"
#import "SYShareModel.h"
#import "UIViewController+Share.h"

@interface SYAllDynamicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray *dataS;
@property (nonatomic,assign)NSInteger currentPage;
@property (assign,nonatomic) BOOL isHeadRefresh;
@property (strong,nonatomic)SYWebURLModel *webURLModel;
@property (strong,nonatomic)SYShareModel *shareModel;
@property (assign,nonatomic)NSInteger currentRow;
@end

@implementation SYAllDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.shareModel = [[SYShareModel alloc] init];
    self.webURLModel = [[SYWebURLModel alloc] init];
    self.webURLModel = [[SYGettingWebURLData sharedManager] getWebURLData];
    
    self.dataS = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.currentRow = 0;
    self.isHeadRefresh = YES;
    
    //上啦下拉刷新
    __block SYAllDynamicViewController *blockSelf = self;
    [self.tableView addHeaderWithCallback:^{
        blockSelf.currentPage = 1;
        blockSelf.isHeadRefresh = YES;
        [blockSelf requestDynamic];
    }];
    
    // 进入上拉加载状态就会调用这个方法
    [self.tableView addFooterWithCallback:^{
        blockSelf.currentPage++;
        [blockSelf requestDynamic];
    }];
    
    [self.tableView headerBeginRefreshing];
    
    [self initHeadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    CGRect frame = self.view.frame;
    frame.size.height = ScreenHeight-64-44-50;
    frame.size.width = ScreenWidth;
    self.view.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHeadView
{
    SYSpreadHeadTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SYSpreadHeadTableViewCell" owner:nil options:nil].firstObject;
    UIView *headView = cell.contentView;
    self.tableView.tableHeaderView = headView;
}

#pragma mark - net

- (void)requestDynamic
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *page = [NSString stringWithFormat:@"&p=%li",(long)self.currentPage];
    NSString *type = [NSString stringWithFormat:@"&flag=%@",self.type];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,Dynamic_List,key,page,type];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestDynamic:result];
    } error:^(NSError *error) {
        [self endRefresh];
    }];
}

- (void)didRequestDynamic:(NSDictionary *)result {
    [self endRefresh];
    if (self.isHeadRefresh) {
        [self.dataS removeAllObjects];
        self.isHeadRefresh = NO;
    }
    
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSArray *dataS = result[@"data"];
            if ([dataS isKindOfClass:[NSNull class]]||dataS.count<=0) {//如果当前页数据为空，则回到上一页
                if (self.currentPage>1) {
                    self.currentPage--;
                }
                [self.tableView loadAll];
                return;
            }
            for (NSDictionary *data in dataS) {
                SYAllDynamicModel *allDdynamicModel = [[SYAllDynamicModel alloc] init];
                allDdynamicModel.storeImgURL = [NSString stringWithFormat:@"%@",data[@"shop"][@"store_label"]];
                allDdynamicModel.store_name = [NSString stringWithFormat:@"%@",data[@"shop"][@"store_name"]];
                allDdynamicModel.inputtime = [NSString stringWithFormat:@"%@",data[@"inputtime"]];
                allDdynamicModel.content = [NSString stringWithFormat:@"%@",data[@"content"]];
                allDdynamicModel.imgURLList = [NSArray arrayWithArray:data[@"pic_group_arr"]];
                allDdynamicModel.goods_price = [NSString stringWithFormat:@"%@",data[@"goods"][@"goods_price"]];
                allDdynamicModel.goods_commission = [NSString stringWithFormat:@"%@",data[@"goods"][@"goods_commission"]];
                allDdynamicModel.good_id = [NSString stringWithFormat:@"%@",data[@"goods"][@"id"]];
                allDdynamicModel.good_name = [NSString stringWithFormat:@"%@",data[@"goods"][@"goods_name"]];
                [self.dataS addObject:allDdynamicModel];
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        [self.tableView reloadData];
    }
}

- (void)requestAddSell
{
    SYAllDynamicModel *allDynamicModel = self.dataS[self.currentRow];
    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *good_id = [NSString stringWithFormat:@"&goods_id=%@",allDynamicModel.good_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Spread_Add_Sell,key,good_id];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestAddSell:result];
    } error:^(NSError *error) {
        
    }];
}

- (void)didRequestAddSell:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSDictionary *share = result[@"data"][@"share"];
            self.shareModel.article_content = [NSString stringWithFormat:@"%@",share[@"share_desc"]];
            self.shareModel.article_image = [NSString stringWithFormat:@"%@",share[@"share_pic"]];
            self.shareModel.article_title = [NSString stringWithFormat:@"%@",share[@"share_title"]];
            self.shareModel.article_url = [NSString stringWithFormat:@"%@",share[@"share_url"]];
            self.shareModel.article_id = [NSString stringWithFormat:@"%@",share[@"id"]];
            
            id<ISSCAttachment>shareImage = [ShareSDK imageWithUrl:self.shareModel.article_image];
           // NSString *content = [NSString stringWithFormat:@"%@\n%@",self.shareModel.article_title,self.shareModel.article_content];
            //[self shareAllButtonClickHandler:content url:self.shareModel.article_url image:shareImage];
            NSString *content = [NSString stringWithFormat:@"%@",self.shareModel.article_content];
            NSString *titleStr = [NSString stringWithFormat:@"%@",self.shareModel.article_title];
            [self shareAllButtonClickHandler:content withTitle:titleStr url:self.shareModel.article_url image:shareImage withId:self.shareModel.article_id];
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
    SYAllDynamicTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYAllDynamicTableViewCell" owner:nil options:nil].firstObject;
    }
    if ([self.dataS count] == 0) {
        return cell;
    }
    NSInteger row = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CHLayout *layout = [CHLayout sharedManager];
    
    [cell.storeImgView sd_setImageWithURL:[NSURL URLWithString:[self.dataS[row] storeImgURL]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    cell.storeNameLabel.text = [self.dataS[row] store_name];
    cell.timeLabel.text = [self.dataS[row] inputtime];
    cell.contentLabel.text = [self.dataS[row] content];
    if ([self.dataS[row] imgURLList].count>=3) {
        [cell.disImgView1 sd_setImageWithURL:[NSURL URLWithString:[self.dataS[row] imgURLList][0]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
        [cell.disImgView2 sd_setImageWithURL:[NSURL URLWithString:[self.dataS[row] imgURLList][1]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
        [cell.disImgView3 sd_setImageWithURL:[NSURL URLWithString:[self.dataS[row] imgURLList][2]] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
    }
    cell.priceLabel.text = [self.dataS[row] goods_price];
    cell.commissionLabel.text = [self.dataS[row] goods_commission];
    
    cell.productBtn.layer.borderColor = [UIColor colorWithWhite:0.757 alpha:1.000].CGColor;
    cell.productBtn.layer.borderWidth = 1;
    [layout setView:cell.productBtn withCornerRadius:3];
    cell.productBtn.tag = row;
    [cell.productBtn addTarget:self action:@selector(productClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [layout setView:cell.transmitBtn withCornerRadius:3];
    cell.transmitBtn.tag = row;
    [cell.transmitBtn addTarget:self action:@selector(transmitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //画虚线
    [layout drawDashLineIn:cell.userView withRect:CGRectMake(0, cell.userView.frame.size.height-1, cell.userView.frame.size.width, 1) withColor:[UIColor colorWithWhite:0.918 alpha:1.000] withSolidWidth:3 withHollowWidth:3];
    [layout drawDashLineIn:cell.goodsView withRect:CGRectMake(0, 0, cell.userView.frame.size.width, 1) withColor:[UIColor colorWithWhite:0.918 alpha:1.000] withSolidWidth:3 withHollowWidth:3];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)endRefresh
{
    [self.tableView endRefreshing];
    //[self.tableView footerEndRefreshing];
}

#pragma mark - Click

- (void)productClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    SYAllDynamicModel *allDynamicModel = self.dataS[row];
    NSString *good_id = [NSString stringWithFormat:@"&good_id=%@",allDynamicModel.good_id];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = [NSString stringWithFormat:@"%@%@",self.webURLModel.Spread_Good_Detail,good_id];
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = allDynamicModel.good_name;
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];
    
}

- (void)transmitClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    self.currentRow = row;
    [self requestAddSell];
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
