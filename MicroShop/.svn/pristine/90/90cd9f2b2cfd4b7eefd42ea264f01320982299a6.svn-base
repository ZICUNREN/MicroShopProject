//
//  CHFileManager.h
//  SYMerchants
//
//  Created by siyue on 14-11-19.
//  Copyright (c) 2014年 aprilnet.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownLoadResponse)(NSURLResponse *response);
typedef void (^DownError)(NSError *error);
typedef void (^DownFinishLoading)(BOOL isSuccess);

@interface CHFileManager : NSObject

//实现单例的函数
+(CHFileManager *)shareInstance;

//md5加密
- (NSString *)md5:(NSString *)str;

- (NSString *)md5_32:(NSString *)str;

/**
 *  在指定路径中创建文件
 *
 *  @param dir    在主目录中的相对路径
 *  @param folder 所要创建的文件夹的名字
 
 *  return YES or NO
 */
- (BOOL)createFolderIn:(NSString *)relativePath withName:(NSString *)folderName;

/**
 *  下载指定地址的文件
 *
 *  @param dir    在主目录中的相对路径
 *  @param folder 所要创建的文件夹的名字
 
 *  return YES or NO
 */
- (BOOL)synDownLoadFile:(NSString *)sUrl saveTo:(NSString *)path;


/**
 *  异步下载指定地址的文件
 *
 *  @param dir    在主目录中的相对路径
 *  @param folder 所要创建的文件夹的名字
 
 *  return YES or NO
 */


- (BOOL)asyDownLoadFile:(NSString *)sUrl saveTo:(NSString *)reletivePath withName:(NSString *)name downLoadResponse:(DownLoadResponse)downLoadResponse downError:(DownError)downError downFinishLoading:(DownFinishLoading)downFinishLoading;


@property (strong, nonatomic) DownLoadResponse downLoadResponse;
@property (strong, nonatomic) DownError downError;
@property (strong, nonatomic) DownFinishLoading downFinishLoading;

@property (strong, nonatomic) NSMutableData *connectionData;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSString *path;


@end
