//
//  SYLoginIconManage.m
//  MicroShop
//
//  Created by siyue on 15/4/30.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYLoginIconManage.h"

@implementation SYLoginIconManage

+(id)sharedManager
{
    static SYLoginIconManage *sharedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[SYLoginIconManage alloc] init];
    });
    return sharedManager;
}

- (UIImage *)getUserIconWithUserName:(NSString *)userName
{
    CHFileManager *fileManager = [CHFileManager shareInstance];
    NSString *currentUserMd5 = [fileManager md5:userName];
    NSString *currentUserfileName = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserMd5];
    NSString *userImagePath = [NSString stringWithFormat:@"%@/Documents/UserImages/%@",NSHomeDirectory(),currentUserfileName];
    UIImage *userImage = [[UIImage alloc] initWithContentsOfFile:userImagePath];
    return userImage;
}

- (void)saveUserIconWithURL:(NSString *)url withUserName:(NSString *)userName
{
    //保存图片
    CHFileManager *fileManager = [CHFileManager shareInstance];
    NSString *userMd5 = [fileManager md5:userName];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@.%@",userMd5,@"png"] forKey:userMd5];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [fileManager createFolderIn:@"Documents" withName:@"UserImages"];
    [fileManager asyDownLoadFile:url saveTo:@"Documents/UserImages" withName:userMd5 downLoadResponse:^(NSURLResponse *response) {
        
    } downError:^(NSError *error) {
        
    } downFinishLoading:^(BOOL isSuccess) {
        
    }];

}

- (void)saveUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCurentUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
}


@end
