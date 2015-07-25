//
//  AppDelegate.m
//  MicroShop
//
//  Created by bladeapp on 15/3/9.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <RennSDK/RennSDK.h>
#import "IQKeyboardManager.h"
#import "SYAnalyzeInterface.h"

@interface AppDelegate ()<WXApiDelegate>
{
    int wxLoginCode;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[SYAnalyzeInterface sharedManager] startAnalyze];//友盟统计，版本管理
    [[SYAnalyzeInterface sharedManager] UMengPUSHapplication:application didFinishLaunchingWithOptions:launchOptions];//友盟推送
    [self setAlias];
    [self setIQkeyboard];
    [WXApi registerApp:@"wx984dad94ac0b612d"];
    [self initShareSDK];
    if (MTVersion>=7) { // 状态栏字体颜色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    return YES;
}

- (void) initShareSDK{
    [ShareSDK registerApp:@"6099481689f0"];
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568403047"
                               appSecret:@"af456bedf57fb29dd9100ee2b1c1cd29"
                             redirectUri:@"http://www.gx.com"];
    //qq空间
    [ShareSDK connectQZoneWithAppKey:@"1104376122"                                   //101170745 ed616401b6c3e5becbbddfca45b3aa36
                           appSecret:@"4WiMsSnPODJI2iG0"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx812afb532e722257"
                           appSecret:@"9b8749c167343b84f20158c28a4c638d"
                           wechatCls:[WXApi class]];
    //腾讯微博
    [ShareSDK connectTencentWeiboWithAppKey:@"801553946"
                                  appSecret:@"00ea6c2348507e495e4c34e3416df5d6"
                                redirectUri:@"http://www.gx.com"
                                   wbApiCls:[WeiboApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"101170745"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
   // [ShareSDK connectCopy];
    
}

- (id)init
{
    if (self = [super init]) {
        _viewDelegate = [[AGViewDelegate alloc] init];
    }
    return self;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark --

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{//友盟推送
    [[SYAnalyzeInterface sharedManager] PUSHapplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{//友盟推送
    [[SYAnalyzeInterface sharedManager] PUSHapplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{//推送注册失败

}

#pragma mark - 键盘处理

- (void)setIQkeyboard
{
    //键盘事件
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

#pragma mark - 别名设置
- (void)setAlias
{
    NSString *member_id = MemberId;
    if (member_id!=nil) {
        [[SYAnalyzeInterface sharedManager] addAlias:member_id type:AliasType response:^(id responseObject, NSError *error) {
            
        }];
    }
}

@end
