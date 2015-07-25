//
//  SiteViewController.m
//  MicroShop
//
//  Created by bladeapp on 15/3/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SiteViewController.h"
#define NAV_BACKGROUNDCOLOR [UIColor colorWithRed:238.0/255 green:60.0/255 blue:48.0/255 alpha:1]

@interface SiteViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *titleArray_Section1;
    NSArray *titleArray_Section2;
    
}

@end

@implementation SiteViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[self buttonImageFromColor:NAV_BACKGROUNDCOLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray_Section1 = @[@"新消息提醒",@"给个好评",@"清除本地缓存"];
    titleArray_Section2 = @[@"关于同城微店",@"意见反馈",@"个性化设置"];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"backIco"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *siteTableView = [[UITableView alloc] init];
    siteTableView.backgroundColor = [UIColor whiteColor];
    siteTableView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height);
    siteTableView.delegate = self;
    siteTableView.dataSource = self;
    [self.view addSubview:siteTableView];
    
    [self setExtraCellLineHidden:siteTableView];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark TableView Delegate and DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [titleArray_Section1 count];
    }
    return [titleArray_Section2 count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifyCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if( indexPath.section == 0){
        cell.textLabel.text = [titleArray_Section1 objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [titleArray_Section2 objectAtIndex:indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
            }
                break;
            case 1:{
            }
                break;
            case 2:{
                [self clearCache];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
            }
                break;
            case 1:{
            }
                break;
            case 2:{
            }
                break;
            default:
                break;
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)clearCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"清除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}
@end
