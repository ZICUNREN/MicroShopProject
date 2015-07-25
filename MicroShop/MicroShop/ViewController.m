//
//  ViewController.m
//  MicroShop
//
//  Created by bladeapp on 15/3/9.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "DialogUtil.h"
#import "UIButton+NMCategory.h"
#import <ShareSDK/ShareSDK.h>
#import "AFNetworking.h"
#import "MLImageCrop.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "SiteViewController.h"


#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define LOGINURL @"http://test.gx.com/?app=ios"
#define HOMEURL @"http://test.gx.com/index.php?g=user&m=user&a=weixin_callback_app&"
#define GETCURRENTURL @"document.location.href"
#define GETJSCONTEXT  @"documentView.webView.mainFrame.javaScriptContext"

#define NAV_BACKGROUNDCOLOR [UIColor colorWithRed:238.0/255 green:60.0/255 blue:48.0/255 alpha:1]


@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,MLImageCropDelegate>{
    UIWebView *loginWebView;
    NSString *currentURL;
    UIButton *refreshBtn;
    EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _reloading;
    UIImageView *imageV;
    NSString *imageData64;
    
    JSContext *callJSContext;
    
    UIImage *resultIma;
    
    int userID;
    NSString *userCookie;
}
@property (nonatomic,assign) double percentage;
@property (nonatomic, copy) NSString *imageID;

@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;
@property (nonatomic, copy) NSString *shareURL;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.view.backgroundColor = NAV_BACKGROUNDCOLOR;
    loginWebView = [[UIWebView alloc] init];
    loginWebView.delegate = self;
    loginWebView.scalesPageToFit = YES;
    loginWebView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-20);
    [self.view addSubview:loginWebView];
    
    [self httpRequest:LOGINURL];
    self.automaticallyAdjustsScrollViewInsets = NO;
    loginWebView.scrollView.delegate = self;
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-loginWebView.scrollView.bounds.size.height, loginWebView.scrollView.frame.size.width, loginWebView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        loginWebView.scrollView.showsVerticalScrollIndicator = NO;
        [loginWebView.scrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    callJSContext = [[JSContext alloc] init];
    [callJSContext evaluateScript:currentURL];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if([cookie.name isEqualToString:@"GX_WD_MEMBERID"]){
            userID = cookie.value.intValue;
        }else if([cookie.name isEqualToString:@"GX_WD_MEMBERID_AUTH"]){
            userCookie = cookie.value;
        }
    }
}

- (void)shareAction
{
    // NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"userintoIco" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:_shareDesc
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithUrl:_shareImage]
                                                title:_shareTitle
                                                  url:_shareURL
                                          description:_shareDesc
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    // [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    NSArray *shareList = [ShareSDK getShareListWithType: ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeWeixiFav,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSMS,ShareTypeCopy, nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess){
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }else if (state == SSResponseStateFail){
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    
                                    if([error errorCode] == -22003){
                                        [DialogUtil showDlgAlert:@"尚未安装微信,是否安装微信?" cancelButtonTitle:@"取消" other:@"确定" title:@"" delegate:self];
                                    }
                                }
                            }];
}
- (void)refreshAction:(UIButton*)button
{
    
    [self httpRequest:currentURL];
}
- (void)httpRequest:(NSString*)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [loginWebView loadRequest:request];
    currentURL = url;
}
#pragma mark WEBVIEW Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _reloading = YES;
    
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
    _context[@"WXLOGIN"] = ^() {
        if([WXApi isWXAppInstalled]){
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"123";
            req.openID = @"335ffd861c0a64aa88eb8d427c36b715";
            [WXApi sendReq:req];
        }else{
            [DialogUtil showDlgAlert:@"是否安装微信?" cancelButtonTitle:@"取消" other:@"确定" title:@"" delegate:weakSelf];
        }
        __block  NSString *s;
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        app.getCode = ^(NSString* str){
            s = [NSString stringWithString:str];
            NSString *url = [NSString stringWithFormat:@"%@code=%@",HOMEURL,s];
            [weakSelf httpRequest:url];
        };
    };
    //----------------------------------------------------------------------------------------------------------------
    _context[@"up_img"] = ^(NSString *id, int w, int h){
        weakSelf.percentage = w/h;
        weakSelf.imageID = [NSString stringWithFormat:@"%@",id];;
        [weakSelf getimageInterface];
    };
    //----------------------------------------------------------------------------------------------------------------
    _context[@"clickOneKeyShare"] = ^(NSString *image, NSString *title, NSString *desc,NSString *url){
        weakSelf.shareImage = [NSString stringWithFormat:@"%@",image];
        weakSelf.shareTitle = [NSString stringWithFormat:@"%@",title];
        weakSelf.shareDesc = [NSString stringWithFormat:@"%@",desc];
        weakSelf.shareURL = [NSString stringWithFormat:@"%@",url];
        [weakSelf shareAction];
    };
    //----------------------------------------------------------------------------------------------------------------
    _context[@"clickShowImage"]= ^(NSString *url, int num){
        NSArray *arr = [url componentsSeparatedByString:@","];
        int count = [arr count];
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            NSString *url = arr[i];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            [photos addObject:photo];
        }
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = num; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    };
    //----------------------------------------------------------------------------------------------------------------
    _context[@"clickSettingActivity"] = ^(){
        SiteViewController *siteVC = [[SiteViewController alloc] init];
        siteVC.title = @"设置";
        [weakSelf.navigationController pushViewController:siteVC animated:YES];
    };
    //----------------------------------------------------------------------------------------------------------------
    
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:loginWebView.scrollView];
    
     //禁用 长按弹出ActionSheet
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:loginWebView.scrollView];
    if(error.code == -1009){
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"" message:@"网络断开,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alView show];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    currentURL =[NSString stringWithFormat:@"%@",request.URL];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            
        }
            break;
        case 1:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [loginWebView reload];
    [self httpRequest:currentURL];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}
#pragma mark ImageInterface
- (void)getimageInterface
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"相册", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma  mark PickerController and UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{//相🐔
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.allowsEditing = NO;//是否可编辑
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 1:{//相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.allowsEditing = NO;//是否可以编辑
                
                //打开相册选择照片
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
        case 2:{//取消
            NSLog(@"2");
        }
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(resultIma == nil){
        resultIma = [[UIImage alloc] init];
    }
    //得到图片
    resultIma = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(resultIma, nil, nil, nil);
    [self cropAction];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark crop
- (void)cropAction
{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    //    imageCrop.ratioOfWidthAndHeight = 600.0f/280.0f;
    imageCrop.ratioOfWidthAndHeight = _percentage;
    //    imageCrop.image = [UIImage imageNamed:@"temp.jpg"];
    imageCrop.image = resultIma;
    [imageCrop showWithAnimation:YES];
}
#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    resultIma = cropImage;
    [self httpRequest];
}

#pragma mark http---
- (void)httpRequest
{
    if(resultIma != nil){
        NSData *data2 = UIImageJPEGRepresentation(resultIma,0.8);
        if ([self respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
            imageData64 = [data2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }else{
            imageData64 = [data2 base64Encoding];
        }
    }
    NSString *url= @"http://test.gx.com/index.php?g=public&m=Upload&a=up_img_back";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:imageData64 forKey:@"img"];
    [dic setObject:[NSNumber numberWithInt:userID] forKey:@"member_id"];
    [dic setObject:userCookie forKey:@"auth"];
    // manager.responseSerializer = [AFXMLParserResponseSerializer serializer]; //设置返回json 格式
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary*)responseObject;
        [self imageResult:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [DialogUtil showDlgAlert:@"网络断了,请检查网络设置"];
        NSLog(@"-0-%@",error);
    }];
}

- (void)imageResult:(NSDictionary*)dic
{
    JSValue *function = [self.context objectForKeyedSubscript:@"up_img_callback"];
    //    JSValue *result = [function callWithArguments:@[_imageID,dic[@"data"]]];
    [function callWithArguments:@[_imageID,dic[@"data"]]];//无返回值
}

@end
