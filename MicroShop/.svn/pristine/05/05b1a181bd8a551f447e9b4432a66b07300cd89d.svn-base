//
//  SYActiveHtmlViewController.m
//  MicroShop
//
//  Created by siyue on 15/6/8.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYActiveHtmlViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
//#import "MJRefresh.h"
#import "UIScrollView+CHRefresh.h"
#import "UITableView+CHRefresh.h"
#import "UIViewController+Share.h"
#import "CHFileManager.h"
#import "SYLoginViewController.h"
#import "SYMicroAddGoodsViewController.h"
#import "SYAwardListViewController.h"
#import "SYActiveListViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#define GETJSCONTEXT  @"documentView.webView.mainFrame.javaScriptContext"

@interface SYActiveHtmlViewController () <UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) JSContext *context;
@end

@implementation SYActiveHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = self.navTitle;
    
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.tag = 100;
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    rightButton.titleLabel.numberOfLines = 2;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitle:@"领奖" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    //上啦下拉刷新
    __block SYActiveHtmlViewController *blockSelf = self;
    [self.webView.scrollView addHeaderWithCallback:^{
        [blockSelf loadUrl];
    }];
    [self loadUrl];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //_progressView.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnAction
{
    SYAwardListViewController *awardListVC = [[SYAwardListViewController alloc] init];
    [self.navigationController pushViewController:awardListVC animated:YES];
    
}

- (void)loadUrl
{
    NSURL *url = [NSURL URLWithString:self.url];
    //NSURL *url = [NSURL URLWithString:@"http://weidian.gx.com/user/user/register.html?app=ios"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)gotoLogout {
    isLogout = YES;
    RemoveUserToken;
    [self shareCancelAuthWithType:ShareTypeWeixiTimeline];
    SYLoginViewController *loginVC = [[SYLoginViewController alloc] initWithNibName:@"SYLoginViewController" bundle:nil];
    loginVC.fatherNavigationController = self.navigationController;
    loginVC.view.frame = self.view.frame;
    loginVC.isLoginVC = YES;
    loginVC.fatherViewController = self;
    self.isLoginVC = YES;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
    
    /*[self.view.window addSubview:loginVC.view];
    
    CGRect frame = loginVC.view.frame;
    frame.size.width = ScreenWidth;
    loginVC.view.frame = frame;
    
    self.navigationController.navigationBar.hidden = YES;
    [self addChildViewController:loginVC];
    loginVC.didLogin = ^(){
        
    };*/
}

- (void)endRefresh
{
    [self.webView.scrollView endRefreshing];
}

#pragma mark - webView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.context = [webView valueForKeyPath:GETJSCONTEXT];
    
    //关联打印异常
    _context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    //----------------------------------------------------------------------------------------------------------------
    __weak typeof(self) weakSelf = self;
    _context[@"getUrl"] = ^(NSString *url,NSString *title) {
        
        NSString *allURL = [NSString stringWithFormat:@"%@",url];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
        SYActiveHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
        generalHtmlVC.url = allURL;
        generalHtmlVC.navTitle = title;
        [weakSelf.navigationController pushViewController:generalHtmlVC animated:YES];
        
    };
    
    //----------------------------------------------------------------------------------------------------------------
    _context[@"clickOneKeyShare"] = ^(NSString *image, NSString *title, NSString *desc,NSString *url){
        id<ISSCAttachment>shareImage = [ShareSDK imageWithUrl:image];
        NSString *content = [NSString stringWithFormat:@"%@",desc];
        NSString *titleStr = [NSString stringWithFormat:@"%@",title];
        NSString *articleId = @"";
        [weakSelf shareAllButtonClickHandler:content withTitle:titleStr url:url image:shareImage withId:articleId isActive:YES];
    };
    
    //----------------------------------------------------------------------------------------------------------------
    _context[@"logout"] = ^(){
        [weakSelf gotoLogout];
    };
    
    //----------------------------------------------------------------------------------------------------------------
    _context[@"didLoad"] = ^(){//异步加载完成
        //[weakSelf performSelector:@selector(saveCatche) withObject:nil afterDelay:2.0f];
    };
    
    //----------------------------------------------------------------------------------------------------------------
    _context[@"didRegister"] = ^(NSString *result){//异步加载完成
        NSDictionary *dic = [weakSelf dictionaryWithJsonString:result];
        if (weakSelf.didLogin!=nil) {
            weakSelf.didLogin(dic);
            [weakSelf dismissViewControllerAnimated:YES completion:NULL];
        }
    };
    
    //----------------------------------------------------------------------------------------------------------------
    _context[@"editSelfGood"] = ^(NSString *goodId){
        
        dispatch_async(dispatch_get_main_queue(),//主线程修改ui,否则程序会崩溃
                       ^{
                           NSString *good_id = [NSString stringWithFormat:@"%@",goodId];
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"McroShop" bundle:nil];
                           SYMicroAddGoodsViewController *microAddGoodsVC = [storyboard instantiateViewControllerWithIdentifier:@"microAddGoodsVC"];
                           microAddGoodsVC.type = 1;
                           microAddGoodsVC.goodId = good_id;
                           microAddGoodsVC.subURL = Micro_Edit_SelfGood;
                           [weakSelf.navigationController pushViewController:microAddGoodsVC animated:YES];
                           
                       });
        
    };
    
    //----------------------------------------------------------------------------------------------------------------
    _context[@"ioslotter"] = ^(NSString *result){//试试手气
        SYActiveListViewController *activeListVC = [[SYActiveListViewController alloc] init];
        [weakSelf.navigationController pushViewController:activeListVC animated:YES];
    };
    
    //----------------------------------------------------------------------------------------------------------------
    _context[@"addAdress"] = ^(){ //添加地址后
    
    };

    
    
    [self endRefresh];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self endRefresh];
    
    if(error.code == -1009){
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"" message:@"网络断开,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alView show];
    }
    
    if (error.code == -999) {
        return;
    }
    
    //缓存
    /* NSString *url = self.url;
     NSString *urlMd5 = [[CHFileManager shareInstance] md5:url];
     NSString *tmpDir = NSTemporaryDirectory();
     NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"htmlCatche.plist"];
     NSMutableDictionary *catche = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
     NSString *HTMLSource = [catche objectForKey:urlMd5];
     
     if (HTMLSource!=nil) {
     [webView loadHTMLString:HTMLSource baseURL:nil];
     }*/
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)refreshWeb //分享成功后刷新网页
{
    [self.webView reload];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.navigationItem.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)saveCatche
{
    //缓存
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    NSString *HTMLSource = [self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    if (HTMLSource!=nil) {
        NSString *url = self.url;
        NSString *urlMd5 = [[CHFileManager shareInstance] md5:url];
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"htmlCatche.plist"];
        NSMutableDictionary *catche = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
        if (catche==nil) {
            catche = [[NSMutableDictionary alloc] init];
        }
        [catche setObject:HTMLSource forKey:urlMd5];
        [catche writeToFile:savePath atomically:YES];
    }
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end
