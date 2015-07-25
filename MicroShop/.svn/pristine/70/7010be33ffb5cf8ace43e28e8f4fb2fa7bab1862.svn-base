//
//  CHFileManager.m
//  SYMerchants
//
//  Created by siyue on 14-11-19.
//  Copyright (c) 2014年 aprilnet.com. All rights reserved.
//

#import "CHFileManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CHFileManager

+(CHFileManager *)shareInstance
{
    static CHFileManager *sharedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[CHFileManager alloc] init];
    });
    return  sharedManager;
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSString *)md5_32:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[32];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [Mstr appendFormat:@"%x",result[i]];
    }
    return Mstr;
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

//在指定路径中创建文件
- (BOOL)createFolderIn:(NSString *)relativePath withName:(NSString *)folderName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),relativePath,folderName];
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (!isDir) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return NO;
}

//下载指定地址的文件
- (BOOL)synDownLoadFile:(NSString *)sUrl saveTo:(NSString *)relativepath
{
    NSURL *url = [NSURL URLWithString:sUrl];
    NSArray *results= [sUrl componentsSeparatedByString:@"/"];
    NSString *fileName = [results lastObject];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),relativepath,fileName];
    if (data) {
        NSError *error = nil;
        return [data writeToFile:path options:NSDataWritingAtomic error:&error];
    }
    return NO;
}

//异步下载指定地址的文件

- (BOOL)asyDownLoadFile:(NSString *)sUrl saveTo:(NSString *)reletivePath withName:(NSString *)name downLoadResponse:(DownLoadResponse)downLoadResponse downError:(DownError)downError downFinishLoading:(DownFinishLoading)downFinishLoading
{
    self.downLoadResponse = downLoadResponse;
    self.downError = downError;
    self.downFinishLoading = downFinishLoading;
    
    NSArray *results = [sUrl componentsSeparatedByString:@"/"];
    NSString *fileName = [results lastObject];
    if (name != nil) {
        fileName = [NSString stringWithFormat:@"%@.%@",name,@"png"];
    }
    
    self.path = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),reletivePath,fileName];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableData *data = [[NSMutableData alloc] init];
    self.connectionData = data;
    NSURLConnection *newConnection = [[NSURLConnection alloc]
                                      initWithRequest:request
                                      delegate:self
                                      startImmediately:YES];
    self.connection = newConnection;
    
    if (self.connection != nil){
        return YES;
    } else {
        return NO;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.connectionData = [NSMutableData data];
    self.downLoadResponse(response);
}

- (void) connection:(NSURLConnection *)connection
   didFailWithError:(NSError *)error{
    self.downError(error);
}

- (void) connection:(NSURLConnection *)connection
     didReceiveData:(NSData *)data{
    [self.connectionData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    self.downFinishLoading([self.connectionData writeToFile:self.path atomically:YES]);
}


@end
