//
//  NetworkInterface.h
//  lib
//
//  Created by siyue on 15-3-26.
//  Copyright (c) 2015年 siyue. All rights reserved.
//

#pragma mark - 宏定义开关
//get
#define __GET_AFNETWORKING_SWITCH__
//post
#define __POST_AFNETWORKING_SWITCH__
//multiPost
#define __MULTIPOST_AFNETWORKING_SWITCH__
//HTTP Manager Reachability
#define __REACHABILITY_AFNETWORKING_SWITCH__



#ifdef __GET_AFNETWORKING_SWITCH__
#define __AFNETWORKING_SWITCH__
#endif

#ifdef __POST_AFNETWORKING_SWITCH__
#define __AFNETWORKING_SWITCH__
#endif

#ifdef __MULTIPOST_AFNETWORKING_SWITCH__
#define __AFNETWORKING_SWITCH__
#endif

#ifdef __REACHABILITY_AFNETWORKING_SWITCH__
#define __AFNETWORKING_SWITCH__
#endif

#import <Foundation/Foundation.h>

#ifdef __AFNETWORKING_SWITCH__
#import "AFNetworking.h"
#endif

typedef void(^FormBlock)(id<AFMultipartFormData> formData);
typedef void(^CompleteBlock)(NSDictionary *result);
typedef void(^ErrorBlock)(NSError *error);
typedef void(^ReachabilityStatusBlock)(AFNetworkReachabilityStatus);

@interface NetworkInterface : NSObject

+ (instancetype)shareInstance;

//get请求
- (void)requestForGet:(NSString*)strUrl complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock;
- (void)requestNoCacheGet:(NSString*)strUrl complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock;//无缓存
- (void)requestCacheFirstForGet:(NSString*)strUrl complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock;//先读缓存
//post请求
- (void)requestForPost:(NSString*)strUrl parms:(NSDictionary*)parms complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock;
- (void)requestNoCachePost:(NSString*)strUrl parms:(NSDictionary*)parms complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock;
//多段post请求，可以附带表单上传图片
- (void)requestForMultiPost:(NSString *)strUrl parms:(NSDictionary *)parms formBlock:(FormBlock)formBlock complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock;
//网络状态监测
- (void)reachabilityWithURL:(NSString *)strURL reachabilityStatusChangeBlock:(ReachabilityStatusBlock)reachabilityStatusBlock;

@end
