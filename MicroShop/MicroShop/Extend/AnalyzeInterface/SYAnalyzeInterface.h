//
//  SYAnalyzeInterface.h
//  MicroShop
//
//  Created by siyue on 15/4/30.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APPKEY @"5541d74a67e58e04160004ee"

@interface SYAnalyzeInterface : NSObject

//实现单例的函数
+(id)sharedManager;

- (void)startAnalyze;

- (void)checkUpdate;

//推送
- (void)UMengPUSHapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)PUSHapplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)PUSHapplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)addAlias:(NSString *)alias type:(NSString *)type response:(void(^)(id responseObject, NSError *error))response;//别名

@end
