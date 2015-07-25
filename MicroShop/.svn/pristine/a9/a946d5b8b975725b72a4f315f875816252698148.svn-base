//
//  SYAnalyzeInterface.m
//  MicroShop
//
//  Created by siyue on 15/4/30.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYAnalyzeInterface.h"
#import "MobClick.h" //统计分析
#import "UMessage.h" //推送
#import "SYActiveHtmlViewController.h"
#import "SYMainTabBarViewController.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000

@interface SYAnalyzeInterface()
@property (strong,nonatomic)NSDictionary *userInfo;
@end

@implementation SYAnalyzeInterface

+(id)sharedManager
{
    static SYAnalyzeInterface *sharedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[SYAnalyzeInterface alloc] init];
    });
    return sharedManager;
}

- (void)startAnalyze
{
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:APPKEY reportPolicy:BATCH channelId:nil];
    [self checkUpdate];
}

- (void)checkUpdate
{
    [MobClick checkUpdate:@"新版本" cancelButtonTitle:@"跳过" otherButtonTitles:@"更新"];
}

- (void)UMengPUSHapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set AppKey and AppSecret
    [UMessage startWithAppkey:APPKEY launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
}

- (void)PUSHapplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)PUSHapplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    self.userInfo = userInfo;
    
    NSString *message = userInfo[@"aps"][@"alert"];
    
    //关闭友盟对话框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    // app was already in the foreground
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"否"
                                               otherButtonTitles:@"是",nil];
        [alert show];
    }
    else {
        NSString *key = UserToken;
        if (key!=nil) {
            NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActiveURL"];
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            SYMainTabBarViewController *mainTabBarVC = (SYMainTabBarViewController *)window.rootViewController;
            UINavigationController *navigationController = mainTabBarVC.nav;
            SYActiveHtmlViewController *activeHtmlVC = [[SYActiveHtmlViewController alloc] init];
            activeHtmlVC.url = url;
            activeHtmlVC.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:activeHtmlVC animated:YES];
            mainTabBarVC.selectedIndex=2;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [UMessage sendClickReportForRemoteNotification:self.userInfo];
    if (buttonIndex==0) {
        
    }
    else {
        NSString *key = UserToken;
        if (key!=nil) {
            NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActiveURL"];
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            SYMainTabBarViewController *mainTabBarVC = (SYMainTabBarViewController *)window.rootViewController;
            UINavigationController *navigationController = mainTabBarVC.nav;
            SYActiveHtmlViewController *activeHtmlVC = [[SYActiveHtmlViewController alloc] init];
            activeHtmlVC.url = url;
            activeHtmlVC.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:activeHtmlVC animated:YES];
            mainTabBarVC.selectedIndex=2;
        }
    }
}

- (void)addAlias:(NSString *)alias type:(NSString *)type response:(void(^)(id responseObject, NSError *error))response
{
    [UMessage addAlias:alias type:type response:response];
}

@end
