//
//  NetworkInterface.m
//  lib
//
//  Created by siyue on 15-3-26.
//  Copyright (c) 2015年 siyue. All rights reserved.
//

#import "NetworkInterface.h"
#import "CHFileManager.h"
#import "SqliteMageger.h"

@interface NetworkInterface()

#ifdef __AFNETWORKING_SWITCH__
@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
#endif

@end

@implementation NetworkInterface

- (id)init {
    self = [super init];
    if (self) {

#ifdef __AFNETWORKING_SWITCH__
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];//返回data类型
#endif
   
    }
    return self;
}

+ (instancetype)shareInstance {
    static NetworkInterface * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[NetworkInterface alloc] init];
    });
    return shareInstance;
}

- (void)requestForGet:(NSString*)strUrl complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#ifdef __GET_AFNETWORKING_SWITCH__
    [self.manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([result[@"code"] integerValue]==LogoutCode) {//如果未登录
            RemoveUserToken;
        }
        
        //缓存
        if (result!=nil) {
            NSString *urlMd5 = [[CHFileManager shareInstance] md5:strUrl];
            NSString *tmpDir = NSTemporaryDirectory();
            NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"catche.plist"];
            NSMutableDictionary *catche = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
            if (catche==nil) {
                catche = [[NSMutableDictionary alloc] init];
            }
            [catche setObject:result forKey:urlMd5];
            [catche writeToFile:savePath atomically:YES];
        }
        
        if (completeBlock) {
            completeBlock(result);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //提示断网
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [[DialogUtil sharedInstance] showDlg:window textOnly:@"网络异常"];
        
        //缓存
        NSString *urlMd5 = [[CHFileManager shareInstance] md5:strUrl];
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"catche.plist"];
        NSMutableDictionary *catche = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
        NSDictionary *result = [catche objectForKey:urlMd5];
        if (result!=nil) {
            if (completeBlock) {
                completeBlock(result);
            }
        }
        else {
            if (errorBlock) {
                errorBlock(error);
            }
        }
    }];
    return;
#endif
    
}

- (void)requestNoCacheGet:(NSString*)strUrl complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#ifdef __GET_AFNETWORKING_SWITCH__
    [self.manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([result[@"code"] integerValue]==LogoutCode) {//如果未登录
            RemoveUserToken;
        }
        
        if (completeBlock) {
            completeBlock(result);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //提示断网
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [[DialogUtil sharedInstance] showDlg:window textOnly:@"网络异常"];
        
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    return;
#endif
    
}

- (void)requestCacheFirstForGet:(NSString*)strUrl complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    BOOL isReadCache = NO;
    //缓存
    NSString *urlMd5 = [[CHFileManager shareInstance] md5:strUrl];
    NSString *catcheJson = [[SqliteMageger shareInstance] getStringFromKey:urlMd5];
    NSDictionary *catche = [self dictionaryWithJsonString:catcheJson];
    NSDictionary *resultCatche = catche;
    if (resultCatche!=nil) {
        isReadCache = YES;
        if (completeBlock) {
            completeBlock(resultCatche);
        }
    }

    
#ifdef __GET_AFNETWORKING_SWITCH__
    [self.manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([result[@"code"] integerValue]==LogoutCode) {//如果未登录
            RemoveUserToken;
        }
        
        //缓存
        if (result!=nil) {
            NSString *urlMd5 = [[CHFileManager shareInstance] md5:strUrl];
            [[SqliteMageger shareInstance] saveString:result.JSONString forKey:urlMd5];
        }
        
        if (!isReadCache) {
            if (completeBlock) {
                completeBlock(result);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //提示断网
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [[DialogUtil sharedInstance] showDlg:window textOnly:@"网络异常"];
        
        //缓存
        NSString *urlMd5 = [[CHFileManager shareInstance] md5:strUrl];
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"catche.plist"];
        NSMutableDictionary *catche = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
        NSDictionary *result = [catche objectForKey:urlMd5];
        if (result!=nil) {
            if (completeBlock) {
                completeBlock(result);
            }
        }
        else {
            if (errorBlock) {
                errorBlock(error);
            }
        }
    }];
    return;
#endif
    
}



- (void)requestForPost:(NSString*)strUrl parms:(NSDictionary*)parms complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock {
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

#ifdef __POST_AFNETWORKING_SWITCH__
    [self.manager POST:strUrl parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([result[@"code"] integerValue]==LogoutCode) {//如果未登录
            RemoveUserToken;
        }
        
        //缓存
        if (result!=nil) {
            NSString *urlMd5 = [[CHFileManager shareInstance] md5:strUrl];
            NSString *tmpDir = NSTemporaryDirectory();
            NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"catche.plist"];
            NSMutableDictionary *catche = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
            if (catche==nil) {
                catche = [[NSMutableDictionary alloc] init];
            }
            [catche setObject:result forKey:urlMd5];
            [catche writeToFile:savePath atomically:YES];
        }
        
        if (completeBlock) {
            completeBlock(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //提示断网
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [[DialogUtil sharedInstance] showDlg:window textOnly:@"网络异常"];
        
        //缓存
        NSString *urlMd5 = [[CHFileManager shareInstance] md5:strUrl];
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *savePath = [NSString stringWithFormat:@"%@%@",tmpDir,@"catche.plist"];
        NSMutableDictionary *catche = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
        NSDictionary *result = [catche objectForKey:urlMd5];
        if (result!=nil) {
            if (completeBlock) {
                completeBlock(result);
            }
        }
        else {
            if (errorBlock) {
                errorBlock(error);
            }
        }

    }];
    return;
#endif
    
}

- (void)requestNoCachePost:(NSString*)strUrl parms:(NSDictionary*)parms complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock {
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#ifdef __POST_AFNETWORKING_SWITCH__
    [self.manager POST:strUrl parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([result[@"code"] integerValue]==LogoutCode) {//如果未登录
            RemoveUserToken;
        }
        
        if (completeBlock) {
            completeBlock(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //提示断网
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [[DialogUtil sharedInstance] showDlg:window textOnly:@"网络异常"];
        
        if (errorBlock) {
            errorBlock(error);
        }
        
        
    }];
    return;
#endif
    
}


- (void)requestForMultiPost:(NSString *)strUrl parms:(NSDictionary *)parms formBlock:(FormBlock)formBlock complete:(CompleteBlock)completeBlock error:(ErrorBlock)errorBlock
{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#ifdef __MULTIPOST_AFNETWORKING_SWITCH__
    [self.manager POST:strUrl parameters:parms constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        formBlock(formData);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([result[@"code"] integerValue]==LogoutCode) {//如果未登录
            RemoveUserToken;
        }
        if (completeBlock) {
            completeBlock(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    return;
#endif
    
}

- (void)reachabilityWithURL:(NSString *)strURL reachabilityStatusChangeBlock:(ReachabilityStatusBlock)reachabilityStatusBlock
{
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#ifdef __REACHABILITY_AFNETWORKING_SWITCH__
    NSURL *baseURL = [NSURL URLWithString:strURL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    return;
#endif
    
}

//json转dictionary
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
